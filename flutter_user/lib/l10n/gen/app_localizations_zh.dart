// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get awChooseLanguage => '选择您的语言';

  @override
  String get awGoogleFailed => 'Google 登录失败。请重试。';

  @override
  String get awCompleteProfileTitle => '完善您的个人资料';

  @override
  String awWelcomeName(String name) {
    return '欢迎，$name！';
  }

  @override
  String get awCompleteProfileSubtitle => '填写一些信息，为您个性化定制 Nakshatralogy。';

  @override
  String get awRegionLabel => '地区';

  @override
  String get awRegionIndia => '印度';

  @override
  String get awRegionInternational => '国际';

  @override
  String get awPreferredLanguage => '首选语言';

  @override
  String get awFinishSetup => '完成设置';

  @override
  String get awChatFileWebUnsupported => '网页端暂不支持文件分享。请使用移动应用。';

  @override
  String get awVideoUnsupported => '此浏览器不支持视频通话。请使用我们的移动应用或受支持的桌面浏览器。';

  @override
  String get awClose => '关闭';

  @override
  String get pwPremiumTitle => '高级报告';

  @override
  String get pwLockedSubtitle => '解锁此星盘的完整分析';

  @override
  String pwUnlockFull(Object name) {
    return '解锁完整$name';
  }

  @override
  String pwUnlockPrice(Object price) {
    return '解锁 · $price';
  }

  @override
  String get pwOneTime => '一次性解锁——此星盘永久归您所有';

  @override
  String get pwWhatYouGet => '您将获得';

  @override
  String get pwYourBalance => '您的钱包余额';

  @override
  String get pwInsufficient => '余额不足';

  @override
  String get pwRechargeToUnlock => '充值以解锁';

  @override
  String get pwRechargeAmount => '充值金额 (₹)';

  @override
  String get pwAddMoney => '充值';

  @override
  String get pwRechargeDone => '钱包已充值';

  @override
  String get pwRechargeFailed => '充值失败，请重试。';

  @override
  String get pwUnlockFailed => '无法解锁，请重试。';

  @override
  String get pwUnlockedNow => '已解锁！正在加载您的报告…';

  @override
  String get pwProcessing => '处理中…';

  @override
  String get pwPrimaryNoDelete => '您的主星盘无法删除——它将永久免费使用。';

  @override
  String get pwPrimaryNoEdit => '您的主星盘无法编辑。';

  @override
  String get pwLoadingAccess => '正在检查访问权限…';

  @override
  String get pwMaybeLater => '以后再说';

  @override
  String get updatePhoto => '更新照片';

  @override
  String get takePhoto => '相机';

  @override
  String get chooseFromGallery => '相册';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoUpdated => '照片已更新';

  @override
  String get photoUploadFailed => '照片上传失败，请重试。';

  @override
  String get tapToChangePhoto => '点击更换照片';

  @override
  String get klSubtitle => 'AI驱动的吠陀前世业力关联报告';

  @override
  String get klTitle => '前世业力关联';

  @override
  String get klSnapshotHeader => '业力关联概览';

  @override
  String get klGaugePairwise => '平均两两关联度';

  @override
  String get klGaugeCohesion => '群体凝聚力';

  @override
  String get klGaugeRahuKetu => '罗睺-计都共鸣';

  @override
  String get klGaugeAtmakaraka => '灵魂共鸣';

  @override
  String get klGaugeD60 => 'D60共鸣';

  @override
  String get klChipSoulResonance => '强烈的灵魂印记共鸣';

  @override
  String get klChipD60Resonance => '强烈的D60前世共鸣';

  @override
  String get klChipCohesiveGroup => '凝聚力强的群体';

  @override
  String get klChipNoDebts => '未检测到业力债务';

  @override
  String get klProfilesTitle => '星盘概况';

  @override
  String get klKetuAt => '计都位于';

  @override
  String get klRahuAt => '罗睺位于';

  @override
  String get klFoundationTitle => '各星盘业力基础';

  @override
  String get klFoundationSubtitle => '每个灵魂的前世精通领域与今生方向';

  @override
  String get klKetuMastery => '计都精通';

  @override
  String get klRahuGrowth => '罗睺成长';

  @override
  String get klNinthHousePunya => '第九宫福报';

  @override
  String get klD60Depth => 'D60业力深度';

  @override
  String get klAtmakarakaAgenda => '灵魂议程';

  @override
  String get klSaturnKarma => '土星业力';

  @override
  String get klPairwiseTitle => '两两业力关联';

  @override
  String get klActiveFactors => '活跃关联因素';

  @override
  String get klGroupPatternTitle => '群体业力模式';

  @override
  String get klSharedSetting => '共同的前世背景';

  @override
  String get klCohesionScore => '业力凝聚力';

  @override
  String get klPastGoalsTitle => '前世目标';

  @override
  String get klLearningTitle => '今生课题';

  @override
  String get klTeachingMap => '相互教导图谱';

  @override
  String get klDebtsTitle => '业力债务与化解';

  @override
  String get klNoDebtsDetected => '此群体中未检测到业力债务';

  @override
  String get klTimingTitle => '命主大运业力时机';

  @override
  String get klAuditTitle => '深度审查表';

  @override
  String klAuditSubtitle(Object count) {
    return '已检查$count项业力参数';
  }

  @override
  String get klTopicLinkage => '我们整体的业力关联';

  @override
  String get klTopicPairwise => '特定两人间的业力纽带';

  @override
  String get klTopicDebts => '需要化解的业力债务';

  @override
  String get klTopicLessons => '我们此生要学习的课题';

  @override
  String get klTopicTiming => '我们群体的最佳时机';

  @override
  String get klTopicGroup => '我们共同的前世故事';

  @override
  String get lcSubtitle => 'AI驱动的吠陀爱情合盘报告';

  @override
  String get lcTitle => '爱情合盘';

  @override
  String get lcSnapshotHeader => '爱情合盘概览';

  @override
  String get lcGaugeAttraction => '吸引力';

  @override
  String get lcGaugeEmotional => '情感和谐度';

  @override
  String get lcGaugeMental => '心灵默契';

  @override
  String get lcGaugePassion => '激情';

  @override
  String get lcGaugeLongterm => '长期和谐度';

  @override
  String get lcChipStrongMental => '强烈的心灵联系';

  @override
  String get lcChipStrongLongterm => '强大的长期潜力';

  @override
  String get lcChipStrongPassion => '强烈的身体吸引力';

  @override
  String get lcChipLowFriction => '整体摩擦较低';

  @override
  String get lcChipKarmicPull => '强烈的业力牵引';

  @override
  String get lcPartnersTitle => '伴侣概况';

  @override
  String get lcVenusSuffix => '金星星座';

  @override
  String get lcAttractionTitle => '吸引力与化学反应';

  @override
  String get lcAttractionScore => '吸引力评分';

  @override
  String get lcActiveContacts => '活跃的金星相位';

  @override
  String get lcEmotionalTitle => '情感和谐度';

  @override
  String get lcEmotionalScore => '情感和谐度评分';

  @override
  String get lcNakshatraCompat => '星宿合盘';

  @override
  String get lcYoniKoota => '尤尼库塔（Yoni Koota）';

  @override
  String get lcGanaKoota => '伽纳库塔（Gana Koota）';

  @override
  String get lcTaraKoota => '塔拉库塔（Tara Koota）';

  @override
  String get lcBhakootAxis => '巴库特轴（Bhakoot Axis）';

  @override
  String get lcMentalTitle => '心灵默契';

  @override
  String get lcMentalScore => '心灵默契评分';

  @override
  String get lcPassionTitle => '激情与身体吸引';

  @override
  String get lcPassionScore => '激情评分';

  @override
  String get lcLongtermTitle => '长期和谐度';

  @override
  String get lcLongtermScore => '长期和谐度评分';

  @override
  String get lcCommitmentPotential => '承诺潜力';

  @override
  String get lc7thHouseSynastry => '第七宫合盘分析';

  @override
  String get lcJupiterBlessing => '木星祝福';

  @override
  String get lcD9Resonance => 'D9那婆姆萨共鸣';

  @override
  String get lcSaturnLongevity => '土星长久度';

  @override
  String get lcKarmicTitle => '业力爱情纽带';

  @override
  String get lcKarmicScore => '业力纽带评分';

  @override
  String get lcKetuContacts => '计都相位';

  @override
  String get lcRahuContacts => '罗睺相位';

  @override
  String get lcChallengesTitle => '挑战与摩擦';

  @override
  String get lcNoChallenges => '两张星盘中均未检测到明显摩擦点';

  @override
  String get lcTotalPenalty => '总挑战扣分';

  @override
  String get lcTimingTitle => '爱情时机——命主大运';

  @override
  String get lcDynamicsTitle => '关系动态';

  @override
  String get lcPowerBalance => '权力平衡';

  @override
  String get lcGiverReceiver => '情感付出者/接受者';

  @override
  String get lcGrowthDynamic => '成长动态';

  @override
  String get lcAreasToNurture => '需要培育的领域';

  @override
  String get lcTopicTiming => '我们关系的最佳时机';

  @override
  String get lcTopicChallenges => '需要应对的挑战';

  @override
  String get lcTopicKarmic => '我们的业力联系';

  @override
  String get lcTopicRemedies => '推荐的补救方法';

  @override
  String get lcTopicLongterm => '我们的长期潜力';

  @override
  String get lcTopicDynamics => '我们的关系动态';

  @override
  String get cpSubtitle => 'AI驱动的吠陀子女概率报告';

  @override
  String get cpTitle => '子女概率';

  @override
  String get cpSnapshotHeader => '子嗣概率概览';

  @override
  String get cpGauge5thHouse => '第五宫';

  @override
  String get cpGaugeJupiter => '木星/子女徵星（Putrakaraka）';

  @override
  String get cpGaugeD7 => 'D7萨普塔姆萨';

  @override
  String get cpGaugeSphuta => '种子-田地（Beeja-Kshetra）';

  @override
  String get cpGaugeTiming => '大运时机';

  @override
  String get cpChipStrongPutrakaraka => '强健的子女徵星（木星）';

  @override
  String get cpChipLowDoshaPenalty => '缺陷扣分较低';

  @override
  String get cpChipFavorableTiming => '有利的大运时机';

  @override
  String get cpChipNoDoshas => '未检测到子嗣缺陷（Dosha）';

  @override
  String get cpPartnersTitle => '伴侣概况';

  @override
  String get cpLagnaSuffix => '上升星座（Lagna）';

  @override
  String get cpMoonSuffix => '月亮星座';

  @override
  String get cpNumberTitle => '子女数量与性别倾向';

  @override
  String get cpProbableNumber => '可能数量';

  @override
  String get cpFirstChildTendency => '第一胎倾向';

  @override
  String get cpSpacing => '间隔说明';

  @override
  String get cpTimingTitle => '时机——命主大运';

  @override
  String get cpCombinedTiming => '综合时机';

  @override
  String get cpNextWindow => '下一个有利时段';

  @override
  String get cp5thHouseTitle => '第五宫分析';

  @override
  String get cp5thHouseSubtitle => '子女宫（Putra Bhava），分别分析';

  @override
  String get cpJupiterTitle => '木星——子女徵星分析';

  @override
  String get cpJupiterSubtitle => '子女的自然徵星，分别分析';

  @override
  String get cpD7Title => 'D7萨普塔姆萨分析';

  @override
  String get cpD7Subtitle => '专门用于子女分析的分盘';

  @override
  String get cpD7Strength => 'D7强度';

  @override
  String get cpSphutaTitle => '种子与田地斯普塔（Beeja & Kshetra Sphuta）';

  @override
  String get cpBeejaSphuta => '种子斯普塔（Beeja Sphuta）';

  @override
  String get cpKshetraSphuta => '田地斯普塔（Kshetra Sphuta）';

  @override
  String get cpDoshaTitle => '缺陷（Dosha）分析';

  @override
  String get cpNoDoshasDetected => '两张星盘均未检测到与子嗣相关的缺陷';

  @override
  String get cpRemediesTitle => '推荐的补救方法';

  @override
  String get cpAddresses => '针对问题';

  @override
  String get cpTopicTiming => '最佳受孕时机';

  @override
  String get cpTopicNumber => '我们可能有多少个子女';

  @override
  String get cpTopicDosha => '需要处理的任何缺陷';

  @override
  String get cpTopicRemedies => '推荐的补救方法';

  @override
  String get cpTopicFifthHouse => '我们第五宫的强度';

  @override
  String get cpTopicJupiter => '木星在其中的作用';

  @override
  String get riSubtitle => 'AI驱动的吠陀关系智能报告';

  @override
  String get riTitle => '关系洞察';

  @override
  String get riSnapshotHeader => '群体概览';

  @override
  String get riGaugeCohesion => '群体凝聚力';

  @override
  String get riGaugeTrust => '信任氛围';

  @override
  String get riGaugeProductivity => '生产力';

  @override
  String get riGaugeCreativity => '创造力';

  @override
  String get riChipNoAlerts => '无重大警示';

  @override
  String get riChipStrongCohesion => '强大的群体凝聚力';

  @override
  String get riChipHighTrust => '高度信任氛围';

  @override
  String get riChipNoHiddenEnemy => '无潜在敌意信号';

  @override
  String get riChipHealthyGroup => '整体健康的群体';

  @override
  String get riProfilesTitle => '星盘概况';

  @override
  String riProfilesSubtitle(Object count) {
    return '此群体中有$count人';
  }

  @override
  String get riLagnaSuffix => '上升星座（Lagna）';

  @override
  String get riIntegrity => '正直度';

  @override
  String get riWarmth => '热情度';

  @override
  String get riTrustworthiness => '可信度';

  @override
  String get riAssertiveness => '果断度';

  @override
  String get riGroupDynamicsTitle => '群体动态概览';

  @override
  String get riMostSupportive => '最具支持性';

  @override
  String get riMostChallenged => '最具挑战性';

  @override
  String get riHiddenEnemyAlert => '检测到潜在敌意信号';

  @override
  String get riBestWorstTitle => '最佳与最具挑战性的组合';

  @override
  String get riBestPair => '最强纽带';

  @override
  String get riWorstPair => '需要关注';

  @override
  String get riAlliances => '可能的联盟';

  @override
  String get riConflicts => '可能的摩擦点';

  @override
  String get riPairwiseTitle => '两两分析';

  @override
  String riPairwiseSubtitle(Object count) {
    return '已分析$count对组合';
  }

  @override
  String get riDynamic => '动态';

  @override
  String get riKarmicLink => '业力联系';

  @override
  String get riMutualTrust => '相互信任';

  @override
  String get riBetrayalRisk => '背叛风险';

  @override
  String get riPowerDistribution => '权力分配';

  @override
  String get riPowerHealth => '权力平衡健康度';

  @override
  String get riCriticalPatternsTitle => '关键模式';

  @override
  String get riGroupRecsTitle => '群体建议';

  @override
  String get riSharedPractices => '共同实践';

  @override
  String get riCommStyle => '推荐的沟通方式';

  @override
  String get riGrowthFocus => '推荐的成长重点';

  @override
  String get riIndividualTitle => '个人指导';

  @override
  String get riBestAllies => '最佳盟友';

  @override
  String get riHandleWithCare => '需谨慎对待';

  @override
  String get riCoreThemeTitle => '核心群体主题';

  @override
  String get riLayerPairwise => '两两完整度';

  @override
  String get riLayerD1 => '本命盘（D1）';

  @override
  String get riLayerD9 => '那婆姆萨盘（D9）';

  @override
  String get riLayerD10 => '达萨姆萨盘（D10）';

  @override
  String get riLayerD30 => '特灵沙姆萨盘（D30）';

  @override
  String get riLayerJaimini => '遮米尼信号（Jaimini）';

  @override
  String get riLayerBehavior => '行为清晰度';

  @override
  String get riLayerCoherence => '群体一致性';

  @override
  String get riTopicDynamics => '我们的群体动态';

  @override
  String get riTopicPairwise => '特定两人间的合盘';

  @override
  String get riTopicAlerts => '任何重大警示';

  @override
  String get riTopicGrowth => '我们如何共同成长';

  @override
  String get riTopicRecs => '推荐的实践方法';

  @override
  String get riTopicTheme => '我们的核心群体主题';

  @override
  String get kmSubtitle => 'AI驱动的吠陀星盘合婚报告';

  @override
  String get kmTitle => '星盘合婚（Kundli Milan）';

  @override
  String get kmSnapshotHeader => '合盘概览';

  @override
  String kmAshtakootScore(Object score) {
    return '阿什塔库特（Ashtakoot）：$score/36';
  }

  @override
  String get kmGaugeAshtakoot => '阿什塔库特百分比';

  @override
  String get kmGaugeD9 => 'D9婚姻业力';

  @override
  String get kmGaugeMangal => '火星缺陷平衡（Mangal）';

  @override
  String get kmGaugePapa => '业力平衡';

  @override
  String get kmGaugeAk => '灵魂共鸣';

  @override
  String get kmChipNoNadi => '无纳迪缺陷（Nadi Dosh）';

  @override
  String get kmChipNoBhakoot => '无巴库特缺陷（Bhakoot Dosh）';

  @override
  String get kmChipMangalCancelled => '火星缺陷（Mangal Dosh）已抵消';

  @override
  String get kmChipPapaBalanced => '业力负担均衡';

  @override
  String get kmChipStrongChemistry => '强烈的身体吸引力';

  @override
  String get kmChipStrongD9 => '强大的D9婚姻业力';

  @override
  String get kmChipLongevity => '强健的寿元契合度';

  @override
  String get kmAshtakootTitle => '阿什塔库特古纳合婚（Ashtakoot Guna Milan）';

  @override
  String get kmAshtakootSubtitle => '经典八项匹配系统，满分36分';

  @override
  String get kmNadiSeverity => '纳迪缺陷严重程度';

  @override
  String get kmBhakootSeverity => '巴库特缺陷严重程度';

  @override
  String get kmGanaSignature => '伽纳（Gana）特征';

  @override
  String get kmMangalTitle => '火星缺陷检查（Mangal Dosha）';

  @override
  String get kmD9Title => 'D9那婆姆萨盘——婚姻业力';

  @override
  String get kmD9Subtitle => '灵魂层面的婚姻星盘，经典上被视为最重要';

  @override
  String get kmD9Score => 'D9合盘度';

  @override
  String get kmLagnaRelation => '上升星座关系';

  @override
  String get km7thLordRelation => '第七宫主星关系';

  @override
  String get kmKarakasTitle => '灵魂与配偶徵星';

  @override
  String get kmAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get kmAkCompatibility => '灵魂印记共鸣';

  @override
  String get kmUlCompatibility => '配偶徵星契合度';

  @override
  String get kmUlSigns => '副宫（Upapada）主星';

  @override
  String get kmChemistryTitle => '金星-火星化学反应';

  @override
  String get kmPhysicalChemistry => '身体吸引力';

  @override
  String get kmEmotionalWarmth => '情感温度';

  @override
  String get kmAestheticAlignment => '审美契合度';

  @override
  String get kmElementalSynthesis => '元素融合度';

  @override
  String get kmHouseCrossTitle => '第七宫与第八宫交叉分析';

  @override
  String get km78Compatibility => '七宫-八宫合盘度';

  @override
  String get km8thHouseSignature => '共同寿元特征';

  @override
  String get kmLongevityAlignment => '寿元契合度';

  @override
  String get km7thLordFriendship => '第七宫主星友谊关系';

  @override
  String get kmDomainsTitle => '各领域合盘度';

  @override
  String get kmConflictEngagement => '冲突应对方式';

  @override
  String get kmDashaTitle => '大运与行运同步';

  @override
  String get kmDashaSync => '大运同步度';

  @override
  String get kmTransitAlignment => '行运契合度';

  @override
  String get kmTimingTitle => '婚姻时机';

  @override
  String get kmMarriageWindow => '婚姻时段';

  @override
  String get kmEngagementWindow => '订婚时段';

  @override
  String get kmRecommendedRange => '推荐时间范围';

  @override
  String get kmMuhurtaNotes => '吉时（Muhurta）说明';

  @override
  String get kmRisksTitle => '需要注意的风险';

  @override
  String get kmConflictRisk => '冲突风险';

  @override
  String get kmCommunicationRisk => '沟通风险';

  @override
  String get kmFinanceRisk => '财务冲突风险';

  @override
  String get kmFamilyDynamicsRisk => '家庭关系风险';

  @override
  String get kmMentalHealthRisk => '心理健康契合风险';

  @override
  String get kmStrengthsTitle => '主要合盘优势';

  @override
  String get kmSharedGrowth => '共同成长潜力';

  @override
  String get kmSharedCreative => '共同创造潜力';

  @override
  String get kmJourneyTitle => '关系历程与成长';

  @override
  String get kmCurrentPhase => '当前阶段';

  @override
  String get kmEarlyArc => '婚姻初期';

  @override
  String get kmMiddleArc => '婚姻中期';

  @override
  String get kmMatureArc => '婚姻成熟期';

  @override
  String get kmElderArc => '晚年时期';

  @override
  String get kmPeakPhase => '陪伴巅峰期';

  @override
  String get kmGrowthAreas => '成长领域';

  @override
  String get kmCommProtocols => '沟通准则';

  @override
  String get kmSharedPractices => '共同实践';

  @override
  String get kmImprovementTitle => '核心主题与改进计划';

  @override
  String get kmVerdictTitle => '最终结论';

  @override
  String get kmRealizationPotential => '关系实现潜力';

  @override
  String get kmLayerAshtakoot => '阿什塔库特（Ashtakoot）';

  @override
  String get kmLayerD9 => 'D9纳瓦姆萨';

  @override
  String get kmLayerMangalPapa => '火星缺陷与业力均衡（Papasamya）';

  @override
  String get kmLayerVenusMars => '金星-火星';

  @override
  String get kmLayerDashaSync => '大运同步度';

  @override
  String get kmLayerH7H8 => '七宫-八宫交叉';

  @override
  String get kmLayerAkResonance => '灵魂行星共鸣';

  @override
  String get kmLayerDomains => '领域维度';

  @override
  String get kmTopicAshtakoot => '我们的阿什塔库特评分';

  @override
  String get kmTopicMangal => '火星缺陷（Mangal Dosha）相关问题';

  @override
  String get kmTopicD9 => '我们的婚姻业力（D9）';

  @override
  String get kmTopicTiming => '最佳结婚时机';

  @override
  String get kmTopicRisks => '需要提前准备的风险';

  @override
  String get kmTopicGrowth => '我们如何共同成长';

  @override
  String get kmTopicRemedies => '推荐的补救方法';

  @override
  String get kmTopicVerdict => '我们是否应该继续这段婚姻';

  @override
  String get pkSubtitle => 'AI驱动的吠陀前世与业力报告';

  @override
  String get pkTitle => '前世与业力';

  @override
  String get pkSnapshotHeader => '前世概览';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return '您的星盘显示出「$theme」的前世印记，目前正$relation地延续到今生。推荐路径：$strategy。';
  }

  @override
  String get pkGaugeSignature => '印记强度';

  @override
  String get pkGaugeMasteryPreserved => '保留的精通能力';

  @override
  String get pkGaugeClearingProgress => '业力清理进度';

  @override
  String get pkGaugeMaturity => '前世成熟度';

  @override
  String get pkGaugeMemoryAccess => '记忆通达度';

  @override
  String get pkChipGoodProgress => '业力清理进展良好';

  @override
  String get pkChipLowDebt => '业力债务较低';

  @override
  String get pkChipMatureSoul => '成熟的灵魂印记';

  @override
  String get pkChipGiftedPast => '星盘携带前世天赋';

  @override
  String get pkChipAccomplished => '成就斐然的前世';

  @override
  String get pkChipMasteryPreserved => '强大的精通能力得以延续';

  @override
  String get pkKetuTitle => '计都——您的前世精通';

  @override
  String get pkKetuSubtitle => '您灵魂已经掌握的技能';

  @override
  String get pkMasteryStrength => '精通强度';

  @override
  String get pkSkillsCarried => '延续下来的技能';

  @override
  String get pkInstincts => '本能能力';

  @override
  String get pkKetuDignity => '计都的力量状态';

  @override
  String get pkRahuTitle => '罗睺——您灵魂的成长方向';

  @override
  String get pkRahuSubtitle => '您灵魂此生要完成的事';

  @override
  String get pkUnmetDesires => '未满足的渴望';

  @override
  String get pkProfileTitle => '您的前世档案';

  @override
  String get pkProfession => '可能的职业';

  @override
  String get pkSocialStanding => '社会地位';

  @override
  String get pkRegion => '可能的地域';

  @override
  String get pkCulturalArchetype => '文化原型';

  @override
  String get pkAccomplishment => '成就水平';

  @override
  String get pkAuthority => '权威水平';

  @override
  String get pkFamilyRole => '家庭角色';

  @override
  String get pkSecondaryProfession => '次要职业';

  @override
  String get pkClimateAffinity => '气候偏好';

  @override
  String get pkForeignResidence => '异地/异国居住业力';

  @override
  String get pkRelationshipsTitle => '延续至今的前世关系';

  @override
  String get pkSpouseConnection => '配偶重逢';

  @override
  String get pkChildrenConnection => '子女重逢';

  @override
  String get pkCarriedRelationTypes => '关系模式';

  @override
  String get pkPartnerArchetype => '前世伴侣原型';

  @override
  String get pkDarakaraka => '配偶徵星（Darakaraka）';

  @override
  String get pkParentsKarma => '父母业力模式';

  @override
  String get pkSiblingKarma => '兄弟姐妹业力模式';

  @override
  String get pkSpiritualTitle => '您当时的灵性生活';

  @override
  String get pkSpiritualLevel => '灵性水平';

  @override
  String get pkPracticeSignature => '修行方式';

  @override
  String get pkMeditativeCapacity => '禅修能力';

  @override
  String get pkDevotionalPractice => '奉爱修行';

  @override
  String get pkYogicAttainment => '瑜伽成就';

  @override
  String get pkMokshaProximity => '解脱（Moksha）临近度';

  @override
  String get pkKarmicDebtsTitle => '当时的业力债务与财富';

  @override
  String get pkTotalKarmicDebt => '总业力债务';

  @override
  String get pkPrimaryDebtType => '主要债务类型';

  @override
  String get pkRelationshipDebt => '关系债务';

  @override
  String get pkFinancialDebt => '财务债务';

  @override
  String get pkServiceDebt => '服务债务';

  @override
  String get pkDharmicDebt => '达摩（Dharma）债务';

  @override
  String get pkPitruKarma => '祖先业力（Pitru Karma）';

  @override
  String get pkMatruKarma => '母系业力（Matru Karma）';

  @override
  String get pkWealthLevel => '当时的财富水平';

  @override
  String get pkWealthKarmaCarried => '延续的财富业力';

  @override
  String get pkResourcePattern => '资源管理方式';

  @override
  String get pkGainSource => '获利来源';

  @override
  String get pkEchoesTitle => '今生的回响';

  @override
  String get pkOnRelationships => '在人际关系方面';

  @override
  String get pkOnCareer => '在事业方面';

  @override
  String get pkOnHealth => '在健康方面';

  @override
  String get pkOnSpirituality => '在灵性方面';

  @override
  String get pkDominantArea => '最强延续领域';

  @override
  String get pkAttractions => '天然吸引';

  @override
  String get pkAversions => '天然排斥';

  @override
  String get pkUnexplainedFears => '无法解释的恐惧';

  @override
  String get pkMagneticPulls => '无形的吸引力';

  @override
  String get pkResolutionTitle => '业力化解与圆满';

  @override
  String get pkPrimaryPathway => '主要路径';

  @override
  String get pkSecondaryPathway => '次要路径';

  @override
  String get pkClearingProgress => '清理进度';

  @override
  String get pkRemainingWork => '剩余功课';

  @override
  String get pkSettlementTimeline => '化解时间线';

  @override
  String get pkAccelerationPractices => '加速化解的修行方法';

  @override
  String get pkPriorityAreas => '优先领域';

  @override
  String get pkVerificationTitle => '跨星盘验证（D60）';

  @override
  String get pkD60Label => 'D60前世时代';

  @override
  String get pkD60Ketu => 'D60计都落位';

  @override
  String get pkD60Standing => '整体地位';

  @override
  String get pkMemoryTitle => '记忆与直觉';

  @override
  String get pkMemoryAccess => '记忆通达度';

  @override
  String get pkRegressionFit => '前世回溯疗法适配度';

  @override
  String get pkDreamVisits => '梦境造访';

  @override
  String get pkDejaVuFrequency => '似曾相识（Deja Vu）频率';

  @override
  String get pkSpontaneousRemembrance => '自发回忆';

  @override
  String get pkRemembrancePractices => '唤醒记忆的修行';

  @override
  String get pkTimelineTitle => '激活时间线';

  @override
  String get pkGiftsActivation => '前世天赋激活';

  @override
  String get pkSurfaceWindow => '浮现时段';

  @override
  String get pkRisksTitle => '风险与长期模式';

  @override
  String get pkTraumaResidue => '创伤残留';

  @override
  String get pkSpiritualBypass => '灵性逃避风险';

  @override
  String get pkMajorRisks => '主要风险';

  @override
  String get pkChronicImprints => '长期印记';

  @override
  String get pkKarmicLoops => '业力循环';

  @override
  String get pkImprovementTitle => '改进计划';

  @override
  String get pkRoadmapTitle => '您的前世路线图';

  @override
  String get pkMaturity => '前世成熟度';

  @override
  String get pkLayerD1 => '本命盘（D1）';

  @override
  String get pkLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get pkLayerD60 => '沙什提安萨盘（D60）';

  @override
  String get pkLayerKetuDepth => '计都深度';

  @override
  String get pkLayerAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get pkTopicMastery => '我的前世精通';

  @override
  String get pkTopicUnfinished => '我未完成的业力';

  @override
  String get pkTopicRelationships => '我的前世关系';

  @override
  String get pkTopicDebts => '我的业力债务';

  @override
  String get pkTopicResolution => '如何化解我的业力';

  @override
  String get pkTopicMemory => '前世记忆通达';

  @override
  String get pkTopicTiming => '最佳时机窗口';

  @override
  String get pkTopicProfile => '我前世是谁';

  @override
  String get chSubtitle => 'AI驱动的吠陀性格分析报告';

  @override
  String get chTitle => '性格分析';

  @override
  String get chSnapshotHeader => '性格概览';

  @override
  String get chGaugeIntegrity => '正直度';

  @override
  String get chGaugeResilience => '韧性';

  @override
  String get chGaugeSelfAwareness => '自我觉察力';

  @override
  String get chGaugeStability => '情绪稳定性';

  @override
  String get chGaugeMoralFabric => '道德底蕴';

  @override
  String get chChipRajaYoga => '存在拉贾瑜伽（Raja Yoga）';

  @override
  String get chChipHighIntegrity => '高度正直';

  @override
  String get chChipResilient => '坚韧的天性';

  @override
  String get chChipDharmic => '强烈的达摩（Dharma）取向';

  @override
  String get chChipEmpathetic => '天生富有同理心';

  @override
  String get chChipLoyal => '极其忠诚';

  @override
  String get chChipGiftedCharacter => '星盘携带性格天赋';

  @override
  String get chSoulTitle => '您的灵魂印记';

  @override
  String get chSoulIntegration => '灵魂与性格的整合度';

  @override
  String get chAmatyakarakaTheme => '辅助性格声音（Amatyakaraka）';

  @override
  String get chAtmakarakaDignity => '灵魂行星的力量状态';

  @override
  String get chAtmakarakaHouse => '宫位落位';

  @override
  String get chSurfaceTitle => '表层性格与体质';

  @override
  String get chLagnaSign => '上升星座';

  @override
  String get chConstitution => '体质';

  @override
  String get chSurfaceSignature => '您给人的第一印象';

  @override
  String get chPhysicalConstitution => '身体体质';

  @override
  String get chLagnaLord => '上升主星';

  @override
  String get chLagnaOccupants => '上升宫内行星';

  @override
  String get chMindEmotionsTitle => '心智、情绪与自我';

  @override
  String get chEmotionalNature => '您的情绪特质';

  @override
  String get chMentalStability => '心智稳定性';

  @override
  String get chSelfConfidence => '健康的自信心';

  @override
  String get chEgoNature => '您的自我与自我认知';

  @override
  String get chAuthorityRelationship => '与权威的关系';

  @override
  String get chPrideTendency => '自负倾向';

  @override
  String get chMoodPatterns => '情绪模式';

  @override
  String get chKemadrumaPresent => '存在凯玛德鲁玛瑜伽（Kemadruma Yoga）——建议加强情绪自我照顾。';

  @override
  String get chFatherImprint => '父亲印记质量';

  @override
  String get chCommunicationTitle => '沟通与智力风格';

  @override
  String get chIntellectStyle => '智力风格';

  @override
  String get chCommStyle => '沟通风格';

  @override
  String get chDecisionStyle => '决策风格';

  @override
  String get chDiscrimination => '辨别能力';

  @override
  String get chPersonaTitle => '公众形象与真实自我';

  @override
  String get chAuthenticityGap => '真实性差距';

  @override
  String get chGunaTitle => '古纳（Guna）与体质（Dosha）档案';

  @override
  String get chGunaSubtitle => '经典吠陀风格下您的内在本质与体质';

  @override
  String get chSattva => '悦性（Sattva）';

  @override
  String get chRajas => '动性（Rajas）';

  @override
  String get chTamas => '惰性（Tamas）';

  @override
  String get chDominantGuna => '主导古纳';

  @override
  String get chPitta => '皮塔（Pitta）';

  @override
  String get chKapha => '卡法（Kapha）';

  @override
  String get chVata => '瓦塔（Vata）';

  @override
  String get chDominantDosha => '主导体质';

  @override
  String get chRahuRestlessness => '罗睺带来的不安分';

  @override
  String get chKetuDetachment => '计都带来的超然';

  @override
  String get chYogasTitle => '性格瑜伽（Yoga）';

  @override
  String get chRajaYogaStrength => '拉贾瑜伽强度';

  @override
  String get chGiftYogas => '天赋瑜伽';

  @override
  String get chTestYogas => '考验瑜伽';

  @override
  String get chStrengthsTitle => '优势与天赋';

  @override
  String get chSignatureVirtues => '标志性美德';

  @override
  String get chNaturalTalents => '天生才能';

  @override
  String get chSoftSkills => '软实力';

  @override
  String get chHiddenStrengths => '有待开发的潜在优势';

  @override
  String get chShadowTitle => '阴影面与成长领域';

  @override
  String get chShadowSubtitle => '温和觉察值得改善的模式';

  @override
  String get chShadowPatterns => '阴影模式';

  @override
  String get chBlindSpots => '盲点';

  @override
  String get chEmotionalWounds => '情感创伤';

  @override
  String get chShadowWorkPriorities => '阴影功课优先事项';

  @override
  String get chMoralTests => '道德考验';

  @override
  String get chRelationshipsTitle => '人际关系与社交风格';

  @override
  String get chWarmth => '人际温暖度';

  @override
  String get chEmpathy => '同理心能力';

  @override
  String get chLoyalty => '忠诚能力';

  @override
  String get chBoundaries => '边界设定';

  @override
  String get chSocialConfidence => '社交自信';

  @override
  String get chTrustGiving => '给予信任的基线';

  @override
  String get chConflictStyle => '冲突应对风格';

  @override
  String get chEthicsTitle => '伦理与道德罗盘';

  @override
  String get chDharmaOrientation => '达摩取向';

  @override
  String get chTruthfulness => '诚实度';

  @override
  String get chCompassion => '慈悲心';

  @override
  String get chGenerosity => '慷慨度';

  @override
  String get chEthicalConsistency => '道德一致性';

  @override
  String get chIntegrityPressure => '压力下的正直度';

  @override
  String get chJusticeFairness => '正义与公平';

  @override
  String get chMoralTrajectory => '道德发展轨迹';

  @override
  String get chEiTitle => '情商';

  @override
  String get chEiSelfAwareness => '自我觉察';

  @override
  String get chEiSelfRegulation => '自我调节';

  @override
  String get chEiEmpathy => '同理心';

  @override
  String get chEiSocialSkills => '社交技能';

  @override
  String get chMotivation => '内在动力';

  @override
  String get chVulnerabilityComfort => '面对脆弱的自在度';

  @override
  String get chEmotionalExpression => '情感表达的自在度';

  @override
  String get chEmotionalReceptivity => '情感接纳度';

  @override
  String get chVerificationTitle => '跨星盘验证（D9/D12/D30/D60）';

  @override
  String get chD9Label => 'D9达摩性格';

  @override
  String get chD12Label => 'D12祖辈遗传';

  @override
  String get chD30Label => 'D30阴影档案';

  @override
  String get chD60Label => 'D60前世性格';

  @override
  String get chD30Standing => '阴影面地位';

  @override
  String get chMaternalInheritance => '母系遗传';

  @override
  String get chAncestralKarmaWeight => '祖先业力权重';

  @override
  String get chTimelineTitle => '性格发展时间线';

  @override
  String get chFormationWindow => '性格形成期';

  @override
  String get chMaturationWindow => '性格成熟期';

  @override
  String get chLegacyWindow => '传承期';

  @override
  String get chPeakMaturationAge => '巅峰成熟年龄';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return '$ageRange岁';
  }

  @override
  String get chImprovementTitle => '改进计划';

  @override
  String get chRoadmapTitle => '您的性格发展路线图';

  @override
  String get chAuthenticExpression => '真实的自我表达';

  @override
  String get chRealizationPotential => '性格实现潜力';

  @override
  String get chLayerAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get chLayerD1 => '本命盘（D1）';

  @override
  String get chLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get chLayerD30 => '特灵沙姆萨盘（D30）';

  @override
  String get chLayerLagnaMoon => '上升星座与月亮';

  @override
  String get chLayerArudha => '阿茹达上升（Arudha Lagna）';

  @override
  String get chTopicStrengths => '我的性格优势';

  @override
  String get chTopicShadow => '我的阴影模式';

  @override
  String get chTopicSoul => '我的灵魂印记';

  @override
  String get chTopicRelationships => '我的关系风格';

  @override
  String get chTopicEthics => '我的伦理与价值观';

  @override
  String get chTopicGuna => '我的古纳与体质档案';

  @override
  String get chTopicGrowth => '如何发展我的性格';

  @override
  String get chTopicTiming => '性格塑造的最佳时机';

  @override
  String get lpSubtitle => 'AI驱动的吠陀人生路径与运势报告';

  @override
  String get lpTitle => '人生路径与运势';

  @override
  String get lpSnapshotHeader => '人生路径概览';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return '您是一位$archetype，主要人生目标在于$domain。我们的分析显示您整体人生实现潜力为$probability%。';
  }

  @override
  String get lpGaugeDharma => '达摩清晰度';

  @override
  String get lpGaugeFortune => '运势基线';

  @override
  String get lpGaugeCoherence => '路径一致性';

  @override
  String get lpGaugeFulfillment => '实现度';

  @override
  String get lpGaugeMomentum => '业力动能';

  @override
  String get lpChipRareGift => '罕见的命运天赋';

  @override
  String get lpChipFreeWillStrong => '强大的自由意志';

  @override
  String get lpChipGraceSupported => '受到恩典支持';

  @override
  String get lpChipLightKarma => '较轻的业力负担';

  @override
  String get lpChipRecognitionPotential => '获得认可的潜力';

  @override
  String get lpChipSpiritualPath => '强烈的灵性牵引';

  @override
  String get lpChipBlessed => '星盘携带福泽';

  @override
  String get lpSoulPathTitle => '您的灵魂路径';

  @override
  String get lpSoulPlanet => '灵魂行星';

  @override
  String get lpCareerPlanet => '使命行星';

  @override
  String get lpSoulClarity => '使命清晰度';

  @override
  String get lpLifeChapter => '当前人生篇章';

  @override
  String get lpPrimaryDomain => '主要使命领域';

  @override
  String get lpKarakaTitle => '您的达摩行星';

  @override
  String get lpKarakaSubtitle => '各行星对您人生使命的支持强度';

  @override
  String get lpVerificationTitle => '跨星盘验证（D9 / D60）';

  @override
  String get lpD9Label => 'D9灵魂契合度';

  @override
  String lpD9Explain(Object stage) {
    return '在纳瓦姆萨盘中，您的灵魂进化阶段为「$stage」。';
  }

  @override
  String get lpD9JupiterDignity => '木星力量状态';

  @override
  String get lpD9DharmaMultiplier => '达摩加成倍数';

  @override
  String get lpD60Label => 'D60前世印记';

  @override
  String get lpKarmaType => '前世业力类型';

  @override
  String get lpKetuMastery => '计都前世精通';

  @override
  String get lpRahuGrowthDir => '罗睺成长方向';

  @override
  String get lpYogasTitle => '运势瑜伽与运势阻碍';

  @override
  String get lpFortuneBoost => '运势加成';

  @override
  String get lpLuckDrain => '运势消耗';

  @override
  String get lpFortuneBoosters => '运势助力';

  @override
  String get lpLuckBlocks => '运势阻碍';

  @override
  String get lpPurposeTitle => '使命领域与声望';

  @override
  String get lpDomainLeadership => '领导力';

  @override
  String get lpDomainWisdom => '智慧与教导';

  @override
  String get lpDomainService => '服务';

  @override
  String get lpDomainHealing => '疗愈';

  @override
  String get lpDomainCreative => '创造性表达';

  @override
  String get lpPrimaryDomainBadge => '主要';

  @override
  String get lpFameRecognition => '声望与认可';

  @override
  String get lpSocialInfluence => '社会影响力';

  @override
  String get lpRecognitionDomain => '受认可领域';

  @override
  String get lpPublicImage => '公众形象';

  @override
  String get lpHistoricalImpact => '历史影响力潜力';

  @override
  String get lpTimelineTitle => '运势与人生时间线';

  @override
  String get lpCurrentPhase => '当前运势阶段';

  @override
  String get lpJupiterReturn => '木星回归';

  @override
  String get lpSaturnReturn => '土星回归';

  @override
  String get lpSadeSati => '土星七返（Sade Sati）';

  @override
  String get lpGoldenWindow => '黄金时段';

  @override
  String get lpTransformationWindow => '转变时段';

  @override
  String get lpPeakYears => '运势巅峰年份';

  @override
  String get lpChallengingYears => '挑战年份';

  @override
  String get lpMilestonesTitle => '重要里程碑与转折点';

  @override
  String get lpFirstTurningPoint => '第一个重大转折点';

  @override
  String get lpMidlifeTransform => '中年转变';

  @override
  String get lpLateLifeFulfillment => '晚年圆满';

  @override
  String lpDharmicMilestone(Object age) {
    return '达摩里程碑（$age岁）';
  }

  @override
  String lpAgeLabel(Object age) {
    return '$age岁';
  }

  @override
  String get lpDestinyTitle => '命运与自由意志';

  @override
  String get lpDestinyStat => '命运权重';

  @override
  String get lpFreeWillStat => '自由意志作用力';

  @override
  String get lpFateStrength => '命运印记强度';

  @override
  String get lpSelfCreation => '自我创造能力';

  @override
  String get lpEffortGrace => '努力与恩典';

  @override
  String get lpKarmicTitle => '业力课题';

  @override
  String get lpRahuGrowthLabel => '罗睺——成长挑战';

  @override
  String get lpKetuSurrenderLabel => '计都——放下主题';

  @override
  String get lpSaturnLessonLabel => '土星——自律课题';

  @override
  String get lpTestDifficulty => '人生考验难度';

  @override
  String get lpLessonsInProgress => '正在进行的课题';

  @override
  String get lpSoulContract => '灵魂契约领域';

  @override
  String get lpSoulExperience => '您的灵魂此生要体验的事';

  @override
  String get lpSoulMastery => '您的灵魂此生要精通的事';

  @override
  String get lpSpiritualTitle => '灵性道路';

  @override
  String get lpSpiritualInclination => '灵性倾向';

  @override
  String get lpMeditationReceptivity => '冥想接受度';

  @override
  String get lpTeacherKarma => '师徒（古鲁）业力';

  @override
  String get lpPilgrimageBenefit => '朝圣的益处';

  @override
  String get lpSelfRealization => '自我实现潜力';

  @override
  String get lpDivineConnection => '神性连接';

  @override
  String get lpTraditionAffinity => '传统亲和度';

  @override
  String get lpIntuitionStrength => '直觉力强度';

  @override
  String get lpMantraEfficacy => '祈祷/真言（Mantra）效力';

  @override
  String get lpInnerGuidance => '对内在指引的信任';

  @override
  String get lpPropheticDreams => '预知梦敏感度';

  @override
  String get lpDifficultyTitle => '人生难度与挑战';

  @override
  String get lpEarlyLife => '早年生活';

  @override
  String get lpMidlife => '中年生活';

  @override
  String get lpLateLife => '晚年生活';

  @override
  String get lpStruggleToSuccess => '先苦后甜的业力';

  @override
  String get lpUnlivedLifeRisk => '未活出真我的风险';

  @override
  String get lpChallenges => '人生挑战';

  @override
  String get lpFortuneDrains => '长期运势消耗';

  @override
  String get lpRegretAreas => '易生遗憾的领域';

  @override
  String get lpRedFlags => '方向警示信号';

  @override
  String get lpBlessingsTitle => '福泽与核心人生主题';

  @override
  String get lpKarmicRoot => '业力根源';

  @override
  String get lpBlessingsList => '您的福泽';

  @override
  String get lpFulfillmentPriorities => '圆满优先事项';

  @override
  String get lpImprovementTitle => '改进计划';

  @override
  String get lpDharmaPriorities => '达摩优先事项';

  @override
  String get lpRoadmapTitle => '您的命运路线图';

  @override
  String get lpStrategy => '策略';

  @override
  String get lpFulfillmentPotential => '圆满潜力';

  @override
  String get lpNext12Focus => '未来12个月重点';

  @override
  String get lpLayerD1 => '本命盘（D1）';

  @override
  String get lpLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get lpLayerD60 => '沙什提安萨盘（D60）';

  @override
  String get lpLayerDasha => '大运时机';

  @override
  String get lpLayerTransit => '当前行运';

  @override
  String get lpTopicPurpose => '我的人生使命';

  @override
  String get lpTopicFortune => '我的运势瑜伽';

  @override
  String get lpTopicKarma => '我的业力课题';

  @override
  String get lpTopicMilestones => '即将到来的里程碑';

  @override
  String get lpTopicDestiny => '命运与自由意志';

  @override
  String get lpTopicSpiritual => '我的灵性道路';

  @override
  String get lpTopicChallenges => '我的人生挑战';

  @override
  String get lpTopicTiming => '最佳时机窗口';

  @override
  String get dbSubtitle => 'AI驱动的吠陀债务与财务恢复报告';

  @override
  String get dbTitle => '债务与财务恢复';

  @override
  String get dbSnapshotHeader => '债务恢复概览';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return '您目前处于「$phase」阶段，理财方式为$personality型。我们的分析显示，您在大约$years年内实现无债一身轻的概率为$probability%。';
  }

  @override
  String get dbGaugeCapacity => '恢复能力';

  @override
  String get dbGaugeProbability => '恢复概率';

  @override
  String get dbGaugeFreedomNow => '当前无债程度';

  @override
  String get dbGaugeDti => '收入健康度';

  @override
  String get dbGaugeResilience => '韧性';

  @override
  String get dbChipCleanKarma => '债务业力清净';

  @override
  String get dbChipStrongRecovery => '强大的恢复能力';

  @override
  String get dbChipHealthyDti => '健康的债务收入比';

  @override
  String get dbChipResilient => '高心理韧性';

  @override
  String get dbChipCycleBreakable => '债务循环可以打破';

  @override
  String get dbChipLowReindebt => '再负债风险较低';

  @override
  String get dbChipGoodNegotiator => '良好的协商胜算';

  @override
  String get dbProfileTitle => '您的债务档案';

  @override
  String get dbPhaseLabel => '当前阶段';

  @override
  String get dbPrimaryCategoryLabel => '主要类别';

  @override
  String get dbKarakaLabel => '债务徵星';

  @override
  String get dbProtectorLabel => '债权人保护力';

  @override
  String get dbSecondaryCategories => '次要类别';

  @override
  String get dbUnsecuredRatio => '无抵押债务比例';

  @override
  String get dbKarakaTitle => '您的债务行星';

  @override
  String get dbKarakaSubtitle => '各行星对您债务恢复的支持强度';

  @override
  String get dbVerificationTitle => '跨星盘验证（D6）';

  @override
  String get dbD6Label => 'D6债务与仇敌盘';

  @override
  String get dbD6LordDignity => '第六宫主星力量';

  @override
  String get dbD6Severity => '债务业力严重程度';

  @override
  String get dbD6Multiplier => 'D6债务倍数';

  @override
  String get dbYogasTitle => '债务瑜伽与保护力';

  @override
  String get dbPressureNow => '当前债务压力';

  @override
  String get dbRecoveryBoost => '恢复加成';

  @override
  String get dbClearingLabel => '债务清偿瑜伽';

  @override
  String get dbCreatingLabel => '债务形成瑜伽';

  @override
  String get dbCategoriesTitle => '债务类别关注';

  @override
  String get dbCategoriesSubtitle => '哪些类型的债务最需要关注';

  @override
  String get dbTimelineTitle => '无债时间线';

  @override
  String get dbFreeWindowLabel => '无债时段';

  @override
  String get dbClearanceEstimate => '完全清偿预估';

  @override
  String get dbPeakYears => '债务高峰年份';

  @override
  String get dbClearanceYears => '清偿年份';

  @override
  String get dbBorrowTitle => '智慧借贷指南';

  @override
  String get dbLoanSuitability => '贷款适宜度';

  @override
  String get dbBestLoanType => '最佳贷款类型';

  @override
  String get dbLeverageCeiling => '杠杆上限';

  @override
  String get dbNegotiationSuccess => '协商成功率';

  @override
  String get dbCreditorAggression => '债权人施压风险';

  @override
  String get dbLegalEscalation => '法律升级风险';

  @override
  String get dbNegotiationApproach => '推荐方式';

  @override
  String get dbAvoidLoanTypes => '应避免的贷款类型';

  @override
  String get dbRiskTitle => '风险与脆弱点关注';

  @override
  String get dbRiskDefault => '违约风险';

  @override
  String get dbRiskDefaultExp => '错过还款计划、严重到触发放款方违约认定的概率。';

  @override
  String get dbRiskDefaultFix => '设置最低还款自动扣款，并保留1个月的缓冲资金，以免一次收入中断引发连锁反应。';

  @override
  String get dbRiskBankruptcy => '破产风险';

  @override
  String get dbRiskBankruptcyExp => '债务负担增长到收入与资产实际无法覆盖的概率。';

  @override
  String get dbRiskBankruptcyFix => '在申请任何新贷款或信用额度前，先进行专业的债务评估。';

  @override
  String get dbRiskAssetSeizure => '资产被没收风险';

  @override
  String get dbRiskAssetSeizureExp => '抵押贷款违约导致放款方收回抵押品或房产的概率。';

  @override
  String get dbRiskAssetSeizureFix => '优先偿还有抵押的贷款，如预见还款缺口应尽早再融资。';

  @override
  String get dbRiskChronic => '长期再负债风险';

  @override
  String get dbRiskChronicExp => '即使清偿当前债务后，再次陷入债务的倾向。';

  @override
  String get dbRiskChronicFix => '在债务清偿后提高生活开支前，先建立专门的应急基金。';

  @override
  String get dbReindebtTrigger => '再负债诱因';

  @override
  String get dbCycleBreakFeasibility => '打破循环的可行性';

  @override
  String get dbMajorRisks => '主要风险';

  @override
  String get dbHiddenSignals => '隐藏的债务信号';

  @override
  String get dbCrisisTitle => '危机准备';

  @override
  String get dbCrisisSubtitle => '如何及早发现问题并冷静应对';

  @override
  String get dbWarningSigns => '早期预警信号';

  @override
  String get dbMitigationActions => '应对措施';

  @override
  String get dbFamilyTitle => '家庭与祖辈债务';

  @override
  String get dbInheritedDebtProb => '继承债务的概率';

  @override
  String get dbFamilyDrag => '家庭债务拖累';

  @override
  String get dbInheritedSource => '可能来源';

  @override
  String get dbCoreBlockerLabel => '核心阻碍';

  @override
  String get dbPsychologyTitle => '您的金钱心理';

  @override
  String get dbResilience => '韧性';

  @override
  String get dbDiscipline => '压力下的自律';

  @override
  String get dbSocialSupport => '社会支持';

  @override
  String get dbDepressionRisk => '财务压力脆弱度';

  @override
  String get dbStressTolerance => '压力承受度';

  @override
  String get dbRootCause => '行为根源';

  @override
  String get dbImprovementTitle => '改进计划';

  @override
  String get dbRoadmapTitle => '您的无债路线图';

  @override
  String get dbRecoveryProbability => '恢复概率';

  @override
  String get dbClearanceTimeline => '清偿时间线';

  @override
  String get dbYears => '年';

  @override
  String get dbDtiHealth => '债务收入比健康度';

  @override
  String get dbDtiCategory => '债务收入比类别';

  @override
  String get dbBreakEvenMonths => '收支平衡所需月数';

  @override
  String get dbIncomeAcceleration => '所需收入增长';

  @override
  String get dbLayerD1 => '本命盘（D1）';

  @override
  String get dbLayerD6 => '债务与仇敌盘（D6）';

  @override
  String get dbLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get dbLayerDasha => '大运时机';

  @override
  String get dbLayerTransit => '当前行运';

  @override
  String get dbTopicRecovery => '我的恢复时间线';

  @override
  String get dbTopicNegotiate => '与债权人协商';

  @override
  String get dbTopicBorrowing => '现在借贷是否安全';

  @override
  String get dbTopicCrisis => '为危机做准备';

  @override
  String get dbTopicAncestral => '祖辈债务业力';

  @override
  String get dbTopicTimeline => '清偿债务的最佳年份';

  @override
  String get dbTopicPsychology => '我的金钱心理';

  @override
  String get dbTopicCategories => '应优先处理哪些债务';

  @override
  String get mnSubtitle => 'AI驱动的吠陀身心健康报告';

  @override
  String get mnTitle => '心理与压力';

  @override
  String get mnSnapshotHeader => '身心健康概览';

  @override
  String get mnResilience => '韧性';

  @override
  String get mnStability => '稳定性';

  @override
  String get mnEmotionalBalance => '情绪平衡';

  @override
  String get mnInnerCalm => '内在平静';

  @override
  String get mnSelfAwareness => '自我觉察力';

  @override
  String get mnStatusThriving => '蓬勃向上';

  @override
  String get mnStatusSteady => '稳定平和';

  @override
  String get mnStatusBuildingStrength => '正在积蓄力量';

  @override
  String get mnStatusNeedsGentleCare => '需要温和照顾';

  @override
  String get mnStatusReachOut => '是时候寻求支持了';

  @override
  String get mnChipStable => '情绪稳定';

  @override
  String get mnChipSupported => '支持充足';

  @override
  String get mnChipSelfAware => '高度自我觉察';

  @override
  String get mnChipResilient => '恢复力强';

  @override
  String get mnChipSecureAttachment => '安全型依恋';

  @override
  String get mnChipHealingReady => '已准备好疗愈';

  @override
  String get mnChipMindBodyBalance => '身心平衡';

  @override
  String get mnSupportBannerTitle => '温馨提示';

  @override
  String get mnSupportBannerBody =>
      '您的星盘显示，现在可能是寻求额外支持的好时机——无论是信任的朋友、家人还是专业人士。主动求助是坚强的表现，而非软弱。';

  @override
  String get mnProfileTitle => '您的情绪蓝图';

  @override
  String get mnStressDriver => '压力来源';

  @override
  String get mnStabilityAnchor => '稳定之锚';

  @override
  String get mnSoulLevelKarma => '灵魂层面的模式';

  @override
  String get mnSubtleSignature => '微妙的情绪印记';

  @override
  String get mnKarakaTitle => '您的心智与行星';

  @override
  String get mnKarakaSubtitle => '哪些行星塑造了您的内心世界';

  @override
  String get mnYogasTitle => '优势与成长领域';

  @override
  String get mnCurrentPhase => '当前阶段';

  @override
  String get mnCurrentStressLevel => '当前压力水平';

  @override
  String get mnRecentStrain => '近期情绪压力';

  @override
  String get mnStrengths => '优势';

  @override
  String get mnGrowthAreas => '成长领域';

  @override
  String get mnSadeSatiStatus => '土星七返状态';

  @override
  String get mnVerificationTitle => '跨星盘验证';

  @override
  String get mnD9Confirmation => 'D9验证';

  @override
  String get mnD30Confirmation => 'D30验证';

  @override
  String get mnMoodPatternsTitle => '情绪与焦虑模式';

  @override
  String get mnMoodPatternsSubtitle => '温和的觉察，而非诊断';

  @override
  String get mnAnxietyPatterns => '焦虑模式';

  @override
  String get mnMoodPatterns => '低落情绪模式';

  @override
  String get mnPrimaryPattern => '主要模式';

  @override
  String get mnRumination => '过度思虑倾向';

  @override
  String get mnHypervigilance => '过度警觉';

  @override
  String get mnHopelessnessVuln => '低落情绪易感性';

  @override
  String get mnEnergyDepletion => '精力耗竭倾向';

  @override
  String get mnMotivationBaseline => '动力基线';

  @override
  String get mnRegulationTitle => '情绪调节与应对';

  @override
  String get mnEmotionalRegulation => '情绪调节能力';

  @override
  String get mnSelfSoothing => '自我安抚能力';

  @override
  String get mnExpressionStyle => '表达风格';

  @override
  String get mnRecoveryTime => '恢复时间';

  @override
  String get mnTriggerIntensity => '触发强度';

  @override
  String get mnHealthyCoping => '健康的应对习惯';

  @override
  String get mnWatchFor => '需温和留意的事项';

  @override
  String get mnSleepTitle => '睡眠与休息';

  @override
  String get mnSleepQuality => '睡眠质量';

  @override
  String get mnSleepAsRegulator => '睡眠作为情绪调节器';

  @override
  String get mnInsomniaTendency => '夜间不安倾向';

  @override
  String get mnNightmareTendency => '生动梦境倾向';

  @override
  String get mnSleepHygienePriority => '睡眠卫生优先度';

  @override
  String get mnBurnoutTitle => '职业倦怠与精力';

  @override
  String get mnBurnoutVulnerability => '职业倦怠易感性';

  @override
  String get mnBurnoutRecovery => '职业倦怠恢复能力';

  @override
  String get mnBurnoutStage => '当前倦怠阶段';

  @override
  String get mnSelfDrivingTendency => '自我驱动倾向';

  @override
  String get mnBurnoutTriggers => '职业倦怠诱因';

  @override
  String get mnConnectionTitle => '连接与支持';

  @override
  String get mnSocialSupport => '社会支持质量';

  @override
  String get mnLonelinessVuln => '孤独易感性';

  @override
  String get mnSolitudeNeed => '独处需求';

  @override
  String get mnSocialComfort => '社交自在度';

  @override
  String get mnTraumaSensitivity => '创伤敏感度';

  @override
  String get mnHealingReadiness => '疗愈准备度';

  @override
  String get mnProcessingStyle => '情绪处理方式';

  @override
  String get mnMindBodyIntegration => '身心整合度';

  @override
  String get mnPtsdVuln => '创伤反应敏感度';

  @override
  String get mnSelfAwarenessTitle => '自我觉察与成长';

  @override
  String get mnSelfAwarenessScore => '自我觉察力';

  @override
  String get mnEmotionalVocabulary => '情绪表达词汇量';

  @override
  String get mnTherapyReadiness => '心理治疗准备度';

  @override
  String get mnJournalingBenefit => '写日记的益处';

  @override
  String get mnInnerDialogue => '内心对话质量';

  @override
  String get mnAwarenessOfPatterns => '模式觉察力';

  @override
  String get mnEscapePatternVuln => '逃避模式易感性';

  @override
  String get mnEscapeChannels => '需温和留意的事项';

  @override
  String get mnHealthyAlternatives => '健康的替代方式';

  @override
  String get mnTherapyFitTitle => '心理治疗与支持适配度';

  @override
  String get mnCrisisSupportRec => '支持建议';

  @override
  String get mnSupportNetwork => '启动您的支持网络';

  @override
  String get mnSelfAdvocacy => '自我倡导准备度';

  @override
  String get mnMedicationReceptivity => '对药物治疗的接受度';

  @override
  String get mnTimelineTitle => '身心健康时间线';

  @override
  String get mnPeakWellnessYears => '身心健康巅峰年份';

  @override
  String get mnExtraCareYears => '需额外自我关怀的年份';

  @override
  String get mnTransformationWindows => '积极转变时段';

  @override
  String get mnTherapyWindow => '推荐的心理治疗时段';

  @override
  String get mnPracticesTitle => '日常身心健康练习';

  @override
  String get mnMorningPractices => '晨间练习';

  @override
  String get mnEveningPractices => '晚间练习';

  @override
  String get mnBreathwork => '呼吸练习';

  @override
  String get mnMovement => '运动';

  @override
  String get mnNutrition => '营养';

  @override
  String get mnNatureExposure => '接触自然的需求';

  @override
  String get mnDigitalDetox => '数字排毒需求';

  @override
  String get mnImprovementTitle => '改进计划';

  @override
  String get mnReliabilityTitle => '可靠性';

  @override
  String get mnLayerD1 => '本命盘（D1）';

  @override
  String get mnLayerD9 => '灵魂盘（D9）';

  @override
  String get mnLayerD30 => 'D30盘';

  @override
  String get mnLayerDasha => '大运时机';

  @override
  String get mnLayerTransit => '行运';

  @override
  String get mnTopicResilience => '我的情绪韧性如何？';

  @override
  String get mnTopicCoping => '我最好的应对策略是什么？';

  @override
  String get mnTopicSleep => '我该如何改善睡眠？';

  @override
  String get mnTopicBurnout => '我是否有职业倦怠的风险？';

  @override
  String get mnTopicTherapy => '哪种心理治疗方式适合我？';

  @override
  String get mnTopicPractices => '哪些日常练习对我帮助最大？';

  @override
  String get mnTopicTiming => '我身心健康的最佳年份是什么时候？';

  @override
  String get mnTopicSupport => '我该如何建立强大的支持网络？';

  @override
  String get lgSubtitle => 'AI驱动的吠陀法律报告';

  @override
  String get lgTitle => '法律与纠纷';

  @override
  String get lgSnapshotHeader => '法律概览';

  @override
  String get lgResilience => '法律韧性';

  @override
  String get lgResolutionCapacity => '解决问题的能力';

  @override
  String get lgVictoryPotential => '胜诉潜力';

  @override
  String get lgLegalSafety => '法律安全度';

  @override
  String get lgNegotiationSkill => '谈判技巧';

  @override
  String get lgStatusExcellent => '极佳';

  @override
  String get lgStatusStrong => '较强';

  @override
  String get lgStatusModerate => '中等';

  @override
  String get lgStatusDeveloping => '发展中';

  @override
  String get lgStatusChallenging => '具有挑战性';

  @override
  String get lgChipResolver => '善于解决问题';

  @override
  String get lgChipWinner => '案件胜诉能力强';

  @override
  String get lgChipNegotiator => '天生的谈判高手';

  @override
  String get lgChipDocumented => '文档准备充分';

  @override
  String get lgChipLowRisk => '法律风险较低';

  @override
  String get lgChipMoralAuthority => '道德权威';

  @override
  String get lgChipLegalAptitude => '法律天赋';

  @override
  String get lgProfileTitle => '您的法律档案与业力';

  @override
  String get lgPrimaryDriver => '主要驱动力';

  @override
  String get lgDharmaAnchor => '达摩之锚';

  @override
  String get lgAggressionMarker => '攻击性指标';

  @override
  String get lgDocumentationKaraka => '文档质量';

  @override
  String get lgKarakaTitle => '您的法律行星';

  @override
  String get lgKarakaSubtitle => '哪些行星塑造了您的法律运势';

  @override
  String get lgYogasTitle => '法律瑜伽与保护力';

  @override
  String get lgCurrentPhase => '当前阶段';

  @override
  String get lgProtections => '保护因素';

  @override
  String get lgDisputePressures => '纠纷压力';

  @override
  String get lgVerificationTitle => '跨星盘验证';

  @override
  String get lgD6Litigation => 'D6诉讼盘';

  @override
  String get lgD9Dharma => 'D9达摩盘';

  @override
  String get lgMoralAuthority => '道德权威';

  @override
  String get lgVictoryTitle => '胜诉分析';

  @override
  String get lgAsPlaintiff => '作为原告';

  @override
  String get lgAsDefendant => '作为被告';

  @override
  String get lgSettlementPreference => '和解倾向';

  @override
  String get lgDisputeCategoriesTitle => '纠纷类别关注';

  @override
  String get lgLowRiskCategories => '低风险类别';

  @override
  String get lgConflictStyleTitle => '冲突风格与仇敌';

  @override
  String get lgConfrontationComfort => '面对冲突的自在度';

  @override
  String get lgArgumentPersuasiveness => '论证说服力';

  @override
  String get lgEmotionalRegulation => '情绪调节能力';

  @override
  String get lgGrudgeHolding => '记仇倾向';

  @override
  String get lgEnemyAnalysisLabel => '仇敌分析';

  @override
  String get lgVisibleEnemies => '明面仇敌';

  @override
  String get lgHiddenEnemies => '隐藏仇敌';

  @override
  String get lgWorkplaceEnemies => '职场仇敌';

  @override
  String get lgFamilyEnemies => '家庭内仇敌';

  @override
  String get lgLegalEnemies => '法律纠纷对手';

  @override
  String get lgEnemyDefeatCapacity => '战胜仇敌的能力';

  @override
  String get lgCriminalFinancialTitle => '刑事与财务风险关注';

  @override
  String get lgCriminalRisk => '涉刑风险';

  @override
  String get lgVictimOfCrime => '成为犯罪受害者的概率';

  @override
  String get lgFalseAccusation => '被诬告的风险';

  @override
  String get lgImprisonmentRisk => '监禁风险';

  @override
  String get lgTaxDisputeRisk => '税务纠纷风险';

  @override
  String get lgFinancialFraudRisk => '财务欺诈风险';

  @override
  String get lgBusinessLitigationRisk => '商业诉讼风险';

  @override
  String get lgBankruptcyRisk => '破产风险';

  @override
  String get lgAuditVulnerability => '被审计的脆弱性';

  @override
  String get lgProtectionPriority => '保护优先事项';

  @override
  String get lgContractsTitle => '合同与谈判';

  @override
  String get lgContractClarity => '合同清晰度';

  @override
  String get lgDocumentationDiscipline => '文档管理自律性';

  @override
  String get lgFinePrintAwareness => '细则条款的警觉性';

  @override
  String get lgSignatureCaution => '签署时的谨慎度';

  @override
  String get lgMediationReceptivity => '调解接受度';

  @override
  String get lgNegotiationSkillFull => '谈判技巧';

  @override
  String get lgCompromiseWillingness => '妥协意愿';

  @override
  String get lgFaceSavingNeeds => '保全颜面的需求';

  @override
  String get lgMediatorHireRecommendation => '聘请调解人建议';

  @override
  String get lgTypicalContractIssues => '常见合同问题';

  @override
  String get lgCareerFitTitle => '法律职业适配度';

  @override
  String get lgProfessionAffinity => '职业亲和度';

  @override
  String get lgRoleFit => '最适合的角色';

  @override
  String get lgLawStudentSuccess => '法学学业成功率';

  @override
  String get lgBarExamSuccess => '司法考试成功率';

  @override
  String get lgTimelineTitle => '法律时间线';

  @override
  String get lgNewMatterChance => '未来12个月新增法律事务的概率';

  @override
  String get lgOngoingCaseOutcome => '在办案件结果';

  @override
  String get lgRecommendedAction => '推荐行动';

  @override
  String get lgPeakDisputeYears => '纠纷高发年份';

  @override
  String get lgClarityYears => '法律明朗年份';

  @override
  String get lgAvoidancePeriods => '重点规避时段';

  @override
  String get lgFavorableWindows => '有利化解时段';

  @override
  String get lgRisksTitle => '风险与脆弱点';

  @override
  String get lgChronicVulnerabilities => '长期脆弱点';

  @override
  String get lgAvoidDashaPeriods => '需关注的大运时段';

  @override
  String get lgPreventivePriorities => '预防优先事项';

  @override
  String get lgRedFlags => '警示情形';

  @override
  String get lgImprovementTitle => '改进计划';

  @override
  String get lgReliabilityTitle => '可靠性';

  @override
  String get lgLayerD1 => '本命盘（D1）';

  @override
  String get lgLayerD6 => '诉讼盘（D6）';

  @override
  String get lgLayerD9 => '达摩盘（D9）';

  @override
  String get lgLayerDasha => '大运时机';

  @override
  String get lgLayerTransit => '行运';

  @override
  String get lgTopicWinChance => '我的胜诉几率有多大？';

  @override
  String get lgTopicStrategy => '适合我的最佳法律策略是什么？';

  @override
  String get lgTopicContract => '需要注意哪些合同风险？';

  @override
  String get lgTopicTiming => '解决纠纷的最佳时机是什么？';

  @override
  String get lgTopicSettlement => '我应该和解还是抗争？';

  @override
  String get lgTopicEnemies => '谁是我的隐藏仇敌？';

  @override
  String get lgTopicProtection => '我该如何在法律上保护自己？';

  @override
  String get lgTopicCareer => '我适合从事法律职业吗？';

  @override
  String get prSubtitle => 'AI驱动的吠陀财产报告';

  @override
  String get prTitle => '财产与资产';

  @override
  String get prSnapshotHeader => '财产概览';

  @override
  String get prAcquisitionCapacity => '置产能力';

  @override
  String get prHomeOwnership => '购房能力';

  @override
  String get prWealthPotential => '财富潜力';

  @override
  String get prRentalIncome => '租金收入';

  @override
  String get prLandOwnership => '土地拥有';

  @override
  String get prStatusExcellent => '极佳';

  @override
  String get prStatusStrong => '较强';

  @override
  String get prStatusModerate => '中等';

  @override
  String get prStatusDeveloping => '发展中';

  @override
  String get prStatusChallenging => '具有挑战性';

  @override
  String get prChipHomeOwner => '拥有住房';

  @override
  String get prChipWealthBuilder => '财富积累者';

  @override
  String get prChipLandOwner => '拥有土地';

  @override
  String get prChipInvestor => '房产投资者';

  @override
  String get prChipInheritance => '可能获得继承';

  @override
  String get prChipVehicle => '拥有车辆';

  @override
  String get prChipGlobalAsset => '海外资产亲和度';

  @override
  String get prProfileTitle => '您的置业风格';

  @override
  String get prHomeAesthetics => '居家美感';

  @override
  String get prHomeSanctuary => '居所作为心灵庇护所';

  @override
  String get prComfortInvestment => '舒适投入';

  @override
  String get prVastuPriority => '风水（Vastu）优先度';

  @override
  String get prNaturalElements => '自然元素偏好';

  @override
  String get prNextActionLabel => '下一步行动';

  @override
  String get prKarakaTitle => '您的财产行星';

  @override
  String get prKarakaSubtitle => '哪些行星塑造了您的房产运势';

  @override
  String get prPrimaryKaraka => '主要徵星';

  @override
  String get prDurableAsset => '耐用资产徵星';

  @override
  String get prYogasTitle => '房产瑜伽与缺陷';

  @override
  String get prCurrentPhase => '当前阶段';

  @override
  String get prBoosters => '助力因素';

  @override
  String get prDrains => '消耗因素';

  @override
  String get prVerificationTitle => '跨星盘验证';

  @override
  String get prD4Property => 'D4房产盘';

  @override
  String get prD16Vehicle => 'D16车辆盘';

  @override
  String get prVehicleFit => '车辆适配度';

  @override
  String get prJourneyTitle => '置产历程与时间线';

  @override
  String get prFirstHomeAge => '首套房年龄';

  @override
  String get prFirstHomeType => '首套房类型';

  @override
  String get prMultipleHomes => '多套房产';

  @override
  String get prNewPropertySoon => '近期添置新房产';

  @override
  String get prFirstMajorWindow => '首个重要时段';

  @override
  String get prBuyingWindow => '购置时段';

  @override
  String get prConstructionWindow => '建造时段';

  @override
  String get prNextOpportunity => '下一次机会';

  @override
  String get prLifetimePropertyCount => '一生房产数量';

  @override
  String get prInheritanceTitle => '继承与家庭财产';

  @override
  String get prMaternalInheritance => '母系继承';

  @override
  String get prPaternalInheritance => '父系继承';

  @override
  String get prAncestralProperty => '祖产';

  @override
  String get prFamilyDisputeRisk => '家庭财产纠纷风险';

  @override
  String get prInheritanceTiming => '继承时机';

  @override
  String get prInheritanceType => '继承类型';

  @override
  String get prLandInvestTitle => '土地、投资与海外房产';

  @override
  String get prPropertyInvestor => '房产投资者评分';

  @override
  String get prAppreciationLuck => '增值运';

  @override
  String get prInvestorMindset => '投资者心态';

  @override
  String get prLandType => '土地类型';

  @override
  String get prRentalCount => '出租房产数量';

  @override
  String get prMultipleLand => '多块地产';

  @override
  String get prFarmEstate => '农场/庄园机会';

  @override
  String get prGlobalPropertyLabel => '海外房产';

  @override
  String get prForeignProperty => '境外房产';

  @override
  String get prNriAffinity => '海外印度人（NRI）资产亲和度';

  @override
  String get prVehiclesTitle => '车辆';

  @override
  String get prVehicleCount => '车辆数量';

  @override
  String get prVehicleFirstAge => '首辆车年龄';

  @override
  String get prVehicleCategory => '车辆类别';

  @override
  String get prVehicleQuality => '车辆品质';

  @override
  String get prLuxuryAffinity => '奢华偏好';

  @override
  String get prVehicleLossRisk => '车辆丢失/损坏风险';

  @override
  String get prLegalRiskTitle => '法律与风险关注';

  @override
  String get prBoundaryDisputes => '边界纠纷';

  @override
  String get prPartitionDisputes => '分割纠纷';

  @override
  String get prTitleIssues => '产权/文件问题';

  @override
  String get prTenantConflict => '租户与房东冲突';

  @override
  String get prForcedSale => '被迫出售风险';

  @override
  String get prPropertyDamage => '财产损坏风险';

  @override
  String get prInsurancePriority => '保险优先度';

  @override
  String get prProtectionUrgency => '保护紧迫性';

  @override
  String get prProtectiveFactors => '保护因素';

  @override
  String get prChronicVulnerabilities => '长期脆弱点';

  @override
  String get prDueDiligenceTitle => '尽职调查清单';

  @override
  String get prPreventiveMeasures => '预防措施';

  @override
  String get prImprovementTitle => '改进计划';

  @override
  String get prReliabilityTitle => '可靠性';

  @override
  String get prLayerD1 => '本命盘（D1）';

  @override
  String get prLayerD4 => '房产盘（D4）';

  @override
  String get prLayerD16 => '车辆盘（D16）';

  @override
  String get prLayerDasha => '大运时机';

  @override
  String get prLayerTransit => '行运';

  @override
  String get prTopicBuying => '最佳购置时机是什么时候？';

  @override
  String get prTopicInherit => '我会继承财产吗？';

  @override
  String get prTopicVehicle => '我什么时候会拥有车辆？';

  @override
  String get prTopicRental => '租金收入潜力如何？';

  @override
  String get prTopicLand => '拥有土地的机会有多大？';

  @override
  String get prTopicLegal => '需要注意哪些法律风险？';

  @override
  String get prTopicForeign => '拥有海外房产的机会有多大？';

  @override
  String get prTopicTiming => '置产的最佳时机窗口是什么？';

  @override
  String get edTitle => '教育与学习分析';

  @override
  String get edSubtitle => 'AI驱动的吠陀教育报告';

  @override
  String get edSnapshotHeader => '您的教育概览';

  @override
  String get edOverallStrength => '整体实力';

  @override
  String get edAcademicSuccess => '学业成就';

  @override
  String get edLearningCapacity => '学习能力';

  @override
  String get edIntellect => '智力';

  @override
  String get edMemory => '记忆力';

  @override
  String get edStatusExcellent => '潜力极佳';

  @override
  String get edStatusStrong => '潜力较强';

  @override
  String get edStatusModerate => '潜力中等';

  @override
  String get edStatusDeveloping => '潜力发展中';

  @override
  String get edStatusChallenging => '挑战阶段';

  @override
  String get edChipSaraswati => '妙音天女瑜伽（Saraswati Yoga）';

  @override
  String get edChipGajaKesari => '象狮瑜伽（Gaja Kesari Yoga）';

  @override
  String get edChipBudhaAditya => '水星-太阳瑜伽（Budha Aditya Yoga）';

  @override
  String get edChipResearch => '研究能力强';

  @override
  String get edChipScholarship => '奖学金潜力';

  @override
  String get edChipDoctorate => '博士学位潜力';

  @override
  String get edChipForeign => '海外留学支持力';

  @override
  String get edChipLifelong => '终身学习者';

  @override
  String get edLearningStyleTitle => '您的学习风格';

  @override
  String get edSoulPlanet => '灵魂行星';

  @override
  String get edSoulHint => '您内心最深处的驱动力与人生使命';

  @override
  String get edSubjectPlanet => '学科行星';

  @override
  String get edTechAtmakaraka => '灵魂行星（Atmakaraka，技术性）';

  @override
  String get edTechAmatyakaraka => '事业徵星（Amatyakaraka，技术性）';

  @override
  String get edSubjectKarakaStrength => '学科徵星强度';

  @override
  String get edFoundationTitle => '教育基础';

  @override
  String get edHouse4 => '早期教育';

  @override
  String get edHouse5 => '智力';

  @override
  String get edHouse9 => '高等教育';

  @override
  String get edPurvaPunya => '前世福报';

  @override
  String get edStudyPlanetsTitle => '您的学习行星';

  @override
  String get edYogasTitle => '您星盘中的教育瑜伽';

  @override
  String get edYogaBudhaAditya => '水星-太阳瑜伽（Budha Aditya）';

  @override
  String get edYogaGajaKesari => '象狮瑜伽（Gaja Kesari）';

  @override
  String get edYogaSaraswati => '妙音天女瑜伽（Saraswati）';

  @override
  String get edYogaPresent => '存在';

  @override
  String get edYogaAbsent => '不存在';

  @override
  String get edYogaNoneNote => '没有经典教育瑜伽——成功来自持续的努力与自律。';

  @override
  String get edVerificationTitle => '跨星盘验证';

  @override
  String get edD24Learning => 'D24——深度学习盘';

  @override
  String get edD4Formal => 'D4——正规教育盘';

  @override
  String get edD9Dharma => 'D9——学习达摩盘';

  @override
  String get edD60Karma => 'D60——前世学习业力';

  @override
  String get edSubjectsTitle => '最适合您的学科';

  @override
  String get edSubjectsSubtitle => '按星盘亲和度排序';

  @override
  String get edLowAffinity => '亲和度较低的学科';

  @override
  String get edDegreesTitle => '学位与层次可能性';

  @override
  String get edExpectedLevel => '预期层次';

  @override
  String get edDegreeFormal => '正规学位';

  @override
  String get edDegreePostgrad => '研究生';

  @override
  String get edDegreeDoctorate => '博士';

  @override
  String get edDegreeForeign => '海外教育';

  @override
  String get edTimelineTitle => '学习时间线';

  @override
  String get edEarlySchooling => '早期教育时段';

  @override
  String get edHigherEducation => '高等教育时段';

  @override
  String get edPostgradResearch => '研究生/科研时段';

  @override
  String get edPeakLearningAge => '学习巅峰年龄';

  @override
  String get edPreferencesTitle => '学习偏好与支持';

  @override
  String get edPrefStudyMode => '学习方式';

  @override
  String get edPrefTiming => '最佳时间';

  @override
  String get edPrefEnvironment => '学习环境';

  @override
  String get edPrefLocation => '地点';

  @override
  String get edPrefForeign => '海外求学';

  @override
  String get edGuruRelationship => '师生（古鲁）关系';

  @override
  String get edMentorAvailability => '导师可得性';

  @override
  String get edPeerLearning => '同侪学习';

  @override
  String get edAuthorityDeference => '对权威的尊重';

  @override
  String get edStrengthsTitle => '优势与挑战';

  @override
  String get edCognitiveGifts => '认知天赋';

  @override
  String get edNaturalAbilities => '天生学习能力';

  @override
  String get edHiddenCapacities => '潜在能力';

  @override
  String get edConcentration => '专注力困难度';

  @override
  String get edBreakRisk => '学业中断风险';

  @override
  String get edDisciplineConsistency => '自律持续性';

  @override
  String get edScholarshipLikelihood => '获得奖学金的可能性';

  @override
  String get edCareerLinkTitle => '教育→职业路径';

  @override
  String get edDirectionRec => '推荐方向';

  @override
  String get edIntegrationStrategy => '融合策略';

  @override
  String get edCareerLinkage => '职业关联度';

  @override
  String get edAlignedSubjects => '与职业契合的学科';

  @override
  String get edDegreeUtility => '学位对职业的实用性';

  @override
  String get edImprovementTitle => '您的改进计划';

  @override
  String get edReliabilityTitle => '预测可靠性';

  @override
  String get edLayerD1 => '本命盘（D1）';

  @override
  String get edLayerD4 => '正规教育盘（D4）';

  @override
  String get edLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get edLayerD24 => '深度学习盘（D24）';

  @override
  String get edLayerD60 => '前世学习盘（D60）';

  @override
  String get edLayerAmk => '学科徵星';

  @override
  String get edLayerMj => '水星-木星';

  @override
  String get edLayerDasha => '行星时机';

  @override
  String get edTopicSubjects => '最适合我的学科';

  @override
  String get edTopicDegree => '学位机会';

  @override
  String get edTopicAbroad => '海外求学';

  @override
  String get edTopicExam => '考试表现';

  @override
  String get edTopicHabits => '学习习惯';

  @override
  String get edTopicCareerLink => '教育与职业的关联';

  @override
  String get edTopicTiming => '教育时机窗口';

  @override
  String get edTopicScholarship => '奖学金机会';

  @override
  String get hwTitle => '健康与身心分析';

  @override
  String get hwSubtitle => 'AI驱动的吠陀健康与身心报告';

  @override
  String get hwSnapshotHeader => '您的健康概览';

  @override
  String get hwOverallVitality => '活力';

  @override
  String get hwImmunity => '免疫力';

  @override
  String get hwRecovery => '恢复力';

  @override
  String get hwMentalWellness => '心理健康';

  @override
  String get hwStressTolerance => '抗压能力';

  @override
  String get hwStatusThriving => '蓬勃向上';

  @override
  String get hwStatusGood => '活力良好';

  @override
  String get hwStatusBalanced => '均衡';

  @override
  String get hwStatusNeedsCare => '需要照顾';

  @override
  String get hwStatusNeedsAttention => '需要关注';

  @override
  String get hwChipImmunity => '免疫力强';

  @override
  String get hwChipRecovery => '恢复迅速';

  @override
  String get hwChipMentalBalance => '心态平衡';

  @override
  String get hwChipStressResilience => '抗压能力强';

  @override
  String get hwChipFertility => '生育力支持';

  @override
  String get hwChipWorkLife => '工作生活平衡良好';

  @override
  String get hwChipLowAddiction => '成瘾风险较低';

  @override
  String get hwConstitutionTitle => '您的体质类型';

  @override
  String get hwConstitutionSubtitle => '根据星盘推断的阿育吠陀体质';

  @override
  String get hwDominantDosha => '主导';

  @override
  String get hwSecondaryDosha => '次要';

  @override
  String get hwPrimaryKaraka => '主要健康指标';

  @override
  String get hwStrongestSystem => '最强系统';

  @override
  String get hwWeakestSystem => '需支持的系统';

  @override
  String get hwBodyMapTitle => '您身体的行星图谱';

  @override
  String get hwBodyMapSubtitle => '9大行星，9大身体系统';

  @override
  String get hwYogaTitle => '您星盘中的健康模式';

  @override
  String get hwYogaSubtitle => '保护性瑜伽与致病压力瑜伽';

  @override
  String get hwDiseasePressureLabel => '疾病压力';

  @override
  String get hwAreasTitle => '需要关注的身体部位';

  @override
  String get hwAreasSubtitle => '各身体区域的脆弱度';

  @override
  String get hwProtectedAreas => '受保护较好的部位';

  @override
  String get hwCategoriesTitle => '疾病类别关注';

  @override
  String get hwCategoriesSubtitle => '主要健康类别的易感性';

  @override
  String get hwLowRiskCategories => '低风险类别';

  @override
  String get hwMentalTitle => '心理与情绪健康';

  @override
  String get hwMentalSubtitle => '情绪韧性与支持需求';

  @override
  String get hwMentalVulnerability => '情绪敏感度';

  @override
  String get hwEmotionalRegulation => '情绪调节能力';

  @override
  String get hwSupportRec => '支持建议';

  @override
  String get hwTendencies => '心理倾向';

  @override
  String get hwTimelineTitle => '健康时间线';

  @override
  String get hwTimelineSubtitle => '巅峰年份、需谨慎年份与恢复时段';

  @override
  String get hwPeakYears => '健康巅峰年份';

  @override
  String get hwCautionYears => '需谨慎年份';

  @override
  String get hwRecoveryWindow => '恢复时段';

  @override
  String get hwCheckupYears => '推荐体检年份';

  @override
  String get hwCurrentPhase => '当前阶段';

  @override
  String get hwLifestyleTitle => '您的生活方式指南';

  @override
  String get hwLifestyleSubtitle => '您的星盘揭示的日常习惯';

  @override
  String get hwSleepDiscipline => '睡眠自律的影响';

  @override
  String get hwDietDiscipline => '饮食自律的影响';

  @override
  String get hwExerciseNeed => '运动需求';

  @override
  String get hwSunlightNeed => '日照需求';

  @override
  String get hwStressSusceptibility => '压力易感性';

  @override
  String get hwHydrationSensitivity => '水分敏感度';

  @override
  String get hwSocialType => '社交能量类型';

  @override
  String get hwHealingSpeed => '疗愈速度';

  @override
  String get hwTreatmentResponse => '治疗反应';

  @override
  String get hwAltHealing => '替代疗法亲和度';

  @override
  String get hwSpecialTitle => '人生阶段与特殊议题';

  @override
  String get hwSpecialSubtitle => '生育力、童年健康、习惯与职业倦怠';

  @override
  String get hwFertility => '生育力指标';

  @override
  String get hwHormonalBalance => '荷尔蒙平衡';

  @override
  String get hwReproductiveStrength => '生殖系统强度';

  @override
  String get hwChildhoodVuln => '童年健康脆弱度';

  @override
  String get hwChildhoodStatus => '童年健康状况';

  @override
  String get hwAddictionVuln => '成瘾脆弱度';

  @override
  String get hwAddictionRecovery => '恢复能力';

  @override
  String get hwBurnoutVuln => '职业倦怠脆弱度';

  @override
  String get hwWorkLifeBalance => '工作生活平衡';

  @override
  String get hwStressTriggers => '压力诱因';

  @override
  String get hwProtectiveFactors => '保护因素';

  @override
  String get hwChallengesTitle => '需要关注的挑战';

  @override
  String get hwChallengesSubtitle => '预防保健的重点方向';

  @override
  String get hwMitigation => '应对方法';

  @override
  String get hwChronicAreas => '长期脆弱部位';

  @override
  String get hwPreventivePriorities => '预防优先事项';

  @override
  String get hwImprovementTitle => '您的健康计划';

  @override
  String get hwImprovementSubtitle => '实用步骤与传统疗法';

  @override
  String get hwReliabilityTitle => '解读可靠性';

  @override
  String get hwLayerD1 => '本命盘（D1）';

  @override
  String get hwLayerD6 => '健康盘（D6）';

  @override
  String get hwLayerD30 => '微观健康盘（D30）';

  @override
  String get hwLayerDasha => '行星时机';

  @override
  String get hwLayerTransit => '当前行运';

  @override
  String get hwDisclaimerLabel => '医疗免责声明';

  @override
  String get hwTopicImmunity => '提升免疫力';

  @override
  String get hwTopicSleep => '睡眠与休息';

  @override
  String get hwTopicStress => '管理压力';

  @override
  String get hwTopicFertility => '生育时机';

  @override
  String get hwTopicDiet => '饮食与营养';

  @override
  String get hwTopicTiming => '健康时机窗口';

  @override
  String get hwTopicMental => '心理健康';

  @override
  String get hwTopicPrevention => '预防保健计划';

  @override
  String get lvSubtitle => 'AI驱动的吠陀爱情报告';

  @override
  String get lvTitle => '爱情与人际关系';

  @override
  String get lvLovePotential => '爱情潜力';

  @override
  String get lvEmotionalAvail => '情感开放度';

  @override
  String get lvAttraction => '吸引力';

  @override
  String get lvCommitment => '承诺度';

  @override
  String get lvCommunication => '沟通能力';

  @override
  String get lvFidelity => '忠诚度';

  @override
  String get lvChipLoyal => '忠诚之心';

  @override
  String get lvChipOpenHeart => '心胸开阔';

  @override
  String get lvChipCommunicator => '沟通高手';

  @override
  String get lvChipMature => '善于处理冲突';

  @override
  String get lvChipEmotionallyWise => '情感成熟睿智';

  @override
  String get lvLoveStyle => '您的爱情风格';

  @override
  String get lvAttractionStyle => '吸引风格';

  @override
  String get lvLangGiven => '您表达爱的方式';

  @override
  String get lvLangReceived => '您感受到爱的方式';

  @override
  String get lvLovePlanets => '您的爱情行星';

  @override
  String get lvLoveKaraka => '爱情';

  @override
  String get lvEmotionKaraka => '情感';

  @override
  String get lvPassionKaraka => '激情';

  @override
  String get lvPathToLove => '您通往爱情的道路';

  @override
  String get lvPathSub => '自由恋爱与包办婚姻';

  @override
  String get lvLoveMarriage => '自由恋爱婚姻';

  @override
  String get lvArrangedMarriage => '包办婚姻';

  @override
  String get lvParentalAccept => '父母接受度';

  @override
  String get lvInterCaste => '跨种姓/宗教联姻';

  @override
  String get lvIdealPartner => '您的理想伴侣';

  @override
  String get lvPersonality => '性格';

  @override
  String get lvAppearance => '外貌';

  @override
  String get lvIdealTraits => '理想特质';

  @override
  String get lvWhatMatters => '最重要的事';

  @override
  String get lvDrawnTo => '会被吸引的类型';

  @override
  String get lvDealbreakers => '无法接受的底线';

  @override
  String get lvYourAppeal => '您的魅力所在';

  @override
  String get lvLoveStory => '您的爱情故事';

  @override
  String get lvLoveStorySub => '关系模式';

  @override
  String get lvFirstLove => '初恋';

  @override
  String get lvRelationCount => '重要感情关系';

  @override
  String get lvDuration => '典型持续时间';

  @override
  String get lvDepth => '情感深度';

  @override
  String get lvDatingPattern => '恋爱模式';

  @override
  String get lvCommitIntimacy => '承诺与亲密关系';

  @override
  String get lvCommitReady => '承诺准备度';

  @override
  String get lvIntimacyDrive => '亲密渴望度';

  @override
  String get lvSensuality => '感官魅力';

  @override
  String get lvEmpathy => '同理心';

  @override
  String get lvCommitStyle => '承诺风格';

  @override
  String get lvChemistry => '化学反应风格';

  @override
  String get lvMakesCommit => '促使您承诺的因素';

  @override
  String get lvMakesFlee => '让您却步的因素';

  @override
  String get lvEmotional => '情商';

  @override
  String get lvEmotionalIQ => '情商指数';

  @override
  String get lvConflictStyle => '冲突应对风格';

  @override
  String get lvTiming => '爱情时机';

  @override
  String get lvNewLove12 => '12个月内出现新恋情';

  @override
  String get lvEnergyNow => '当前能量';

  @override
  String get lvPhaseNow => '当前阶段';

  @override
  String get lvPeakRomance => '浪漫巅峰年份';

  @override
  String get lvNewLoveWindow => '新恋情时段';

  @override
  String get lvChallenges => '需要关注的挑战';

  @override
  String get lvRiskHeartbreak => '心碎易感度';

  @override
  String get lvRiskSabotage => '自我破坏';

  @override
  String get lvRiskCommitFear => '承诺恐惧';

  @override
  String get lvRiskRepeat => '重复模式';

  @override
  String get lvRiskWorkaholic => '重事业轻爱情';

  @override
  String get lvRedFlags => '需要留意的警示信号';

  @override
  String get lvHealing => '需要疗愈的地方';

  @override
  String get lvFocusArea => '重点关注领域';

  @override
  String get lvHealDir => '疗愈方向';

  @override
  String get lvImprovementPlan => '改进计划';

  @override
  String get lvReliability => '预测可靠性';

  @override
  String get lvLayerBirth => '本命盘（D1）';

  @override
  String get lvLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get lvLayerSaptamsa => '萨普塔姆萨盘（D7）';

  @override
  String get lvLayerDasha => '大运时机';

  @override
  String get lvLayerTransit => '当前行运';

  @override
  String get lvTopicWhen => '我什么时候能找到爱情？';

  @override
  String get lvTopicSoulmate => '关于我的灵魂伴侣';

  @override
  String get lvTopicCurrent => '我目前的感情关系';

  @override
  String get lvTopicHeal => '从过去中疗愈';

  @override
  String get lvTopicCommit => '承诺方面的帮助';

  @override
  String get lvTopicLoveVsArranged => '自由恋爱与包办婚姻';

  @override
  String get lvTopicHeartbreak => '避免心碎';

  @override
  String get lvTopicConfidence => '爱情中的自信';

  @override
  String get mrSubtitle => 'AI驱动的吠陀婚姻报告';

  @override
  String get mrTitle => '婚姻与家庭';

  @override
  String get mrMarriagePotential => '婚姻潜力';

  @override
  String get mrHarmony => '和谐度';

  @override
  String get mrLongevity => '长久度';

  @override
  String get mrSatisfaction => '满意度';

  @override
  String get mrStability => '家庭稳定性';

  @override
  String get mrClarity => '清晰度';

  @override
  String get mrChipHarmony => '和谐的纽带';

  @override
  String get mrChipNoMangal => '无火星缺陷（Mangal Dosh）';

  @override
  String get mrChipLongLasting => '持久稳固';

  @override
  String get mrChipHome => '有望拥有自己的住所';

  @override
  String get mrChipInLaws => '姻亲关系良好';

  @override
  String get mrChipChildren => '子女有福';

  @override
  String get mrSpouse => '您未来的配偶';

  @override
  String get mrSpouseSub => '星盘所揭示的信息';

  @override
  String get mrSpouseTraits => '可能的性格';

  @override
  String get mrSpouseWork => '可能的职业';

  @override
  String get mrAgeDiff => '年龄差';

  @override
  String get mrCulture => '文化契合度';

  @override
  String get mrEducation => '教育背景';

  @override
  String get mrFamilyBg => '家庭背景';

  @override
  String get mrSoulPartnership => '灵魂与伴侣关系';

  @override
  String get mrSelfPlanet => '您在关系中的样子';

  @override
  String get mrSpousePlanet => '您的配偶行星';

  @override
  String get mrSoulAlignment => '灵魂契合度';

  @override
  String get mrAlignStrong => '您的灵魂与理想伴侣高度契合——这有力支持了一段深刻圆满的感情关系。';

  @override
  String get mrAlignModerate => '您的灵魂与理想伴侣中等契合——通过用心经营，圆满的感情关系会逐渐成长。';

  @override
  String get mrAlignLow => '您的灵魂与伴侣关系需要有意识地融合——请选择真正符合您内在价值观的伴侣。';

  @override
  String get mrTechDarakaraka => '配偶行星（Darakaraka）';

  @override
  String get mrUpapada => '婚姻点（Upapada）';

  @override
  String get mrUpapadaLord => '副宫（Upapada）主星';

  @override
  String get mrFoundation => '婚姻基础';

  @override
  String get mrMarriageSign => '婚姻星座';

  @override
  String get mrMarriageLord => '婚姻主星';

  @override
  String get mrHouseStrength => '宫位强度';

  @override
  String get mrPartnerHint => '星盘中的伴侣提示';

  @override
  String get mrHarmonyHdr => '合盘和谐度';

  @override
  String get mrHarmonySub => '你们的连接方式';

  @override
  String get mrEmotional => '情感层面';

  @override
  String get mrIntellectual => '智识层面';

  @override
  String get mrPhysical => '身体亲密';

  @override
  String get mrFinancial => '财务层面';

  @override
  String get mrCommunication => '沟通';

  @override
  String get mrSharedValues => '共同价值观';

  @override
  String get mrSpiritual => '灵性层面';

  @override
  String get mrConflictRes => '冲突化解';

  @override
  String get mrTiming => '婚姻时机';

  @override
  String get mrFirstMarriageAge => '可能的结婚年龄';

  @override
  String get mrDelayChance => '延迟概率';

  @override
  String get mrMarriageWindow => '结婚时段';

  @override
  String get mrSecondaryWindow => '备选时段';

  @override
  String get mrCurrentReadiness => '当前状态';

  @override
  String get mrJourney => '婚姻历程';

  @override
  String get mrJourneySub => '关系的演变方式';

  @override
  String get mrPhaseEarly => '初期';

  @override
  String get mrPhaseMid => '中期';

  @override
  String get mrPhaseMature => '成熟期';

  @override
  String get mrPhaseLate => '晚期';

  @override
  String get mrTip => '提示';

  @override
  String get mrFamilyHome => '家庭与住所';

  @override
  String get mrInLaws => '姻亲关系';

  @override
  String get mrFamilyHarmony => '家庭和谐';

  @override
  String get mrHomeOwnership => '购房能力';

  @override
  String get mrDomesticPeace => '家庭安宁';

  @override
  String get mrFertility => '生育力';

  @override
  String get mrParenting => '育儿和谐度';

  @override
  String get mrChildren => '子女';

  @override
  String get mrLikelyCount => '可能数量';

  @override
  String get mrVerification => '跨星盘验证';

  @override
  String get mrD9 => '婚姻盘（D9）';

  @override
  String get mrD10 => '事业-配偶盘（D10）';

  @override
  String get mrD60 => '业力盘（D60）';

  @override
  String get mrChallenges => '需要关注的挑战';

  @override
  String get mrMangalPresent => '星盘中存在火星缺陷（Mangal Dosh）——请仔细核对补救方法与合婚匹配。';

  @override
  String get mrMangalAbsent => '未检测到火星缺陷——这是有利于婚姻的迹象。';

  @override
  String get mrRiskConflict => '冲突';

  @override
  String get mrRiskSeparation => '分离';

  @override
  String get mrRiskDistance => '情感疏离';

  @override
  String get mrRiskInfidelity => '不忠';

  @override
  String get mrRiskFinance => '财务分歧';

  @override
  String get mrPartnerGuide => '伴侣指南';

  @override
  String get mrPartnerGuideSub => '需要留意的要点';

  @override
  String get mrSeek => '寻找';

  @override
  String get mrMatchingPriorities => '合婚优先事项';

  @override
  String get mrImprovementPlan => '改进计划';

  @override
  String get mrReliability => '预测可靠性';

  @override
  String get mrLayerBirth => '本命盘（D1）';

  @override
  String get mrLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get mrLayerDashamsa => '达萨姆萨盘（D10）';

  @override
  String get mrLayerShashtiamsa => '业力盘（D60）';

  @override
  String get mrLayerDarakaraka => '配偶行星';

  @override
  String get mrTopicWhen => '我什么时候结婚？';

  @override
  String get mrTopicSpouse => '关于我的配偶';

  @override
  String get mrTopicCompat => '合盘建议';

  @override
  String get mrTopicDelay => '婚姻延迟';

  @override
  String get mrTopicMangal => '火星缺陷（Mangal Dosh）';

  @override
  String get mrTopicChildren => '生育时机';

  @override
  String get mrTopicInLaws => '姻亲关系';

  @override
  String get mrTopicHarmony => '建立和谐关系';

  @override
  String get wlSubtitle => 'AI驱动的吠陀财富报告';

  @override
  String get wlTitle => '财富与财务';

  @override
  String get wlWealthPotential => '财富潜力';

  @override
  String get wlAccumulation => '积累能力';

  @override
  String get wlIncomeFlow => '收入流';

  @override
  String get wlRetention => '留存能力';

  @override
  String get wlSustainability => '可持续性';

  @override
  String get wlSavings => '储蓄自律';

  @override
  String get wlChipSaver => '天生善于储蓄';

  @override
  String get wlChipMultiIncome => '多元收入';

  @override
  String get wlChipStrongYogas => '财富瑜伽';

  @override
  String get wlChipLowDebt => '低负债';

  @override
  String get wlChipInheritance => '可能获得继承';

  @override
  String get wlChipInvestor => '精明的投资者';

  @override
  String get wlWealthClass => '财富等级';

  @override
  String get wlWealthType => '主要财富类型';

  @override
  String get wlPrimarySource => '主要收入来源';

  @override
  String get wlPeakAge => '财富巅峰年龄';

  @override
  String get wlBoosters => '助推您财富的因素';

  @override
  String get wlBoostersSub => '强大的财富组合';

  @override
  String get wlWealthImpact => '加成';

  @override
  String get wlDrains => '财富消耗因素';

  @override
  String get wlIncomeSources => '收入来源';

  @override
  String get wlIncomeSourcesSub => '您的收入来源';

  @override
  String get wlPrimary => '主要';

  @override
  String get wlInvestment => '投资计划';

  @override
  String get wlInvestmentSub => '理想资产配置';

  @override
  String get wlRiskAppetite => '风险偏好';

  @override
  String get wlInvestStyle => '投资风格';

  @override
  String get wlDrivenBy => '驱动因素';

  @override
  String get wlMoneyPersonality => '金钱性格';

  @override
  String get wlMoneyType => '金钱类型';

  @override
  String get wlSpending => '消费习惯';

  @override
  String get wlSavingsDiscipline => '储蓄自律';

  @override
  String get wlCharity => '慈善倾向';

  @override
  String get wlLuxury => '奢侈消费';

  @override
  String get wlWindfalls => '意外之财与机遇';

  @override
  String get wlWindfallsSub => '基于运气的财富';

  @override
  String get wlInheritanceChance => '继承';

  @override
  String get wlSuddenGains => '意外获利';

  @override
  String get wlLottery => '彩票/投机';

  @override
  String get wlInsurance => '保险理赔';

  @override
  String get wlWindfallSource => '可能的意外之财来源';

  @override
  String get wlMoneyPlanets => '您的财富行星';

  @override
  String get wlPrimaryKaraka => '主要财富行星';

  @override
  String get wlSecondaryKaraka => '次要财富行星';

  @override
  String get wlTimeline => '财富时间线';

  @override
  String get wlPeakYears => '巅峰年份';

  @override
  String get wlGoodPeriod => '繁荣时期';

  @override
  String get wlSuddenGainWindow => '意外获利时段';

  @override
  String get wlToughPeriod => '需谨慎时期';

  @override
  String get wlDebtRisks => '债务与财务风险';

  @override
  String get wlDebtChance => '负债可能性';

  @override
  String get wlLoanBurden => '贷款负担';

  @override
  String get wlDrainSources => '需要留意';

  @override
  String get wlStrengthen => '需要加强的方面';

  @override
  String get wlWeakestDriver => '最薄弱的财富驱动因素';

  @override
  String get wlHowToFix => '如何加强';

  @override
  String get wlImprovementPlan => '改进计划';

  @override
  String get wlReliability => '预测可靠性';

  @override
  String get wlLayerBirth => '财富宫位（D1）';

  @override
  String get wlLayerHora => '霍拉盘（D2）';

  @override
  String get wlLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get wlLayerDasha => '大运时机';

  @override
  String get wlLayerTransit => '当前行运';

  @override
  String get wlTopicGrow => '如何增长财富';

  @override
  String get wlTopicInvest => '在哪里投资';

  @override
  String get wlTopicDebt => '管理债务';

  @override
  String get wlTopicProperty => '购置房产';

  @override
  String get wlTopicRetire => '退休规划';

  @override
  String get wlTopicPassive => '被动收入';

  @override
  String get wlTopicWindfall => '意外获利';

  @override
  String get wlTopicTiming => '最佳理财时机';

  @override
  String get bzSubtitle => 'AI驱动的吠陀商业报告';

  @override
  String get bzTitle => '商业与创业';

  @override
  String get bzBusinessPotential => '商业潜力';

  @override
  String get bzEntrepreneurship => '创业精神';

  @override
  String get bzVenture => '创业成功率';

  @override
  String get bzWealth => '通过商业获得的财富';

  @override
  String get bzRiskAppetite => '风险偏好';

  @override
  String get bzLongevity => '持久度';

  @override
  String get bzChipWealthMagnet => '财富磁石';

  @override
  String get bzChipMoneyYoga => '财富瑜伽';

  @override
  String get bzChipLeadership => '领导力';

  @override
  String get bzChipPartnerFit => '极佳的合伙契合度';

  @override
  String get bzChipGains => '强劲收益';

  @override
  String get bzChipInvestor => '吸引投资者';

  @override
  String get bzChipFounder => '创始人思维';

  @override
  String get bzWhatsWorking => '对您有利的因素';

  @override
  String get bzWhatsWorkingSub => '您的商业天赋';

  @override
  String get bzClassicYogas => '经典财富组合';

  @override
  String get bzFounderType => '您的创始人类型';

  @override
  String get bzSoulBusiness => '灵魂与商业使命';

  @override
  String get bzSoulPlanet => '您的灵魂驱动力';

  @override
  String get bzBusinessPlanet => '您的商业头脑';

  @override
  String get bzDirectionStrength => '方向清晰度';

  @override
  String get bzAlignStrong => '您的灵魂使命与商业方向高度契合——创业对您而言自然且充满成就感。';

  @override
  String get bzAlignModerate => '您的灵魂使命与商业方向中等契合——当创业能体现您更深层的价值观时效果最好。';

  @override
  String get bzAlignLow => '您的灵魂使命与商业方向需要有意识地对齐——请选择真正契合真实自我的事业。';

  @override
  String get bzTechAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get bzTechAmatyakaraka => '商业行星（Amatyakaraka）';

  @override
  String get bzTechDarakaraka => '合伙人行星（Darakaraka）';

  @override
  String get bzFoundation => '商业基础';

  @override
  String get bzCareerHouse => '事业宫';

  @override
  String get bzGainsHouse => '收益宫';

  @override
  String get bzLord => '主星';

  @override
  String get bzGainsPotential => '收益潜力';

  @override
  String get bzNetwork => '人脉力量';

  @override
  String get bzRecovery => '恢复能力';

  @override
  String get bzVerification => '跨星盘验证';

  @override
  String get bzD10 => '事业盘（D10）';

  @override
  String get bzD11 => '收益盘（D11）';

  @override
  String get bzD9 => '使命盘（D9）';

  @override
  String get bzD60 => '业力盘（D60）';

  @override
  String get bzFounderSkills => '创始人技能';

  @override
  String get bzSkillStrategy => '战略思维';

  @override
  String get bzSkillExecution => '执行力';

  @override
  String get bzSkillPeople => '团队管理';

  @override
  String get bzSkillSales => '销售与说服力';

  @override
  String get bzSkillFinance => '财务敏锐度';

  @override
  String get bzSkillOps => '运营纪律';

  @override
  String get bzTopSkill => '最强技能';

  @override
  String get bzDomains => '最适合的商业领域';

  @override
  String get bzDomainsSub => '按天生契合度排序';

  @override
  String get bzFit => '契合度';

  @override
  String get bzBusinessStyleHdr => '经商风格';

  @override
  String get bzStyleService => '产品型与服务型';

  @override
  String get bzStyleMarket => '市场定位';

  @override
  String get bzStyleTech => '科技路线';

  @override
  String get bzStyleLeadership => '领导风格';

  @override
  String get bzStylePartnership => '独资或合伙';

  @override
  String get bzWhereBuild => '覆盖范围';

  @override
  String get bzExpansion => '扩张';

  @override
  String get bzSetup => '创业设置';

  @override
  String get bzPartnership => '合伙与团队';

  @override
  String get bzIdealCofounder => '理想联合创始人';

  @override
  String get bzPartnerViability => '合伙契合度';

  @override
  String get bzTeamBuilding => '团队建设';

  @override
  String get bzCofounderFit => '联合创始人契合度';

  @override
  String get bzAdvisorNetwork => '顾问网络';

  @override
  String get bzFunding => '融资与资金';

  @override
  String get bzRecommendedPath => '推荐融资路径';

  @override
  String get bzInvestorAttract => '投资者吸引力';

  @override
  String get bzFamilyBacking => '家庭支持';

  @override
  String get bzHybridViability => '工作与创业并行';

  @override
  String get bzFallback => '留职以作后盾';

  @override
  String get bzDebtStyle => '负债风格';

  @override
  String get bzTimeline => '创业时间线';

  @override
  String get bzCurrentPhase => '当前阶段';

  @override
  String get bzLaunchWindow => '启动时段';

  @override
  String get bzScaleWindow => '成长时段';

  @override
  String get bzPeakAge => '巅峰年份';

  @override
  String get bzChallenges => '需要关注的挑战';

  @override
  String get bzRiskFinancial => '财务损失';

  @override
  String get bzRiskBurnout => '职业倦怠';

  @override
  String get bzRiskTeam => '团队冲突';

  @override
  String get bzRiskLegal => '法律/监管';

  @override
  String get bzFinancialExp => '创业过程中因过度投资或现金流时机不当而导致资金损失的风险。';

  @override
  String get bzFinancialFix => '保留现金储备，精简起步，在扩大支出前先验证市场需求。';

  @override
  String get bzBurnoutExp => '长期过度拼搏会耗尽您的精力与专注力。';

  @override
  String get bzBurnoutFix => '保护休息时间，尽早授权，并将重大冲刺安排在有利时期。';

  @override
  String get bzTeamExp => '与联合创始人或员工的摩擦可能拖慢业务发展。';

  @override
  String get bzTeamFix => '以书面形式明确角色与期望，并经常沟通。';

  @override
  String get bzLegalExp => '合规、合同或监管问题可能造成阻碍。';

  @override
  String get bzLegalFix => '让合同经过审核，保持文件规范，并尽早咨询专业人士。';

  @override
  String get bzImprovementPlan => '改进计划';

  @override
  String get bzBestDirection => '最佳方向';

  @override
  String get bzStrategy => '创业策略';

  @override
  String get bzTopFields => '热门领域';

  @override
  String get bzEmploymentPath => '就业与创业';

  @override
  String get bzRoadmap => '成长路线图';

  @override
  String get bzRoadmapSub => '您的创业计划';

  @override
  String get bzReliability => '预测可靠性';

  @override
  String get bzLayerBirth => '本命盘（D1）';

  @override
  String get bzLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get bzLayerDashamsa => '事业盘（D10）';

  @override
  String get bzLayerLabhamsa => '收益盘（D11）';

  @override
  String get bzLayerShashtiamsa => '业力盘（D60）';

  @override
  String get bzTopicStart => '我现在应该创业吗？';

  @override
  String get bzTopicIdea => '最佳创业点子';

  @override
  String get bzTopicPartner => '寻找联合创始人';

  @override
  String get bzTopicFunding => '如何融资';

  @override
  String get bzTopicScale => '何时扩张';

  @override
  String get bzTopicRisk => '管理风险';

  @override
  String get bzTopicJob => '就业与创业';

  @override
  String get bzTopicTiming => '最佳时机';

  @override
  String get crTitle => '事业与职业分析';

  @override
  String get crSubtitle => 'AI驱动的吠陀事业报告';

  @override
  String get crCrumbHome => '首页';

  @override
  String get crCrumbReports => '报告';

  @override
  String get crCareerPotential => '事业潜力';

  @override
  String get crStatusStrong => '潜力较强';

  @override
  String get crStatusGood => '潜力良好';

  @override
  String get crStatusModerate => '潜力中等';

  @override
  String get crStatusDeveloping => '潜力发展中';

  @override
  String get crStatusChallenging => '挑战阶段';

  @override
  String get crOverallCareer => '整体事业';

  @override
  String get crStability => '事业稳定性';

  @override
  String get crGrowth => '成长潜力';

  @override
  String get crRecognition => '认可度';

  @override
  String get crSatisfaction => '满意度';

  @override
  String get crChipLeadership => '领导力';

  @override
  String get crChipCreativity => '创造力';

  @override
  String get crChipBusiness => '商业才能';

  @override
  String get crChipStableIncome => '稳定收入';

  @override
  String get crChipLearning => '学习能力';

  @override
  String get crChipGrowth => '长期成长';

  @override
  String get crChipTechnical => '技术能力';

  @override
  String get crChipRecognition => '认可度';

  @override
  String get crTopInsights => '核心洞察';

  @override
  String get crWhatDefines => '是什么定义了您的事业？';

  @override
  String get crSoulCareer => '灵魂与事业使命';

  @override
  String get crSoulPlanet => '灵魂使命行星';

  @override
  String get crCareerPlanet => '事业行星';

  @override
  String get crMeaning => '含义';

  @override
  String get crAlignment => '灵魂与事业契合度';

  @override
  String get crAlignStrong => '您的天生兴趣与事业道路高度契合。';

  @override
  String get crAlignModerate => '您的天生兴趣与事业道路中等契合。';

  @override
  String get crAlignLow => '您的天生兴趣与事业道路需要有意识地对齐。';

  @override
  String get crTechAtmakaraka => '灵魂行星（Atmakaraka，灵魂指标）';

  @override
  String get crTechAmatyakaraka => '事业行星（Amatyakaraka，事业指标）';

  @override
  String get crDegrees => '度数';

  @override
  String get crDignity => '力量状态';

  @override
  String get crFoundation => '事业基础';

  @override
  String get crCareerSign => '事业星座';

  @override
  String get crCareerLord => '事业主星';

  @override
  String get crLordPosition => '主星位置';

  @override
  String get crCareerStrength => '事业强度';

  @override
  String get crProfStyle => '职业风格';

  @override
  String get crBestFields => '最佳领域';

  @override
  String get crTechnicalDetails => '技术细节';

  @override
  String get crHouseLabel => '宫位';

  @override
  String get crVerification => '跨星盘事业验证';

  @override
  String get crD10Career => 'D10 · 事业';

  @override
  String get crD9Purpose => 'D9 · 使命';

  @override
  String get crD60Karma => 'D60 · 业力';

  @override
  String get crStatusNeedsImprovement => '需要改进';

  @override
  String get crStatusWellAligned => '高度契合';

  @override
  String get crStatusStrongSupport => '强力支持';

  @override
  String get crStatusModerateSupport => '中等支持';

  @override
  String get crChartDetails => '技术性星盘细节';

  @override
  String get crPersonality => '您的事业性格';

  @override
  String get crGrowthAreas => '成长领域';

  @override
  String get crBestRoles => '最佳角色';

  @override
  String get crBestIndustries => '最佳行业';

  @override
  String get crEnvironment => '事业环境';

  @override
  String get crWorkStyle => '最佳工作方式';

  @override
  String get crEmployment => '受雇工作';

  @override
  String get crBusiness => '创业';

  @override
  String get crFreelance => '自由职业/咨询';

  @override
  String get crPortfolio => '混合组合';

  @override
  String get crLeadership => '领导力';

  @override
  String get crFit => '契合度';

  @override
  String get crBestFit => '最佳契合';

  @override
  String get crTimeline => '事业时间线';

  @override
  String get crPastPeak => '过去的巅峰';

  @override
  String get crPresentPhase => '当前阶段';

  @override
  String get crUpcoming => '即将到来的机遇';

  @override
  String get crFutureExpansion => '未来扩展';

  @override
  String get crRiskPeriod => '风险时期';

  @override
  String get crViewDasha => '行星运程（技术性）';

  @override
  String get crChallenges => '需要关注的挑战';

  @override
  String get crRiskBurnout => '职业倦怠';

  @override
  String get crRiskRecognition => '认可延迟';

  @override
  String get crRiskConflict => '职场冲突';

  @override
  String get crRiskFinancial => '财务不稳定';

  @override
  String get crRiskOverqual => '才能未被充分利用';

  @override
  String get crPrevention => '预防';

  @override
  String get crBurnoutExp => '长期高强度的阶段会逐渐消耗您的精力。';

  @override
  String get crBurnoutFix => '保护休息时间，设立边界，合理安排重大冲刺节奏。';

  @override
  String get crRecognitionExp => '回报与认可可能比您付出的努力来得慢。';

  @override
  String get crRecognitionFix => '记录成果，让上级看到您的贡献。';

  @override
  String get crConflictExp => '有时可能与同事或上级产生摩擦。';

  @override
  String get crConflictFix => '保持冷静沟通，明智地选择该坚持的事情。';

  @override
  String get crFinancialExp => '在某些阶段，收入可能会不稳定。';

  @override
  String get crFinancialFix => '保留缓冲资金，避免过度的财务承诺。';

  @override
  String get crOverqualExp => '您有时可能感到才能未被充分发挥或缺乏挑战。';

  @override
  String get crOverqualFix => '寻求更具挑战性的角色，持续学习以保持投入感。';

  @override
  String get crImprovementPlan => '事业改进计划';

  @override
  String get crCatPlanetary => '行星与灵性';

  @override
  String get crCatPractical => '实用步骤';

  @override
  String get crTraditionalExplain => '传统占星学解释';

  @override
  String get crActionPlan => '30天事业行动计划';

  @override
  String get crWeek1 => '第1周 · 优化个人档案';

  @override
  String get crWeek2 => '第2周 · 技能提升';

  @override
  String get crWeek3 => '第3周 · 人脉拓展';

  @override
  String get crWeek4 => '第4周 · 提升事业曝光度';

  @override
  String get crWeek1Tip => '围绕您最突出的事业主题，更新您的简历与领英（LinkedIn）资料。';

  @override
  String get crWeek2Tip => '在您最擅长的领域中选择一项高价值技能，每天练习。';

  @override
  String get crWeek3Tip => '与导师重新建立联系，并主动联系两位新的行业人脉。';

  @override
  String get crWeek4Tip => '公开分享您的工作成果，并主动承担一个有曝光度的项目。';

  @override
  String get crPriority => '优先级';

  @override
  String get crTimeRequired => '所需时间';

  @override
  String get crExpectedBenefit => '预期收益';

  @override
  String get crPriorityHigh => '高';

  @override
  String get crPriorityMedium => '中';

  @override
  String get crRoadmap => 'AI事业路线图';

  @override
  String get crNext12 => '未来12个月';

  @override
  String get crBestFocus => '最佳关注点';

  @override
  String get crSkillsLearn => '需要学习的技能';

  @override
  String get crIndustriesTarget => '目标行业';

  @override
  String get crExpectedOutcome => '预期成果';

  @override
  String get crReliability => '预测可靠性';

  @override
  String get crReliabilityHigh => '高可靠性';

  @override
  String get crReliabilityGood => '良好可靠性';

  @override
  String get crReliabilityModerate => '中等可靠性';

  @override
  String get crReliabilityExplain =>
      '本报告综合了您的本命盘、分盘及遮米尼（Jaimini）指标。此评分反映了各星盘层面的一致程度。';

  @override
  String get crChartLayers => '星盘层面与权重';

  @override
  String get crBirthChart => '本命盘（D1）';

  @override
  String get crNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get crDashamsa => '达萨姆萨盘（D10）';

  @override
  String get crShashtiamsa => '沙什提安萨盘（D60）';

  @override
  String get crDiscussAi => '与AI讨论';

  @override
  String get crAskAbout => '咨询关于';

  @override
  String get crTopicChange => '转行';

  @override
  String get crTopicGovt => '公职/政府工作';

  @override
  String get crTopicBusiness => '创业';

  @override
  String get crTopicPromotion => '晋升';

  @override
  String get crTopicMarriage => '婚姻与事业';

  @override
  String get crTopicAbroad => '海外发展';

  @override
  String get crTopicIncome => '收入';

  @override
  String get crTopicPurpose => '人生使命';

  @override
  String get crTopicResume => '简历';

  @override
  String get crTopicCopied => '问题已复制——请粘贴到AI聊天中。';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul引导您内心的召唤，而$career塑造您外在的职业。';
  }

  @override
  String get rzTodayOutlook => '今日星座运势';

  @override
  String get rzPlanetaryEnergy => '今日行星能量';

  @override
  String get rzBestSign => '最佳星座';

  @override
  String get rzChallengingSign => '最具挑战星座';

  @override
  String get rzDominantPlanet => '主导行星';

  @override
  String get rzOverallMood => '整体氛围';

  @override
  String get rzMoodBright => '明朗活跃';

  @override
  String get rzMoodCalm => '平静稳定';

  @override
  String get rzMoodMixed => '能量参差';

  @override
  String get rzMoodTense => '紧张需谨慎';

  @override
  String get rzTodayEnergy => '今日能量';

  @override
  String get rzCaution => '需谨慎';

  @override
  String get rzWeak => '较弱';

  @override
  String get rzAllSigns => '全部星座';

  @override
  String get rzAiSummary => 'AI摘要';

  @override
  String get rzPlanetaryInfluence => '今日行星影响';

  @override
  String get rzStrongInfluences => '强烈影响';

  @override
  String get rzShowTechnical => '显示技术细节';

  @override
  String get rzOpportunities => '今日机遇';

  @override
  String get rzAvoidTitle => '今日应避免之事';

  @override
  String get rzTechnicalReason => '技术原因';

  @override
  String get rzAvoidDecisions => '仓促做出重要决定';

  @override
  String get rzAvoidArguments => '激烈争执';

  @override
  String get rzAvoidInvestments => '大额投资';

  @override
  String get rzAvoidOverthink => '对小事过度思虑';

  @override
  String get rzAvoidOverspend => '不必要的花费';

  @override
  String get rzAvoidStress => '压力与过度劳累';

  @override
  String get rzPlanetaryChart => '今日行星星盘';

  @override
  String get rzWhatChartMeans => '此星盘的含义';

  @override
  String get rzChartExplain =>
      '这张菱形图显示了今天各行星在天空中的位置，并对应到您的星座。位于有利宫位的行星会提升您今天的运势；位于不利宫位的行星则需要多加留意。';

  @override
  String get rzDoNetworking => '社交与建立联系';

  @override
  String get rzDoLearning => '学习新事物';

  @override
  String get rzDoMeditation => '冥想与平静';

  @override
  String get rzDoFamily => '家庭时光';

  @override
  String get rzDoCreative => '创意工作';

  @override
  String get rzDoRest => '休息与自我照顾';

  @override
  String get rzAiRecommendations => '今日AI建议';

  @override
  String get rzTechnical => '技术性占星细节';

  @override
  String get rzTransitScore => '行运评分';

  @override
  String get rzVedha => '维达（Vedha，阻碍）';

  @override
  String get rzGocharDetails => '行运（Gochar）详情';

  @override
  String get rzAdvancedOnly => '适合进阶用户';

  @override
  String get rzTomorrow => '明日预览';

  @override
  String get rzTomorrowEnergy => '明日能量';

  @override
  String get rzImproving => '逐渐好转';

  @override
  String get rzWeaker => '稍显疲弱';

  @override
  String get rzSteady => '保持平稳';

  @override
  String get rzTomorrowUpLine => '预计明日能量将会上升——请提前规划重要事项。';

  @override
  String get rzTomorrowDownLine => '明日能量可能略有下降——请保持轻松稳定的节奏。';

  @override
  String get rzTomorrowFlatLine => '明日能量保持平稳——将是平和均衡的一天。';

  @override
  String get rzWeeklyTrend => '每周趋势';

  @override
  String get rzMonthlyTrend => '每月趋势';

  @override
  String get rzBestDayWeek => '最佳日期';

  @override
  String get rzHardestDay => '最具挑战的日期';

  @override
  String get rzLuckyToday => '今日幸运';

  @override
  String get rzKarakaSun => '自信与活力';

  @override
  String get rzKarakaMoon => '情绪与内心平静';

  @override
  String get rzKarakaMars => '精力与干劲';

  @override
  String get rzKarakaMercury => '沟通与学习';

  @override
  String get rzKarakaJupiter => '智慧与成长';

  @override
  String get rzKarakaVenus => '人际关系与舒适感';

  @override
  String get rzKarakaSaturn => '自律与耐心';

  @override
  String get rzKarakaRahu => '野心与变化';

  @override
  String get rzKarakaKetu => '灵性与放下';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom奠定了今日的基调，而$chal则需要耐心与用心对待。';
  }

  @override
  String rzInsightGood(Object karaka) {
    return '今天适合关注$karaka。';
  }

  @override
  String rzInsightHard(Object karaka) {
    return '今天在$karaka方面请放慢脚步。';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '今天$karaka获得良好支持。';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '今天$karaka可能会遇到延迟。';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return '今天有利于$strong，而$weak则需要耐心与用心对待。';
  }

  @override
  String get fdEnergyScore => '今日能量评分';

  @override
  String get fdStatusAverage => '一般';

  @override
  String get fdStatusMixed => '参差不齐';

  @override
  String get fdStatusChallenging => '具有挑战性';

  @override
  String get fdTheme => '今日主题';

  @override
  String get fdExplainToday => '解读今日';

  @override
  String get fdTodaysFocus => '今日重点';

  @override
  String get fdTopRecommendation => '首要建议';

  @override
  String get fdTopCaution => '首要注意事项';

  @override
  String get fdReadingTime => '阅读时间';

  @override
  String get fdSeconds30 => '30秒';

  @override
  String get fdCareer => '事业';

  @override
  String get fdMoney => '财务';

  @override
  String get fdLove => '爱情';

  @override
  String get fdHealth => '健康';

  @override
  String get fdTravel => '出行';

  @override
  String get fdFamily => '家庭';

  @override
  String get fdBestToDo => '今日最适合做的事';

  @override
  String get fdAvoidToday => '今日应避免之事';

  @override
  String get fdConfidenceLabel => '可信度';

  @override
  String get fdBestTime => '最佳时间';

  @override
  String get fdRecommended => '推荐';

  @override
  String get fdReason => '原因';

  @override
  String get fdRisk => '风险';

  @override
  String get fdRecommendation => '建议';

  @override
  String get fdNoActions => '今天没有特别需要推进的大事——保持稳定平静的日常节奏即可。';

  @override
  String get fdNoCautions => '今天没有重大注意事项——保持平常心即可。';

  @override
  String get fdHighlights => '今日亮点';

  @override
  String get fdProbVeryHigh => '极高';

  @override
  String get fdProbHigh => '高';

  @override
  String get fdProbElevated => '偏高';

  @override
  String get fdProbCaution => '需谨慎';

  @override
  String get fdWhatToDo => '应对方法';

  @override
  String get fdLifeAreas => '人生领域';

  @override
  String get fdTapDetails => '点击查看详情';

  @override
  String get fdArea1 => '自我与健康';

  @override
  String get fdArea2 => '财富与家庭';

  @override
  String get fdArea3 => '沟通';

  @override
  String get fdArea4 => '居家与舒适';

  @override
  String get fdArea5 => '创造力与恋爱';

  @override
  String get fdArea6 => '工作与职责';

  @override
  String get fdArea7 => '人际关系';

  @override
  String get fdArea8 => '变化与深度';

  @override
  String get fdArea9 => '运气与出行';

  @override
  String get fdArea10 => '事业与地位';

  @override
  String get fdArea11 => '收益与人脉';

  @override
  String get fdArea12 => '休息与灵性';

  @override
  String get fdTodaysMeaning => '今日意涵';

  @override
  String get fdGoodFor => '有利于';

  @override
  String get fdAvoid => '避免';

  @override
  String get fdPlanetSupport => '行星支持';

  @override
  String get fdWhyPrediction => '为何有此预测？';

  @override
  String get fdAdvancedDetails => '进阶详情';

  @override
  String get fdAiRecommendation => 'AI建议';

  @override
  String get fdOverallStatus => '整体状态';

  @override
  String get fdNoPlanetTransit => '今天没有主要行星行运至该领域。';

  @override
  String get fdFinancialOutlook => '财务展望';

  @override
  String get fdIncomeProbability => '收入概率';

  @override
  String get fdExpenseProbability => '支出概率';

  @override
  String get fdNetBalance => '净财务余额';

  @override
  String get fdAvoidSpending => '应避免的支出';

  @override
  String get fdRelationshipOutlook => '感情展望';

  @override
  String get fdOverallScore => '总体评分';

  @override
  String get fdPartner => '伴侣';

  @override
  String get fdRomance => '浪漫';

  @override
  String get fdWorkplace => '职场';

  @override
  String get fdPublicImage => '公众形象';

  @override
  String get fdBestActivity => '最佳活动';

  @override
  String get fdWeakArea => '薄弱领域';

  @override
  String get fdBiggestOpportunity => '最大机遇';

  @override
  String get fdBiggestRisk => '最大风险';

  @override
  String get fdProbability => '概率';

  @override
  String get fdProtection => '保护建议';

  @override
  String get fdDescription => '描述';

  @override
  String get fdBestTimeToday => '今日最佳时间';

  @override
  String get fdAvoidDuring => '应避免的时段';

  @override
  String get fdPredictionConfidence => '预测可信度';

  @override
  String get fdConfBasis => '今日预测综合了';

  @override
  String get fdConfNatal => '本命盘';

  @override
  String get fdConfTransit => '当前行运';

  @override
  String get fdConfDasha => '行星运程';

  @override
  String get fdConfStrength => '行星力量';

  @override
  String get fdConfHouse => '宫位激活';

  @override
  String get fdAskAi => '咨询AI';

  @override
  String get fdAskAiSub => '点击问题以获取今日解答';

  @override
  String get fdQ1 => '为什么今天事业进展缓慢？';

  @override
  String get fdQ2 => '今天最佳的时间是什么时候？';

  @override
  String get fdQ3 => '今天适合处理财务事项吗？';

  @override
  String get fdQ4 => '今天适合出行吗？';

  @override
  String get fdQ5 => '今天我应该避免什么？';

  @override
  String get fdMoreSuggestions => '更多建议';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return '今天最适合专注于$top。$weak方面可能进展缓慢，请避免在该领域做重大决定。财务方面，今天看起来$fin。';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return '您今天的能量集中在$top——请顺势而为，其他方面则放缓节奏。';
  }

  @override
  String get gochToday => '今天';

  @override
  String get gochOverallScore => '整体行运评分';

  @override
  String get gochNeutral => '中性';

  @override
  String get gochChallenging => '具有挑战性';

  @override
  String get gochTopPositive => '最积极因素';

  @override
  String get gochTopChallenges => '最大挑战';

  @override
  String get gochFilterAll => '全部';

  @override
  String get gochFavorability => '有利程度';

  @override
  String get gochAlerts => '行运提醒';

  @override
  String get gochAlertCritical => '严重';

  @override
  String get gochAlertWarning => '需谨慎';

  @override
  String get gochAlertOpportunity => '机遇';

  @override
  String get gochAiFocus => '今日AI关注点';

  @override
  String get gochLifeScores => '人生领域评分';

  @override
  String get gochWhy => '为什么？';

  @override
  String get gochCurrentTransits => '当前生效行运';

  @override
  String get gochDailyPlan => '您的每日计划';

  @override
  String get gochMorning => '早晨';

  @override
  String get gochAfternoon => '下午';

  @override
  String get gochEvening => '傍晚';

  @override
  String get gochNight => '夜晚';

  @override
  String get gochSmartReco => '智能建议';

  @override
  String get gochExplain => '解读今日行运';

  @override
  String get gochDo => '宜';

  @override
  String get gochDont => '忌';

  @override
  String get gochDoWork => '处理重要工作';

  @override
  String get gochDoMeditate => '冥想与反思';

  @override
  String get gochDoStart => '启动新计划';

  @override
  String get gochDoFinish => '完成待办事项';

  @override
  String get gochDontArgue => '避免争执';

  @override
  String get gochDontImpulsive => '避免冲动决定';

  @override
  String get gochDontOverspend => '避免过度消费';

  @override
  String gochThemeGrowth(Object area) {
    return '今天是$area方面成长的一天——请顺势而为。';
  }

  @override
  String gochThemeChallenge(Object area) {
    return '今天在$area方面请保持耐心，稳步前行。';
  }

  @override
  String gochPosLine(Object area) {
    return '目前$area获得良好支持。';
  }

  @override
  String gochChalLine(Object area) {
    return '今天$area需要格外用心。';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return '今天请将精力投入到$a1，并在$a2方面放缓节奏。';
  }

  @override
  String get divBeginner => '初学者';

  @override
  String get divSearchHint => '搜索：事业、婚姻、教育……';

  @override
  String get divSummaryTitle => '分盘概览';

  @override
  String get divTotalCharts => '分盘总数';

  @override
  String get divMostImportant => '最重要';

  @override
  String get divRecommendedForYou => '为您推荐';

  @override
  String get divCatEssential => '核心分盘';

  @override
  String get divCatPersonal => '个人生活';

  @override
  String get divCatKnowledge => '知识类分盘';

  @override
  String get divCatAdvanced => '进阶分盘';

  @override
  String get divGoalProperty => '财产';

  @override
  String get divGoalKarma => '业力';

  @override
  String get divBadgeHighlyRec => '强烈推荐';

  @override
  String get divBadgeRec => '推荐';

  @override
  String get divBadgeUseful => '有用';

  @override
  String get divBadgeOptional => '可选';

  @override
  String get divBadgeAdvOnly => '仅限进阶';

  @override
  String get divRecommendBest => '推荐最佳分盘';

  @override
  String get divNoMatch => '没有符合搜索条件的分盘';

  @override
  String get divLifeAreas => '人生领域';

  @override
  String divAiUse(Object purpose) {
    return '使用此分盘来分析$purpose。';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return '您的$c1与$c2分盘尤为重要——建议先从这两者所涵盖的领域入手，再按需探索其他分盘。';
  }

  @override
  String divRecReasonHouse(Object house) {
    return '您的$house宫需要仔细审视——此分盘可深入展现其状况。';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet是一个关键但受考验的行星——此分盘可揭示其更深层的状态。';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return '您正处于$planet的大运（Mahadasha）中，因此此分盘现在尤为应景。';
  }

  @override
  String divRecSummary(Object c1) {
    return '根据您的星盘，$c1应是您的首要关注点。以下分盘按其当前与您的相关程度排序。';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return '当您想研究$purpose时，可打开此分盘。';
  }

  @override
  String get yogaHelpful => '有益';

  @override
  String get yogaInactive => '未激活';

  @override
  String get yogaTabMoney => '财富';

  @override
  String get yogaTabRare => '稀有';

  @override
  String get yogaSummaryTitle => '瑜伽概览';

  @override
  String get yogaActiveYogas => '已激活瑜伽';

  @override
  String get yogaTotalYogas => '瑜伽总数';

  @override
  String get yogaMostPowerful => '最强瑜伽';

  @override
  String get yogaFortuneRating => '整体运势';

  @override
  String get yogaBenefits => '益处';

  @override
  String get yogaSupportingPlanets => '支持行星';

  @override
  String get yogaRanking => '五大最强瑜伽';

  @override
  String get yogaExplain => '解读我的瑜伽';

  @override
  String get yogaExplainSubtitle => '您的瑜伽如何为您助力';

  @override
  String get yogaNoneActive => '尚无已激活的瑜伽';

  @override
  String get yogaNoneInCategory => '此类别中没有瑜伽';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return '您的星盘中有$count个已激活的瑜伽——这些是有利的行星组合。涉及$planets的组合对成长与成功尤其有益。';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name对$areas有支持作用，当其相关行星在大运或行运中活跃时，其益处会更加显著。';
  }

  @override
  String get yogaAiGeneric => '此瑜伽是您星盘中的一个有利组合，能增强其所关联的人生领域。';

  @override
  String get yogaExplainReassure =>
      '瑜伽是您星盘中的亮点——是对您有利的行星组合。较强的瑜伽会带来持久的益处，尤其是在构成它们的行星运程期间。';

  @override
  String get doshSevere => '严重';

  @override
  String get doshVeryMild => '非常轻微';

  @override
  String get doshLow => '轻微';

  @override
  String get doshHigh => '较高';

  @override
  String get doshCritical => '危急';

  @override
  String get doshSummaryTitle => '缺陷概览';

  @override
  String get doshActiveDoshas => '已激活缺陷';

  @override
  String get doshTotalChecked => '已检查总数';

  @override
  String get doshOverallSeverity => '整体严重程度';

  @override
  String get doshNoneActive => '没有已激活的缺陷——星盘十分清净！';

  @override
  String get doshCategory => '类别';

  @override
  String get doshConfidence => '可信度';

  @override
  String get doshWhyFormed => '形成原因';

  @override
  String get doshAffectedAreas => '受影响领域';

  @override
  String get doshTimeline => '时间线';

  @override
  String get doshDefinition => '定义';

  @override
  String get doshFormationRule => '形成规则';

  @override
  String get doshSupportingPlanets => '相关行星';

  @override
  String get doshCancellation => '抵消瑜伽';

  @override
  String get doshNoCancellation => '未发现';

  @override
  String get doshAreaChildren => '子女';

  @override
  String get doshAreaMind => '心智';

  @override
  String get remMantra => '真言（Mantra）';

  @override
  String get remGemstone => '宝石';

  @override
  String get remDonation => '布施';

  @override
  String get remTemple => '庙宇参拜';

  @override
  String get remFasting => '斋戒';

  @override
  String get remLifestyle => '生活方式';

  @override
  String get remLifestyleGeneric => '践行与此行星相关的感恩、自律与慈善，并保持良好品行。';

  @override
  String get doshExplain => '解读我的缺陷';

  @override
  String get doshExplainSubtitle => '以平和务实的角度看待您的缺陷';

  @override
  String get doshExplainReassure =>
      '缺陷十分常见——几乎每张星盘都会有一些。它们描述的是倾向，而非注定的命运。觉察、良好品行与简单的补救方法能够减轻其实际影响，因此无需过度担心。';

  @override
  String get doshAiGeneric => '此缺陷描述了您星盘中的一种倾向。其实际影响通常较轻，可以通过觉察与简单的补救方法来平衡。';

  @override
  String doshHeroSummary(Object active, Object total) {
    return '在检查的$total项缺陷中，您的星盘显示有$active项处于激活状态。大多数程度轻微，仅少数需要留意。通过理解与简单的补救方法，可以缓解其实际影响。';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return '此缺陷主要影响$areas。在$planet运程期间，其影响可能会更为明显，补救方法有助于平衡它。';
  }

  @override
  String doshTimelineLine(Object planet) {
    return '其影响在$planet的大运（Mahadasha）与子运（Antardasha）期间，以及$planet行运活跃时最为明显。';
  }

  @override
  String get sbLegendary => '传奇级';

  @override
  String get sbSthana => '位置力（Sthana Bala）';

  @override
  String get sbDig => '方位力（Dig Bala）';

  @override
  String get sbKala => '时间力（Kala Bala）';

  @override
  String get sbChesta => '运动力（Chesta Bala）';

  @override
  String get sbNaisargika => '自然力（Naisargika Bala）';

  @override
  String get sbDrik => '相位力（Drik Bala）';

  @override
  String get sbSummary => '行星力量概览';

  @override
  String get sbAverageStrength => '平均力量';

  @override
  String get sbHighestRupa => '最高鲁帕（Rupa）值';

  @override
  String get sbRupa => '鲁帕（Rupa）';

  @override
  String get sbRanking => '行星排名';

  @override
  String get sbRequired => '所需值';

  @override
  String get sbExcess => '超出值';

  @override
  String get sbDeficit => '不足值';

  @override
  String get sbTotalShadbala => '沙德巴拉（Shadbala）总值';

  @override
  String get sbExplain => '解读我的行星力量';

  @override
  String get sbExplainSubtitle => '您行星力量的简明概览';

  @override
  String get sbInfoTitle => '了解沙德巴拉（Shadbala）';

  @override
  String get sbQWhatIs => '什么是沙德巴拉（Shadbala）？';

  @override
  String get sbQRupas => '什么是鲁帕（Rupas）？';

  @override
  String get sbQHowCalc => '力量是如何计算的？';

  @override
  String get sbQHowUse => '如何使用这些信息';

  @override
  String get sbWhyStrong => '为何强劲';

  @override
  String get sbWhyWeak => '为何薄弱';

  @override
  String get sbDuringMahadasha => '在大运期间';

  @override
  String get sbEffects => '影响';

  @override
  String get sbLifeAreas => '人生领域';

  @override
  String get sbPlanetDetails => '行星详情';

  @override
  String get sbBodyWhatIs => '沙德巴拉（意为“六重力量”）通过累加六种独立的力量来源，衡量每颗行星实现其结果的能力大小。';

  @override
  String get sbBodyRupas =>
      '力量以鲁帕（Rupa）为单位计量（1鲁帕=60维鲁帕）。每颗行星需要达到最低鲁帕值才能被视为强劲；鲁帕值越高，意味着其结果实现得越充分。';

  @override
  String get sbBodyHowCalc =>
      '六种力量相加：位置力（Sthana）、方位力（Dig）、时间力（Kala）、运动力（Chesta）、自然力（Naisargika）与相位力（Drik）。总值与该行星所需的最低值进行比较，得出百分比。';

  @override
  String get sbBodyHowUse =>
      '力量超过100%的行星能轻松实现其所主管的事项；低于100%则需要支持。在重要事务上宜倚重最强的行星，对最薄弱的行星则应给予补救方法与耐心。';

  @override
  String get sbRemedyStrong => '支持充足——无需特殊补救；您可以自信地运用此行星的运程。';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP是您最强的行星，为$strongTrait提供了极佳的支持。$weakP最为薄弱，最能从补救方法中受益。';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet的沙德巴拉属于$category水平，因此其所主管的$karakatva也相应地受到影响。';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '最强来源于$bala（$rupa鲁帕）。';
  }

  @override
  String sbWeakLine(Object bala) {
    return '在$bala方面最为薄弱，拉低了总值。';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '在$planet的大运期间，其所主管的$karak会更为突出。';
  }

  @override
  String sbEffectStrong(Object karak) {
    return '由于沙德巴拉强劲，$karak自然获得支持。';
  }

  @override
  String sbEffectWeak(Object karak) {
    return '由于沙德巴拉较弱，$karak可能需要有意识地努力。';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '通过真言、宝石或布施来增强$planet的力量，并在其运程期间保持耐心。';
  }

  @override
  String get bhOverview => '概览';

  @override
  String get bhDetailed => '详细';

  @override
  String get bhavaHouses => '宫位';

  @override
  String get bhStrengthOverview => '宫位力量概览';

  @override
  String get bhOverallAverage => '宫位整体平均值';

  @override
  String get bhStrongestHouse => '最强宫位';

  @override
  String get bhWeakestHouse => '最弱宫位';

  @override
  String get bhBestArea => '最佳人生领域';

  @override
  String get bhNeedsAttention => '需要关注';

  @override
  String get bhSavContribution => 'SAV贡献值';

  @override
  String get bhLordCondition => '宫主星状态';

  @override
  String get bhBenefic => '吉星影响';

  @override
  String get bhMalefic => '凶星影响';

  @override
  String get bhStrengthReasons => '评分原因';

  @override
  String get bhGoodEffects => '有利影响';

  @override
  String get bhChallenges => '挑战';

  @override
  String get bhRemedies => '补救方法';

  @override
  String get bhRanking => '宫位排名';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => '解读我的宫位';

  @override
  String get bhExplainSubtitle => '您12宫的简明概览';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return '您最强的宫位是$s1和$s2。$strongArea天生较强，而$weakArea则需要更多努力。';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return '其宫主星$lord处于$relation状态。';
  }

  @override
  String bhWhyLine(Object sav) {
    return '此宫位携带$sav个吉点（SAV）；其内的行星及所受相位共同塑造了余下的评分。';
  }

  @override
  String bhGoodLine(Object meaning) {
    return '当此宫位强劲时，有利于$meaning。';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return '当此宫位薄弱时，$meaning可能需要额外的努力与用心。';
  }

  @override
  String bhRemedyLine(Object lord) {
    return '增强其宫主星$lord的力量，并重视此宫位所涉及的事务，以提升其运势。';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return '您的$house处于$strengthWord状态。它主管$meaning。';
  }

  @override
  String get kunNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get kunD10 => '达萨姆萨盘（D10）';

  @override
  String get kunPlacement => '行星落位';

  @override
  String get kunHousesTitle => '宫位详情';

  @override
  String get kunPlanet => '行星';

  @override
  String get kunNakshatra => '星宿';

  @override
  String get kunPada => '分度（Pada）';

  @override
  String get kunLord => '主星';

  @override
  String get kunExplain => '解读我的星盘';

  @override
  String get kunExplainSubtitle => '您星盘的简明概览';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '第$ordinal宫主管$meaning。';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '落于此处的$planets塑造了其结果。';
  }

  @override
  String kunExplainAsc(Object asc) {
    return '您的上升星座是$asc，塑造了您的人生观以及他人对您的第一印象。';
  }

  @override
  String kunExplainMoon(Object moon) {
    return '您的心智与情绪受位于$moon的月亮所影响。';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet是您最强的行星——是一个天生轻松且获得支持的领域。';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet是您最受考验的行星——在此处付出耐心与努力会有所回报。';
  }

  @override
  String get plNature => '性质';

  @override
  String get plElement => '元素';

  @override
  String get plGender => '性别';

  @override
  String get plKarakatva => '徵象（Karakatva）';

  @override
  String get plLordship => '宫主权';

  @override
  String get plStrength => '力量';

  @override
  String get plAspectsGiven => '给出的相位';

  @override
  String get plAspectsReceived => '接收的相位';

  @override
  String get plConjunction => '合相';

  @override
  String get plHouseMeaning => '宫位含义';

  @override
  String get plNakshatraMeaning => '星宿含义';

  @override
  String get plAiInterpretation => 'AI解读';

  @override
  String get plSearchHint => '搜索任意行星';

  @override
  String get plNoResults => '未找到行星';

  @override
  String get plBenefic => '吉星';

  @override
  String get plMalefic => '凶星';

  @override
  String get plMale => '阳性';

  @override
  String get plFemale => '阴性';

  @override
  String get plNeutralGender => '中性';

  @override
  String get plOwnSign => '本位星座';

  @override
  String get plFriend => '友好星座';

  @override
  String get plEnemy => '敌对星座';

  @override
  String get plNeutral => '中立';

  @override
  String get sumEther => '以太';

  @override
  String plLordOfHouses(Object houses) {
    return '第$houses宫主星';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '由$nakLord主管，带来$trait。';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet位于$sign星座，落在第$house宫。';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return '其核心徵象——$karak——在此获得了良好的支持。';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return '其核心徵象——$karak——在此可能需要有意识的努力。';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet处于旺相（exalted），能带来最佳的结果。';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet处于弱相（debilitated），需要支持才能发挥其结果。';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet处于焦伤（combust）状态，因受太阳光芒遮蔽，其作用较为隐晦。';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet处于同宫互映（Vargottama）状态——即在纳瓦姆萨盘中重复出现同一星座，是力量强劲的标志。';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet处于逆行（retrograde）状态，其能量转向内在并被强化。';
  }

  @override
  String get plHouse1 => '自我、身体、性格与活力';

  @override
  String get plHouse2 => '财富、家庭、言语与饮食';

  @override
  String get plHouse3 => '勇气、兄弟姐妹、沟通与短途旅行';

  @override
  String get plHouse4 => '家庭、母亲、舒适、财产与内心平静';

  @override
  String get plHouse5 => '子女、创造力、智力、恋爱与前世福报';

  @override
  String get plHouse6 => '健康、仇敌、债务、服务与日常工作';

  @override
  String get plHouse7 => '婚姻、伴侣关系与商业合作';

  @override
  String get plHouse8 => '寿元、蜕变、秘密与继承';

  @override
  String get plHouse9 => '福运、达摩、高等教育、导师与父亲';

  @override
  String get plHouse10 => '事业、地位、权威与公众业力';

  @override
  String get plHouse11 => '收益、收入、朋友、人脉与愿望实现';

  @override
  String get plHouse12 => '损失、支出、异国他乡、灵性与解脱';

  @override
  String get sumVeryStrong => '极强';

  @override
  String get sumStrong => '较强';

  @override
  String get sumAverage => '一般';

  @override
  String get sumWeak => '较弱';

  @override
  String get sumNeedsAttention => '需要关注';

  @override
  String get sumFire => '火象';

  @override
  String get sumEarth => '土象';

  @override
  String get sumAir => '风象';

  @override
  String get sumWater => '水象';

  @override
  String get sumMovable => '动相';

  @override
  String get sumFixed => '固定相';

  @override
  String get sumDual => '双重相';

  @override
  String get sumDirEast => '东方';

  @override
  String get sumDirWest => '西方';

  @override
  String get sumDirNorth => '北方';

  @override
  String get sumDirSouth => '南方';

  @override
  String get sumDirNE => '东北方';

  @override
  String get sumDirNW => '西北方';

  @override
  String get sumDirSE => '东南方';

  @override
  String get sumDirSW => '西南方';

  @override
  String get sumSnapshotTitle => '您的占星概览';

  @override
  String get sumMahadasha => '大运（Mahadasha）';

  @override
  String get sumAntardasha => '子运（Antardasha）';

  @override
  String get sumNakshatra => '出生星宿（Janma Nakshatra）';

  @override
  String get sumElement => '元素';

  @override
  String get sumModality => '属性';

  @override
  String get sumLuckyDirection => '幸运方位';

  @override
  String get sumHighlights => '重要亮点';

  @override
  String get sumStrongPlanet => '最强行星';

  @override
  String get sumWeakPlanet => '最弱行星';

  @override
  String get sumYogas => '瑜伽';

  @override
  String get sumDoshas => '缺陷';

  @override
  String get sumRetrograde => '逆行';

  @override
  String get sumCombust => '焦伤';

  @override
  String get sumExalted => '旺相';

  @override
  String get sumDebilitated => '弱相';

  @override
  String get sumVargottama => '同宫互映（Vargottama）';

  @override
  String get sumQuickInsights => '快速洞察';

  @override
  String get sumSpirituality => '灵性';

  @override
  String get sumTimezone => '时区';

  @override
  String get sumAyanamsa => '岁差校正（Ayanamsa）';

  @override
  String get sumCalendarType => '历法';

  @override
  String get sumCopied => '已复制到剪贴板';

  @override
  String get sumNatureFire => '您具有大胆、充满活力且富有开创精神的性格，善于身先士卒。';

  @override
  String get sumNatureEarth => '您具有务实、踏实且自律的性格，能够创造持久的成果。';

  @override
  String get sumNatureAir => '您具有好奇、善于沟通且富有智识的性格，在新想法中蓬勃发展。';

  @override
  String get sumNatureWater => '您具有直觉敏锐、情感丰富且富有同理心的性格，内心极为敏感。';

  @override
  String get sumGradePhraseExcellent => '支持强劲——只要持续努力，很可能获得有利的结果。';

  @override
  String get sumGradePhraseGood => '支持良好——只需稍加用心，整体趋势正面。';

  @override
  String get sumGradePhraseAverage => '支持参差——结果取决于努力程度与时机。';

  @override
  String get sumGradePhraseWeak => '需要关注——耐心与补救方法在此会有所帮助。';

  @override
  String get kDefCombust => '行星过于靠近太阳，导致其能量被“灼烧”而减弱。';

  @override
  String get kDefRetrograde => '看似逆向运行的行星；其效应会转向内在并被强化。';

  @override
  String get kDefNakshatra => '月亮与各行星运行经过的27个月宿之一。';

  @override
  String get kDefVargottama => '一颗行星在本命盘（D1）与纳瓦姆萨盘（D9）中处于相同星座——这是力量强劲的标志。';

  @override
  String get kDefOwnSign => '行星位于自己所主管的星座中，如鱼得水，能带来稳定的结果。';

  @override
  String get kDefExalted => '行星位于其力量最强的星座，能带来最佳的结果。';

  @override
  String get kDefDebilitated => '行星位于其最弱的星座，难以发挥应有的结果。';

  @override
  String get kDefMooltrikona => '行星本位星座中一段特殊的区间，在此区间内行星力量尤为强大。';

  @override
  String get kDefAscendant => '出生时在东方地平线上升起的星座——即上升星座（Lagna），是星盘的基础。';

  @override
  String get kDefMahadasha => '影响人生较长时段的主要行星运程。';

  @override
  String get kDefAntardasha => '大运内部的子运程，用以细化其结果。';

  @override
  String get kDefPada => '行星所处星宿中四个分度（Pada）之一。';

  @override
  String get aspGivesAspectTo => '投射相位于';

  @override
  String get aspReceivesAspectFrom => '接收相位来自';

  @override
  String get aspInfluences => '影响';

  @override
  String get aspNoInfluence => '无影响';

  @override
  String get aspNoAspect => '无相位';

  @override
  String get aspPresent => '存在';

  @override
  String get aspAbsent => '不存在';

  @override
  String get aspNotPresent => '不存在';

  @override
  String get aspSpecialAspect => '特殊相位';

  @override
  String get aspAspectWord => '相位';

  @override
  String get aspTotalGiven => '给出的相位';

  @override
  String get aspTotalReceived => '接收的相位';

  @override
  String get aspStrongestInfluence => '最强影响';

  @override
  String get aspMedium => '中等';

  @override
  String get aspAspectPresent => '存在相位';

  @override
  String get aspReason => '原因';

  @override
  String get aspBoth => '两者皆有';

  @override
  String get aspTargetHouse => '目标宫位';

  @override
  String get aspTargetSign => '目标星座';

  @override
  String get aspLagnaReceives => '上升星座接收相位来自';

  @override
  String get aspNoAspectFrom => '无相位来自';

  @override
  String get aspPlanetToPlanet => '行星对行星';

  @override
  String get aspSignToSign => '星座对星座';

  @override
  String get aspCombinedAspect => '综合相位';

  @override
  String get aspGrahaAspect => '行星相位（Graha Drishti）';

  @override
  String get aspRashiAspect => '星座相位（Rashi Drishti）';

  @override
  String get aspInfoTitle => '了解相位（Drishti）';

  @override
  String get aspQGraha => '什么是行星相位（Graha Drishti）？';

  @override
  String get aspQRashi => '什么是星座相位（Rashi Drishti）？';

  @override
  String get aspQDiff => '两者的区别';

  @override
  String get aspQPredict => '相位如何影响预测';

  @override
  String get aspGrahaBody =>
      '行星相位（Graha Drishti）是行星从其所在位置投射出的相位。每颗行星都会对自身第七宫/宫内行星形成完全相位（一种直接、面对面的影响）。此外，火星还会对第四宫和第八宫形成相位，木星对第五宫和第九宫，土星对第三宫和第十宫。罗睺与计都通常被视为对第五、七、九宫形成相位。行星的相位会以其自身的性质影响所落宫位或行星。';

  @override
  String get aspRashiBody =>
      '星座相位（Rashi Drishti）是遮米尼占星学中星座与星座之间的相位，与其中所居行星无关。动相星座对固定相星座形成相位（相邻星座除外），固定相星座对动相星座形成相位（相邻星座除外），双重相星座之间相互形成相位。此相位主要用于遮米尼预测以及判断宫位间的关系。';

  @override
  String get aspDiffBody =>
      '行星相位由行星投射，取决于该行星所在的位置。星座相位则属于星座本身，适用于落入其中的任何事物。行星相位具有方向性（行星A看向行星B），而星座相位通常在星座之间是相互的。当两者都指向同一目标时，其影响尤为强烈。';

  @override
  String get aspPredictBody =>
      '相位显示了一颗行星将其影响延伸到本宫之外的范围。吉星相位（木星、金星、状态良好的月亮/水星）会支持并保护目标；凶星相位（土星、火星、太阳、罗睺、计都）则可能带来压力、延迟或挑战。解读哪些行星对某个宫位或行星形成相位，有助于解释结果为何如此呈现。';

  @override
  String get aspTraitSun => '权威、领导力与活力';

  @override
  String get aspTraitMoon => '情感深度、舒适感与直觉';

  @override
  String get aspTraitMars => '精力、勇气与干劲';

  @override
  String get aspTraitMercury => '沟通、智力与适应能力';

  @override
  String get aspTraitJupiter => '智慧、成长与福运';

  @override
  String get aspTraitVenus => '爱、和谐与享受';

  @override
  String get aspTraitSaturn => '自律、责任感，以及需要耐心、有时会延迟到来的成功';

  @override
  String get aspTraitRahu => '野心、强度与非传统的转折';

  @override
  String get aspTraitKetu => '超然、灵性与突发的变化';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet正在影响$targets。这可能会为这些行星所代表的领域带来$trait。';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet在此未对其他任何行星形成特殊相位；其影响主要通过自身所在的星座与宫位发挥作用。';
  }

  @override
  String get avSummaryTitle => '阿什塔卡瓦尔加（Ashtakavarga）概览';

  @override
  String get avOverallScore => '整体SAV评分';

  @override
  String get avOverallRating => '整体评级';

  @override
  String get avStrongestSigns => '最强星座';

  @override
  String get avWeakestSigns => '最弱星座';

  @override
  String get avScore => '评分';

  @override
  String get avMeaning => '含义';

  @override
  String get avGrid => '网格';

  @override
  String get avList => '列表';

  @override
  String get avOverallScoreShort => '总体评分';

  @override
  String get avNatalSignScore => '本命星座评分';

  @override
  String get avBestSigns => '最佳星座';

  @override
  String get avWeakSigns => '薄弱星座';

  @override
  String get avAiInterpretation => 'AI解读';

  @override
  String get avVeryGood => '非常好';

  @override
  String get avVeryWeak => '非常弱';

  @override
  String get avTotalSav => 'SAV总值';

  @override
  String get avPlanetContributions => '各行星贡献值';

  @override
  String get avFinance => '财务';

  @override
  String get avOverallStrength => '整体力量';

  @override
  String get avWhatDoesThisMean => '这意味着什么？';

  @override
  String get avSimple => '简单';

  @override
  String get avAdvanced => '进阶';

  @override
  String get avInfoTitle => '了解阿什塔卡瓦尔加（Ashtakavarga）';

  @override
  String get avStrong => '强';

  @override
  String get avModerate => '中等';

  @override
  String get avQWhatIsAv => '什么是阿什塔卡瓦尔加（Ashtakavarga）？';

  @override
  String get avQWhatIsSav => '什么是SAV？';

  @override
  String get avQWhatIsBav => '什么是BAV？';

  @override
  String get avQHowToRead => '如何解读这些评分';

  @override
  String get avQSavVsBav => 'SAV与BAV的区别';

  @override
  String get avABody =>
      '阿什塔卡瓦尔加是吠陀占星学中一种基于点数的力量评估系统。每颗行星会根据其所处位置，向十二星座授予吉点（宾杜，Bindu，亦称Rekha）。某星座得分越高，意味着该领域在相关行星运程与行运期间会获得更顺畅的支持。';

  @override
  String get avSavBody =>
      'SAV（总阿什塔卡瓦尔加，Sarva Ashtakavarga）将七颗行星在每个星座上的点数相加。它为每个星座提供一个综合力量评分，让您能快速看出星盘中哪些星座——以及它们所落的宫位——获得了最好的支持。';

  @override
  String get avBavBody =>
      'BAV（单项阿什塔卡瓦尔加，Bhinna Ashtakavarga）显示单颗行星在十二星座上的点数分布。它告诉您某颗特定行星最支持哪些星座，这在该行星的大运或行运活跃时尤为重要。';

  @override
  String get avHowToReadBody =>
      '数值越高越好。就SAV而言，一个星座的平均得分约为28分——高于30分为强，低于25分则需要留意。就BAV而言，每个星座的得分范围为0至8分，4分为平均水平。重要行动宜倚重最强的星座，对最薄弱的星座则应保持耐心与自律。';

  @override
  String get avSavVsBavBody =>
      'SAV是所有行星的总和，展示一个星座的整体力量。BAV则是单颗行星的贡献值，显示是哪颗行星在支持该星座。使用SAV把握整体情况，使用BAV了解是哪颗行星驱动了该星座的力量。';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return '您的星盘在$s1、$s2和$s3方面最为强劲。这些星座在行星运程与行运期间能提供更好的支持。$weak目前支持最少，因此在与之相关的事务上，耐心与自律会有所帮助。';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet在$s1和$s2方面表现最为强劲。当这些星座被激活时，$planet所主管的事务往往会有所改善。';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return '您最强的星座是$s1和$s2——当行星行运至此时，适合开展重要的新计划。';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1获得的支持最少——请谨慎行事，避免在相关事务上过度投入。';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet携带的点数最多，因此其所主管的事项在您的人生中获得了良好的支持。';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet携带的点数最少，最能从补救方法与有意识的努力中受益。';
  }

  @override
  String avInsightAverage(Object avg) {
    return '得分高于您平均值$avg分的星座，往往能带来更顺畅、更可靠的结果。';
  }

  @override
  String get fcKey => '关键';

  @override
  String get fcActions => '行动建议';

  @override
  String get fcCautions => '注意事项';

  @override
  String get fc12House => '十二宫';

  @override
  String get fcProbabilities => '概率';

  @override
  String get fcHousesCaps => '宫位';

  @override
  String get fcCritical => '严重';

  @override
  String get fcFlags => '警示';

  @override
  String get fcAnalysis => '分析';

  @override
  String get fcConfidence => '可信度';

  @override
  String get fcQualityCaps => '质量';

  @override
  String get fcIncomeVs => '收入与';

  @override
  String get fcExpense => '支出';

  @override
  String get fcFinance => '财务';

  @override
  String get fcNetBalance => '净余额';

  @override
  String get fcSignature => '特征';

  @override
  String get fcBestTimeForIncome => '最佳收入时段';

  @override
  String get fcExpenseCaution => '支出注意事项';

  @override
  String get fcIncomeCaps => '收入';

  @override
  String get fcExpenseCaps => '支出';

  @override
  String get fcRelationships => '人际关系';

  @override
  String get fcAreasCaps => '领域';

  @override
  String get fcBestForMeetings => '最适合会面';

  @override
  String get fcOpportunitiesVs => '机遇与';

  @override
  String get fcRisks => '风险';

  @override
  String get fcOutlook => '展望';

  @override
  String get fcAction => '行动';

  @override
  String get fcProtect => '防护';

  @override
  String get fcOpportunityCaps => '机遇';

  @override
  String get fcRiskCaps => '风险';

  @override
  String get fcTopOpportunities => '主要机遇';

  @override
  String get fcTopRisks => '主要风险';

  @override
  String get fcTiming => '时机';

  @override
  String get fcWindows => '时段';

  @override
  String get fcSlotsCaps => '时段';

  @override
  String get fcBestWindows => '最佳时段';

  @override
  String get fcWorstWindows => '最差时段';

  @override
  String get fcAvoid => '避免';

  @override
  String get fcHouse => '宫位';

  @override
  String get fcFailed => '失败';

  @override
  String get lifeCareer => '事业';

  @override
  String get lifeHealth => '健康';

  @override
  String get lifeWealth => '财富';

  @override
  String get lifeFamily => '家庭';

  @override
  String get lifeMind => '心智';

  @override
  String get lifeEgo => '自我';

  @override
  String get lifeAggression => '攻击性';

  @override
  String get lifeConflict => '冲突';

  @override
  String get rashiElement => '元素';

  @override
  String get rashiQuality => '属性';

  @override
  String get rashiLuckyColor => '幸运颜色';

  @override
  String get rashiLuckyDay => '幸运日';

  @override
  String get rashiLuckyNumber => '幸运数字';

  @override
  String get rashiGemstone => '幸运宝石';

  @override
  String get rashiBody => '身体部位';

  @override
  String get gocharTodaysTransitChart => '今日行运星盘';

  @override
  String get gocharTransit => '行运';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get best => '最佳';

  @override
  String get worst => '最差';

  @override
  String get avg => '平均';

  @override
  String get favorableLoveWindowsLabel => '有利爱情时段';

  @override
  String get lordLabel => '主星';

  @override
  String get lordPlacementLabel => '主星落位';

  @override
  String get lordDignityLabel => '主星力量状态';

  @override
  String get categoriesSuffix => '类别';

  @override
  String get coreBlockerLabel => '核心阻碍';

  @override
  String get coreGiftLabel => '✦ 核心天赋';

  @override
  String get coreThemeLabel => '● 核心主题';

  @override
  String dominantLabel(Object value) {
    return '主导：$value';
  }

  @override
  String get karakasSuffix => '徵星';

  @override
  String get protectiveLabel => '保护性';

  @override
  String secondaryLabel(Object value) {
    return ' · 次要：$value';
  }

  @override
  String get tagCore => '核心';

  @override
  String get debtScoresHeader => '📉 债务评分';

  @override
  String get debtCurrentLoadStat => '当前\n债务负担';

  @override
  String get debtRecoveryCapacityStat => '恢复\n能力';

  @override
  String get debtIntensityStat => '强度';

  @override
  String get debtDefaultRiskStat => '违约风险';

  @override
  String get debtProfileTitle => '债务档案';

  @override
  String get debtKarmaLabel => '业力';

  @override
  String get debtPersonalityLabel => '性格';

  @override
  String get debtPhaseLabel => '阶段';

  @override
  String get debtPrimaryCategoryLabel => '主要类别';

  @override
  String get debtWord => '债务';

  @override
  String get debtYogasTitle => '债务瑜伽';

  @override
  String get debtCreatingLabel => '形成债务';

  @override
  String get debtClearingLabel => '清偿债务';

  @override
  String get yearlyDebtTitle => '年度债务';

  @override
  String get debtRepaymentTitle => '还款';

  @override
  String get debtDangerPeriodsTitle => '危险时期';

  @override
  String get debtDefaultPctStat => '违约率';

  @override
  String get debtBankruptcyPctStat => '破产率';

  @override
  String get debtChronicPctStat => '长期负债率';

  @override
  String get debtResilienceStat => '韧性';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return '恢复率：$pct% · 时间线：$years年';
  }

  @override
  String get debtFreeWindowLabel => '🎯 无债时段';

  @override
  String debtFreeYear(Object year) {
    return '第$year年';
  }

  @override
  String get legalScoresHeader => '⚖️ 法律评分';

  @override
  String get legalVulnerabilityStat => '法律\n脆弱度';

  @override
  String get legalVictoryPotentialStat => '胜诉\n潜力';

  @override
  String get legalConflictStat => '冲突';

  @override
  String get legalResolutionStat => '化解能力';

  @override
  String get legalProfileTitle => '法律档案';

  @override
  String get legalKarmaTypeLabel => '业力类型';

  @override
  String get legalConflictStyleLabel => '冲突风格';

  @override
  String get legalStrategyLabel => '策略';

  @override
  String get legalCaseDurationLabel => '案件时长';

  @override
  String get legalCurrentStatusLabel => '当前状态';

  @override
  String get legalWord => '法律';

  @override
  String get legalYogasTitle => '法律瑜伽';

  @override
  String get legalDisputePressureLabel => '纠纷压力';

  @override
  String get legalProtectionLabel => '法律保护力';

  @override
  String get legalStressTrendTitle => '法律压力';

  @override
  String get legalVisibleEnemiesStat => '明面仇敌';

  @override
  String get legalHiddenEnemiesStat => '隐藏仇敌';

  @override
  String get legalCriminalRiskStat => '涉刑风险';

  @override
  String get legalFalseAccusationStat => '被诬告风险';

  @override
  String get legalContractKarmaTitle => '合同业力';

  @override
  String get legalDocumentationLabel => '文档质量';

  @override
  String get legalFinePrintAwareLabel => '细则条款警觉性';

  @override
  String get legalNegotiationSkillLabel => '谈判技巧';

  @override
  String get legalSignatureCautionLabel => '签署谨慎度';

  @override
  String legalResilienceSubtitle(Object pct) {
    return '韧性：$pct/100';
  }

  @override
  String get legalVictoryWord => '胜诉';

  @override
  String get legalAnalysisSuffix => '分析';

  @override
  String get legalAsPlaintiff => '作为原告';

  @override
  String get legalAsDefendant => '作为被告';

  @override
  String get legalWinProbability => '胜诉概率';

  @override
  String get legalDisputeWord => '纠纷';

  @override
  String get lifepathScoresHeader => '🌟 人生路径评分';

  @override
  String get lifepathDharmaClarityStat => '达摩\n清晰度';

  @override
  String get lifepathFortuneBaselineStat => '运势\n基线';

  @override
  String get lifepathCoherenceStat => '人生路径\n一致性';

  @override
  String get lifepathKarmaStat => '业力';

  @override
  String get lifepathSpiritualStat => '灵性';

  @override
  String get lifepathFameStat => '声望';

  @override
  String get lifepathSoulContractTitle => '灵魂契约';

  @override
  String get lifepathAtmakarakaLabel => '灵魂行星';

  @override
  String get lifepathAkFocusLabel => '灵魂焦点';

  @override
  String get lifepathSoulPurposeLabel => '灵魂使命';

  @override
  String get lifepathLifeChapterLabel => '人生篇章';

  @override
  String get lifepathPrimaryDomainLabel => '主要领域';

  @override
  String get lifepathLeadershipStat => '领导力';

  @override
  String get lifepathWisdomTeachStat => '智慧/教导';

  @override
  String get lifepathServiceStat => '服务';

  @override
  String get lifepathHealingStat => '疗愈';

  @override
  String get lifepathFortuneYogasTitle => '运势瑜伽';

  @override
  String get lifepathLuckBlocksLabel => '运势阻碍';

  @override
  String get lifepathFortuneBoostersLabel => '运势助力';

  @override
  String get lifepathFortuneTrendTitle => '运势趋势';

  @override
  String get lifepathGoldenWindowsTitle => '黄金时段 ★';

  @override
  String get lifepathTransformationTitle => '转变';

  @override
  String get lifepathMilestonesTitle => '人生里程碑';

  @override
  String get lifepathKarmicLessonsTitle => '业力课题';

  @override
  String get lifepathRahuGrowthLabel => '罗睺成长';

  @override
  String get lifepathKetuSurrenderLabel => '计都放下';

  @override
  String get lifepathSaturnLessonLabel => '土星课题';

  @override
  String get lifepathLifeDifficultyLabel => '人生难度';

  @override
  String get lifepathSoulExperienceTitle => '★ 灵魂此生要体验的事';

  @override
  String get lifepathBlessingsTitle => '● 福泽';

  @override
  String get lifepathLifeWord => '人生';

  @override
  String get lifepathArchetypeSuffix => '原型';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return '实现度：$pct%';
  }

  @override
  String get lifepathDestinyVsWord => '命运与';

  @override
  String get lifepathFreeWillSuffix => '自由意志';

  @override
  String get lifepathDestinyStat => '命运';

  @override
  String get lifepathFreeWillStat => '自由意志';

  @override
  String get pastlifeScoresHeader => '🔮 前世评分';

  @override
  String get pastlifeSignatureStrengthStat => '印记\n强度';

  @override
  String get pastlifeCarryForwardStat => '延续\n程度';

  @override
  String get pastlifeMasteryPreservedStat => '保留的\n精通能力';

  @override
  String get pastlifeUnfinishedStat => '未完成';

  @override
  String get pastlifeKarmicDebtStat => '业力债务';

  @override
  String get pastlifeProfileTitle => '前世档案';

  @override
  String get pastlifeThemeLabel => '主题';

  @override
  String get pastlifeProfessionLabel => '职业';

  @override
  String get pastlifeSocialStandingLabel => '社会地位';

  @override
  String get pastlifeRegionLabel => '地域';

  @override
  String get pastlifeSpiritualLevelLabel => '灵性水平';

  @override
  String get pastlifeGenderLabel => '性别';

  @override
  String get pastlifeWealthLevelLabel => '财富水平';

  @override
  String get pastlifeFamilyRoleLabel => '家庭角色';

  @override
  String get pastlifeSkillsCarriedTitle => '★ 延续下来的技能';

  @override
  String get pastlifeNaturalAttractionsTitle => '● 天然吸引';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ 无法解释的恐惧';

  @override
  String get pastlifeMagneticPullsTitle => '→ 无形的吸引力';

  @override
  String get pastlifeRelationshipStat => '关系';

  @override
  String get pastlifeFinancialStat => '财务';

  @override
  String get pastlifeServiceStat => '服务';

  @override
  String get pastlifeDharmicStat => '达摩';

  @override
  String get pastlifeOnRelationsStat => '在人际关系方面';

  @override
  String get pastlifeOnCareerStat => '在事业方面';

  @override
  String get pastlifeOnHealthStat => '在健康方面';

  @override
  String get pastlifeOnSpiritualStat => '在灵性方面';

  @override
  String get pastlifeKarmicResolutionTitle => '业力化解';

  @override
  String get pastlifePrimaryPathLabel => '主要路径';

  @override
  String get pastlifeSecondaryPathLabel => '次要路径';

  @override
  String get pastlifeClearingProgressLabel => '清理进度';

  @override
  String get pastlifeRemainingWorkLabel => '剩余功课';

  @override
  String get pastlifeDebtTimelineLabel => '债务时间线';

  @override
  String get pastlifeMemoryAccessStat => '记忆通达度';

  @override
  String get pastlifeDreamVisitsStat => '梦境造访';

  @override
  String get pastlifeDejaVuStat => '似曾相识';

  @override
  String get pastlifeRegressionFitStat => '回溯疗法适配度';

  @override
  String get pastlifeActivationTitle => '前世激活';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return '成熟度：$maturity · 状态：$status';
  }

  @override
  String get pastlifeKetuWord => '计都';

  @override
  String get pastlifePastMasterySuffix => '前世精通';

  @override
  String get pastlifeKetuMasteredLabel => '计都 · 您所精通之事';

  @override
  String get pastlifeRahuWord => '罗睺';

  @override
  String get pastlifeFutureGrowthSuffix => '未来成长';

  @override
  String get pastlifeRahuPullsLabel => '罗睺 · 牵引您前行之事';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ 阴影：$shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 心理评分';

  @override
  String get mentalStabilityStat => '心理\n稳定性';

  @override
  String get mentalEmotionalBaselineStat => '情绪\n基线';

  @override
  String get mentalResilienceStat => '韧性';

  @override
  String get mentalAnxietyStat => '焦虑';

  @override
  String get mentalDepressionStat => '低落情绪';

  @override
  String get mentalRegulationStat => '调节能力';

  @override
  String get mentalProfileTitle => '心理档案';

  @override
  String get mentalConstitutionLabel => '体质';

  @override
  String get mentalStressDriverLabel => '压力来源';

  @override
  String get mentalStabilityAnchorLabel => '稳定之锚';

  @override
  String get mentalStressResponseLabel => '压力反应';

  @override
  String get mentalAttachmentStyleLabel => '依恋风格';

  @override
  String get mentalBurnoutStageLabel => '倦怠阶段';

  @override
  String get mentalWord => '心理';

  @override
  String get mentalYogasTitle => '心理瑜伽';

  @override
  String get mentalStressPressureLabel => '压力程度';

  @override
  String get mentalWellnessTrendTitle => '身心健康趋势';

  @override
  String get mentalHealthyCopingTitle => '✓ 健康的应对方式';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ 不健康的风险';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ 推荐的替代方式';

  @override
  String get mentalSleepQualityStat => '睡眠质量';

  @override
  String get mentalSocialSupportStat => '社会支持';

  @override
  String get mentalBurnoutVulnStat => '倦怠脆弱度';

  @override
  String get mentalSelfAwarenessStat => '自我觉察力';

  @override
  String get mentalAnxietyWord => '焦虑';

  @override
  String get mentalTypesSuffix => '类型';

  @override
  String get mentalTherapyWord => '心理治疗';

  @override
  String get mentalModalityFitSuffix => '疗法适配度';

  @override
  String get characterScoresHeader => '🔍 性格评分';

  @override
  String get characterStrengthStat => '性格\n力量';

  @override
  String get characterIntegrityStat => '正直度';

  @override
  String get characterResilienceStat => '韧性';

  @override
  String get characterAwarenessStat => '觉察力';

  @override
  String get characterStabilityStat => '稳定性';

  @override
  String get characterEthicsStat => '伦理';

  @override
  String get characterSurfacePersonalityTitle => '表层性格';

  @override
  String get characterLagnaLabel => '上升星座';

  @override
  String get characterConstitutionLabel => '体质';

  @override
  String get characterNakshatraLabel => '星宿';

  @override
  String get characterDeityLabel => '守护神';

  @override
  String get characterMoonManasTitle => '月亮心智';

  @override
  String get characterSignLabel => '星座';

  @override
  String get characterHouseLabel => '宫位';

  @override
  String get characterWarmthStat => '热情度';

  @override
  String get characterEmpathyStat => '同理心';

  @override
  String get characterLoyaltyStat => '忠诚度';

  @override
  String get characterBoundariesStat => '边界感';

  @override
  String get characterDharmaStat => '达摩';

  @override
  String get characterTruthStat => '真实度';

  @override
  String get characterCompassionStat => '慈悲心';

  @override
  String get characterGenerosityStat => '慷慨度';

  @override
  String get characterSignatureVirtuesTitle => '★ 标志性美德';

  @override
  String get characterNaturalTalentsTitle => '● 天生才能';

  @override
  String get characterShadowPatternsTitle => '⚠ 阴影模式';

  @override
  String get characterYogasTitle => '性格瑜伽';

  @override
  String get characterTestsLabel => '考验';

  @override
  String get characterGiftsLabel => '天赋';

  @override
  String get characterSelfAwareEiStat => '自我觉察情商';

  @override
  String get characterSelfRegulateStat => '自我调节';

  @override
  String get characterEmpathyEiStat => '同理心情商';

  @override
  String get characterSocialSkillsStat => '社交技能';

  @override
  String characterRealizationSubtitle(Object pct) {
    return '实现度：$pct%';
  }

  @override
  String get characterAtmakarakaWord => '灵魂行星（Atmakaraka）';

  @override
  String get characterSoulSignatureSuffix => '灵魂印记';

  @override
  String get characterAtmakarakaLabel => '灵魂行星';

  @override
  String get characterGunaWord => '古纳';

  @override
  String get characterProfileSuffix => '档案';

  @override
  String get characterSattvaLabel => '悦性（Sattva）';

  @override
  String get characterRajasLabel => '动性（Rajas）';

  @override
  String get characterTamasLabel => '惰性（Tamas）';

  @override
  String get healthScoresHeader => '🏥 健康评分';

  @override
  String get healthVitalityStat => '活力';

  @override
  String get healthImmunityStat => '免疫力';

  @override
  String get healthRecoveryStat => '恢复力';

  @override
  String get healthMentalStat => '心理';

  @override
  String get healthStressTolStat => '抗压能力';

  @override
  String get healthYogasTitle => '健康瑜伽';

  @override
  String get healthDiseasePressureLabel => '疾病压力';

  @override
  String get healthTrendTitle => '健康趋势';

  @override
  String get healthRecoveryWindowsTitle => '恢复时段';

  @override
  String get healthCautionPeriodsTitle => '需谨慎时期';

  @override
  String get healthFertilityStat => '生育力';

  @override
  String get healthBurnoutRiskStat => '职业倦怠风险';

  @override
  String get healthAddictionVulnStat => '成瘾脆弱度';

  @override
  String get healthWorkLifeBalStat => '工作生活平衡';

  @override
  String get healthAyurvedicWord => '阿育吠陀';

  @override
  String get healthConstitutionSuffix => '体质';

  @override
  String get healthBodyWord => '身体';

  @override
  String get healthSystemMapSuffix => '系统图谱';

  @override
  String get healthBodyZoneWord => '身体区域';

  @override
  String get healthVulnerabilitySuffix => '脆弱度';

  @override
  String get healthDiseaseWord => '疾病';

  @override
  String get healthSusceptibilitySuffix => '易感性';

  @override
  String get healthLifestyleFactorsTitle => '生活方式因素';

  @override
  String get healthSleepDisciplineLabel => '睡眠自律';

  @override
  String get healthDietDisciplineLabel => '饮食自律';

  @override
  String get healthExerciseNeedLabel => '运动需求';

  @override
  String get healthSunlightNeedLabel => '日照需求';

  @override
  String get healthSocialTypeLabel => '社交类型';

  @override
  String get healthHealingSpeedLabel => '疗愈速度';

  @override
  String get wealthScoresHeader => '💰 财富评分';

  @override
  String get wealthStrengthStat => '财富\n力量';

  @override
  String get wealthAccumulationStat => '积累\n能力';

  @override
  String get wealthIncomeFlowStat => '收入\n流';

  @override
  String get wealthSustainStat => '可持续性';

  @override
  String get wealthMultiStreamStat => '多元收入流';

  @override
  String get wealthRetentionStat => '留存能力';

  @override
  String get wealthWord => '财富';

  @override
  String get wealthYogasTitle => '财富瑜伽';

  @override
  String get wealthDrainsLabel => '消耗因素';

  @override
  String get wealthBoostersLabel => '助推因素';

  @override
  String get wealthYearlyTrendTitle => '年度趋势';

  @override
  String get wealthGrowthTitle => '财富增长';

  @override
  String get wealthCashPressureTitle => '现金压力';

  @override
  String get wealthMoneyPersonalityTitle => '金钱性格';

  @override
  String get wealthTypeLabel => '财富类型';

  @override
  String get wealthRiskAppetiteLabel => '风险偏好';

  @override
  String get wealthInvestmentStyleLabel => '投资风格';

  @override
  String get wealthMoneyPersonalityLabel => '金钱性格';

  @override
  String get wealthSpendingLabel => '消费习惯';

  @override
  String get wealthDebtProbStat => '负债概率%';

  @override
  String get wealthInheritanceStat => '继承概率%';

  @override
  String get wealthSuddenGainsStat => '意外获利概率%';

  @override
  String get wealthSpouseBoostStat => '配偶加成%';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return '成功概率：$pct%';
  }

  @override
  String get wealthLifetimeClassLabel => '一生财富等级';

  @override
  String wealthPrimaryLabel(Object value) {
    return '主要：$value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return '巅峰：$value';
  }

  @override
  String get wealthIncomeWord => '收入';

  @override
  String get wealthSourcesSuffix => '来源';

  @override
  String get wealthInvestmentWord => '投资';

  @override
  String get wealthMixSuffix => '组合';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '由$planet驱动';
  }

  @override
  String get marriageScoresHeader => '💒 婚姻评分';

  @override
  String get marriageOverallStat => '整体\n婚姻';

  @override
  String get marriageHarmonyStat => '婚姻\n和谐度';

  @override
  String get marriageDomesticStabilityStat => '家庭\n稳定性';

  @override
  String get marriageLongevityStat => '长久度';

  @override
  String get marriageSatisfactionStat => '满意度';

  @override
  String get marriageClarityStat => '清晰度';

  @override
  String get marriageWindowsTitle => '婚姻时段';

  @override
  String get marriagePhasesTitle => '婚姻阶段';

  @override
  String get marriageInLawRelationsStat => '姻亲关系';

  @override
  String get marriageFamilyHarmonyStat => '家庭和谐';

  @override
  String get marriageFertilityStat => '生育力';

  @override
  String get marriageHomeOwnershipStat => '购房能力';

  @override
  String get marriageDivorceRiskStat => '离婚风险';

  @override
  String get marriageInfidelityStat => '不忠风险';

  @override
  String get marriageConflictStat => '冲突';

  @override
  String get marriageDistanceStat => '情感疏离';

  @override
  String get marriageSeekInPartnerTitle => '★ 寻找伴侣时应关注';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ 择偶时应避免';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return '实现度：$pct%';
  }

  @override
  String get marriageDarakarakaWord => '配偶徵星（Darakaraka）';

  @override
  String get marriageSpouseKarakaSuffix => '配偶徵星';

  @override
  String get marriageDarakarakaDkLabel => '配偶徵星（DK）';

  @override
  String get marriage7thWord => '第七宫';

  @override
  String get marriageSignLabel => '星座';

  @override
  String get marriageLordInLabel => '主星位于';

  @override
  String get marriageStrengthLabel => '力量';

  @override
  String get marriageSpouseWord => '配偶';

  @override
  String get marriageProfileSuffix => '档案';

  @override
  String get marriageSpouseTraitsTitle => '★ 配偶特质';

  @override
  String get marriageLikelyProfessionsTitle => '● 可能的职业';

  @override
  String get marriageHarmonyWord => '和谐度';

  @override
  String get marriageRadarSuffix => '雷达图';

  @override
  String get marriagePhysicalLabel => '身体层面';

  @override
  String get marriageSharedValuesLabel => '共同价值观';

  @override
  String get marriageConflictResolutionLabel => '冲突化解';

  @override
  String get marriageMangalDoshLabel => '⚠ 火星缺陷（Mangal Dosh）';

  @override
  String marriageSeveritySubtitle(Object value) {
    return '严重程度：$value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return '抵消情况：$value';
  }

  @override
  String get marriageD9Word => 'D9';

  @override
  String get marriageNavamsaSuffix => '纳瓦姆萨';

  @override
  String get multiChartTitleChild => '子女';

  @override
  String get multiChartTitleLove => '爱情';

  @override
  String get multiChartTitleKarma => '业力';

  @override
  String get multiChartTitleDefault => '多重星盘';

  @override
  String get multiChartSuffixProbability => '概率';

  @override
  String get multiChartSuffixCompatibility => '合盘';

  @override
  String get multiChartSuffixLinkage => '关联';

  @override
  String get multiChartSuffixReport => '报告';

  @override
  String get multiChartParticipantsLabel => '参与者';

  @override
  String get multiChartAnalysisWord => '分析';

  @override
  String get multiChartConfidenceSuffix => '可信度';

  @override
  String get multiChartQualityBadge => '质量';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return '请分析这份吠陀占星报告，并给出详细的解读：\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return '这是一份吠陀占星专项报告。请深入分析并提供可操作的建议：\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return '请审阅这份吠陀占星分析，并用简单易懂的语言解释关键发现：\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '已为$label复制！';
  }

  @override
  String get childProbTitle1 => '子女';

  @override
  String get childProbTitle2 => '概率';

  @override
  String get childNumberOfChildrenHeader1 => '子女';

  @override
  String get childNumberOfChildrenHeader2 => '数量';

  @override
  String get childTimingHeader1 => '时机';

  @override
  String get childTimingHeader2 => '命主大运';

  @override
  String get child5thHouseHeader1 => '第五宫';

  @override
  String get analysisWord => '分析';

  @override
  String get jupiterWord => '木星';

  @override
  String get childD7Header1 => 'D7萨普塔姆萨';

  @override
  String get childBeejaHeader1 => '种子与田地';

  @override
  String get childBeejaHeader2 => '斯普塔（Sphuta）';

  @override
  String get childDoshaHeader1 => '缺陷';

  @override
  String get childVedicHeader1 => '吠陀';

  @override
  String get childVedicHeader2 => '补救方法';

  @override
  String get progenyProbabilityLabel => '子嗣概率';

  @override
  String get favorableWindowsLabel => '有利时段';

  @override
  String get partnerOneLabel => '伴侣一';

  @override
  String get partnerTwoLabel => '伴侣二';

  @override
  String get moonSignLabel => '月亮星座';

  @override
  String get lordInDusthana => '主星落陷宫（Dusthana）';

  @override
  String get lordStrengthLabel => '主星力量';

  @override
  String get houseStrengthLabel => '宫位力量';

  @override
  String get dignityLabel => '力量状态';

  @override
  String get directBadge => '顺行';

  @override
  String get notCombustBadge => '未焦伤';

  @override
  String get in5thHouseBadge => '位于第五宫';

  @override
  String get aspects5thBadge => '相位第五宫';

  @override
  String get no5thConnectionBadge => '与第五宫无关联';

  @override
  String jupiterInSignHeading(String sign) {
    return '木星位于$sign';
  }

  @override
  String get d7LagnaLabel => 'D7上升星座';

  @override
  String get d7FifthSignLabel => 'D7第五宫星座';

  @override
  String get d7FifthLordLabel => 'D7第五宫主星';

  @override
  String get jupiterInD7Label => '木星在D7中';

  @override
  String get jupiterDignityLabel => '木星力量状态';

  @override
  String get d7StrengthLabel => 'D7强度';

  @override
  String get yesWord => '是';

  @override
  String get noWord => '否';

  @override
  String get beejaSphutaTitle => '种子斯普塔';

  @override
  String get kshetraSphutaTitle => '田地斯普塔';

  @override
  String get degreeLabel => '度数';

  @override
  String get signLordLabel => '星座主星';

  @override
  String get presentInLabel => '存在于';

  @override
  String get netPenaltyLabel => '净扣分';

  @override
  String get remedyGemstone => '宝石补救';

  @override
  String get remedyMantra => '真言补救';

  @override
  String get remedyRitual => '仪式补救';

  @override
  String get remedyLifestyle => '生活方式补救';

  @override
  String get remedyCharitable => '慈善补救';

  @override
  String copiedForName(String name) {
    return '已为$name复制！';
  }

  @override
  String get mahadashaLabel => '大运（Mahadasha）';

  @override
  String get mdPeriodLabel => '大运期间';

  @override
  String get antardashaLabel => '子运（Antardasha）';

  @override
  String get adPeriodLabel => '子运期间';

  @override
  String get pratyantardashaLabel => '孙运（Pratyantardasha）';

  @override
  String get favorabilityLabel => '有利程度';

  @override
  String factorPrefix(String factor) {
    return '因素：$factor';
  }

  @override
  String appliesToLabel(String value) {
    return '适用于：$value';
  }

  @override
  String get qualityTag => '质量';

  @override
  String get reliabilityVeryHigh => '极高可靠性';

  @override
  String get reliabilityGuidanceLevel => '指导性解读';

  @override
  String get karmaLinkTitle1 => '业力';

  @override
  String get karmaLinkTitle2 => '关联';

  @override
  String get karmaFoundationHeader1 => '业力';

  @override
  String get karmaFoundationHeader2 => '基础';

  @override
  String get karmaPairwiseHeader1 => '两两';

  @override
  String get karmaPairwiseHeader2 => '关联';

  @override
  String get karmaGroupHeader1 => '群体';

  @override
  String get karmaGroupHeader2 => '模式';

  @override
  String get karmaPastLifeHeader1 => '前世';

  @override
  String get karmaPastLifeHeader2 => '目标';

  @override
  String get karmaCurrentLifeHeader1 => '今生';

  @override
  String get karmaCurrentLifeHeader2 => '课题';

  @override
  String get karmaDebtsHeader2 => '债务';

  @override
  String get karmaMoolaDashaHeader1 => '命主大运';

  @override
  String get karmaMoolaDashaHeader2 => '时机';

  @override
  String get karmaDeepAuditHeader1 => '深度审查';

  @override
  String get karmaDeepAuditHeader2 => '表格';

  @override
  String get karmaHeroLabel => '前世业力关联';

  @override
  String get karmaKetuMastery => '计都精通';

  @override
  String get nakshatraLabel => '星宿';

  @override
  String get deityLabel => '守护神';

  @override
  String get masteryScoreLabel => '精通评分';

  @override
  String get karmaRahuGrowth => '罗睺成长';

  @override
  String get growthScoreLabel => '成长评分';

  @override
  String get karmaAtmakaraka => '灵魂行星';

  @override
  String get karmaSaturnKarma => '土星业力';

  @override
  String get karma12thHouse => '第十二宫';

  @override
  String get karma9thHousePunya => '第九宫福报';

  @override
  String get bhavaScoreLabel => '宫位评分';

  @override
  String get karmaD60Signature => 'D60印记';

  @override
  String get depthScoreLabel => '深度评分';

  @override
  String get linkageStrengthLabel => '关联强度';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return '关联因素（$count项已激活）';
  }

  @override
  String get factorColumnLabel => '因素';

  @override
  String get weightColumnLabel => '权重';

  @override
  String get meaningColumnLabel => '含义';

  @override
  String get statusColumnLabel => '状态';

  @override
  String get karmaPastLifeConnection => '前世联系';

  @override
  String get karmaCurrentLifeDynamic => '今生动态';

  @override
  String get karmaWhatTheyTeach => '彼此教导之事';

  @override
  String get karmaGroupThemeHeader => '群体业力主题';

  @override
  String get karmaSharedSettingHeader => '共同的前世背景';

  @override
  String get karmaCollectiveKetuHeader => '集体计都模式';

  @override
  String get karmaCollectiveRahuHeader => '集体罗睺模式';

  @override
  String get housesPrefixLabel => '宫位：';

  @override
  String get signsPrefixLabel => '星座：';

  @override
  String get karmicCohesionLabel => '业力凝聚力';

  @override
  String get karmaGroupSoulContractHeader => '群体灵魂契约';

  @override
  String get goalLabel => '目标';

  @override
  String get karmaSharedGoalHeader => '共同的前世目标';

  @override
  String get howToGrowHeader => '如何成长';

  @override
  String moolaDashaPrefix(String value) {
    return '命主大运：$value';
  }

  @override
  String get karmaSharedLessonHeader => '群体共同课题';

  @override
  String get karmaMutualTeachingHeader => '相互教导图谱';

  @override
  String get karmaTeachingDynamicsPlaceholder => '随着业力联系的深化，教导动态将逐渐显现。';

  @override
  String get typeFieldLabel => '类型';

  @override
  String get basisFieldLabel => '依据';

  @override
  String get resolutionPathHeader => '化解路径';

  @override
  String dashaTimingPrefix(String value) {
    return '大运时机：$value';
  }

  @override
  String get mutualDebtsHeader => '相互业力债务';

  @override
  String get mdLabel => '大运（MD）';

  @override
  String get adLabel => '子运（AD）';

  @override
  String get pdLabel => '孙运（PD）';

  @override
  String get datesLabel => '日期';

  @override
  String get groupKarmicWindowHeader => '群体业力时段';

  @override
  String parametersAuditedHeading(int count) {
    return '已审查$count项参数';
  }

  @override
  String get valuePrefixLabel => '数值：';

  @override
  String weightPrefix(String value) {
    return '权重：$value';
  }

  @override
  String get loveCompatTitle1 => '爱情';

  @override
  String get loveCompatTitle2 => '合盘';

  @override
  String get loveAttractionHeader1 => '吸引力与';

  @override
  String get loveAttractionHeader2 => '化学反应';

  @override
  String get loveEmotionalHeader1 => '情感';

  @override
  String get loveEmotionalHeader2 => '和谐度';

  @override
  String get loveMentalHeader1 => '心灵';

  @override
  String get loveMentalHeader2 => '默契';

  @override
  String get lovePassionHeader1 => '激情与';

  @override
  String get lovePassionHeader2 => '身体吸引';

  @override
  String get loveLongtermHeader1 => '长期';

  @override
  String get loveKarmicHeader1 => '业力爱情';

  @override
  String get loveKarmicHeader2 => '纽带';

  @override
  String get loveChallengesHeader1 => '挑战与';

  @override
  String get loveChallengesHeader2 => '摩擦';

  @override
  String get loveTimingHeader1 => '爱情时机';

  @override
  String get loveRelationshipHeader1 => '关系';

  @override
  String get loveRelationshipHeader2 => '动态';

  @override
  String get loveRemediesHeader1 => '补救方法与';

  @override
  String get loveRemediesHeader2 => '指引';

  @override
  String get loveCompatHeroLabel => '爱情合盘';

  @override
  String get loveChipAttraction => '吸引力';

  @override
  String get loveChipPassion => '激情';

  @override
  String get loveChipChallenge => '挑战';

  @override
  String get venusSignLabel => '金星星座';

  @override
  String get attractionScoreLabel => '吸引力评分';

  @override
  String get activeContactsLabel => '活跃相位';

  @override
  String get magneticPullLabel => '无形吸引力';

  @override
  String get initialAttractionLabel => '初始吸引力';

  @override
  String get emotionalScoreLabel => '情感评分';

  @override
  String get elementMatchLabel => '元素匹配度';

  @override
  String get harmonyLabel => '和谐度';

  @override
  String get kootaYoni => '尤尼（Yoni）';

  @override
  String get kootaGana => '伽纳（Gana）';

  @override
  String get kootaTara => '塔拉（Tara）';

  @override
  String get doshaPresentBadge => '存在缺陷';

  @override
  String get noDoshaBadge => '无缺陷';

  @override
  String get axisLabel => '轴线';

  @override
  String get mentalScoreLabel => '心灵评分';

  @override
  String get mercuryDynamicsLabel => '水星动态';

  @override
  String get communicationStyleLabel => '沟通风格匹配度';

  @override
  String get intellectualConnectionLabel => '智识连接';

  @override
  String get passionScoreLabel => '激情评分';

  @override
  String get marsVenusLabel => '火星-金星互动';

  @override
  String get physicalChemistryLabel => '身体吸引力';

  @override
  String get yoniCompatLabel => '尤尼合盘度';

  @override
  String get longtermScoreLabel => '长期评分';

  @override
  String get seventhHouseSynastryLabel => '第七宫合盘分析';

  @override
  String get commitmentPotentialLabel => '承诺潜力';

  @override
  String get jupiterBlessingLabel => '木星祝福';

  @override
  String get d9NavamsaResonanceLabel => 'D9纳瓦姆萨共鸣';

  @override
  String get saturnLongevityLabel => '土星长久度';

  @override
  String get karmicScoreLabel => '业力评分';

  @override
  String get darakarakaLinkLabel => '配偶徵星关联';

  @override
  String get sourceLabel => '来源';

  @override
  String get emotionalGiverReceiverLabel => '情感付出者/接受者';

  @override
  String get powerBalanceLabel => '权力平衡';

  @override
  String get growthDynamicLabel => '成长动态';

  @override
  String get addressesLabel => '针对问题';

  @override
  String get loveScoresLabel => '爱情评分';

  @override
  String get loveCapacityLabel => '爱的\n能力';

  @override
  String get emotionalAvailabilityLabel => '情感\n开放度';

  @override
  String get romanticAttractionLabel => '浪漫\n吸引力';

  @override
  String get commitmentWord => '承诺';

  @override
  String get intimacyWord => '亲密度';

  @override
  String get fidelityWord => '忠诚度';

  @override
  String get loveProfileTitle => '爱情档案';

  @override
  String get loveStyleLabel => '爱情风格';

  @override
  String get attractionStyleLabel => '吸引风格';

  @override
  String get lovePathLabel => '爱情路径';

  @override
  String get currentPhaseLabel => '当前阶段';

  @override
  String get commitmentStyleLabel => '承诺风格';

  @override
  String get loveWord => '爱情';

  @override
  String get karakasWord => '徵星';

  @override
  String get attractedToLabel => '吸引类型';

  @override
  String get whatPartnerSeesLabel => '伴侣眼中的您';

  @override
  String get romancePatternTitle => '恋爱模式';

  @override
  String get firstLoveAgeLabel => '初恋年龄';

  @override
  String get relationshipCountLabel => '感情关系数量';

  @override
  String get avgDurationLabel => '平均持续时间';

  @override
  String get breakupTriggerLabel => '分手诱因';

  @override
  String get heartbreakRecoveryLabel => '心碎恢复力';

  @override
  String get loveTrendTitle => '爱情趋势';

  @override
  String get newLoveWindowsTitle => '新恋情时段';

  @override
  String get loveBlocksTitle => '爱情阻碍';

  @override
  String get activeBlocksLabel => '已激活的阻碍';

  @override
  String get loveMarriagePctLabel => '自由恋爱婚姻概率%';

  @override
  String get heartbreakVulnLabel => '心碎易感度';

  @override
  String get selfSabotageLabel => '自我破坏';

  @override
  String get emotionalIqLabel => '情商';

  @override
  String fulfillmentPctLabel(String pct) {
    return '实现度：$pct%';
  }

  @override
  String get languagesWord => '爱之语言';

  @override
  String get givesLabel => '付出方式';

  @override
  String get receivesLabel => '接受方式';

  @override
  String get idealWord => '理想';

  @override
  String get partnerWord => '伴侣';

  @override
  String get seekTheseTraitsLabel => '应寻找的特质';

  @override
  String get dealbreakersLabel => '无法接受的底线';

  @override
  String get propertyScoresLabel => '财产评分';

  @override
  String get acquisitionCapacityLabel => '置产\n能力';

  @override
  String get homeOwnershipPctLabel => '购房\n概率%';

  @override
  String get reWealthPotentialLabel => '房产财富\n潜力';

  @override
  String get rentalWord => '租赁';

  @override
  String get vehiclesWord => '车辆';

  @override
  String get landPctLabel => '土地拥有率%';

  @override
  String get propertyProfileTitle => '财产档案';

  @override
  String get karmaTypeLabel => '业力类型';

  @override
  String get environmentLabel => '环境';

  @override
  String get styleLabel => '风格';

  @override
  String get sizeLabel => '规模';

  @override
  String get locationLabel => '地点';

  @override
  String get actionNext12mLabel => '未来12个月行动';

  @override
  String get propertyWord => '财产';

  @override
  String get propertyYogasTitle => '财产瑜伽';

  @override
  String get drainsLabel => '消耗因素';

  @override
  String get boostersLabel => '助推因素';

  @override
  String get propertyTrendTitle => '财产趋势';

  @override
  String get buyingWindowsTitle => '购置时段';

  @override
  String get constructionWindowsTitle => '建造时段';

  @override
  String get maternalInherPctLabel => '母系继承率%';

  @override
  String get paternalInherPctLabel => '父系继承率%';

  @override
  String get multiHomePctLabel => '多套房产率%';

  @override
  String get investmentPctLabel => '投资率%';

  @override
  String get vehicleProfileTitle => '车辆档案';

  @override
  String get countLabel => '数量';

  @override
  String get firstAgeLabel => '首次年龄';

  @override
  String get categoryLabel => '类别';

  @override
  String get luxuryLabel => '奢华度';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return '一生数量：$count · 实现度：$pct%';
  }

  @override
  String get pressureWord => '压力';

  @override
  String get protectionWord => '保护力';

  @override
  String get astrologicalWord => '占星学';

  @override
  String get keyRisksHeader1 => '关键';

  @override
  String get keyRisksHeader2 => '风险';

  @override
  String get reportCopiedShort => '报告已复制！';

  @override
  String get keyScoresLabel => '关键评分';

  @override
  String allScoresCountLabel(int count) {
    return '所有评分（$count项）';
  }

  @override
  String get windowsWord => '时段';

  @override
  String get genericFailedMsg => '失败';

  @override
  String get unknownWord => '未知';

  @override
  String selectKarmaChartsLabel(int max) {
    return '选择2至$max个星盘';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '选择$max个星盘';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '正在进行$label分析…';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return '选择2至$max个星盘以分析业力关联';
  }

  @override
  String get pickMaleFemaleHint => '请选择一男一女的星盘';

  @override
  String get personOneLabel => '人物一';

  @override
  String get personTwoLabel => '人物二';

  @override
  String get analysisFailedMsg => '分析失败';

  @override
  String analyzeChartsCountLabel(int count) {
    return '分析$count个星盘';
  }

  @override
  String get contextGeneralLabel => '常规';

  @override
  String get contextLoveLabel => '爱情';

  @override
  String get contextBusinessLabel => '商业';

  @override
  String get contextFamilyLabel => '家庭';

  @override
  String get contextTeamLabel => '团队';

  @override
  String get contextFriendshipLabel => '友情';

  @override
  String get relationshipIntelTitle => '关系洞察';

  @override
  String analyzingChartsCountLabel(int count) {
    return '正在分析$count个星盘…';
  }

  @override
  String get relationshipContextLabel => '关系背景';

  @override
  String get kundliMilanReportTitle => '星盘合婚报告';

  @override
  String get runningMilanAnalysisLabel => '正在进行合婚分析…';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '已选择$count/2';
  }

  @override
  String get runMilanAnalysisBtn => '开始合婚分析';

  @override
  String get noChartsCreateFirst => '暂无星盘。请先创建一份本命盘。';

  @override
  String get selectBirthChartAnalyze => '选择要分析的本命盘';

  @override
  String get doshAnalysis => '缺陷分析';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active项已激活 / 共检查$total项';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active项已激活 / 共检查$total项瑜伽';
  }

  @override
  String yogaActiveHeader(Object count) {
    return '已激活瑜伽（$count项）';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return '隐藏未激活瑜伽（$count项）';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return '显示未激活瑜伽（$count项）';
  }

  @override
  String get loadFailed => '加载失败';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet大运 → 子运';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet子运 → 孙运';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet孙运 → 曾孙运';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet子期';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return '出生主星：$lord • 剩余：$balance年';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return '上升星座：$lagna • 剩余：$balance年';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years年';
  }

  @override
  String get dashaCurrentPeriod => '当前大运期';

  @override
  String dashaAsOf(Object date) {
    return '截至：$date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return '当前运程中已激活的瑜伽（$count项）';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return '当前运程中已激活的缺陷（$count项）';
  }

  @override
  String get dashaNoYogasTriggered => '未触发任何瑜伽';

  @override
  String get dashaNoDoshasTriggered => '未触发任何缺陷';

  @override
  String get divD1Name => '本命盘（D1）';

  @override
  String get divD1Desc => '肉身存在，涵盖一切事项';

  @override
  String get divD2Name => '霍拉盘（D2）';

  @override
  String get divD2Desc => '财富、金钱';

  @override
  String get divD3Name => '德雷卡纳盘（D3）';

  @override
  String get divD3Desc => '兄弟姐妹、勇气';

  @override
  String get divD4Name => '查图尔塔姆萨盘（D4）';

  @override
  String get divD4Desc => '财产、住所、运势';

  @override
  String get divD5Name => '潘查姆萨盘（D5）';

  @override
  String get divD5Desc => '声望、权威、权力';

  @override
  String get divD6Name => '沙什塔姆萨盘（D6）';

  @override
  String get divD6Desc => '健康问题';

  @override
  String get divD7Name => '萨普塔姆萨盘（D7）';

  @override
  String get divD7Desc => '子女、孙辈';

  @override
  String get divD8Name => '阿什塔姆萨盘（D8）';

  @override
  String get divD8Desc => '突发麻烦、诉讼';

  @override
  String get divD9Name => '纳瓦姆萨盘（D9）';

  @override
  String get divD9Desc => '婚姻、配偶、达摩';

  @override
  String get divD10Name => '达萨姆萨盘（D10）';

  @override
  String get divD10Desc => '事业、职业';

  @override
  String get divD11Name => '鲁德拉姆萨盘（D11）';

  @override
  String get divD11Desc => '死亡、毁灭';

  @override
  String get divD12Name => '德瓦达萨姆萨盘（D12）';

  @override
  String get divD12Desc => '父母、血亲';

  @override
  String get divD16Name => '十六分盘（D16）';

  @override
  String get divD16Desc => '车辆、舒适、享乐';

  @override
  String get divD20Name => '温沙姆萨盘（D20）';

  @override
  String get divD20Desc => '灵性事务、宗教';

  @override
  String get divD24Name => '二十四分盘（D24）';

  @override
  String get divD24Desc => '学习、知识、教育';

  @override
  String get divD27Name => '星宿盘（D27）';

  @override
  String get divD27Desc => '优势、弱点、本性';

  @override
  String get divD30Name => '特灵沙姆萨盘（D30）';

  @override
  String get divD30Desc => '灾厄、潜意识、惩罚';

  @override
  String get divD40Name => '卡维达姆萨盘（D40）';

  @override
  String get divD40Desc => '吉凶祸福（母系）';

  @override
  String get divD45Name => '阿克沙维达姆萨盘（D45）';

  @override
  String get divD45Desc => '一切事项（父系）';

  @override
  String get divD60Name => '沙什提安萨盘（D60）';

  @override
  String get divD60Desc => '前世业力——最为重要';

  @override
  String get lifeAreaCareer => '事业';

  @override
  String get lifeAreaWealth => '财富';

  @override
  String get lifeAreaMarriage => '婚姻';

  @override
  String get lifeAreaHealth => '健康';

  @override
  String get lifeAreaSpirituality => '灵性';

  @override
  String lifeAreaGrade(Object grade) {
    return '等级：$grade';
  }

  @override
  String get lifeAreaFactorsLabel => '因素：';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return '星宿：$nakshatra（第$pada分度）';
  }

  @override
  String planetNakLord(Object lord) {
    return '星宿主：$lord';
  }

  @override
  String planetLongitude(Object value) {
    return '经度：$value°';
  }

  @override
  String get chakraOverallHealth => '整体健康';

  @override
  String get careerWord => '事业';

  @override
  String get failedToLoad => '加载失败';

  @override
  String get kundliAscendantLagna => '上升星座（Lagna）';

  @override
  String get kundliMoonSignRashi => '月亮星座（Rashi）';

  @override
  String get kundliSunSign => '太阳星座';

  @override
  String kundliEngineLabel(Object engine) {
    return '引擎：$engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return '度数：$degree° • 星宿：$nakshatra（第$pada分度）';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return '星宿主星：$lord • 力量状态：$dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base盘 — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base盘';
  }

  @override
  String get careerSummary => '事业概览';

  @override
  String get phase => '阶段';

  @override
  String get confidenceLabel => '可信度';

  @override
  String get careerScores => '事业评分';

  @override
  String get stabilityLabel => '稳定性';

  @override
  String get growthLabel => '成长性';

  @override
  String get gradeExcellent => '优秀';

  @override
  String get gradeGood => '良好';

  @override
  String get gradeAverage => '一般';

  @override
  String get gradeBelowAvg => '低于平均';

  @override
  String get gradeWeak => '较弱';

  @override
  String get careerTypeDomain => '事业与领域';

  @override
  String get careerTimeline => '事业时间线';

  @override
  String dashaLabel(Object dasha) {
    return '大运：$dasha';
  }

  @override
  String get improvementSuggestions => '改进建议';

  @override
  String get chartDetails => '星盘详情';

  @override
  String get keyHousesCareer => '关键宫位（事业）';

  @override
  String get keyCareerPlanets => '关键事业行星';

  @override
  String get empty => '空';

  @override
  String get guna => '古纳';

  @override
  String get dasha => '大运';

  @override
  String get satwik => '悦性（Satwik）';

  @override
  String get rajasik => '动性（Rajasik）';

  @override
  String get tamasik => '惰性（Tamasik）';

  @override
  String get charGroupCorePersonality => '核心性格';

  @override
  String get charGroupTrustHonesty => '信任与诚实';

  @override
  String get charGroupLoyaltyCommitment => '忠诚与承诺';

  @override
  String get charGroupStrategicPrivacy => '策略与隐私';

  @override
  String get charGroupFinancial => '财务';

  @override
  String get charGroupAngerConflict => '愤怒与冲突';

  @override
  String get charGroupMoralDharmic => '道德与达摩';

  @override
  String get charGroupIntellectCommunication => '智力与沟通';

  @override
  String get charGroupEmotionalProfile => '情感档案';

  @override
  String get charGroupMentalHealth => '心理健康';

  @override
  String get charGroupRomantic => '浪漫倾向';

  @override
  String get charGroupMarriageFamily => '婚姻与家庭';

  @override
  String get charGroupOverallLife => '整体人生';

  @override
  String get grahaDrishti => '行星相位（Graha Drishti）';

  @override
  String get grahaDrishtiSubtitle => '谁相位谁（%）';

  @override
  String get lagnaAspectsReceived => '上升星座接收的相位';

  @override
  String get rashiDrishti => '星座相位（Rashi Drishti）';

  @override
  String get shadbalaRupas => '鲁帕（Rupa）';

  @override
  String get bhavaHouse1 => '自我/身体';

  @override
  String get bhavaHouse2 => '财富/家庭';

  @override
  String get bhavaHouse3 => '兄弟姐妹/勇气';

  @override
  String get bhavaHouse4 => '家庭/母亲';

  @override
  String get bhavaHouse5 => '子女/智力';

  @override
  String get bhavaHouse6 => '仇敌/健康';

  @override
  String get bhavaHouse7 => '婚姻/伴侣';

  @override
  String get bhavaHouse8 => '寿元';

  @override
  String get bhavaHouse9 => '福运/导师';

  @override
  String get bhavaHouse10 => '事业/父亲';

  @override
  String get bhavaHouse11 => '收益/朋友';

  @override
  String get bhavaHouse12 => '损失/解脱';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • 主星：$lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV：$value';
  }

  @override
  String get sarvaAshtakavarga => '总阿什塔卡瓦尔加（SAV）';

  @override
  String savSubtitle(Object total, Object avg) {
    return '总计：$total点（星座平均值=$avg）';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return '总计：$total点 • 本命星座：$score';
  }

  @override
  String get today => '今天';

  @override
  String gocharTransitScores(Object date) {
    return '行运（Gochar，行运评分）— $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return '本命月亮：$sign';
  }

  @override
  String get gocharBest => '最佳';

  @override
  String get gocharWorst => '最差';

  @override
  String copiedOpening(Object ai) {
    return '已复制！正在打开$ai…';
  }

  @override
  String get openLink => '打开 ↗';

  @override
  String get discussReportWithAI => '与AI讨论此报告';

  @override
  String get reliabilityHigh => '高可靠性';

  @override
  String get reliabilityModerate => '中等可靠性';

  @override
  String get reliabilityLow => '较低——仅供参考';

  @override
  String get reliabilityGoodEdu => '良好可靠性 · 已通过D24验证';

  @override
  String get relationshipWord => '关系';

  @override
  String get intelligenceWord => '洞察';

  @override
  String get relationshipIntelligence => '关系洞察';

  @override
  String get typeLabel => '类型';

  @override
  String get trustLabel => '信任';

  @override
  String get dhokaRisk => '背叛风险';

  @override
  String get powerLabel => '权力';

  @override
  String get integrity => '正直度';

  @override
  String get warmth => '热情度';

  @override
  String get trustWord => '信任';

  @override
  String get assertLabel => '果断度';

  @override
  String get character => '性格';

  @override
  String get love => '爱情';

  @override
  String get businessWord => '商业';

  @override
  String get karmic => '业力';

  @override
  String get enmityRisk => '敌意风险';

  @override
  String get hdrChartProfiles => '星盘概况';

  @override
  String get hdrPairwiseAnalysis => '两两分析';

  @override
  String get hdrCriticalPatterns => '关键模式';

  @override
  String get hdrGroupRecommendations => '群体建议';

  @override
  String get sharedPractices => '共同实践';

  @override
  String get hdrIndividualGuidance => '个人指导';

  @override
  String get growthAreas => '成长领域';

  @override
  String get hdrCoreTheme => '核心主题';

  @override
  String get growthOriented => '成长导向';

  @override
  String get groupTheme => '群体主题';

  @override
  String get compatibility => '合盘度';

  @override
  String get unifiedScoreLabel => '综合评分';

  @override
  String get ashtakoot => '阿什塔库特';

  @override
  String get probability => '概率';

  @override
  String get hdrAshtakootSummary => '阿什塔库特概览';

  @override
  String get hdrGunBreakdown => '八项古纳明细';

  @override
  String get hdrMangalDosh => '火星缺陷（Mangal Dosh）';

  @override
  String get hdrD9CrossChart => 'D9交叉分析';

  @override
  String get d9Compatibility => 'D9合盘度';

  @override
  String get hdrDomainCompatibility => '各领域合盘度';

  @override
  String get emotional => '情感';

  @override
  String get intellectual => '智识';

  @override
  String get spiritual => '灵性';

  @override
  String get financial => '财务';

  @override
  String get domestic => '家庭生活';

  @override
  String get communicationWord => '沟通';

  @override
  String get sharedDharma => '共同达摩';

  @override
  String get familyCreation => '组建家庭';

  @override
  String get hdrMarriageTiming => '婚姻时机';

  @override
  String get jointMarriageWindows => '共同婚姻时段';

  @override
  String get engagementWindows => '订婚时段';

  @override
  String get recommendedLabel => '推荐';

  @override
  String get hdrKeyRisks => '关键风险';

  @override
  String get hdrFinalVerdict => '最终结论';

  @override
  String get marriageVerdict => '婚姻结论';

  @override
  String get educationWord => '教育';

  @override
  String get learningSuffix => '与学习';

  @override
  String get coreEducationScores => '核心教育评分';

  @override
  String get academicSuccess => '学业成就';

  @override
  String get learningCapacity => '学习能力';

  @override
  String get memory => '记忆力';

  @override
  String get intelligence => '智力';

  @override
  String get research => '研究能力';

  @override
  String get hdrIntellectualProfile => '智识档案';

  @override
  String get learningSignature => '学习印记';

  @override
  String get hdrSubjectKaraka => '学科徵星';

  @override
  String get hdrHouseFoundations => '宫位基础';

  @override
  String get hdrMercuryJupiter => '水星与木星';

  @override
  String get hdrEducationYogas => '教育瑜伽';

  @override
  String get hdrDivisionalValidation => '分盘验证';

  @override
  String get standing => '地位';

  @override
  String get hdrSubjectRanking => '学科排名';

  @override
  String get hdrDegreeLikelihood => '学位可能性';

  @override
  String get hdrStudyPeriods => '学习时期';

  @override
  String get earlySchooling => '早期教育';

  @override
  String get higherEducation => '高等教育';

  @override
  String get postgradResearch => '研究生·科研';

  @override
  String get hdrLearningPreferences => '学习偏好';

  @override
  String get hdrChallengesGifts => '挑战与天赋';

  @override
  String get challenges => '挑战';

  @override
  String get cognitiveGifts => '认知天赋';

  @override
  String get naturalAbilities => '天生能力';

  @override
  String get hdrSaraswatiRemedies => '妙音天女补救法';

  @override
  String get studentVerdict => '学业结论';

  @override
  String get educationCareerLinkage => '教育→职业关联';

  @override
  String get startupSuffix => '与创业';

  @override
  String get coreBusinessScores => '核心商业评分';

  @override
  String get overallBusiness => '整体商业';

  @override
  String get ventureSuccess => '创业成功率';

  @override
  String get eleventhHouse => '第十一宫';

  @override
  String get gains => '收益';

  @override
  String get investor => '投资者';

  @override
  String get hdrFounderArchetype => '创始人原型';

  @override
  String get hdrTenthEleventhHouses => '第十宫与第十一宫';

  @override
  String get hdrBusinessYogas => '商业瑜伽';

  @override
  String get hdrRecommendedDomains => '推荐领域';

  @override
  String get hdrBusinessStyle => '经商风格';

  @override
  String get hdrFounderSkills => '创始人技能';

  @override
  String get hdrFundingProfile => '融资档案';

  @override
  String get recommendedPath => '推荐路径';

  @override
  String get investorAttract => '投资者吸引力';

  @override
  String get familyBacking => '家庭支持';

  @override
  String get hybridViability => '混合模式可行性';

  @override
  String get launchWindow => '启动时段';

  @override
  String get scaleWindow => '扩张时段';

  @override
  String get hdrBusinessRisks => '商业风险';

  @override
  String get recoveryCapacity => '恢复能力';

  @override
  String get hdrRemediesSolutions => '补救方法与解决方案';

  @override
  String get aiConnectionLost => '连接已断开，请重试。';

  @override
  String get aiSomethingWrong => '出现了一些问题';

  @override
  String get aiNoResponse => '无响应';

  @override
  String get aiConnectionError => '连接错误，请重试。';

  @override
  String get aiAutoDetect => '自动检测';

  @override
  String aiAutoArrow(String lang) {
    return '自动 → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return '语言：$lang';
  }

  @override
  String get aiNoBirthCharts => '未找到本命盘';

  @override
  String get aiCreateChartFirst => '请先创建本命盘以便与AI对话';

  @override
  String get aiSelectChartBegin => '选择一份本命盘以开始分析';

  @override
  String aiAnalyzingName(String name) {
    return '正在分析：$name';
  }

  @override
  String get aiChange => '更换';

  @override
  String get aiAnalyzingChart => '正在分析您的星盘…';

  @override
  String get aiAskStarsHint => '向星辰询问任何问题…';

  @override
  String get aiSuggestedFollowups => '推荐追问';

  @override
  String get aiThinking => '思考中…';

  @override
  String get aiThanks => '谢谢！';

  @override
  String get aiFeedbackNoted => '已记录反馈';

  @override
  String get svcAll => '全部';

  @override
  String get svcNoServices => '暂无可用服务';

  @override
  String get svcFree => '免费';

  @override
  String get astroFailedStartCall => '无法发起通话';

  @override
  String get astroFailedStartChat => '无法发起聊天';

  @override
  String astroErrorDetail(String error) {
    return '错误：$error';
  }

  @override
  String get astroExperience => '经验';

  @override
  String get astroSessions => '咨询次数';

  @override
  String get astroMinutes => '分钟数';

  @override
  String get astroAbout => '关于';

  @override
  String get astroLanguages => '语言';

  @override
  String get astroRateCard => '价目表';

  @override
  String get astroVoice => '语音';

  @override
  String astroReviews(int count) {
    return '评价（$count条）';
  }

  @override
  String get astroNoReviews => '暂无评价';

  @override
  String get astroAnonymous => '匿名用户';

  @override
  String get forgotPasswordSubtitle => '请输入您的邮箱，我们将发送\n密码重置链接给您。';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => '重新发送链接';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => '您的宇宙之旅即将开始';

  @override
  String get home => '首页';

  @override
  String get astrologers => '占星师';

  @override
  String get services => '服务';

  @override
  String get wallet => '钱包';

  @override
  String get profile => '我的';

  @override
  String get live => '直播';

  @override
  String get kundli => '星盘';

  @override
  String get chat => '聊天';

  @override
  String get call => '通话';

  @override
  String get video => '视频';

  @override
  String get signIn => '登录';

  @override
  String get createAccount => '创建账户';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get fullName => '全名';

  @override
  String get phone => '电话';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get backToSignIn => '返回登录';

  @override
  String get dontHaveAccount => '还没有账户？';

  @override
  String get alreadyHaveAccount => '已经有账户了？';

  @override
  String get continueGoogle => '使用Google继续';

  @override
  String get required => '必填项';

  @override
  String get minSixChars => '最少6个字符';

  @override
  String get passwordsMismatch => '两次输入的密码不一致';

  @override
  String get validEmailRequired => '请输入有效的邮箱地址';

  @override
  String get loginFailed => '登录失败';

  @override
  String get signupFailed => '注册失败';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get todaysHoroscope => '今日运势';

  @override
  String get todaysRashi => '今日星座';

  @override
  String get tapDetails => '点击查看详情';

  @override
  String get allServices => '所有服务';

  @override
  String get seeAll => '查看全部';

  @override
  String get topAstrologers => '顶级占星师';

  @override
  String get onlineExperts => '在线专家随时为您咨询';

  @override
  String get searchAstrologers => '搜索占星师…';

  @override
  String get noAstrologersFound => '未找到占星师';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get busy => '忙碌中';

  @override
  String get perMin => '/分钟';

  @override
  String get noCharts => '暂无本命盘';

  @override
  String get createFirst => '创建您的第一份出生星盘';

  @override
  String get createChart => '创建星盘';

  @override
  String get newBirthChart => '新建本命盘';

  @override
  String get clientName => '客户姓名';

  @override
  String get gender => '性别';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get other => '其他';

  @override
  String get dateOfBirth => '出生日期';

  @override
  String get timeOfBirth => '出生时间';

  @override
  String get birthPlace => '出生地点';

  @override
  String get birthPlaceHint => '输入城市名称进行搜索…';

  @override
  String get generateKundli => '生成星盘';

  @override
  String get birthChartCreated => '本命盘创建成功！';

  @override
  String get deleteChart => '删除星盘？';

  @override
  String get cannotUndo => '此操作无法撤销。';

  @override
  String get primary => '主要';

  @override
  String get viewKundli => '查看星盘';

  @override
  String get completeBirthChart => '完整本命盘';

  @override
  String get birthDetails => '出生信息';

  @override
  String get name => '姓名';

  @override
  String get dob => '出生日期';

  @override
  String get tob => '出生时间';

  @override
  String get place => '地点';

  @override
  String get summary => '概览';

  @override
  String get planets => '行星';

  @override
  String get divisions => '分盘';

  @override
  String get vimshottari => '维姆修塔里（Vimshottari）';

  @override
  String get moola => '命主大运（Moola）';

  @override
  String get gochar => '行运（Gochar）';

  @override
  String get dosh => '缺陷';

  @override
  String get yoga => '瑜伽';

  @override
  String get shadbala => '沙德巴拉（Shadbala）';

  @override
  String get ashtakavarga => '阿什塔卡瓦尔加（Ashtakavarga）';

  @override
  String get aspects => '相位';

  @override
  String get lifeAreas => '人生领域';

  @override
  String get bhava => '宫位（Bhava）';

  @override
  String get chakras => '脉轮';

  @override
  String get dashaActive => '当前大运';

  @override
  String get lagna => '上升星座';

  @override
  String get moon => '月亮';

  @override
  String get sun => '太阳';

  @override
  String get premiumSection => '高级内容';

  @override
  String get unlockReading => '解锁此解读以查看详细分析。';

  @override
  String get unlock => '解锁';

  @override
  String get retrograde => '逆行';

  @override
  String get combust => '焦伤';

  @override
  String get vargottama => '同宫互映（Vargottama）';

  @override
  String get exalted => '旺相';

  @override
  String get debilitated => '弱相';

  @override
  String get addBalance => '充值';

  @override
  String get amount => '金额';

  @override
  String get walletBalance => '钱包余额';

  @override
  String get recharge => '充值';

  @override
  String get bonus => '赠送金额';

  @override
  String get serviceLabel => '服务';

  @override
  String get refund => '退款';

  @override
  String get noTransactions => '暂无交易记录';

  @override
  String get editProfile => '编辑资料';

  @override
  String get savedAstrologers => '收藏的占星师';

  @override
  String get noSavedAstrologers => '暂无收藏的占星师';

  @override
  String get myOrders => '我的订单';

  @override
  String get communicationHistory => '沟通记录';

  @override
  String get chatHistory => '聊天记录';

  @override
  String get callHistory => '通话记录';

  @override
  String get logout => '退出登录';

  @override
  String get chatMessages => '聊天消息';

  @override
  String get typeMessage => '输入消息…';

  @override
  String get sessionEnded => '会话已结束';

  @override
  String get endChat => '结束聊天？';

  @override
  String get endChatConfirm => '您确定要结束此次聊天会话吗？';

  @override
  String get sendPhoto => '发送照片';

  @override
  String get sendPDF => '发送PDF';

  @override
  String get upload => '上传';

  @override
  String get fileNotFound => '未找到文件';

  @override
  String get voiceCall => '语音通话';

  @override
  String get videoCall => '视频通话';

  @override
  String get ringing => '响铃中…';

  @override
  String get connected => '已连接';

  @override
  String get endCall => '结束通话';

  @override
  String get mute => '静音';

  @override
  String get unmute => '取消静音';

  @override
  String get speaker => '扬声器';

  @override
  String get camera => '摄像头';

  @override
  String get flip => '切换镜头';

  @override
  String get liveStreams => '直播';

  @override
  String get noLiveStreams => '当前没有直播';

  @override
  String get astrologerUnavailable => '占星师不可用，直播即将结束。';

  @override
  String get streamEnded => '直播已结束';

  @override
  String get superChat => '超级留言';

  @override
  String get sendGift => '赠送礼物';

  @override
  String get goBack => '返回';

  @override
  String get appPermissions => '应用权限';

  @override
  String get grantPermissions => '授予权限';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get microphone => '麦克风';

  @override
  String get notifications => '通知';

  @override
  String get storage => '存储空间';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get retry => '重试';

  @override
  String get send => '发送';

  @override
  String get refresh => '刷新';

  @override
  String get loading => '加载中…';

  @override
  String get noData => '暂无数据';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get myDetails => '我的信息';

  @override
  String get myKundlis => '我的星盘';

  @override
  String get walletRecharge => '钱包与充值';

  @override
  String get consultationHistory => '咨询记录';

  @override
  String get helpSupport => '帮助与支持';

  @override
  String get biometricLogin => '生物识别登录';

  @override
  String get pastVoiceConsultations => '历史语音咨询';

  @override
  String get pastTextConversations => '历史文字对话';

  @override
  String get comingSoon => '敬请期待';

  @override
  String get totalCredit => '总收入';

  @override
  String get totalDebit => '总支出';

  @override
  String get statement => '对账单';

  @override
  String get allTypes => '所有类型';

  @override
  String get prev => '上一页';

  @override
  String get next => '下一页';

  @override
  String get allInsights => '全部洞察';

  @override
  String get yourCompleteReading => '您的完整解读';

  @override
  String get expertEngines => '专业引擎';

  @override
  String get eachInsightConsultation => '每一项洞察都是一次完整的咨询';

  @override
  String get engines => '引擎';

  @override
  String get dataPoints => '数据点';

  @override
  String get singleChart => '单人';

  @override
  String get careerPurpose => '事业与使命';

  @override
  String get wealthAssets => '财富与资产';

  @override
  String get loveRelationships => '爱情与人际关系';

  @override
  String get healthWellness => '健康与身心';

  @override
  String get soulKarma => '灵魂与业力';

  @override
  String get specialistReports => '专项报告';

  @override
  String get searchByNameSpeciality => '按姓名、专长搜索…';

  @override
  String get sortedByRating => '按评分排序';

  @override
  String get initiatingChat => '正在发起聊天…';

  @override
  String get startingCall => '正在发起通话…';

  @override
  String get yrs => '年';

  @override
  String get chatWithAISpecialist => '与AI专家聊天';

  @override
  String get tapToStart => '点击开始';

  @override
  String get astrologer => '占星师';

  @override
  String get reports => '报告';

  @override
  String get milan => '合婚';

  @override
  String get forecast => '运势预测';

  @override
  String get rashi => '星座';

  @override
  String get jupiterFavorsBold => '木星有利于大胆行动';

  @override
  String get careerIlluminated => '您的事业宫得到照耀——请相信自己的直觉。';

  @override
  String get todaysForecast => '今日运势预测';

  @override
  String get engCareer => '事业与工作';

  @override
  String get engBusiness => '商业与创业';

  @override
  String get engEducation => '教育与学习';

  @override
  String get engLifePath => '人生路径与运势';

  @override
  String get engWealth => '财富与财务';

  @override
  String get engDebt => '债务与财务恢复';

  @override
  String get engProperty => '财产与资产';

  @override
  String get engLegal => '法律与纠纷';

  @override
  String get engLove => '爱情与恋爱';

  @override
  String get engMarriage => '婚姻与家庭';

  @override
  String get engKundliMilan => '星盘合婚';

  @override
  String get engRelationship => '关系洞察';

  @override
  String get engLoveCompat => '爱情合盘';

  @override
  String get engChildProb => '子女概率';

  @override
  String get engHealth => '健康与身心';

  @override
  String get engMental => '心理与压力';

  @override
  String get engCharacter => '性格分析';

  @override
  String get engPastLife => '前世与业力';

  @override
  String get engKarmaLink => '业力关联';

  @override
  String get noChatSessions => '暂无聊天记录';

  @override
  String get chatAppearHere => '您与占星师的对话将显示在这里。';

  @override
  String get noCallsYet => '暂无通话记录';

  @override
  String get callAppearHere => '您与占星师的通话记录将显示在这里。';

  @override
  String get chatWith => '与...聊天';

  @override
  String get msgs => '条消息';

  @override
  String get voiceCallLabel => '语音通话';

  @override
  String get videoCallLabel => '视频通话';

  @override
  String get pullToRefresh => '下拉刷新';

  @override
  String get sessionExpired => '会话已过期';

  @override
  String get connectionFailed => '连接失败';

  @override
  String get callActive => '通话进行中';

  @override
  String get lessThanOneMin => '剩余不到1分钟';

  @override
  String get noMessages => '此会话中没有消息';

  @override
  String get gocharForAllSigns => '今日全部12个星座的行运';

  @override
  String get selectChart => '选择要分析的星盘';

  @override
  String get selectTwoCharts => '选择两个星盘';

  @override
  String get analyzing => '分析中…';

  @override
  String get browseAstrologers => '浏览占星师';

  @override
  String get probableNumber => '可能数量';

  @override
  String get genderTendency => '性别倾向';

  @override
  String get son => '儿子';

  @override
  String get daughter => '女儿';

  @override
  String get occupants => '宫内行星';

  @override
  String get beneficAspects => '吉星相位';

  @override
  String get maleficAspects => '凶星相位';

  @override
  String get nextFavorableWindow => '下一个有利时段';

  @override
  String get totalDoshaPenalty => '总缺陷扣分';

  @override
  String get cancellationFactors => '抵消因素';

  @override
  String get combinedFertility => '综合生育力指标';

  @override
  String get planetPositions => '行星位置';

  @override
  String get bestWindows => '最佳时段';

  @override
  String get worstWindows => '最差时段';

  @override
  String get scoreComponents => '评分构成';

  @override
  String get topOpportunities => '主要机遇';

  @override
  String get topRisks => '主要风险';

  @override
  String get remedies => '补救方法';

  @override
  String get keyInsights => '核心洞察';

  @override
  String get overallVerdict => '总体结论';

  @override
  String get venusContacts => '金星交叉相位';

  @override
  String get contact => '相位';

  @override
  String get effect => '影响';

  @override
  String get moonSignCompat => '月亮星座合盘度';

  @override
  String get hisMoon => '男方月亮';

  @override
  String get herMoon => '女方月亮';

  @override
  String get nakshatraCompat => '星宿合盘度';

  @override
  String get ketuContacts => '计都相位';

  @override
  String get rahuContacts => '罗睺相位';

  @override
  String get pastLifeIndication => '前世指标';

  @override
  String get totalChallengePenalty => '总挑战扣分';

  @override
  String get manifestation => '显现方式';

  @override
  String get cancellation => '抵消';

  @override
  String get navigation => '应对方法';

  @override
  String get potentialStrengths => '潜在优势';

  @override
  String get areasToNurture => '需要培育的领域';

  @override
  String get relationshipGuidance => '关系指引';

  @override
  String get detailedSummary => '详细概览';

  @override
  String get discussWithAI => '与AI讨论';

  @override
  String get planet => '行星';

  @override
  String get sign => '星座';

  @override
  String get house => '宫位';

  @override
  String get strength => '力量';

  @override
  String get copy => '复制';

  @override
  String get confidence => '可信度';

  @override
  String get d7Saptamsa => 'D7萨普塔姆萨';

  @override
  String get numberExplanation => '数量说明';

  @override
  String get genderExplanation => '性别说明';

  @override
  String get inFifth => '是否位于第五宫？';

  @override
  String get primaryArchetype => '主要原型';

  @override
  String get mitigation => '缓解方法';

  @override
  String get soulCareerAlign => '灵魂与事业契合度';

  @override
  String get favorablePeriods => '有利时期';

  @override
  String get challengingPeriods => '挑战时期';

  @override
  String get keyHouses => '关键宫位';

  @override
  String get keyPlanets => '关键行星';

  @override
  String get characterOverview => '性格概览';

  @override
  String get noYogasActive => '此星盘中当前没有已激活的瑜伽。';

  @override
  String get basedOnPlanetStrengths => '基于行星力量与宫位落位';

  @override
  String get basedOnTransits => '基于当前行星行运';

  @override
  String get currentPlanetPositions => '以您的星座为第一宫的当前行星位置';

  @override
  String get favorablePeriodAdvice => '有利时期——专注于事业发展与人际关系。';

  @override
  String get noClassicalYogas => '虽无经典学习瑜伽，成功仍可通过持续努力获得。';

  @override
  String get walletDeduction => '此金额将从您的钱包中扣除';

  @override
  String get bhakootAxis => '巴库特轴（Bhakoot Axis）';

  @override
  String get basis => '依据';

  @override
  String get selectChartsForMilan => '选择2个星盘进行合婚分析';

  @override
  String get selectMultiCharts => '选择2至5个星盘';

  @override
  String get running => '进行中';

  @override
  String get past => '过去';

  @override
  String get topActiveDoshas => '主要已激活缺陷';

  @override
  String get allDoshas => '全部缺陷';

  @override
  String get activeYogas => '已激活瑜伽';

  @override
  String get activeDoshas => '已激活缺陷';

  @override
  String get yogaAnalysis => '瑜伽分析';

  @override
  String get factors => '因素';

  @override
  String get dominantPlanet => '主导行星';

  @override
  String get startSession => '开始会话';

  @override
  String get notesSaved => '笔记已保存';

  @override
  String get unlocked => '已解锁！尽情享受您的解读吧。';

  @override
  String get todaysGochar => '今日行运';

  @override
  String get todaysTransitChart => '今日行运星盘';

  @override
  String get lifeAreaPredictions => '人生领域预测';

  @override
  String get strengths => '优势';

  @override
  String get weaknesses => '弱点';

  @override
  String get ruledBy => '主管行星';

  @override
  String get kundliMilan => '星盘合婚';

  @override
  String get startKundliMilan => '开始星盘合婚';

  @override
  String get recommendations => '建议';

  @override
  String get cancellations => '抵消';

  @override
  String get dashaSync => '大运同步度';

  @override
  String get transitMarriageWindows => '行运婚姻时段';

  @override
  String get overlappingWindows => '重叠婚姻时段';

  @override
  String get overallStrength => '整体力量';

  @override
  String get stability => '稳定性';

  @override
  String get growth => '成长性';

  @override
  String get clarity => '清晰度';

  @override
  String get recognition => '认可度';

  @override
  String get satisfaction => '满意度';

  @override
  String get verdict => '结论';

  @override
  String get topRoles => '最佳角色';

  @override
  String get areasForGrowth => '成长领域';

  @override
  String get bestIndustries => '最佳行业';

  @override
  String get employment => '受雇工作';

  @override
  String get entrepreneurship => '创业';

  @override
  String get freelance => '自由职业';

  @override
  String get portfolio => '混合组合';

  @override
  String get burnoutRisk => '职业倦怠风险';

  @override
  String get careerStagnation => '事业停滞';

  @override
  String get workplaceConflict => '职场冲突';

  @override
  String get positioning => '定位';

  @override
  String get skillDevelopment => '技能发展';

  @override
  String get network => '人脉';

  @override
  String get visibility => '曝光度';

  @override
  String get lagnaLord => '上升主星';

  @override
  String get tenthLord => '第十宫主星';

  @override
  String get lord => '主星';

  @override
  String get lordPlacedIn => '主星落于';

  @override
  String get lordDignity => '主星力量状态';

  @override
  String get d9Dignity => 'D9力量状态';

  @override
  String get careerAnalysis => '事业分析';

  @override
  String get launchWindows => '启动时段';

  @override
  String get peakWindows => '巅峰时段';

  @override
  String get promotionWindows => '晋升时段';

  @override
  String get riskWindows => '风险时段';

  @override
  String get timingWindows => '时机窗口';

  @override
  String get careerRisks => '事业风险';

  @override
  String get astrologicalRemedies => '占星补救法';

  @override
  String get practicalSolutions => '实用解决方案';

  @override
  String get analysisConfidence => '分析可信度';

  @override
  String get careerArchetype => '事业原型';

  @override
  String get workStructure => '工作结构';

  @override
  String get teamLeadership => '团队领导力';

  @override
  String get idealEnvironment => '理想环境';

  @override
  String get idealOrgSize => '理想组织规模';

  @override
  String get fitScore => '契合度评分';

  @override
  String get recommended => '推荐';

  @override
  String get divisionalValidation => '分盘验证';

  @override
  String get houseAnalysis => '宫位分析';

  @override
  String get jaiminiKarakas => '遮米尼徵星（Jaimini Karakas）';

  @override
  String get copyFullReport => '复制完整报告数据';

  @override
  String get reportCopied => '报告数据已复制！';

  @override
  String get biometricNotAvailable => '此设备不支持生物识别';

  @override
  String biometricErrorMsg(Object error) {
    return '生物识别错误：$error';
  }

  @override
  String get biometricVerifyReason => '验证以启用生物识别登录';

  @override
  String get dobFormatLabel => '出生日期 (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => '出生时间 (HH:MM)';

  @override
  String get phoneLabel => '电话';

  @override
  String get activeBadge => '激活中';

  @override
  String get chartCategoryLabel => '类别';

  @override
  String get freePrimaryDescription => '免费主档案 — 用于每日星座运势和免费单图服务';

  @override
  String get searchChartsHint => '按姓名或出生日期搜索...';

  @override
  String unlockPriceLabel(Object price) {
    return '以$price解锁';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return '以$price（一次性）解锁此AI专家，通过应用商店安全购买。';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return '以$price（一次性）解锁此AI专家。金额将从您的钱包中扣除。';
  }

  @override
  String get specialistNotAvailablePurchase => '该专家暂不支持购买。';

  @override
  String get couldNotCompletePurchase => '无法完成购买。请重试。';

  @override
  String get couldNotUnlockWalletBalance => '无法解锁（请检查钱包余额）';

  @override
  String get freeBadge => '免费';

  @override
  String activeSessionInProgress(Object kind) {
    return '您有一个正在进行的$kind';
  }

  @override
  String get returnLabel => '返回';

  @override
  String get enableNotificationsForAlerts => '启用通知以获取咨询和优惠提醒';

  @override
  String get enableLabel => '启用';

  @override
  String get notificationsEnabled => '通知已启用';

  @override
  String get couldNotEnableNotifications => '无法启用 — 请在浏览器中允许通知';

  @override
  String get amountInrLabel => '金额 (₹)';

  @override
  String get noteOptionalLabel => '备注（可选）';

  @override
  String get txnDate => '日期';

  @override
  String get txnDescription => '描述';

  @override
  String get txnType => '类型';

  @override
  String get txnAmount => '金额';

  @override
  String get txnBalance => '余额';

  @override
  String get credit => '入账';

  @override
  String get debit => '出账';

  @override
  String get razorpayStripeNote => '💳 在生产环境中，这将跳转到 Razorpay/Stripe。';

  @override
  String get downloadPdf => '下载PDF';

  @override
  String get chatWithAiCta => '与AI聊天';

  @override
  String get pdfServiceUnavailable => 'PDF服务暂时不可用，请稍后再试。';

  @override
  String get pleaseUnlockFirst => '请先解锁此内容。';

  @override
  String get couldNotGeneratePdf => '无法生成PDF。请重试。';

  @override
  String get statConsults => '咨询次数';

  @override
  String get statCharts => '星盘数';

  @override
  String get statWallet => '钱包';

  @override
  String get firstChartPrimaryInfo => '您的第一张星盘是免费主档案。额外的星盘将单独解锁服务。';

  @override
  String get tryDifferentFilter => '尝试其他筛选条件';

  @override
  String get defaultChartName => '星盘';

  @override
  String get balAbbr => '余额';

  @override
  String get aiTimePassTitle => '选择聊天时长';

  @override
  String get aiTimePassHint => '从钱包支付。时间立即开始计算，再次购买会累加到剩余时间。';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes 分钟';
  }

  @override
  String aiTimePassPay(Object price) {
    return '支付 $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return '剩余 $minutes 分钟';
  }

  @override
  String get liveNow => '正在直播';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get awChooseLanguage => '选择您的语言';

  @override
  String get awGoogleFailed => 'Google 登录失败。请重试。';

  @override
  String get awCompleteProfileTitle => '完善您的个人资料';

  @override
  String awWelcomeName(String name) {
    return '欢迎，$name！';
  }

  @override
  String get awCompleteProfileSubtitle => '填写一些信息，为您个性化定制 Nakshatralogy。';

  @override
  String get awRegionLabel => '地区';

  @override
  String get awRegionIndia => '印度';

  @override
  String get awRegionInternational => '国际';

  @override
  String get awPreferredLanguage => '首选语言';

  @override
  String get awFinishSetup => '完成设置';

  @override
  String get awChatFileWebUnsupported => '网页端暂不支持文件分享。请使用移动应用。';

  @override
  String get awVideoUnsupported => '此浏览器不支持视频通话。请使用我们的移动应用或受支持的桌面浏览器。';

  @override
  String get awClose => '关闭';

  @override
  String get pwPremiumTitle => '高级报告';

  @override
  String get pwLockedSubtitle => '解锁此星盘的完整分析';

  @override
  String pwUnlockFull(Object name) {
    return '解锁完整$name';
  }

  @override
  String pwUnlockPrice(Object price) {
    return '解锁 · $price';
  }

  @override
  String get pwOneTime => '一次性解锁——此星盘永久归您所有';

  @override
  String get pwWhatYouGet => '您将获得';

  @override
  String get pwYourBalance => '您的钱包余额';

  @override
  String get pwInsufficient => '余额不足';

  @override
  String get pwRechargeToUnlock => '充值以解锁';

  @override
  String get pwRechargeAmount => '充值金额 (₹)';

  @override
  String get pwAddMoney => '充值';

  @override
  String get pwRechargeDone => '钱包已充值';

  @override
  String get pwRechargeFailed => '充值失败，请重试。';

  @override
  String get pwUnlockFailed => '无法解锁，请重试。';

  @override
  String get pwUnlockedNow => '已解锁！正在加载您的报告…';

  @override
  String get pwProcessing => '处理中…';

  @override
  String get pwPrimaryNoDelete => '您的主星盘无法删除——它将永久免费使用。';

  @override
  String get pwPrimaryNoEdit => '您的主星盘无法编辑。';

  @override
  String get pwLoadingAccess => '正在检查访问权限…';

  @override
  String get pwMaybeLater => '以后再说';

  @override
  String get updatePhoto => '更新照片';

  @override
  String get takePhoto => '相机';

  @override
  String get chooseFromGallery => '相册';

  @override
  String get removePhoto => '移除照片';

  @override
  String get photoUpdated => '照片已更新';

  @override
  String get photoUploadFailed => '照片上传失败，请重试。';

  @override
  String get tapToChangePhoto => '点击更换照片';

  @override
  String get klSubtitle => 'AI驱动的吠陀前世业力关联报告';

  @override
  String get klTitle => '前世业力关联';

  @override
  String get klSnapshotHeader => '业力关联概览';

  @override
  String get klGaugePairwise => '平均两两关联度';

  @override
  String get klGaugeCohesion => '群体凝聚力';

  @override
  String get klGaugeRahuKetu => '罗睺-计都共鸣';

  @override
  String get klGaugeAtmakaraka => '灵魂共鸣';

  @override
  String get klGaugeD60 => 'D60共鸣';

  @override
  String get klChipSoulResonance => '强烈的灵魂印记共鸣';

  @override
  String get klChipD60Resonance => '强烈的D60前世共鸣';

  @override
  String get klChipCohesiveGroup => '凝聚力强的群体';

  @override
  String get klChipNoDebts => '未检测到业力债务';

  @override
  String get klProfilesTitle => '星盘概况';

  @override
  String get klKetuAt => '计都位于';

  @override
  String get klRahuAt => '罗睺位于';

  @override
  String get klFoundationTitle => '各星盘业力基础';

  @override
  String get klFoundationSubtitle => '每个灵魂的前世精通领域与今生方向';

  @override
  String get klKetuMastery => '计都精通';

  @override
  String get klRahuGrowth => '罗睺成长';

  @override
  String get klNinthHousePunya => '第九宫福报';

  @override
  String get klD60Depth => 'D60业力深度';

  @override
  String get klAtmakarakaAgenda => '灵魂议程';

  @override
  String get klSaturnKarma => '土星业力';

  @override
  String get klPairwiseTitle => '两两业力关联';

  @override
  String get klActiveFactors => '活跃关联因素';

  @override
  String get klGroupPatternTitle => '群体业力模式';

  @override
  String get klSharedSetting => '共同的前世背景';

  @override
  String get klCohesionScore => '业力凝聚力';

  @override
  String get klPastGoalsTitle => '前世目标';

  @override
  String get klLearningTitle => '今生课题';

  @override
  String get klTeachingMap => '相互教导图谱';

  @override
  String get klDebtsTitle => '业力债务与化解';

  @override
  String get klNoDebtsDetected => '此群体中未检测到业力债务';

  @override
  String get klTimingTitle => '命主大运业力时机';

  @override
  String get klAuditTitle => '深度审查表';

  @override
  String klAuditSubtitle(Object count) {
    return '已检查$count项业力参数';
  }

  @override
  String get klTopicLinkage => '我们整体的业力关联';

  @override
  String get klTopicPairwise => '特定两人间的业力纽带';

  @override
  String get klTopicDebts => '需要化解的业力债务';

  @override
  String get klTopicLessons => '我们此生要学习的课题';

  @override
  String get klTopicTiming => '我们群体的最佳时机';

  @override
  String get klTopicGroup => '我们共同的前世故事';

  @override
  String get lcSubtitle => 'AI驱动的吠陀爱情合盘报告';

  @override
  String get lcTitle => '爱情合盘';

  @override
  String get lcSnapshotHeader => '爱情合盘概览';

  @override
  String get lcGaugeAttraction => '吸引力';

  @override
  String get lcGaugeEmotional => '情感和谐度';

  @override
  String get lcGaugeMental => '心灵默契';

  @override
  String get lcGaugePassion => '激情';

  @override
  String get lcGaugeLongterm => '长期和谐度';

  @override
  String get lcChipStrongMental => '强烈的心灵联系';

  @override
  String get lcChipStrongLongterm => '强大的长期潜力';

  @override
  String get lcChipStrongPassion => '强烈的身体吸引力';

  @override
  String get lcChipLowFriction => '整体摩擦较低';

  @override
  String get lcChipKarmicPull => '强烈的业力牵引';

  @override
  String get lcPartnersTitle => '伴侣概况';

  @override
  String get lcVenusSuffix => '金星星座';

  @override
  String get lcAttractionTitle => '吸引力与化学反应';

  @override
  String get lcAttractionScore => '吸引力评分';

  @override
  String get lcActiveContacts => '活跃的金星相位';

  @override
  String get lcEmotionalTitle => '情感和谐度';

  @override
  String get lcEmotionalScore => '情感和谐度评分';

  @override
  String get lcNakshatraCompat => '星宿合盘';

  @override
  String get lcYoniKoota => '尤尼库塔（Yoni Koota）';

  @override
  String get lcGanaKoota => '伽纳库塔（Gana Koota）';

  @override
  String get lcTaraKoota => '塔拉库塔（Tara Koota）';

  @override
  String get lcBhakootAxis => '巴库特轴（Bhakoot Axis）';

  @override
  String get lcMentalTitle => '心灵默契';

  @override
  String get lcMentalScore => '心灵默契评分';

  @override
  String get lcPassionTitle => '激情与身体吸引';

  @override
  String get lcPassionScore => '激情评分';

  @override
  String get lcLongtermTitle => '长期和谐度';

  @override
  String get lcLongtermScore => '长期和谐度评分';

  @override
  String get lcCommitmentPotential => '承诺潜力';

  @override
  String get lc7thHouseSynastry => '第七宫合盘分析';

  @override
  String get lcJupiterBlessing => '木星祝福';

  @override
  String get lcD9Resonance => 'D9那婆姆萨共鸣';

  @override
  String get lcSaturnLongevity => '土星长久度';

  @override
  String get lcKarmicTitle => '业力爱情纽带';

  @override
  String get lcKarmicScore => '业力纽带评分';

  @override
  String get lcKetuContacts => '计都相位';

  @override
  String get lcRahuContacts => '罗睺相位';

  @override
  String get lcChallengesTitle => '挑战与摩擦';

  @override
  String get lcNoChallenges => '两张星盘中均未检测到明显摩擦点';

  @override
  String get lcTotalPenalty => '总挑战扣分';

  @override
  String get lcTimingTitle => '爱情时机——命主大运';

  @override
  String get lcDynamicsTitle => '关系动态';

  @override
  String get lcPowerBalance => '权力平衡';

  @override
  String get lcGiverReceiver => '情感付出者/接受者';

  @override
  String get lcGrowthDynamic => '成长动态';

  @override
  String get lcAreasToNurture => '需要培育的领域';

  @override
  String get lcTopicTiming => '我们关系的最佳时机';

  @override
  String get lcTopicChallenges => '需要应对的挑战';

  @override
  String get lcTopicKarmic => '我们的业力联系';

  @override
  String get lcTopicRemedies => '推荐的补救方法';

  @override
  String get lcTopicLongterm => '我们的长期潜力';

  @override
  String get lcTopicDynamics => '我们的关系动态';

  @override
  String get cpSubtitle => 'AI驱动的吠陀子女概率报告';

  @override
  String get cpTitle => '子女概率';

  @override
  String get cpSnapshotHeader => '子嗣概率概览';

  @override
  String get cpGauge5thHouse => '第五宫';

  @override
  String get cpGaugeJupiter => '木星/子女徵星（Putrakaraka）';

  @override
  String get cpGaugeD7 => 'D7萨普塔姆萨';

  @override
  String get cpGaugeSphuta => '种子-田地（Beeja-Kshetra）';

  @override
  String get cpGaugeTiming => '大运时机';

  @override
  String get cpChipStrongPutrakaraka => '强健的子女徵星（木星）';

  @override
  String get cpChipLowDoshaPenalty => '缺陷扣分较低';

  @override
  String get cpChipFavorableTiming => '有利的大运时机';

  @override
  String get cpChipNoDoshas => '未检测到子嗣缺陷（Dosha）';

  @override
  String get cpPartnersTitle => '伴侣概况';

  @override
  String get cpLagnaSuffix => '上升星座（Lagna）';

  @override
  String get cpMoonSuffix => '月亮星座';

  @override
  String get cpNumberTitle => '子女数量与性别倾向';

  @override
  String get cpProbableNumber => '可能数量';

  @override
  String get cpFirstChildTendency => '第一胎倾向';

  @override
  String get cpSpacing => '间隔说明';

  @override
  String get cpTimingTitle => '时机——命主大运';

  @override
  String get cpCombinedTiming => '综合时机';

  @override
  String get cpNextWindow => '下一个有利时段';

  @override
  String get cp5thHouseTitle => '第五宫分析';

  @override
  String get cp5thHouseSubtitle => '子女宫（Putra Bhava），分别分析';

  @override
  String get cpJupiterTitle => '木星——子女徵星分析';

  @override
  String get cpJupiterSubtitle => '子女的自然徵星，分别分析';

  @override
  String get cpD7Title => 'D7萨普塔姆萨分析';

  @override
  String get cpD7Subtitle => '专门用于子女分析的分盘';

  @override
  String get cpD7Strength => 'D7强度';

  @override
  String get cpSphutaTitle => '种子与田地斯普塔（Beeja & Kshetra Sphuta）';

  @override
  String get cpBeejaSphuta => '种子斯普塔（Beeja Sphuta）';

  @override
  String get cpKshetraSphuta => '田地斯普塔（Kshetra Sphuta）';

  @override
  String get cpDoshaTitle => '缺陷（Dosha）分析';

  @override
  String get cpNoDoshasDetected => '两张星盘均未检测到与子嗣相关的缺陷';

  @override
  String get cpRemediesTitle => '推荐的补救方法';

  @override
  String get cpAddresses => '针对问题';

  @override
  String get cpTopicTiming => '最佳受孕时机';

  @override
  String get cpTopicNumber => '我们可能有多少个子女';

  @override
  String get cpTopicDosha => '需要处理的任何缺陷';

  @override
  String get cpTopicRemedies => '推荐的补救方法';

  @override
  String get cpTopicFifthHouse => '我们第五宫的强度';

  @override
  String get cpTopicJupiter => '木星在其中的作用';

  @override
  String get riSubtitle => 'AI驱动的吠陀关系智能报告';

  @override
  String get riTitle => '关系洞察';

  @override
  String get riSnapshotHeader => '群体概览';

  @override
  String get riGaugeCohesion => '群体凝聚力';

  @override
  String get riGaugeTrust => '信任氛围';

  @override
  String get riGaugeProductivity => '生产力';

  @override
  String get riGaugeCreativity => '创造力';

  @override
  String get riChipNoAlerts => '无重大警示';

  @override
  String get riChipStrongCohesion => '强大的群体凝聚力';

  @override
  String get riChipHighTrust => '高度信任氛围';

  @override
  String get riChipNoHiddenEnemy => '无潜在敌意信号';

  @override
  String get riChipHealthyGroup => '整体健康的群体';

  @override
  String get riProfilesTitle => '星盘概况';

  @override
  String riProfilesSubtitle(Object count) {
    return '此群体中有$count人';
  }

  @override
  String get riLagnaSuffix => '上升星座（Lagna）';

  @override
  String get riIntegrity => '正直度';

  @override
  String get riWarmth => '热情度';

  @override
  String get riTrustworthiness => '可信度';

  @override
  String get riAssertiveness => '果断度';

  @override
  String get riGroupDynamicsTitle => '群体动态概览';

  @override
  String get riMostSupportive => '最具支持性';

  @override
  String get riMostChallenged => '最具挑战性';

  @override
  String get riHiddenEnemyAlert => '检测到潜在敌意信号';

  @override
  String get riBestWorstTitle => '最佳与最具挑战性的组合';

  @override
  String get riBestPair => '最强纽带';

  @override
  String get riWorstPair => '需要关注';

  @override
  String get riAlliances => '可能的联盟';

  @override
  String get riConflicts => '可能的摩擦点';

  @override
  String get riPairwiseTitle => '两两分析';

  @override
  String riPairwiseSubtitle(Object count) {
    return '已分析$count对组合';
  }

  @override
  String get riDynamic => '动态';

  @override
  String get riKarmicLink => '业力联系';

  @override
  String get riMutualTrust => '相互信任';

  @override
  String get riBetrayalRisk => '背叛风险';

  @override
  String get riPowerDistribution => '权力分配';

  @override
  String get riPowerHealth => '权力平衡健康度';

  @override
  String get riCriticalPatternsTitle => '关键模式';

  @override
  String get riGroupRecsTitle => '群体建议';

  @override
  String get riSharedPractices => '共同实践';

  @override
  String get riCommStyle => '推荐的沟通方式';

  @override
  String get riGrowthFocus => '推荐的成长重点';

  @override
  String get riIndividualTitle => '个人指导';

  @override
  String get riBestAllies => '最佳盟友';

  @override
  String get riHandleWithCare => '需谨慎对待';

  @override
  String get riCoreThemeTitle => '核心群体主题';

  @override
  String get riLayerPairwise => '两两完整度';

  @override
  String get riLayerD1 => '本命盘（D1）';

  @override
  String get riLayerD9 => '那婆姆萨盘（D9）';

  @override
  String get riLayerD10 => '达萨姆萨盘（D10）';

  @override
  String get riLayerD30 => '特灵沙姆萨盘（D30）';

  @override
  String get riLayerJaimini => '遮米尼信号（Jaimini）';

  @override
  String get riLayerBehavior => '行为清晰度';

  @override
  String get riLayerCoherence => '群体一致性';

  @override
  String get riTopicDynamics => '我们的群体动态';

  @override
  String get riTopicPairwise => '特定两人间的合盘';

  @override
  String get riTopicAlerts => '任何重大警示';

  @override
  String get riTopicGrowth => '我们如何共同成长';

  @override
  String get riTopicRecs => '推荐的实践方法';

  @override
  String get riTopicTheme => '我们的核心群体主题';

  @override
  String get kmSubtitle => 'AI驱动的吠陀星盘合婚报告';

  @override
  String get kmTitle => '星盘合婚（Kundli Milan）';

  @override
  String get kmSnapshotHeader => '合盘概览';

  @override
  String kmAshtakootScore(Object score) {
    return '阿什塔库特（Ashtakoot）：$score/36';
  }

  @override
  String get kmGaugeAshtakoot => '阿什塔库特百分比';

  @override
  String get kmGaugeD9 => 'D9婚姻业力';

  @override
  String get kmGaugeMangal => '火星缺陷平衡（Mangal）';

  @override
  String get kmGaugePapa => '业力平衡';

  @override
  String get kmGaugeAk => '灵魂共鸣';

  @override
  String get kmChipNoNadi => '无纳迪缺陷（Nadi Dosh）';

  @override
  String get kmChipNoBhakoot => '无巴库特缺陷（Bhakoot Dosh）';

  @override
  String get kmChipMangalCancelled => '火星缺陷（Mangal Dosh）已抵消';

  @override
  String get kmChipPapaBalanced => '业力负担均衡';

  @override
  String get kmChipStrongChemistry => '强烈的身体吸引力';

  @override
  String get kmChipStrongD9 => '强大的D9婚姻业力';

  @override
  String get kmChipLongevity => '强健的寿元契合度';

  @override
  String get kmAshtakootTitle => '阿什塔库特古纳合婚（Ashtakoot Guna Milan）';

  @override
  String get kmAshtakootSubtitle => '经典八项匹配系统，满分36分';

  @override
  String get kmNadiSeverity => '纳迪缺陷严重程度';

  @override
  String get kmBhakootSeverity => '巴库特缺陷严重程度';

  @override
  String get kmGanaSignature => '伽纳（Gana）特征';

  @override
  String get kmMangalTitle => '火星缺陷检查（Mangal Dosha）';

  @override
  String get kmD9Title => 'D9那婆姆萨盘——婚姻业力';

  @override
  String get kmD9Subtitle => '灵魂层面的婚姻星盘，经典上被视为最重要';

  @override
  String get kmD9Score => 'D9合盘度';

  @override
  String get kmLagnaRelation => '上升星座关系';

  @override
  String get km7thLordRelation => '第七宫主星关系';

  @override
  String get kmKarakasTitle => '灵魂与配偶徵星';

  @override
  String get kmAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get kmAkCompatibility => '灵魂印记共鸣';

  @override
  String get kmUlCompatibility => '配偶徵星契合度';

  @override
  String get kmUlSigns => '副宫（Upapada）主星';

  @override
  String get kmChemistryTitle => '金星-火星化学反应';

  @override
  String get kmPhysicalChemistry => '身体吸引力';

  @override
  String get kmEmotionalWarmth => '情感温度';

  @override
  String get kmAestheticAlignment => '审美契合度';

  @override
  String get kmElementalSynthesis => '元素融合度';

  @override
  String get kmHouseCrossTitle => '第七宫与第八宫交叉分析';

  @override
  String get km78Compatibility => '七宫-八宫合盘度';

  @override
  String get km8thHouseSignature => '共同寿元特征';

  @override
  String get kmLongevityAlignment => '寿元契合度';

  @override
  String get km7thLordFriendship => '第七宫主星友谊关系';

  @override
  String get kmDomainsTitle => '各领域合盘度';

  @override
  String get kmConflictEngagement => '冲突应对方式';

  @override
  String get kmDashaTitle => '大运与行运同步';

  @override
  String get kmDashaSync => '大运同步度';

  @override
  String get kmTransitAlignment => '行运契合度';

  @override
  String get kmTimingTitle => '婚姻时机';

  @override
  String get kmMarriageWindow => '婚姻时段';

  @override
  String get kmEngagementWindow => '订婚时段';

  @override
  String get kmRecommendedRange => '推荐时间范围';

  @override
  String get kmMuhurtaNotes => '吉时（Muhurta）说明';

  @override
  String get kmRisksTitle => '需要注意的风险';

  @override
  String get kmConflictRisk => '冲突风险';

  @override
  String get kmCommunicationRisk => '沟通风险';

  @override
  String get kmFinanceRisk => '财务冲突风险';

  @override
  String get kmFamilyDynamicsRisk => '家庭关系风险';

  @override
  String get kmMentalHealthRisk => '心理健康契合风险';

  @override
  String get kmStrengthsTitle => '主要合盘优势';

  @override
  String get kmSharedGrowth => '共同成长潜力';

  @override
  String get kmSharedCreative => '共同创造潜力';

  @override
  String get kmJourneyTitle => '关系历程与成长';

  @override
  String get kmCurrentPhase => '当前阶段';

  @override
  String get kmEarlyArc => '婚姻初期';

  @override
  String get kmMiddleArc => '婚姻中期';

  @override
  String get kmMatureArc => '婚姻成熟期';

  @override
  String get kmElderArc => '晚年时期';

  @override
  String get kmPeakPhase => '陪伴巅峰期';

  @override
  String get kmGrowthAreas => '成长领域';

  @override
  String get kmCommProtocols => '沟通准则';

  @override
  String get kmSharedPractices => '共同实践';

  @override
  String get kmImprovementTitle => '核心主题与改进计划';

  @override
  String get kmVerdictTitle => '最终结论';

  @override
  String get kmRealizationPotential => '关系实现潜力';

  @override
  String get kmLayerAshtakoot => '阿什塔库特（Ashtakoot）';

  @override
  String get kmLayerD9 => 'D9纳瓦姆萨';

  @override
  String get kmLayerMangalPapa => '火星缺陷与业力均衡（Papasamya）';

  @override
  String get kmLayerVenusMars => '金星-火星';

  @override
  String get kmLayerDashaSync => '大运同步度';

  @override
  String get kmLayerH7H8 => '七宫-八宫交叉';

  @override
  String get kmLayerAkResonance => '灵魂行星共鸣';

  @override
  String get kmLayerDomains => '领域维度';

  @override
  String get kmTopicAshtakoot => '我们的阿什塔库特评分';

  @override
  String get kmTopicMangal => '火星缺陷（Mangal Dosha）相关问题';

  @override
  String get kmTopicD9 => '我们的婚姻业力（D9）';

  @override
  String get kmTopicTiming => '最佳结婚时机';

  @override
  String get kmTopicRisks => '需要提前准备的风险';

  @override
  String get kmTopicGrowth => '我们如何共同成长';

  @override
  String get kmTopicRemedies => '推荐的补救方法';

  @override
  String get kmTopicVerdict => '我们是否应该继续这段婚姻';

  @override
  String get pkSubtitle => 'AI驱动的吠陀前世与业力报告';

  @override
  String get pkTitle => '前世与业力';

  @override
  String get pkSnapshotHeader => '前世概览';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return '您的星盘显示出「$theme」的前世印记，目前正$relation地延续到今生。推荐路径：$strategy。';
  }

  @override
  String get pkGaugeSignature => '印记强度';

  @override
  String get pkGaugeMasteryPreserved => '保留的精通能力';

  @override
  String get pkGaugeClearingProgress => '业力清理进度';

  @override
  String get pkGaugeMaturity => '前世成熟度';

  @override
  String get pkGaugeMemoryAccess => '记忆通达度';

  @override
  String get pkChipGoodProgress => '业力清理进展良好';

  @override
  String get pkChipLowDebt => '业力债务较低';

  @override
  String get pkChipMatureSoul => '成熟的灵魂印记';

  @override
  String get pkChipGiftedPast => '星盘携带前世天赋';

  @override
  String get pkChipAccomplished => '成就斐然的前世';

  @override
  String get pkChipMasteryPreserved => '强大的精通能力得以延续';

  @override
  String get pkKetuTitle => '计都——您的前世精通';

  @override
  String get pkKetuSubtitle => '您灵魂已经掌握的技能';

  @override
  String get pkMasteryStrength => '精通强度';

  @override
  String get pkSkillsCarried => '延续下来的技能';

  @override
  String get pkInstincts => '本能能力';

  @override
  String get pkKetuDignity => '计都的力量状态';

  @override
  String get pkRahuTitle => '罗睺——您灵魂的成长方向';

  @override
  String get pkRahuSubtitle => '您灵魂此生要完成的事';

  @override
  String get pkUnmetDesires => '未满足的渴望';

  @override
  String get pkProfileTitle => '您的前世档案';

  @override
  String get pkProfession => '可能的职业';

  @override
  String get pkSocialStanding => '社会地位';

  @override
  String get pkRegion => '可能的地域';

  @override
  String get pkCulturalArchetype => '文化原型';

  @override
  String get pkAccomplishment => '成就水平';

  @override
  String get pkAuthority => '权威水平';

  @override
  String get pkFamilyRole => '家庭角色';

  @override
  String get pkSecondaryProfession => '次要职业';

  @override
  String get pkClimateAffinity => '气候偏好';

  @override
  String get pkForeignResidence => '异地/异国居住业力';

  @override
  String get pkRelationshipsTitle => '延续至今的前世关系';

  @override
  String get pkSpouseConnection => '配偶重逢';

  @override
  String get pkChildrenConnection => '子女重逢';

  @override
  String get pkCarriedRelationTypes => '关系模式';

  @override
  String get pkPartnerArchetype => '前世伴侣原型';

  @override
  String get pkDarakaraka => '配偶徵星（Darakaraka）';

  @override
  String get pkParentsKarma => '父母业力模式';

  @override
  String get pkSiblingKarma => '兄弟姐妹业力模式';

  @override
  String get pkSpiritualTitle => '您当时的灵性生活';

  @override
  String get pkSpiritualLevel => '灵性水平';

  @override
  String get pkPracticeSignature => '修行方式';

  @override
  String get pkMeditativeCapacity => '禅修能力';

  @override
  String get pkDevotionalPractice => '奉爱修行';

  @override
  String get pkYogicAttainment => '瑜伽成就';

  @override
  String get pkMokshaProximity => '解脱（Moksha）临近度';

  @override
  String get pkKarmicDebtsTitle => '当时的业力债务与财富';

  @override
  String get pkTotalKarmicDebt => '总业力债务';

  @override
  String get pkPrimaryDebtType => '主要债务类型';

  @override
  String get pkRelationshipDebt => '关系债务';

  @override
  String get pkFinancialDebt => '财务债务';

  @override
  String get pkServiceDebt => '服务债务';

  @override
  String get pkDharmicDebt => '达摩（Dharma）债务';

  @override
  String get pkPitruKarma => '祖先业力（Pitru Karma）';

  @override
  String get pkMatruKarma => '母系业力（Matru Karma）';

  @override
  String get pkWealthLevel => '当时的财富水平';

  @override
  String get pkWealthKarmaCarried => '延续的财富业力';

  @override
  String get pkResourcePattern => '资源管理方式';

  @override
  String get pkGainSource => '获利来源';

  @override
  String get pkEchoesTitle => '今生的回响';

  @override
  String get pkOnRelationships => '在人际关系方面';

  @override
  String get pkOnCareer => '在事业方面';

  @override
  String get pkOnHealth => '在健康方面';

  @override
  String get pkOnSpirituality => '在灵性方面';

  @override
  String get pkDominantArea => '最强延续领域';

  @override
  String get pkAttractions => '天然吸引';

  @override
  String get pkAversions => '天然排斥';

  @override
  String get pkUnexplainedFears => '无法解释的恐惧';

  @override
  String get pkMagneticPulls => '无形的吸引力';

  @override
  String get pkResolutionTitle => '业力化解与圆满';

  @override
  String get pkPrimaryPathway => '主要路径';

  @override
  String get pkSecondaryPathway => '次要路径';

  @override
  String get pkClearingProgress => '清理进度';

  @override
  String get pkRemainingWork => '剩余功课';

  @override
  String get pkSettlementTimeline => '化解时间线';

  @override
  String get pkAccelerationPractices => '加速化解的修行方法';

  @override
  String get pkPriorityAreas => '优先领域';

  @override
  String get pkVerificationTitle => '跨星盘验证（D60）';

  @override
  String get pkD60Label => 'D60前世时代';

  @override
  String get pkD60Ketu => 'D60计都落位';

  @override
  String get pkD60Standing => '整体地位';

  @override
  String get pkMemoryTitle => '记忆与直觉';

  @override
  String get pkMemoryAccess => '记忆通达度';

  @override
  String get pkRegressionFit => '前世回溯疗法适配度';

  @override
  String get pkDreamVisits => '梦境造访';

  @override
  String get pkDejaVuFrequency => '似曾相识（Deja Vu）频率';

  @override
  String get pkSpontaneousRemembrance => '自发回忆';

  @override
  String get pkRemembrancePractices => '唤醒记忆的修行';

  @override
  String get pkTimelineTitle => '激活时间线';

  @override
  String get pkGiftsActivation => '前世天赋激活';

  @override
  String get pkSurfaceWindow => '浮现时段';

  @override
  String get pkRisksTitle => '风险与长期模式';

  @override
  String get pkTraumaResidue => '创伤残留';

  @override
  String get pkSpiritualBypass => '灵性逃避风险';

  @override
  String get pkMajorRisks => '主要风险';

  @override
  String get pkChronicImprints => '长期印记';

  @override
  String get pkKarmicLoops => '业力循环';

  @override
  String get pkImprovementTitle => '改进计划';

  @override
  String get pkRoadmapTitle => '您的前世路线图';

  @override
  String get pkMaturity => '前世成熟度';

  @override
  String get pkLayerD1 => '本命盘（D1）';

  @override
  String get pkLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get pkLayerD60 => '沙什提安萨盘（D60）';

  @override
  String get pkLayerKetuDepth => '计都深度';

  @override
  String get pkLayerAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get pkTopicMastery => '我的前世精通';

  @override
  String get pkTopicUnfinished => '我未完成的业力';

  @override
  String get pkTopicRelationships => '我的前世关系';

  @override
  String get pkTopicDebts => '我的业力债务';

  @override
  String get pkTopicResolution => '如何化解我的业力';

  @override
  String get pkTopicMemory => '前世记忆通达';

  @override
  String get pkTopicTiming => '最佳时机窗口';

  @override
  String get pkTopicProfile => '我前世是谁';

  @override
  String get chSubtitle => 'AI驱动的吠陀性格分析报告';

  @override
  String get chTitle => '性格分析';

  @override
  String get chSnapshotHeader => '性格概览';

  @override
  String get chGaugeIntegrity => '正直度';

  @override
  String get chGaugeResilience => '韧性';

  @override
  String get chGaugeSelfAwareness => '自我觉察力';

  @override
  String get chGaugeStability => '情绪稳定性';

  @override
  String get chGaugeMoralFabric => '道德底蕴';

  @override
  String get chChipRajaYoga => '存在拉贾瑜伽（Raja Yoga）';

  @override
  String get chChipHighIntegrity => '高度正直';

  @override
  String get chChipResilient => '坚韧的天性';

  @override
  String get chChipDharmic => '强烈的达摩（Dharma）取向';

  @override
  String get chChipEmpathetic => '天生富有同理心';

  @override
  String get chChipLoyal => '极其忠诚';

  @override
  String get chChipGiftedCharacter => '星盘携带性格天赋';

  @override
  String get chSoulTitle => '您的灵魂印记';

  @override
  String get chSoulIntegration => '灵魂与性格的整合度';

  @override
  String get chAmatyakarakaTheme => '辅助性格声音（Amatyakaraka）';

  @override
  String get chAtmakarakaDignity => '灵魂行星的力量状态';

  @override
  String get chAtmakarakaHouse => '宫位落位';

  @override
  String get chSurfaceTitle => '表层性格与体质';

  @override
  String get chLagnaSign => '上升星座';

  @override
  String get chConstitution => '体质';

  @override
  String get chSurfaceSignature => '您给人的第一印象';

  @override
  String get chPhysicalConstitution => '身体体质';

  @override
  String get chLagnaLord => '上升主星';

  @override
  String get chLagnaOccupants => '上升宫内行星';

  @override
  String get chMindEmotionsTitle => '心智、情绪与自我';

  @override
  String get chEmotionalNature => '您的情绪特质';

  @override
  String get chMentalStability => '心智稳定性';

  @override
  String get chSelfConfidence => '健康的自信心';

  @override
  String get chEgoNature => '您的自我与自我认知';

  @override
  String get chAuthorityRelationship => '与权威的关系';

  @override
  String get chPrideTendency => '自负倾向';

  @override
  String get chMoodPatterns => '情绪模式';

  @override
  String get chKemadrumaPresent => '存在凯玛德鲁玛瑜伽（Kemadruma Yoga）——建议加强情绪自我照顾。';

  @override
  String get chFatherImprint => '父亲印记质量';

  @override
  String get chCommunicationTitle => '沟通与智力风格';

  @override
  String get chIntellectStyle => '智力风格';

  @override
  String get chCommStyle => '沟通风格';

  @override
  String get chDecisionStyle => '决策风格';

  @override
  String get chDiscrimination => '辨别能力';

  @override
  String get chPersonaTitle => '公众形象与真实自我';

  @override
  String get chAuthenticityGap => '真实性差距';

  @override
  String get chGunaTitle => '古纳（Guna）与体质（Dosha）档案';

  @override
  String get chGunaSubtitle => '经典吠陀风格下您的内在本质与体质';

  @override
  String get chSattva => '悦性（Sattva）';

  @override
  String get chRajas => '动性（Rajas）';

  @override
  String get chTamas => '惰性（Tamas）';

  @override
  String get chDominantGuna => '主导古纳';

  @override
  String get chPitta => '皮塔（Pitta）';

  @override
  String get chKapha => '卡法（Kapha）';

  @override
  String get chVata => '瓦塔（Vata）';

  @override
  String get chDominantDosha => '主导体质';

  @override
  String get chRahuRestlessness => '罗睺带来的不安分';

  @override
  String get chKetuDetachment => '计都带来的超然';

  @override
  String get chYogasTitle => '性格瑜伽（Yoga）';

  @override
  String get chRajaYogaStrength => '拉贾瑜伽强度';

  @override
  String get chGiftYogas => '天赋瑜伽';

  @override
  String get chTestYogas => '考验瑜伽';

  @override
  String get chStrengthsTitle => '优势与天赋';

  @override
  String get chSignatureVirtues => '标志性美德';

  @override
  String get chNaturalTalents => '天生才能';

  @override
  String get chSoftSkills => '软实力';

  @override
  String get chHiddenStrengths => '有待开发的潜在优势';

  @override
  String get chShadowTitle => '阴影面与成长领域';

  @override
  String get chShadowSubtitle => '温和觉察值得改善的模式';

  @override
  String get chShadowPatterns => '阴影模式';

  @override
  String get chBlindSpots => '盲点';

  @override
  String get chEmotionalWounds => '情感创伤';

  @override
  String get chShadowWorkPriorities => '阴影功课优先事项';

  @override
  String get chMoralTests => '道德考验';

  @override
  String get chRelationshipsTitle => '人际关系与社交风格';

  @override
  String get chWarmth => '人际温暖度';

  @override
  String get chEmpathy => '同理心能力';

  @override
  String get chLoyalty => '忠诚能力';

  @override
  String get chBoundaries => '边界设定';

  @override
  String get chSocialConfidence => '社交自信';

  @override
  String get chTrustGiving => '给予信任的基线';

  @override
  String get chConflictStyle => '冲突应对风格';

  @override
  String get chEthicsTitle => '伦理与道德罗盘';

  @override
  String get chDharmaOrientation => '达摩取向';

  @override
  String get chTruthfulness => '诚实度';

  @override
  String get chCompassion => '慈悲心';

  @override
  String get chGenerosity => '慷慨度';

  @override
  String get chEthicalConsistency => '道德一致性';

  @override
  String get chIntegrityPressure => '压力下的正直度';

  @override
  String get chJusticeFairness => '正义与公平';

  @override
  String get chMoralTrajectory => '道德发展轨迹';

  @override
  String get chEiTitle => '情商';

  @override
  String get chEiSelfAwareness => '自我觉察';

  @override
  String get chEiSelfRegulation => '自我调节';

  @override
  String get chEiEmpathy => '同理心';

  @override
  String get chEiSocialSkills => '社交技能';

  @override
  String get chMotivation => '内在动力';

  @override
  String get chVulnerabilityComfort => '面对脆弱的自在度';

  @override
  String get chEmotionalExpression => '情感表达的自在度';

  @override
  String get chEmotionalReceptivity => '情感接纳度';

  @override
  String get chVerificationTitle => '跨星盘验证（D9/D12/D30/D60）';

  @override
  String get chD9Label => 'D9达摩性格';

  @override
  String get chD12Label => 'D12祖辈遗传';

  @override
  String get chD30Label => 'D30阴影档案';

  @override
  String get chD60Label => 'D60前世性格';

  @override
  String get chD30Standing => '阴影面地位';

  @override
  String get chMaternalInheritance => '母系遗传';

  @override
  String get chAncestralKarmaWeight => '祖先业力权重';

  @override
  String get chTimelineTitle => '性格发展时间线';

  @override
  String get chFormationWindow => '性格形成期';

  @override
  String get chMaturationWindow => '性格成熟期';

  @override
  String get chLegacyWindow => '传承期';

  @override
  String get chPeakMaturationAge => '巅峰成熟年龄';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return '$ageRange岁';
  }

  @override
  String get chImprovementTitle => '改进计划';

  @override
  String get chRoadmapTitle => '您的性格发展路线图';

  @override
  String get chAuthenticExpression => '真实的自我表达';

  @override
  String get chRealizationPotential => '性格实现潜力';

  @override
  String get chLayerAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get chLayerD1 => '本命盘（D1）';

  @override
  String get chLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get chLayerD30 => '特灵沙姆萨盘（D30）';

  @override
  String get chLayerLagnaMoon => '上升星座与月亮';

  @override
  String get chLayerArudha => '阿茹达上升（Arudha Lagna）';

  @override
  String get chTopicStrengths => '我的性格优势';

  @override
  String get chTopicShadow => '我的阴影模式';

  @override
  String get chTopicSoul => '我的灵魂印记';

  @override
  String get chTopicRelationships => '我的关系风格';

  @override
  String get chTopicEthics => '我的伦理与价值观';

  @override
  String get chTopicGuna => '我的古纳与体质档案';

  @override
  String get chTopicGrowth => '如何发展我的性格';

  @override
  String get chTopicTiming => '性格塑造的最佳时机';

  @override
  String get lpSubtitle => 'AI驱动的吠陀人生路径与运势报告';

  @override
  String get lpTitle => '人生路径与运势';

  @override
  String get lpSnapshotHeader => '人生路径概览';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return '您是一位$archetype，主要人生目标在于$domain。我们的分析显示您整体人生实现潜力为$probability%。';
  }

  @override
  String get lpGaugeDharma => '达摩清晰度';

  @override
  String get lpGaugeFortune => '运势基线';

  @override
  String get lpGaugeCoherence => '路径一致性';

  @override
  String get lpGaugeFulfillment => '实现度';

  @override
  String get lpGaugeMomentum => '业力动能';

  @override
  String get lpChipRareGift => '罕见的命运天赋';

  @override
  String get lpChipFreeWillStrong => '强大的自由意志';

  @override
  String get lpChipGraceSupported => '受到恩典支持';

  @override
  String get lpChipLightKarma => '较轻的业力负担';

  @override
  String get lpChipRecognitionPotential => '获得认可的潜力';

  @override
  String get lpChipSpiritualPath => '强烈的灵性牵引';

  @override
  String get lpChipBlessed => '星盘携带福泽';

  @override
  String get lpSoulPathTitle => '您的灵魂路径';

  @override
  String get lpSoulPlanet => '灵魂行星';

  @override
  String get lpCareerPlanet => '使命行星';

  @override
  String get lpSoulClarity => '使命清晰度';

  @override
  String get lpLifeChapter => '当前人生篇章';

  @override
  String get lpPrimaryDomain => '主要使命领域';

  @override
  String get lpKarakaTitle => '您的达摩行星';

  @override
  String get lpKarakaSubtitle => '各行星对您人生使命的支持强度';

  @override
  String get lpVerificationTitle => '跨星盘验证（D9 / D60）';

  @override
  String get lpD9Label => 'D9灵魂契合度';

  @override
  String lpD9Explain(Object stage) {
    return '在纳瓦姆萨盘中，您的灵魂进化阶段为「$stage」。';
  }

  @override
  String get lpD9JupiterDignity => '木星力量状态';

  @override
  String get lpD9DharmaMultiplier => '达摩加成倍数';

  @override
  String get lpD60Label => 'D60前世印记';

  @override
  String get lpKarmaType => '前世业力类型';

  @override
  String get lpKetuMastery => '计都前世精通';

  @override
  String get lpRahuGrowthDir => '罗睺成长方向';

  @override
  String get lpYogasTitle => '运势瑜伽与运势阻碍';

  @override
  String get lpFortuneBoost => '运势加成';

  @override
  String get lpLuckDrain => '运势消耗';

  @override
  String get lpFortuneBoosters => '运势助力';

  @override
  String get lpLuckBlocks => '运势阻碍';

  @override
  String get lpPurposeTitle => '使命领域与声望';

  @override
  String get lpDomainLeadership => '领导力';

  @override
  String get lpDomainWisdom => '智慧与教导';

  @override
  String get lpDomainService => '服务';

  @override
  String get lpDomainHealing => '疗愈';

  @override
  String get lpDomainCreative => '创造性表达';

  @override
  String get lpPrimaryDomainBadge => '主要';

  @override
  String get lpFameRecognition => '声望与认可';

  @override
  String get lpSocialInfluence => '社会影响力';

  @override
  String get lpRecognitionDomain => '受认可领域';

  @override
  String get lpPublicImage => '公众形象';

  @override
  String get lpHistoricalImpact => '历史影响力潜力';

  @override
  String get lpTimelineTitle => '运势与人生时间线';

  @override
  String get lpCurrentPhase => '当前运势阶段';

  @override
  String get lpJupiterReturn => '木星回归';

  @override
  String get lpSaturnReturn => '土星回归';

  @override
  String get lpSadeSati => '土星七返（Sade Sati）';

  @override
  String get lpGoldenWindow => '黄金时段';

  @override
  String get lpTransformationWindow => '转变时段';

  @override
  String get lpPeakYears => '运势巅峰年份';

  @override
  String get lpChallengingYears => '挑战年份';

  @override
  String get lpMilestonesTitle => '重要里程碑与转折点';

  @override
  String get lpFirstTurningPoint => '第一个重大转折点';

  @override
  String get lpMidlifeTransform => '中年转变';

  @override
  String get lpLateLifeFulfillment => '晚年圆满';

  @override
  String lpDharmicMilestone(Object age) {
    return '达摩里程碑（$age岁）';
  }

  @override
  String lpAgeLabel(Object age) {
    return '$age岁';
  }

  @override
  String get lpDestinyTitle => '命运与自由意志';

  @override
  String get lpDestinyStat => '命运权重';

  @override
  String get lpFreeWillStat => '自由意志作用力';

  @override
  String get lpFateStrength => '命运印记强度';

  @override
  String get lpSelfCreation => '自我创造能力';

  @override
  String get lpEffortGrace => '努力与恩典';

  @override
  String get lpKarmicTitle => '业力课题';

  @override
  String get lpRahuGrowthLabel => '罗睺——成长挑战';

  @override
  String get lpKetuSurrenderLabel => '计都——放下主题';

  @override
  String get lpSaturnLessonLabel => '土星——自律课题';

  @override
  String get lpTestDifficulty => '人生考验难度';

  @override
  String get lpLessonsInProgress => '正在进行的课题';

  @override
  String get lpSoulContract => '灵魂契约领域';

  @override
  String get lpSoulExperience => '您的灵魂此生要体验的事';

  @override
  String get lpSoulMastery => '您的灵魂此生要精通的事';

  @override
  String get lpSpiritualTitle => '灵性道路';

  @override
  String get lpSpiritualInclination => '灵性倾向';

  @override
  String get lpMeditationReceptivity => '冥想接受度';

  @override
  String get lpTeacherKarma => '师徒（古鲁）业力';

  @override
  String get lpPilgrimageBenefit => '朝圣的益处';

  @override
  String get lpSelfRealization => '自我实现潜力';

  @override
  String get lpDivineConnection => '神性连接';

  @override
  String get lpTraditionAffinity => '传统亲和度';

  @override
  String get lpIntuitionStrength => '直觉力强度';

  @override
  String get lpMantraEfficacy => '祈祷/真言（Mantra）效力';

  @override
  String get lpInnerGuidance => '对内在指引的信任';

  @override
  String get lpPropheticDreams => '预知梦敏感度';

  @override
  String get lpDifficultyTitle => '人生难度与挑战';

  @override
  String get lpEarlyLife => '早年生活';

  @override
  String get lpMidlife => '中年生活';

  @override
  String get lpLateLife => '晚年生活';

  @override
  String get lpStruggleToSuccess => '先苦后甜的业力';

  @override
  String get lpUnlivedLifeRisk => '未活出真我的风险';

  @override
  String get lpChallenges => '人生挑战';

  @override
  String get lpFortuneDrains => '长期运势消耗';

  @override
  String get lpRegretAreas => '易生遗憾的领域';

  @override
  String get lpRedFlags => '方向警示信号';

  @override
  String get lpBlessingsTitle => '福泽与核心人生主题';

  @override
  String get lpKarmicRoot => '业力根源';

  @override
  String get lpBlessingsList => '您的福泽';

  @override
  String get lpFulfillmentPriorities => '圆满优先事项';

  @override
  String get lpImprovementTitle => '改进计划';

  @override
  String get lpDharmaPriorities => '达摩优先事项';

  @override
  String get lpRoadmapTitle => '您的命运路线图';

  @override
  String get lpStrategy => '策略';

  @override
  String get lpFulfillmentPotential => '圆满潜力';

  @override
  String get lpNext12Focus => '未来12个月重点';

  @override
  String get lpLayerD1 => '本命盘（D1）';

  @override
  String get lpLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get lpLayerD60 => '沙什提安萨盘（D60）';

  @override
  String get lpLayerDasha => '大运时机';

  @override
  String get lpLayerTransit => '当前行运';

  @override
  String get lpTopicPurpose => '我的人生使命';

  @override
  String get lpTopicFortune => '我的运势瑜伽';

  @override
  String get lpTopicKarma => '我的业力课题';

  @override
  String get lpTopicMilestones => '即将到来的里程碑';

  @override
  String get lpTopicDestiny => '命运与自由意志';

  @override
  String get lpTopicSpiritual => '我的灵性道路';

  @override
  String get lpTopicChallenges => '我的人生挑战';

  @override
  String get lpTopicTiming => '最佳时机窗口';

  @override
  String get dbSubtitle => 'AI驱动的吠陀债务与财务恢复报告';

  @override
  String get dbTitle => '债务与财务恢复';

  @override
  String get dbSnapshotHeader => '债务恢复概览';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return '您目前处于「$phase」阶段，理财方式为$personality型。我们的分析显示，您在大约$years年内实现无债一身轻的概率为$probability%。';
  }

  @override
  String get dbGaugeCapacity => '恢复能力';

  @override
  String get dbGaugeProbability => '恢复概率';

  @override
  String get dbGaugeFreedomNow => '当前无债程度';

  @override
  String get dbGaugeDti => '收入健康度';

  @override
  String get dbGaugeResilience => '韧性';

  @override
  String get dbChipCleanKarma => '债务业力清净';

  @override
  String get dbChipStrongRecovery => '强大的恢复能力';

  @override
  String get dbChipHealthyDti => '健康的债务收入比';

  @override
  String get dbChipResilient => '高心理韧性';

  @override
  String get dbChipCycleBreakable => '债务循环可以打破';

  @override
  String get dbChipLowReindebt => '再负债风险较低';

  @override
  String get dbChipGoodNegotiator => '良好的协商胜算';

  @override
  String get dbProfileTitle => '您的债务档案';

  @override
  String get dbPhaseLabel => '当前阶段';

  @override
  String get dbPrimaryCategoryLabel => '主要类别';

  @override
  String get dbKarakaLabel => '债务徵星';

  @override
  String get dbProtectorLabel => '债权人保护力';

  @override
  String get dbSecondaryCategories => '次要类别';

  @override
  String get dbUnsecuredRatio => '无抵押债务比例';

  @override
  String get dbKarakaTitle => '您的债务行星';

  @override
  String get dbKarakaSubtitle => '各行星对您债务恢复的支持强度';

  @override
  String get dbVerificationTitle => '跨星盘验证（D6）';

  @override
  String get dbD6Label => 'D6债务与仇敌盘';

  @override
  String get dbD6LordDignity => '第六宫主星力量';

  @override
  String get dbD6Severity => '债务业力严重程度';

  @override
  String get dbD6Multiplier => 'D6债务倍数';

  @override
  String get dbYogasTitle => '债务瑜伽与保护力';

  @override
  String get dbPressureNow => '当前债务压力';

  @override
  String get dbRecoveryBoost => '恢复加成';

  @override
  String get dbClearingLabel => '债务清偿瑜伽';

  @override
  String get dbCreatingLabel => '债务形成瑜伽';

  @override
  String get dbCategoriesTitle => '债务类别关注';

  @override
  String get dbCategoriesSubtitle => '哪些类型的债务最需要关注';

  @override
  String get dbTimelineTitle => '无债时间线';

  @override
  String get dbFreeWindowLabel => '无债时段';

  @override
  String get dbClearanceEstimate => '完全清偿预估';

  @override
  String get dbPeakYears => '债务高峰年份';

  @override
  String get dbClearanceYears => '清偿年份';

  @override
  String get dbBorrowTitle => '智慧借贷指南';

  @override
  String get dbLoanSuitability => '贷款适宜度';

  @override
  String get dbBestLoanType => '最佳贷款类型';

  @override
  String get dbLeverageCeiling => '杠杆上限';

  @override
  String get dbNegotiationSuccess => '协商成功率';

  @override
  String get dbCreditorAggression => '债权人施压风险';

  @override
  String get dbLegalEscalation => '法律升级风险';

  @override
  String get dbNegotiationApproach => '推荐方式';

  @override
  String get dbAvoidLoanTypes => '应避免的贷款类型';

  @override
  String get dbRiskTitle => '风险与脆弱点关注';

  @override
  String get dbRiskDefault => '违约风险';

  @override
  String get dbRiskDefaultExp => '错过还款计划、严重到触发放款方违约认定的概率。';

  @override
  String get dbRiskDefaultFix => '设置最低还款自动扣款，并保留1个月的缓冲资金，以免一次收入中断引发连锁反应。';

  @override
  String get dbRiskBankruptcy => '破产风险';

  @override
  String get dbRiskBankruptcyExp => '债务负担增长到收入与资产实际无法覆盖的概率。';

  @override
  String get dbRiskBankruptcyFix => '在申请任何新贷款或信用额度前，先进行专业的债务评估。';

  @override
  String get dbRiskAssetSeizure => '资产被没收风险';

  @override
  String get dbRiskAssetSeizureExp => '抵押贷款违约导致放款方收回抵押品或房产的概率。';

  @override
  String get dbRiskAssetSeizureFix => '优先偿还有抵押的贷款，如预见还款缺口应尽早再融资。';

  @override
  String get dbRiskChronic => '长期再负债风险';

  @override
  String get dbRiskChronicExp => '即使清偿当前债务后，再次陷入债务的倾向。';

  @override
  String get dbRiskChronicFix => '在债务清偿后提高生活开支前，先建立专门的应急基金。';

  @override
  String get dbReindebtTrigger => '再负债诱因';

  @override
  String get dbCycleBreakFeasibility => '打破循环的可行性';

  @override
  String get dbMajorRisks => '主要风险';

  @override
  String get dbHiddenSignals => '隐藏的债务信号';

  @override
  String get dbCrisisTitle => '危机准备';

  @override
  String get dbCrisisSubtitle => '如何及早发现问题并冷静应对';

  @override
  String get dbWarningSigns => '早期预警信号';

  @override
  String get dbMitigationActions => '应对措施';

  @override
  String get dbFamilyTitle => '家庭与祖辈债务';

  @override
  String get dbInheritedDebtProb => '继承债务的概率';

  @override
  String get dbFamilyDrag => '家庭债务拖累';

  @override
  String get dbInheritedSource => '可能来源';

  @override
  String get dbCoreBlockerLabel => '核心阻碍';

  @override
  String get dbPsychologyTitle => '您的金钱心理';

  @override
  String get dbResilience => '韧性';

  @override
  String get dbDiscipline => '压力下的自律';

  @override
  String get dbSocialSupport => '社会支持';

  @override
  String get dbDepressionRisk => '财务压力脆弱度';

  @override
  String get dbStressTolerance => '压力承受度';

  @override
  String get dbRootCause => '行为根源';

  @override
  String get dbImprovementTitle => '改进计划';

  @override
  String get dbRoadmapTitle => '您的无债路线图';

  @override
  String get dbRecoveryProbability => '恢复概率';

  @override
  String get dbClearanceTimeline => '清偿时间线';

  @override
  String get dbYears => '年';

  @override
  String get dbDtiHealth => '债务收入比健康度';

  @override
  String get dbDtiCategory => '债务收入比类别';

  @override
  String get dbBreakEvenMonths => '收支平衡所需月数';

  @override
  String get dbIncomeAcceleration => '所需收入增长';

  @override
  String get dbLayerD1 => '本命盘（D1）';

  @override
  String get dbLayerD6 => '债务与仇敌盘（D6）';

  @override
  String get dbLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get dbLayerDasha => '大运时机';

  @override
  String get dbLayerTransit => '当前行运';

  @override
  String get dbTopicRecovery => '我的恢复时间线';

  @override
  String get dbTopicNegotiate => '与债权人协商';

  @override
  String get dbTopicBorrowing => '现在借贷是否安全';

  @override
  String get dbTopicCrisis => '为危机做准备';

  @override
  String get dbTopicAncestral => '祖辈债务业力';

  @override
  String get dbTopicTimeline => '清偿债务的最佳年份';

  @override
  String get dbTopicPsychology => '我的金钱心理';

  @override
  String get dbTopicCategories => '应优先处理哪些债务';

  @override
  String get mnSubtitle => 'AI驱动的吠陀身心健康报告';

  @override
  String get mnTitle => '心理与压力';

  @override
  String get mnSnapshotHeader => '身心健康概览';

  @override
  String get mnResilience => '韧性';

  @override
  String get mnStability => '稳定性';

  @override
  String get mnEmotionalBalance => '情绪平衡';

  @override
  String get mnInnerCalm => '内在平静';

  @override
  String get mnSelfAwareness => '自我觉察力';

  @override
  String get mnStatusThriving => '蓬勃向上';

  @override
  String get mnStatusSteady => '稳定平和';

  @override
  String get mnStatusBuildingStrength => '正在积蓄力量';

  @override
  String get mnStatusNeedsGentleCare => '需要温和照顾';

  @override
  String get mnStatusReachOut => '是时候寻求支持了';

  @override
  String get mnChipStable => '情绪稳定';

  @override
  String get mnChipSupported => '支持充足';

  @override
  String get mnChipSelfAware => '高度自我觉察';

  @override
  String get mnChipResilient => '恢复力强';

  @override
  String get mnChipSecureAttachment => '安全型依恋';

  @override
  String get mnChipHealingReady => '已准备好疗愈';

  @override
  String get mnChipMindBodyBalance => '身心平衡';

  @override
  String get mnSupportBannerTitle => '温馨提示';

  @override
  String get mnSupportBannerBody =>
      '您的星盘显示，现在可能是寻求额外支持的好时机——无论是信任的朋友、家人还是专业人士。主动求助是坚强的表现，而非软弱。';

  @override
  String get mnProfileTitle => '您的情绪蓝图';

  @override
  String get mnStressDriver => '压力来源';

  @override
  String get mnStabilityAnchor => '稳定之锚';

  @override
  String get mnSoulLevelKarma => '灵魂层面的模式';

  @override
  String get mnSubtleSignature => '微妙的情绪印记';

  @override
  String get mnKarakaTitle => '您的心智与行星';

  @override
  String get mnKarakaSubtitle => '哪些行星塑造了您的内心世界';

  @override
  String get mnYogasTitle => '优势与成长领域';

  @override
  String get mnCurrentPhase => '当前阶段';

  @override
  String get mnCurrentStressLevel => '当前压力水平';

  @override
  String get mnRecentStrain => '近期情绪压力';

  @override
  String get mnStrengths => '优势';

  @override
  String get mnGrowthAreas => '成长领域';

  @override
  String get mnSadeSatiStatus => '土星七返状态';

  @override
  String get mnVerificationTitle => '跨星盘验证';

  @override
  String get mnD9Confirmation => 'D9验证';

  @override
  String get mnD30Confirmation => 'D30验证';

  @override
  String get mnMoodPatternsTitle => '情绪与焦虑模式';

  @override
  String get mnMoodPatternsSubtitle => '温和的觉察，而非诊断';

  @override
  String get mnAnxietyPatterns => '焦虑模式';

  @override
  String get mnMoodPatterns => '低落情绪模式';

  @override
  String get mnPrimaryPattern => '主要模式';

  @override
  String get mnRumination => '过度思虑倾向';

  @override
  String get mnHypervigilance => '过度警觉';

  @override
  String get mnHopelessnessVuln => '低落情绪易感性';

  @override
  String get mnEnergyDepletion => '精力耗竭倾向';

  @override
  String get mnMotivationBaseline => '动力基线';

  @override
  String get mnRegulationTitle => '情绪调节与应对';

  @override
  String get mnEmotionalRegulation => '情绪调节能力';

  @override
  String get mnSelfSoothing => '自我安抚能力';

  @override
  String get mnExpressionStyle => '表达风格';

  @override
  String get mnRecoveryTime => '恢复时间';

  @override
  String get mnTriggerIntensity => '触发强度';

  @override
  String get mnHealthyCoping => '健康的应对习惯';

  @override
  String get mnWatchFor => '需温和留意的事项';

  @override
  String get mnSleepTitle => '睡眠与休息';

  @override
  String get mnSleepQuality => '睡眠质量';

  @override
  String get mnSleepAsRegulator => '睡眠作为情绪调节器';

  @override
  String get mnInsomniaTendency => '夜间不安倾向';

  @override
  String get mnNightmareTendency => '生动梦境倾向';

  @override
  String get mnSleepHygienePriority => '睡眠卫生优先度';

  @override
  String get mnBurnoutTitle => '职业倦怠与精力';

  @override
  String get mnBurnoutVulnerability => '职业倦怠易感性';

  @override
  String get mnBurnoutRecovery => '职业倦怠恢复能力';

  @override
  String get mnBurnoutStage => '当前倦怠阶段';

  @override
  String get mnSelfDrivingTendency => '自我驱动倾向';

  @override
  String get mnBurnoutTriggers => '职业倦怠诱因';

  @override
  String get mnConnectionTitle => '连接与支持';

  @override
  String get mnSocialSupport => '社会支持质量';

  @override
  String get mnLonelinessVuln => '孤独易感性';

  @override
  String get mnSolitudeNeed => '独处需求';

  @override
  String get mnSocialComfort => '社交自在度';

  @override
  String get mnTraumaSensitivity => '创伤敏感度';

  @override
  String get mnHealingReadiness => '疗愈准备度';

  @override
  String get mnProcessingStyle => '情绪处理方式';

  @override
  String get mnMindBodyIntegration => '身心整合度';

  @override
  String get mnPtsdVuln => '创伤反应敏感度';

  @override
  String get mnSelfAwarenessTitle => '自我觉察与成长';

  @override
  String get mnSelfAwarenessScore => '自我觉察力';

  @override
  String get mnEmotionalVocabulary => '情绪表达词汇量';

  @override
  String get mnTherapyReadiness => '心理治疗准备度';

  @override
  String get mnJournalingBenefit => '写日记的益处';

  @override
  String get mnInnerDialogue => '内心对话质量';

  @override
  String get mnAwarenessOfPatterns => '模式觉察力';

  @override
  String get mnEscapePatternVuln => '逃避模式易感性';

  @override
  String get mnEscapeChannels => '需温和留意的事项';

  @override
  String get mnHealthyAlternatives => '健康的替代方式';

  @override
  String get mnTherapyFitTitle => '心理治疗与支持适配度';

  @override
  String get mnCrisisSupportRec => '支持建议';

  @override
  String get mnSupportNetwork => '启动您的支持网络';

  @override
  String get mnSelfAdvocacy => '自我倡导准备度';

  @override
  String get mnMedicationReceptivity => '对药物治疗的接受度';

  @override
  String get mnTimelineTitle => '身心健康时间线';

  @override
  String get mnPeakWellnessYears => '身心健康巅峰年份';

  @override
  String get mnExtraCareYears => '需额外自我关怀的年份';

  @override
  String get mnTransformationWindows => '积极转变时段';

  @override
  String get mnTherapyWindow => '推荐的心理治疗时段';

  @override
  String get mnPracticesTitle => '日常身心健康练习';

  @override
  String get mnMorningPractices => '晨间练习';

  @override
  String get mnEveningPractices => '晚间练习';

  @override
  String get mnBreathwork => '呼吸练习';

  @override
  String get mnMovement => '运动';

  @override
  String get mnNutrition => '营养';

  @override
  String get mnNatureExposure => '接触自然的需求';

  @override
  String get mnDigitalDetox => '数字排毒需求';

  @override
  String get mnImprovementTitle => '改进计划';

  @override
  String get mnReliabilityTitle => '可靠性';

  @override
  String get mnLayerD1 => '本命盘（D1）';

  @override
  String get mnLayerD9 => '灵魂盘（D9）';

  @override
  String get mnLayerD30 => 'D30盘';

  @override
  String get mnLayerDasha => '大运时机';

  @override
  String get mnLayerTransit => '行运';

  @override
  String get mnTopicResilience => '我的情绪韧性如何？';

  @override
  String get mnTopicCoping => '我最好的应对策略是什么？';

  @override
  String get mnTopicSleep => '我该如何改善睡眠？';

  @override
  String get mnTopicBurnout => '我是否有职业倦怠的风险？';

  @override
  String get mnTopicTherapy => '哪种心理治疗方式适合我？';

  @override
  String get mnTopicPractices => '哪些日常练习对我帮助最大？';

  @override
  String get mnTopicTiming => '我身心健康的最佳年份是什么时候？';

  @override
  String get mnTopicSupport => '我该如何建立强大的支持网络？';

  @override
  String get lgSubtitle => 'AI驱动的吠陀法律报告';

  @override
  String get lgTitle => '法律与纠纷';

  @override
  String get lgSnapshotHeader => '法律概览';

  @override
  String get lgResilience => '法律韧性';

  @override
  String get lgResolutionCapacity => '解决问题的能力';

  @override
  String get lgVictoryPotential => '胜诉潜力';

  @override
  String get lgLegalSafety => '法律安全度';

  @override
  String get lgNegotiationSkill => '谈判技巧';

  @override
  String get lgStatusExcellent => '极佳';

  @override
  String get lgStatusStrong => '较强';

  @override
  String get lgStatusModerate => '中等';

  @override
  String get lgStatusDeveloping => '发展中';

  @override
  String get lgStatusChallenging => '具有挑战性';

  @override
  String get lgChipResolver => '善于解决问题';

  @override
  String get lgChipWinner => '案件胜诉能力强';

  @override
  String get lgChipNegotiator => '天生的谈判高手';

  @override
  String get lgChipDocumented => '文档准备充分';

  @override
  String get lgChipLowRisk => '法律风险较低';

  @override
  String get lgChipMoralAuthority => '道德权威';

  @override
  String get lgChipLegalAptitude => '法律天赋';

  @override
  String get lgProfileTitle => '您的法律档案与业力';

  @override
  String get lgPrimaryDriver => '主要驱动力';

  @override
  String get lgDharmaAnchor => '达摩之锚';

  @override
  String get lgAggressionMarker => '攻击性指标';

  @override
  String get lgDocumentationKaraka => '文档质量';

  @override
  String get lgKarakaTitle => '您的法律行星';

  @override
  String get lgKarakaSubtitle => '哪些行星塑造了您的法律运势';

  @override
  String get lgYogasTitle => '法律瑜伽与保护力';

  @override
  String get lgCurrentPhase => '当前阶段';

  @override
  String get lgProtections => '保护因素';

  @override
  String get lgDisputePressures => '纠纷压力';

  @override
  String get lgVerificationTitle => '跨星盘验证';

  @override
  String get lgD6Litigation => 'D6诉讼盘';

  @override
  String get lgD9Dharma => 'D9达摩盘';

  @override
  String get lgMoralAuthority => '道德权威';

  @override
  String get lgVictoryTitle => '胜诉分析';

  @override
  String get lgAsPlaintiff => '作为原告';

  @override
  String get lgAsDefendant => '作为被告';

  @override
  String get lgSettlementPreference => '和解倾向';

  @override
  String get lgDisputeCategoriesTitle => '纠纷类别关注';

  @override
  String get lgLowRiskCategories => '低风险类别';

  @override
  String get lgConflictStyleTitle => '冲突风格与仇敌';

  @override
  String get lgConfrontationComfort => '面对冲突的自在度';

  @override
  String get lgArgumentPersuasiveness => '论证说服力';

  @override
  String get lgEmotionalRegulation => '情绪调节能力';

  @override
  String get lgGrudgeHolding => '记仇倾向';

  @override
  String get lgEnemyAnalysisLabel => '仇敌分析';

  @override
  String get lgVisibleEnemies => '明面仇敌';

  @override
  String get lgHiddenEnemies => '隐藏仇敌';

  @override
  String get lgWorkplaceEnemies => '职场仇敌';

  @override
  String get lgFamilyEnemies => '家庭内仇敌';

  @override
  String get lgLegalEnemies => '法律纠纷对手';

  @override
  String get lgEnemyDefeatCapacity => '战胜仇敌的能力';

  @override
  String get lgCriminalFinancialTitle => '刑事与财务风险关注';

  @override
  String get lgCriminalRisk => '涉刑风险';

  @override
  String get lgVictimOfCrime => '成为犯罪受害者的概率';

  @override
  String get lgFalseAccusation => '被诬告的风险';

  @override
  String get lgImprisonmentRisk => '监禁风险';

  @override
  String get lgTaxDisputeRisk => '税务纠纷风险';

  @override
  String get lgFinancialFraudRisk => '财务欺诈风险';

  @override
  String get lgBusinessLitigationRisk => '商业诉讼风险';

  @override
  String get lgBankruptcyRisk => '破产风险';

  @override
  String get lgAuditVulnerability => '被审计的脆弱性';

  @override
  String get lgProtectionPriority => '保护优先事项';

  @override
  String get lgContractsTitle => '合同与谈判';

  @override
  String get lgContractClarity => '合同清晰度';

  @override
  String get lgDocumentationDiscipline => '文档管理自律性';

  @override
  String get lgFinePrintAwareness => '细则条款的警觉性';

  @override
  String get lgSignatureCaution => '签署时的谨慎度';

  @override
  String get lgMediationReceptivity => '调解接受度';

  @override
  String get lgNegotiationSkillFull => '谈判技巧';

  @override
  String get lgCompromiseWillingness => '妥协意愿';

  @override
  String get lgFaceSavingNeeds => '保全颜面的需求';

  @override
  String get lgMediatorHireRecommendation => '聘请调解人建议';

  @override
  String get lgTypicalContractIssues => '常见合同问题';

  @override
  String get lgCareerFitTitle => '法律职业适配度';

  @override
  String get lgProfessionAffinity => '职业亲和度';

  @override
  String get lgRoleFit => '最适合的角色';

  @override
  String get lgLawStudentSuccess => '法学学业成功率';

  @override
  String get lgBarExamSuccess => '司法考试成功率';

  @override
  String get lgTimelineTitle => '法律时间线';

  @override
  String get lgNewMatterChance => '未来12个月新增法律事务的概率';

  @override
  String get lgOngoingCaseOutcome => '在办案件结果';

  @override
  String get lgRecommendedAction => '推荐行动';

  @override
  String get lgPeakDisputeYears => '纠纷高发年份';

  @override
  String get lgClarityYears => '法律明朗年份';

  @override
  String get lgAvoidancePeriods => '重点规避时段';

  @override
  String get lgFavorableWindows => '有利化解时段';

  @override
  String get lgRisksTitle => '风险与脆弱点';

  @override
  String get lgChronicVulnerabilities => '长期脆弱点';

  @override
  String get lgAvoidDashaPeriods => '需关注的大运时段';

  @override
  String get lgPreventivePriorities => '预防优先事项';

  @override
  String get lgRedFlags => '警示情形';

  @override
  String get lgImprovementTitle => '改进计划';

  @override
  String get lgReliabilityTitle => '可靠性';

  @override
  String get lgLayerD1 => '本命盘（D1）';

  @override
  String get lgLayerD6 => '诉讼盘（D6）';

  @override
  String get lgLayerD9 => '达摩盘（D9）';

  @override
  String get lgLayerDasha => '大运时机';

  @override
  String get lgLayerTransit => '行运';

  @override
  String get lgTopicWinChance => '我的胜诉几率有多大？';

  @override
  String get lgTopicStrategy => '适合我的最佳法律策略是什么？';

  @override
  String get lgTopicContract => '需要注意哪些合同风险？';

  @override
  String get lgTopicTiming => '解决纠纷的最佳时机是什么？';

  @override
  String get lgTopicSettlement => '我应该和解还是抗争？';

  @override
  String get lgTopicEnemies => '谁是我的隐藏仇敌？';

  @override
  String get lgTopicProtection => '我该如何在法律上保护自己？';

  @override
  String get lgTopicCareer => '我适合从事法律职业吗？';

  @override
  String get prSubtitle => 'AI驱动的吠陀财产报告';

  @override
  String get prTitle => '财产与资产';

  @override
  String get prSnapshotHeader => '财产概览';

  @override
  String get prAcquisitionCapacity => '置产能力';

  @override
  String get prHomeOwnership => '购房能力';

  @override
  String get prWealthPotential => '财富潜力';

  @override
  String get prRentalIncome => '租金收入';

  @override
  String get prLandOwnership => '土地拥有';

  @override
  String get prStatusExcellent => '极佳';

  @override
  String get prStatusStrong => '较强';

  @override
  String get prStatusModerate => '中等';

  @override
  String get prStatusDeveloping => '发展中';

  @override
  String get prStatusChallenging => '具有挑战性';

  @override
  String get prChipHomeOwner => '拥有住房';

  @override
  String get prChipWealthBuilder => '财富积累者';

  @override
  String get prChipLandOwner => '拥有土地';

  @override
  String get prChipInvestor => '房产投资者';

  @override
  String get prChipInheritance => '可能获得继承';

  @override
  String get prChipVehicle => '拥有车辆';

  @override
  String get prChipGlobalAsset => '海外资产亲和度';

  @override
  String get prProfileTitle => '您的置业风格';

  @override
  String get prHomeAesthetics => '居家美感';

  @override
  String get prHomeSanctuary => '居所作为心灵庇护所';

  @override
  String get prComfortInvestment => '舒适投入';

  @override
  String get prVastuPriority => '风水（Vastu）优先度';

  @override
  String get prNaturalElements => '自然元素偏好';

  @override
  String get prNextActionLabel => '下一步行动';

  @override
  String get prKarakaTitle => '您的财产行星';

  @override
  String get prKarakaSubtitle => '哪些行星塑造了您的房产运势';

  @override
  String get prPrimaryKaraka => '主要徵星';

  @override
  String get prDurableAsset => '耐用资产徵星';

  @override
  String get prYogasTitle => '房产瑜伽与缺陷';

  @override
  String get prCurrentPhase => '当前阶段';

  @override
  String get prBoosters => '助力因素';

  @override
  String get prDrains => '消耗因素';

  @override
  String get prVerificationTitle => '跨星盘验证';

  @override
  String get prD4Property => 'D4房产盘';

  @override
  String get prD16Vehicle => 'D16车辆盘';

  @override
  String get prVehicleFit => '车辆适配度';

  @override
  String get prJourneyTitle => '置产历程与时间线';

  @override
  String get prFirstHomeAge => '首套房年龄';

  @override
  String get prFirstHomeType => '首套房类型';

  @override
  String get prMultipleHomes => '多套房产';

  @override
  String get prNewPropertySoon => '近期添置新房产';

  @override
  String get prFirstMajorWindow => '首个重要时段';

  @override
  String get prBuyingWindow => '购置时段';

  @override
  String get prConstructionWindow => '建造时段';

  @override
  String get prNextOpportunity => '下一次机会';

  @override
  String get prLifetimePropertyCount => '一生房产数量';

  @override
  String get prInheritanceTitle => '继承与家庭财产';

  @override
  String get prMaternalInheritance => '母系继承';

  @override
  String get prPaternalInheritance => '父系继承';

  @override
  String get prAncestralProperty => '祖产';

  @override
  String get prFamilyDisputeRisk => '家庭财产纠纷风险';

  @override
  String get prInheritanceTiming => '继承时机';

  @override
  String get prInheritanceType => '继承类型';

  @override
  String get prLandInvestTitle => '土地、投资与海外房产';

  @override
  String get prPropertyInvestor => '房产投资者评分';

  @override
  String get prAppreciationLuck => '增值运';

  @override
  String get prInvestorMindset => '投资者心态';

  @override
  String get prLandType => '土地类型';

  @override
  String get prRentalCount => '出租房产数量';

  @override
  String get prMultipleLand => '多块地产';

  @override
  String get prFarmEstate => '农场/庄园机会';

  @override
  String get prGlobalPropertyLabel => '海外房产';

  @override
  String get prForeignProperty => '境外房产';

  @override
  String get prNriAffinity => '海外印度人（NRI）资产亲和度';

  @override
  String get prVehiclesTitle => '车辆';

  @override
  String get prVehicleCount => '车辆数量';

  @override
  String get prVehicleFirstAge => '首辆车年龄';

  @override
  String get prVehicleCategory => '车辆类别';

  @override
  String get prVehicleQuality => '车辆品质';

  @override
  String get prLuxuryAffinity => '奢华偏好';

  @override
  String get prVehicleLossRisk => '车辆丢失/损坏风险';

  @override
  String get prLegalRiskTitle => '法律与风险关注';

  @override
  String get prBoundaryDisputes => '边界纠纷';

  @override
  String get prPartitionDisputes => '分割纠纷';

  @override
  String get prTitleIssues => '产权/文件问题';

  @override
  String get prTenantConflict => '租户与房东冲突';

  @override
  String get prForcedSale => '被迫出售风险';

  @override
  String get prPropertyDamage => '财产损坏风险';

  @override
  String get prInsurancePriority => '保险优先度';

  @override
  String get prProtectionUrgency => '保护紧迫性';

  @override
  String get prProtectiveFactors => '保护因素';

  @override
  String get prChronicVulnerabilities => '长期脆弱点';

  @override
  String get prDueDiligenceTitle => '尽职调查清单';

  @override
  String get prPreventiveMeasures => '预防措施';

  @override
  String get prImprovementTitle => '改进计划';

  @override
  String get prReliabilityTitle => '可靠性';

  @override
  String get prLayerD1 => '本命盘（D1）';

  @override
  String get prLayerD4 => '房产盘（D4）';

  @override
  String get prLayerD16 => '车辆盘（D16）';

  @override
  String get prLayerDasha => '大运时机';

  @override
  String get prLayerTransit => '行运';

  @override
  String get prTopicBuying => '最佳购置时机是什么时候？';

  @override
  String get prTopicInherit => '我会继承财产吗？';

  @override
  String get prTopicVehicle => '我什么时候会拥有车辆？';

  @override
  String get prTopicRental => '租金收入潜力如何？';

  @override
  String get prTopicLand => '拥有土地的机会有多大？';

  @override
  String get prTopicLegal => '需要注意哪些法律风险？';

  @override
  String get prTopicForeign => '拥有海外房产的机会有多大？';

  @override
  String get prTopicTiming => '置产的最佳时机窗口是什么？';

  @override
  String get edTitle => '教育与学习分析';

  @override
  String get edSubtitle => 'AI驱动的吠陀教育报告';

  @override
  String get edSnapshotHeader => '您的教育概览';

  @override
  String get edOverallStrength => '整体实力';

  @override
  String get edAcademicSuccess => '学业成就';

  @override
  String get edLearningCapacity => '学习能力';

  @override
  String get edIntellect => '智力';

  @override
  String get edMemory => '记忆力';

  @override
  String get edStatusExcellent => '潜力极佳';

  @override
  String get edStatusStrong => '潜力较强';

  @override
  String get edStatusModerate => '潜力中等';

  @override
  String get edStatusDeveloping => '潜力发展中';

  @override
  String get edStatusChallenging => '挑战阶段';

  @override
  String get edChipSaraswati => '妙音天女瑜伽（Saraswati Yoga）';

  @override
  String get edChipGajaKesari => '象狮瑜伽（Gaja Kesari Yoga）';

  @override
  String get edChipBudhaAditya => '水星-太阳瑜伽（Budha Aditya Yoga）';

  @override
  String get edChipResearch => '研究能力强';

  @override
  String get edChipScholarship => '奖学金潜力';

  @override
  String get edChipDoctorate => '博士学位潜力';

  @override
  String get edChipForeign => '海外留学支持力';

  @override
  String get edChipLifelong => '终身学习者';

  @override
  String get edLearningStyleTitle => '您的学习风格';

  @override
  String get edSoulPlanet => '灵魂行星';

  @override
  String get edSoulHint => '您内心最深处的驱动力与人生使命';

  @override
  String get edSubjectPlanet => '学科行星';

  @override
  String get edTechAtmakaraka => '灵魂行星（Atmakaraka，技术性）';

  @override
  String get edTechAmatyakaraka => '事业徵星（Amatyakaraka，技术性）';

  @override
  String get edSubjectKarakaStrength => '学科徵星强度';

  @override
  String get edFoundationTitle => '教育基础';

  @override
  String get edHouse4 => '早期教育';

  @override
  String get edHouse5 => '智力';

  @override
  String get edHouse9 => '高等教育';

  @override
  String get edPurvaPunya => '前世福报';

  @override
  String get edStudyPlanetsTitle => '您的学习行星';

  @override
  String get edYogasTitle => '您星盘中的教育瑜伽';

  @override
  String get edYogaBudhaAditya => '水星-太阳瑜伽（Budha Aditya）';

  @override
  String get edYogaGajaKesari => '象狮瑜伽（Gaja Kesari）';

  @override
  String get edYogaSaraswati => '妙音天女瑜伽（Saraswati）';

  @override
  String get edYogaPresent => '存在';

  @override
  String get edYogaAbsent => '不存在';

  @override
  String get edYogaNoneNote => '没有经典教育瑜伽——成功来自持续的努力与自律。';

  @override
  String get edVerificationTitle => '跨星盘验证';

  @override
  String get edD24Learning => 'D24——深度学习盘';

  @override
  String get edD4Formal => 'D4——正规教育盘';

  @override
  String get edD9Dharma => 'D9——学习达摩盘';

  @override
  String get edD60Karma => 'D60——前世学习业力';

  @override
  String get edSubjectsTitle => '最适合您的学科';

  @override
  String get edSubjectsSubtitle => '按星盘亲和度排序';

  @override
  String get edLowAffinity => '亲和度较低的学科';

  @override
  String get edDegreesTitle => '学位与层次可能性';

  @override
  String get edExpectedLevel => '预期层次';

  @override
  String get edDegreeFormal => '正规学位';

  @override
  String get edDegreePostgrad => '研究生';

  @override
  String get edDegreeDoctorate => '博士';

  @override
  String get edDegreeForeign => '海外教育';

  @override
  String get edTimelineTitle => '学习时间线';

  @override
  String get edEarlySchooling => '早期教育时段';

  @override
  String get edHigherEducation => '高等教育时段';

  @override
  String get edPostgradResearch => '研究生/科研时段';

  @override
  String get edPeakLearningAge => '学习巅峰年龄';

  @override
  String get edPreferencesTitle => '学习偏好与支持';

  @override
  String get edPrefStudyMode => '学习方式';

  @override
  String get edPrefTiming => '最佳时间';

  @override
  String get edPrefEnvironment => '学习环境';

  @override
  String get edPrefLocation => '地点';

  @override
  String get edPrefForeign => '海外求学';

  @override
  String get edGuruRelationship => '师生（古鲁）关系';

  @override
  String get edMentorAvailability => '导师可得性';

  @override
  String get edPeerLearning => '同侪学习';

  @override
  String get edAuthorityDeference => '对权威的尊重';

  @override
  String get edStrengthsTitle => '优势与挑战';

  @override
  String get edCognitiveGifts => '认知天赋';

  @override
  String get edNaturalAbilities => '天生学习能力';

  @override
  String get edHiddenCapacities => '潜在能力';

  @override
  String get edConcentration => '专注力困难度';

  @override
  String get edBreakRisk => '学业中断风险';

  @override
  String get edDisciplineConsistency => '自律持续性';

  @override
  String get edScholarshipLikelihood => '获得奖学金的可能性';

  @override
  String get edCareerLinkTitle => '教育→职业路径';

  @override
  String get edDirectionRec => '推荐方向';

  @override
  String get edIntegrationStrategy => '融合策略';

  @override
  String get edCareerLinkage => '职业关联度';

  @override
  String get edAlignedSubjects => '与职业契合的学科';

  @override
  String get edDegreeUtility => '学位对职业的实用性';

  @override
  String get edImprovementTitle => '您的改进计划';

  @override
  String get edReliabilityTitle => '预测可靠性';

  @override
  String get edLayerD1 => '本命盘（D1）';

  @override
  String get edLayerD4 => '正规教育盘（D4）';

  @override
  String get edLayerD9 => '纳瓦姆萨盘（D9）';

  @override
  String get edLayerD24 => '深度学习盘（D24）';

  @override
  String get edLayerD60 => '前世学习盘（D60）';

  @override
  String get edLayerAmk => '学科徵星';

  @override
  String get edLayerMj => '水星-木星';

  @override
  String get edLayerDasha => '行星时机';

  @override
  String get edTopicSubjects => '最适合我的学科';

  @override
  String get edTopicDegree => '学位机会';

  @override
  String get edTopicAbroad => '海外求学';

  @override
  String get edTopicExam => '考试表现';

  @override
  String get edTopicHabits => '学习习惯';

  @override
  String get edTopicCareerLink => '教育与职业的关联';

  @override
  String get edTopicTiming => '教育时机窗口';

  @override
  String get edTopicScholarship => '奖学金机会';

  @override
  String get hwTitle => '健康与身心分析';

  @override
  String get hwSubtitle => 'AI驱动的吠陀健康与身心报告';

  @override
  String get hwSnapshotHeader => '您的健康概览';

  @override
  String get hwOverallVitality => '活力';

  @override
  String get hwImmunity => '免疫力';

  @override
  String get hwRecovery => '恢复力';

  @override
  String get hwMentalWellness => '心理健康';

  @override
  String get hwStressTolerance => '抗压能力';

  @override
  String get hwStatusThriving => '蓬勃向上';

  @override
  String get hwStatusGood => '活力良好';

  @override
  String get hwStatusBalanced => '均衡';

  @override
  String get hwStatusNeedsCare => '需要照顾';

  @override
  String get hwStatusNeedsAttention => '需要关注';

  @override
  String get hwChipImmunity => '免疫力强';

  @override
  String get hwChipRecovery => '恢复迅速';

  @override
  String get hwChipMentalBalance => '心态平衡';

  @override
  String get hwChipStressResilience => '抗压能力强';

  @override
  String get hwChipFertility => '生育力支持';

  @override
  String get hwChipWorkLife => '工作生活平衡良好';

  @override
  String get hwChipLowAddiction => '成瘾风险较低';

  @override
  String get hwConstitutionTitle => '您的体质类型';

  @override
  String get hwConstitutionSubtitle => '根据星盘推断的阿育吠陀体质';

  @override
  String get hwDominantDosha => '主导';

  @override
  String get hwSecondaryDosha => '次要';

  @override
  String get hwPrimaryKaraka => '主要健康指标';

  @override
  String get hwStrongestSystem => '最强系统';

  @override
  String get hwWeakestSystem => '需支持的系统';

  @override
  String get hwBodyMapTitle => '您身体的行星图谱';

  @override
  String get hwBodyMapSubtitle => '9大行星，9大身体系统';

  @override
  String get hwYogaTitle => '您星盘中的健康模式';

  @override
  String get hwYogaSubtitle => '保护性瑜伽与致病压力瑜伽';

  @override
  String get hwDiseasePressureLabel => '疾病压力';

  @override
  String get hwAreasTitle => '需要关注的身体部位';

  @override
  String get hwAreasSubtitle => '各身体区域的脆弱度';

  @override
  String get hwProtectedAreas => '受保护较好的部位';

  @override
  String get hwCategoriesTitle => '疾病类别关注';

  @override
  String get hwCategoriesSubtitle => '主要健康类别的易感性';

  @override
  String get hwLowRiskCategories => '低风险类别';

  @override
  String get hwMentalTitle => '心理与情绪健康';

  @override
  String get hwMentalSubtitle => '情绪韧性与支持需求';

  @override
  String get hwMentalVulnerability => '情绪敏感度';

  @override
  String get hwEmotionalRegulation => '情绪调节能力';

  @override
  String get hwSupportRec => '支持建议';

  @override
  String get hwTendencies => '心理倾向';

  @override
  String get hwTimelineTitle => '健康时间线';

  @override
  String get hwTimelineSubtitle => '巅峰年份、需谨慎年份与恢复时段';

  @override
  String get hwPeakYears => '健康巅峰年份';

  @override
  String get hwCautionYears => '需谨慎年份';

  @override
  String get hwRecoveryWindow => '恢复时段';

  @override
  String get hwCheckupYears => '推荐体检年份';

  @override
  String get hwCurrentPhase => '当前阶段';

  @override
  String get hwLifestyleTitle => '您的生活方式指南';

  @override
  String get hwLifestyleSubtitle => '您的星盘揭示的日常习惯';

  @override
  String get hwSleepDiscipline => '睡眠自律的影响';

  @override
  String get hwDietDiscipline => '饮食自律的影响';

  @override
  String get hwExerciseNeed => '运动需求';

  @override
  String get hwSunlightNeed => '日照需求';

  @override
  String get hwStressSusceptibility => '压力易感性';

  @override
  String get hwHydrationSensitivity => '水分敏感度';

  @override
  String get hwSocialType => '社交能量类型';

  @override
  String get hwHealingSpeed => '疗愈速度';

  @override
  String get hwTreatmentResponse => '治疗反应';

  @override
  String get hwAltHealing => '替代疗法亲和度';

  @override
  String get hwSpecialTitle => '人生阶段与特殊议题';

  @override
  String get hwSpecialSubtitle => '生育力、童年健康、习惯与职业倦怠';

  @override
  String get hwFertility => '生育力指标';

  @override
  String get hwHormonalBalance => '荷尔蒙平衡';

  @override
  String get hwReproductiveStrength => '生殖系统强度';

  @override
  String get hwChildhoodVuln => '童年健康脆弱度';

  @override
  String get hwChildhoodStatus => '童年健康状况';

  @override
  String get hwAddictionVuln => '成瘾脆弱度';

  @override
  String get hwAddictionRecovery => '恢复能力';

  @override
  String get hwBurnoutVuln => '职业倦怠脆弱度';

  @override
  String get hwWorkLifeBalance => '工作生活平衡';

  @override
  String get hwStressTriggers => '压力诱因';

  @override
  String get hwProtectiveFactors => '保护因素';

  @override
  String get hwChallengesTitle => '需要关注的挑战';

  @override
  String get hwChallengesSubtitle => '预防保健的重点方向';

  @override
  String get hwMitigation => '应对方法';

  @override
  String get hwChronicAreas => '长期脆弱部位';

  @override
  String get hwPreventivePriorities => '预防优先事项';

  @override
  String get hwImprovementTitle => '您的健康计划';

  @override
  String get hwImprovementSubtitle => '实用步骤与传统疗法';

  @override
  String get hwReliabilityTitle => '解读可靠性';

  @override
  String get hwLayerD1 => '本命盘（D1）';

  @override
  String get hwLayerD6 => '健康盘（D6）';

  @override
  String get hwLayerD30 => '微观健康盘（D30）';

  @override
  String get hwLayerDasha => '行星时机';

  @override
  String get hwLayerTransit => '当前行运';

  @override
  String get hwDisclaimerLabel => '医疗免责声明';

  @override
  String get hwTopicImmunity => '提升免疫力';

  @override
  String get hwTopicSleep => '睡眠与休息';

  @override
  String get hwTopicStress => '管理压力';

  @override
  String get hwTopicFertility => '生育时机';

  @override
  String get hwTopicDiet => '饮食与营养';

  @override
  String get hwTopicTiming => '健康时机窗口';

  @override
  String get hwTopicMental => '心理健康';

  @override
  String get hwTopicPrevention => '预防保健计划';

  @override
  String get lvSubtitle => 'AI驱动的吠陀爱情报告';

  @override
  String get lvTitle => '爱情与人际关系';

  @override
  String get lvLovePotential => '爱情潜力';

  @override
  String get lvEmotionalAvail => '情感开放度';

  @override
  String get lvAttraction => '吸引力';

  @override
  String get lvCommitment => '承诺度';

  @override
  String get lvCommunication => '沟通能力';

  @override
  String get lvFidelity => '忠诚度';

  @override
  String get lvChipLoyal => '忠诚之心';

  @override
  String get lvChipOpenHeart => '心胸开阔';

  @override
  String get lvChipCommunicator => '沟通高手';

  @override
  String get lvChipMature => '善于处理冲突';

  @override
  String get lvChipEmotionallyWise => '情感成熟睿智';

  @override
  String get lvLoveStyle => '您的爱情风格';

  @override
  String get lvAttractionStyle => '吸引风格';

  @override
  String get lvLangGiven => '您表达爱的方式';

  @override
  String get lvLangReceived => '您感受到爱的方式';

  @override
  String get lvLovePlanets => '您的爱情行星';

  @override
  String get lvLoveKaraka => '爱情';

  @override
  String get lvEmotionKaraka => '情感';

  @override
  String get lvPassionKaraka => '激情';

  @override
  String get lvPathToLove => '您通往爱情的道路';

  @override
  String get lvPathSub => '自由恋爱与包办婚姻';

  @override
  String get lvLoveMarriage => '自由恋爱婚姻';

  @override
  String get lvArrangedMarriage => '包办婚姻';

  @override
  String get lvParentalAccept => '父母接受度';

  @override
  String get lvInterCaste => '跨种姓/宗教联姻';

  @override
  String get lvIdealPartner => '您的理想伴侣';

  @override
  String get lvPersonality => '性格';

  @override
  String get lvAppearance => '外貌';

  @override
  String get lvIdealTraits => '理想特质';

  @override
  String get lvWhatMatters => '最重要的事';

  @override
  String get lvDrawnTo => '会被吸引的类型';

  @override
  String get lvDealbreakers => '无法接受的底线';

  @override
  String get lvYourAppeal => '您的魅力所在';

  @override
  String get lvLoveStory => '您的爱情故事';

  @override
  String get lvLoveStorySub => '关系模式';

  @override
  String get lvFirstLove => '初恋';

  @override
  String get lvRelationCount => '重要感情关系';

  @override
  String get lvDuration => '典型持续时间';

  @override
  String get lvDepth => '情感深度';

  @override
  String get lvDatingPattern => '恋爱模式';

  @override
  String get lvCommitIntimacy => '承诺与亲密关系';

  @override
  String get lvCommitReady => '承诺准备度';

  @override
  String get lvIntimacyDrive => '亲密渴望度';

  @override
  String get lvSensuality => '感官魅力';

  @override
  String get lvEmpathy => '同理心';

  @override
  String get lvCommitStyle => '承诺风格';

  @override
  String get lvChemistry => '化学反应风格';

  @override
  String get lvMakesCommit => '促使您承诺的因素';

  @override
  String get lvMakesFlee => '让您却步的因素';

  @override
  String get lvEmotional => '情商';

  @override
  String get lvEmotionalIQ => '情商指数';

  @override
  String get lvConflictStyle => '冲突应对风格';

  @override
  String get lvTiming => '爱情时机';

  @override
  String get lvNewLove12 => '12个月内出现新恋情';

  @override
  String get lvEnergyNow => '当前能量';

  @override
  String get lvPhaseNow => '当前阶段';

  @override
  String get lvPeakRomance => '浪漫巅峰年份';

  @override
  String get lvNewLoveWindow => '新恋情时段';

  @override
  String get lvChallenges => '需要关注的挑战';

  @override
  String get lvRiskHeartbreak => '心碎易感度';

  @override
  String get lvRiskSabotage => '自我破坏';

  @override
  String get lvRiskCommitFear => '承诺恐惧';

  @override
  String get lvRiskRepeat => '重复模式';

  @override
  String get lvRiskWorkaholic => '重事业轻爱情';

  @override
  String get lvRedFlags => '需要留意的警示信号';

  @override
  String get lvHealing => '需要疗愈的地方';

  @override
  String get lvFocusArea => '重点关注领域';

  @override
  String get lvHealDir => '疗愈方向';

  @override
  String get lvImprovementPlan => '改进计划';

  @override
  String get lvReliability => '预测可靠性';

  @override
  String get lvLayerBirth => '本命盘（D1）';

  @override
  String get lvLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get lvLayerSaptamsa => '萨普塔姆萨盘（D7）';

  @override
  String get lvLayerDasha => '大运时机';

  @override
  String get lvLayerTransit => '当前行运';

  @override
  String get lvTopicWhen => '我什么时候能找到爱情？';

  @override
  String get lvTopicSoulmate => '关于我的灵魂伴侣';

  @override
  String get lvTopicCurrent => '我目前的感情关系';

  @override
  String get lvTopicHeal => '从过去中疗愈';

  @override
  String get lvTopicCommit => '承诺方面的帮助';

  @override
  String get lvTopicLoveVsArranged => '自由恋爱与包办婚姻';

  @override
  String get lvTopicHeartbreak => '避免心碎';

  @override
  String get lvTopicConfidence => '爱情中的自信';

  @override
  String get mrSubtitle => 'AI驱动的吠陀婚姻报告';

  @override
  String get mrTitle => '婚姻与家庭';

  @override
  String get mrMarriagePotential => '婚姻潜力';

  @override
  String get mrHarmony => '和谐度';

  @override
  String get mrLongevity => '长久度';

  @override
  String get mrSatisfaction => '满意度';

  @override
  String get mrStability => '家庭稳定性';

  @override
  String get mrClarity => '清晰度';

  @override
  String get mrChipHarmony => '和谐的纽带';

  @override
  String get mrChipNoMangal => '无火星缺陷（Mangal Dosh）';

  @override
  String get mrChipLongLasting => '持久稳固';

  @override
  String get mrChipHome => '有望拥有自己的住所';

  @override
  String get mrChipInLaws => '姻亲关系良好';

  @override
  String get mrChipChildren => '子女有福';

  @override
  String get mrSpouse => '您未来的配偶';

  @override
  String get mrSpouseSub => '星盘所揭示的信息';

  @override
  String get mrSpouseTraits => '可能的性格';

  @override
  String get mrSpouseWork => '可能的职业';

  @override
  String get mrAgeDiff => '年龄差';

  @override
  String get mrCulture => '文化契合度';

  @override
  String get mrEducation => '教育背景';

  @override
  String get mrFamilyBg => '家庭背景';

  @override
  String get mrSoulPartnership => '灵魂与伴侣关系';

  @override
  String get mrSelfPlanet => '您在关系中的样子';

  @override
  String get mrSpousePlanet => '您的配偶行星';

  @override
  String get mrSoulAlignment => '灵魂契合度';

  @override
  String get mrAlignStrong => '您的灵魂与理想伴侣高度契合——这有力支持了一段深刻圆满的感情关系。';

  @override
  String get mrAlignModerate => '您的灵魂与理想伴侣中等契合——通过用心经营，圆满的感情关系会逐渐成长。';

  @override
  String get mrAlignLow => '您的灵魂与伴侣关系需要有意识地融合——请选择真正符合您内在价值观的伴侣。';

  @override
  String get mrTechDarakaraka => '配偶行星（Darakaraka）';

  @override
  String get mrUpapada => '婚姻点（Upapada）';

  @override
  String get mrUpapadaLord => '副宫（Upapada）主星';

  @override
  String get mrFoundation => '婚姻基础';

  @override
  String get mrMarriageSign => '婚姻星座';

  @override
  String get mrMarriageLord => '婚姻主星';

  @override
  String get mrHouseStrength => '宫位强度';

  @override
  String get mrPartnerHint => '星盘中的伴侣提示';

  @override
  String get mrHarmonyHdr => '合盘和谐度';

  @override
  String get mrHarmonySub => '你们的连接方式';

  @override
  String get mrEmotional => '情感层面';

  @override
  String get mrIntellectual => '智识层面';

  @override
  String get mrPhysical => '身体亲密';

  @override
  String get mrFinancial => '财务层面';

  @override
  String get mrCommunication => '沟通';

  @override
  String get mrSharedValues => '共同价值观';

  @override
  String get mrSpiritual => '灵性层面';

  @override
  String get mrConflictRes => '冲突化解';

  @override
  String get mrTiming => '婚姻时机';

  @override
  String get mrFirstMarriageAge => '可能的结婚年龄';

  @override
  String get mrDelayChance => '延迟概率';

  @override
  String get mrMarriageWindow => '结婚时段';

  @override
  String get mrSecondaryWindow => '备选时段';

  @override
  String get mrCurrentReadiness => '当前状态';

  @override
  String get mrJourney => '婚姻历程';

  @override
  String get mrJourneySub => '关系的演变方式';

  @override
  String get mrPhaseEarly => '初期';

  @override
  String get mrPhaseMid => '中期';

  @override
  String get mrPhaseMature => '成熟期';

  @override
  String get mrPhaseLate => '晚期';

  @override
  String get mrTip => '提示';

  @override
  String get mrFamilyHome => '家庭与住所';

  @override
  String get mrInLaws => '姻亲关系';

  @override
  String get mrFamilyHarmony => '家庭和谐';

  @override
  String get mrHomeOwnership => '购房能力';

  @override
  String get mrDomesticPeace => '家庭安宁';

  @override
  String get mrFertility => '生育力';

  @override
  String get mrParenting => '育儿和谐度';

  @override
  String get mrChildren => '子女';

  @override
  String get mrLikelyCount => '可能数量';

  @override
  String get mrVerification => '跨星盘验证';

  @override
  String get mrD9 => '婚姻盘（D9）';

  @override
  String get mrD10 => '事业-配偶盘（D10）';

  @override
  String get mrD60 => '业力盘（D60）';

  @override
  String get mrChallenges => '需要关注的挑战';

  @override
  String get mrMangalPresent => '星盘中存在火星缺陷（Mangal Dosh）——请仔细核对补救方法与合婚匹配。';

  @override
  String get mrMangalAbsent => '未检测到火星缺陷——这是有利于婚姻的迹象。';

  @override
  String get mrRiskConflict => '冲突';

  @override
  String get mrRiskSeparation => '分离';

  @override
  String get mrRiskDistance => '情感疏离';

  @override
  String get mrRiskInfidelity => '不忠';

  @override
  String get mrRiskFinance => '财务分歧';

  @override
  String get mrPartnerGuide => '伴侣指南';

  @override
  String get mrPartnerGuideSub => '需要留意的要点';

  @override
  String get mrSeek => '寻找';

  @override
  String get mrMatchingPriorities => '合婚优先事项';

  @override
  String get mrImprovementPlan => '改进计划';

  @override
  String get mrReliability => '预测可靠性';

  @override
  String get mrLayerBirth => '本命盘（D1）';

  @override
  String get mrLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get mrLayerDashamsa => '达萨姆萨盘（D10）';

  @override
  String get mrLayerShashtiamsa => '业力盘（D60）';

  @override
  String get mrLayerDarakaraka => '配偶行星';

  @override
  String get mrTopicWhen => '我什么时候结婚？';

  @override
  String get mrTopicSpouse => '关于我的配偶';

  @override
  String get mrTopicCompat => '合盘建议';

  @override
  String get mrTopicDelay => '婚姻延迟';

  @override
  String get mrTopicMangal => '火星缺陷（Mangal Dosh）';

  @override
  String get mrTopicChildren => '生育时机';

  @override
  String get mrTopicInLaws => '姻亲关系';

  @override
  String get mrTopicHarmony => '建立和谐关系';

  @override
  String get wlSubtitle => 'AI驱动的吠陀财富报告';

  @override
  String get wlTitle => '财富与财务';

  @override
  String get wlWealthPotential => '财富潜力';

  @override
  String get wlAccumulation => '积累能力';

  @override
  String get wlIncomeFlow => '收入流';

  @override
  String get wlRetention => '留存能力';

  @override
  String get wlSustainability => '可持续性';

  @override
  String get wlSavings => '储蓄自律';

  @override
  String get wlChipSaver => '天生善于储蓄';

  @override
  String get wlChipMultiIncome => '多元收入';

  @override
  String get wlChipStrongYogas => '财富瑜伽';

  @override
  String get wlChipLowDebt => '低负债';

  @override
  String get wlChipInheritance => '可能获得继承';

  @override
  String get wlChipInvestor => '精明的投资者';

  @override
  String get wlWealthClass => '财富等级';

  @override
  String get wlWealthType => '主要财富类型';

  @override
  String get wlPrimarySource => '主要收入来源';

  @override
  String get wlPeakAge => '财富巅峰年龄';

  @override
  String get wlBoosters => '助推您财富的因素';

  @override
  String get wlBoostersSub => '强大的财富组合';

  @override
  String get wlWealthImpact => '加成';

  @override
  String get wlDrains => '财富消耗因素';

  @override
  String get wlIncomeSources => '收入来源';

  @override
  String get wlIncomeSourcesSub => '您的收入来源';

  @override
  String get wlPrimary => '主要';

  @override
  String get wlInvestment => '投资计划';

  @override
  String get wlInvestmentSub => '理想资产配置';

  @override
  String get wlRiskAppetite => '风险偏好';

  @override
  String get wlInvestStyle => '投资风格';

  @override
  String get wlDrivenBy => '驱动因素';

  @override
  String get wlMoneyPersonality => '金钱性格';

  @override
  String get wlMoneyType => '金钱类型';

  @override
  String get wlSpending => '消费习惯';

  @override
  String get wlSavingsDiscipline => '储蓄自律';

  @override
  String get wlCharity => '慈善倾向';

  @override
  String get wlLuxury => '奢侈消费';

  @override
  String get wlWindfalls => '意外之财与机遇';

  @override
  String get wlWindfallsSub => '基于运气的财富';

  @override
  String get wlInheritanceChance => '继承';

  @override
  String get wlSuddenGains => '意外获利';

  @override
  String get wlLottery => '彩票/投机';

  @override
  String get wlInsurance => '保险理赔';

  @override
  String get wlWindfallSource => '可能的意外之财来源';

  @override
  String get wlMoneyPlanets => '您的财富行星';

  @override
  String get wlPrimaryKaraka => '主要财富行星';

  @override
  String get wlSecondaryKaraka => '次要财富行星';

  @override
  String get wlTimeline => '财富时间线';

  @override
  String get wlPeakYears => '巅峰年份';

  @override
  String get wlGoodPeriod => '繁荣时期';

  @override
  String get wlSuddenGainWindow => '意外获利时段';

  @override
  String get wlToughPeriod => '需谨慎时期';

  @override
  String get wlDebtRisks => '债务与财务风险';

  @override
  String get wlDebtChance => '负债可能性';

  @override
  String get wlLoanBurden => '贷款负担';

  @override
  String get wlDrainSources => '需要留意';

  @override
  String get wlStrengthen => '需要加强的方面';

  @override
  String get wlWeakestDriver => '最薄弱的财富驱动因素';

  @override
  String get wlHowToFix => '如何加强';

  @override
  String get wlImprovementPlan => '改进计划';

  @override
  String get wlReliability => '预测可靠性';

  @override
  String get wlLayerBirth => '财富宫位（D1）';

  @override
  String get wlLayerHora => '霍拉盘（D2）';

  @override
  String get wlLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get wlLayerDasha => '大运时机';

  @override
  String get wlLayerTransit => '当前行运';

  @override
  String get wlTopicGrow => '如何增长财富';

  @override
  String get wlTopicInvest => '在哪里投资';

  @override
  String get wlTopicDebt => '管理债务';

  @override
  String get wlTopicProperty => '购置房产';

  @override
  String get wlTopicRetire => '退休规划';

  @override
  String get wlTopicPassive => '被动收入';

  @override
  String get wlTopicWindfall => '意外获利';

  @override
  String get wlTopicTiming => '最佳理财时机';

  @override
  String get bzSubtitle => 'AI驱动的吠陀商业报告';

  @override
  String get bzTitle => '商业与创业';

  @override
  String get bzBusinessPotential => '商业潜力';

  @override
  String get bzEntrepreneurship => '创业精神';

  @override
  String get bzVenture => '创业成功率';

  @override
  String get bzWealth => '通过商业获得的财富';

  @override
  String get bzRiskAppetite => '风险偏好';

  @override
  String get bzLongevity => '持久度';

  @override
  String get bzChipWealthMagnet => '财富磁石';

  @override
  String get bzChipMoneyYoga => '财富瑜伽';

  @override
  String get bzChipLeadership => '领导力';

  @override
  String get bzChipPartnerFit => '极佳的合伙契合度';

  @override
  String get bzChipGains => '强劲收益';

  @override
  String get bzChipInvestor => '吸引投资者';

  @override
  String get bzChipFounder => '创始人思维';

  @override
  String get bzWhatsWorking => '对您有利的因素';

  @override
  String get bzWhatsWorkingSub => '您的商业天赋';

  @override
  String get bzClassicYogas => '经典财富组合';

  @override
  String get bzFounderType => '您的创始人类型';

  @override
  String get bzSoulBusiness => '灵魂与商业使命';

  @override
  String get bzSoulPlanet => '您的灵魂驱动力';

  @override
  String get bzBusinessPlanet => '您的商业头脑';

  @override
  String get bzDirectionStrength => '方向清晰度';

  @override
  String get bzAlignStrong => '您的灵魂使命与商业方向高度契合——创业对您而言自然且充满成就感。';

  @override
  String get bzAlignModerate => '您的灵魂使命与商业方向中等契合——当创业能体现您更深层的价值观时效果最好。';

  @override
  String get bzAlignLow => '您的灵魂使命与商业方向需要有意识地对齐——请选择真正契合真实自我的事业。';

  @override
  String get bzTechAtmakaraka => '灵魂行星（Atmakaraka）';

  @override
  String get bzTechAmatyakaraka => '商业行星（Amatyakaraka）';

  @override
  String get bzTechDarakaraka => '合伙人行星（Darakaraka）';

  @override
  String get bzFoundation => '商业基础';

  @override
  String get bzCareerHouse => '事业宫';

  @override
  String get bzGainsHouse => '收益宫';

  @override
  String get bzLord => '主星';

  @override
  String get bzGainsPotential => '收益潜力';

  @override
  String get bzNetwork => '人脉力量';

  @override
  String get bzRecovery => '恢复能力';

  @override
  String get bzVerification => '跨星盘验证';

  @override
  String get bzD10 => '事业盘（D10）';

  @override
  String get bzD11 => '收益盘（D11）';

  @override
  String get bzD9 => '使命盘（D9）';

  @override
  String get bzD60 => '业力盘（D60）';

  @override
  String get bzFounderSkills => '创始人技能';

  @override
  String get bzSkillStrategy => '战略思维';

  @override
  String get bzSkillExecution => '执行力';

  @override
  String get bzSkillPeople => '团队管理';

  @override
  String get bzSkillSales => '销售与说服力';

  @override
  String get bzSkillFinance => '财务敏锐度';

  @override
  String get bzSkillOps => '运营纪律';

  @override
  String get bzTopSkill => '最强技能';

  @override
  String get bzDomains => '最适合的商业领域';

  @override
  String get bzDomainsSub => '按天生契合度排序';

  @override
  String get bzFit => '契合度';

  @override
  String get bzBusinessStyleHdr => '经商风格';

  @override
  String get bzStyleService => '产品型与服务型';

  @override
  String get bzStyleMarket => '市场定位';

  @override
  String get bzStyleTech => '科技路线';

  @override
  String get bzStyleLeadership => '领导风格';

  @override
  String get bzStylePartnership => '独资或合伙';

  @override
  String get bzWhereBuild => '覆盖范围';

  @override
  String get bzExpansion => '扩张';

  @override
  String get bzSetup => '创业设置';

  @override
  String get bzPartnership => '合伙与团队';

  @override
  String get bzIdealCofounder => '理想联合创始人';

  @override
  String get bzPartnerViability => '合伙契合度';

  @override
  String get bzTeamBuilding => '团队建设';

  @override
  String get bzCofounderFit => '联合创始人契合度';

  @override
  String get bzAdvisorNetwork => '顾问网络';

  @override
  String get bzFunding => '融资与资金';

  @override
  String get bzRecommendedPath => '推荐融资路径';

  @override
  String get bzInvestorAttract => '投资者吸引力';

  @override
  String get bzFamilyBacking => '家庭支持';

  @override
  String get bzHybridViability => '工作与创业并行';

  @override
  String get bzFallback => '留职以作后盾';

  @override
  String get bzDebtStyle => '负债风格';

  @override
  String get bzTimeline => '创业时间线';

  @override
  String get bzCurrentPhase => '当前阶段';

  @override
  String get bzLaunchWindow => '启动时段';

  @override
  String get bzScaleWindow => '成长时段';

  @override
  String get bzPeakAge => '巅峰年份';

  @override
  String get bzChallenges => '需要关注的挑战';

  @override
  String get bzRiskFinancial => '财务损失';

  @override
  String get bzRiskBurnout => '职业倦怠';

  @override
  String get bzRiskTeam => '团队冲突';

  @override
  String get bzRiskLegal => '法律/监管';

  @override
  String get bzFinancialExp => '创业过程中因过度投资或现金流时机不当而导致资金损失的风险。';

  @override
  String get bzFinancialFix => '保留现金储备，精简起步，在扩大支出前先验证市场需求。';

  @override
  String get bzBurnoutExp => '长期过度拼搏会耗尽您的精力与专注力。';

  @override
  String get bzBurnoutFix => '保护休息时间，尽早授权，并将重大冲刺安排在有利时期。';

  @override
  String get bzTeamExp => '与联合创始人或员工的摩擦可能拖慢业务发展。';

  @override
  String get bzTeamFix => '以书面形式明确角色与期望，并经常沟通。';

  @override
  String get bzLegalExp => '合规、合同或监管问题可能造成阻碍。';

  @override
  String get bzLegalFix => '让合同经过审核，保持文件规范，并尽早咨询专业人士。';

  @override
  String get bzImprovementPlan => '改进计划';

  @override
  String get bzBestDirection => '最佳方向';

  @override
  String get bzStrategy => '创业策略';

  @override
  String get bzTopFields => '热门领域';

  @override
  String get bzEmploymentPath => '就业与创业';

  @override
  String get bzRoadmap => '成长路线图';

  @override
  String get bzRoadmapSub => '您的创业计划';

  @override
  String get bzReliability => '预测可靠性';

  @override
  String get bzLayerBirth => '本命盘（D1）';

  @override
  String get bzLayerNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get bzLayerDashamsa => '事业盘（D10）';

  @override
  String get bzLayerLabhamsa => '收益盘（D11）';

  @override
  String get bzLayerShashtiamsa => '业力盘（D60）';

  @override
  String get bzTopicStart => '我现在应该创业吗？';

  @override
  String get bzTopicIdea => '最佳创业点子';

  @override
  String get bzTopicPartner => '寻找联合创始人';

  @override
  String get bzTopicFunding => '如何融资';

  @override
  String get bzTopicScale => '何时扩张';

  @override
  String get bzTopicRisk => '管理风险';

  @override
  String get bzTopicJob => '就业与创业';

  @override
  String get bzTopicTiming => '最佳时机';

  @override
  String get crTitle => '事业与职业分析';

  @override
  String get crSubtitle => 'AI驱动的吠陀事业报告';

  @override
  String get crCrumbHome => '首页';

  @override
  String get crCrumbReports => '报告';

  @override
  String get crCareerPotential => '事业潜力';

  @override
  String get crStatusStrong => '潜力较强';

  @override
  String get crStatusGood => '潜力良好';

  @override
  String get crStatusModerate => '潜力中等';

  @override
  String get crStatusDeveloping => '潜力发展中';

  @override
  String get crStatusChallenging => '挑战阶段';

  @override
  String get crOverallCareer => '整体事业';

  @override
  String get crStability => '事业稳定性';

  @override
  String get crGrowth => '成长潜力';

  @override
  String get crRecognition => '认可度';

  @override
  String get crSatisfaction => '满意度';

  @override
  String get crChipLeadership => '领导力';

  @override
  String get crChipCreativity => '创造力';

  @override
  String get crChipBusiness => '商业才能';

  @override
  String get crChipStableIncome => '稳定收入';

  @override
  String get crChipLearning => '学习能力';

  @override
  String get crChipGrowth => '长期成长';

  @override
  String get crChipTechnical => '技术能力';

  @override
  String get crChipRecognition => '认可度';

  @override
  String get crTopInsights => '核心洞察';

  @override
  String get crWhatDefines => '是什么定义了您的事业？';

  @override
  String get crSoulCareer => '灵魂与事业使命';

  @override
  String get crSoulPlanet => '灵魂使命行星';

  @override
  String get crCareerPlanet => '事业行星';

  @override
  String get crMeaning => '含义';

  @override
  String get crAlignment => '灵魂与事业契合度';

  @override
  String get crAlignStrong => '您的天生兴趣与事业道路高度契合。';

  @override
  String get crAlignModerate => '您的天生兴趣与事业道路中等契合。';

  @override
  String get crAlignLow => '您的天生兴趣与事业道路需要有意识地对齐。';

  @override
  String get crTechAtmakaraka => '灵魂行星（Atmakaraka，灵魂指标）';

  @override
  String get crTechAmatyakaraka => '事业行星（Amatyakaraka，事业指标）';

  @override
  String get crDegrees => '度数';

  @override
  String get crDignity => '力量状态';

  @override
  String get crFoundation => '事业基础';

  @override
  String get crCareerSign => '事业星座';

  @override
  String get crCareerLord => '事业主星';

  @override
  String get crLordPosition => '主星位置';

  @override
  String get crCareerStrength => '事业强度';

  @override
  String get crProfStyle => '职业风格';

  @override
  String get crBestFields => '最佳领域';

  @override
  String get crTechnicalDetails => '技术细节';

  @override
  String get crHouseLabel => '宫位';

  @override
  String get crVerification => '跨星盘事业验证';

  @override
  String get crD10Career => 'D10 · 事业';

  @override
  String get crD9Purpose => 'D9 · 使命';

  @override
  String get crD60Karma => 'D60 · 业力';

  @override
  String get crStatusNeedsImprovement => '需要改进';

  @override
  String get crStatusWellAligned => '高度契合';

  @override
  String get crStatusStrongSupport => '强力支持';

  @override
  String get crStatusModerateSupport => '中等支持';

  @override
  String get crChartDetails => '技术性星盘细节';

  @override
  String get crPersonality => '您的事业性格';

  @override
  String get crGrowthAreas => '成长领域';

  @override
  String get crBestRoles => '最佳角色';

  @override
  String get crBestIndustries => '最佳行业';

  @override
  String get crEnvironment => '事业环境';

  @override
  String get crWorkStyle => '最佳工作方式';

  @override
  String get crEmployment => '受雇工作';

  @override
  String get crBusiness => '创业';

  @override
  String get crFreelance => '自由职业/咨询';

  @override
  String get crPortfolio => '混合组合';

  @override
  String get crLeadership => '领导力';

  @override
  String get crFit => '契合度';

  @override
  String get crBestFit => '最佳契合';

  @override
  String get crTimeline => '事业时间线';

  @override
  String get crPastPeak => '过去的巅峰';

  @override
  String get crPresentPhase => '当前阶段';

  @override
  String get crUpcoming => '即将到来的机遇';

  @override
  String get crFutureExpansion => '未来扩展';

  @override
  String get crRiskPeriod => '风险时期';

  @override
  String get crViewDasha => '行星运程（技术性）';

  @override
  String get crChallenges => '需要关注的挑战';

  @override
  String get crRiskBurnout => '职业倦怠';

  @override
  String get crRiskRecognition => '认可延迟';

  @override
  String get crRiskConflict => '职场冲突';

  @override
  String get crRiskFinancial => '财务不稳定';

  @override
  String get crRiskOverqual => '才能未被充分利用';

  @override
  String get crPrevention => '预防';

  @override
  String get crBurnoutExp => '长期高强度的阶段会逐渐消耗您的精力。';

  @override
  String get crBurnoutFix => '保护休息时间，设立边界，合理安排重大冲刺节奏。';

  @override
  String get crRecognitionExp => '回报与认可可能比您付出的努力来得慢。';

  @override
  String get crRecognitionFix => '记录成果，让上级看到您的贡献。';

  @override
  String get crConflictExp => '有时可能与同事或上级产生摩擦。';

  @override
  String get crConflictFix => '保持冷静沟通，明智地选择该坚持的事情。';

  @override
  String get crFinancialExp => '在某些阶段，收入可能会不稳定。';

  @override
  String get crFinancialFix => '保留缓冲资金，避免过度的财务承诺。';

  @override
  String get crOverqualExp => '您有时可能感到才能未被充分发挥或缺乏挑战。';

  @override
  String get crOverqualFix => '寻求更具挑战性的角色，持续学习以保持投入感。';

  @override
  String get crImprovementPlan => '事业改进计划';

  @override
  String get crCatPlanetary => '行星与灵性';

  @override
  String get crCatPractical => '实用步骤';

  @override
  String get crTraditionalExplain => '传统占星学解释';

  @override
  String get crActionPlan => '30天事业行动计划';

  @override
  String get crWeek1 => '第1周 · 优化个人档案';

  @override
  String get crWeek2 => '第2周 · 技能提升';

  @override
  String get crWeek3 => '第3周 · 人脉拓展';

  @override
  String get crWeek4 => '第4周 · 提升事业曝光度';

  @override
  String get crWeek1Tip => '围绕您最突出的事业主题，更新您的简历与领英（LinkedIn）资料。';

  @override
  String get crWeek2Tip => '在您最擅长的领域中选择一项高价值技能，每天练习。';

  @override
  String get crWeek3Tip => '与导师重新建立联系，并主动联系两位新的行业人脉。';

  @override
  String get crWeek4Tip => '公开分享您的工作成果，并主动承担一个有曝光度的项目。';

  @override
  String get crPriority => '优先级';

  @override
  String get crTimeRequired => '所需时间';

  @override
  String get crExpectedBenefit => '预期收益';

  @override
  String get crPriorityHigh => '高';

  @override
  String get crPriorityMedium => '中';

  @override
  String get crRoadmap => 'AI事业路线图';

  @override
  String get crNext12 => '未来12个月';

  @override
  String get crBestFocus => '最佳关注点';

  @override
  String get crSkillsLearn => '需要学习的技能';

  @override
  String get crIndustriesTarget => '目标行业';

  @override
  String get crExpectedOutcome => '预期成果';

  @override
  String get crReliability => '预测可靠性';

  @override
  String get crReliabilityHigh => '高可靠性';

  @override
  String get crReliabilityGood => '良好可靠性';

  @override
  String get crReliabilityModerate => '中等可靠性';

  @override
  String get crReliabilityExplain =>
      '本报告综合了您的本命盘、分盘及遮米尼（Jaimini）指标。此评分反映了各星盘层面的一致程度。';

  @override
  String get crChartLayers => '星盘层面与权重';

  @override
  String get crBirthChart => '本命盘（D1）';

  @override
  String get crNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get crDashamsa => '达萨姆萨盘（D10）';

  @override
  String get crShashtiamsa => '沙什提安萨盘（D60）';

  @override
  String get crDiscussAi => '与AI讨论';

  @override
  String get crAskAbout => '咨询关于';

  @override
  String get crTopicChange => '转行';

  @override
  String get crTopicGovt => '公职/政府工作';

  @override
  String get crTopicBusiness => '创业';

  @override
  String get crTopicPromotion => '晋升';

  @override
  String get crTopicMarriage => '婚姻与事业';

  @override
  String get crTopicAbroad => '海外发展';

  @override
  String get crTopicIncome => '收入';

  @override
  String get crTopicPurpose => '人生使命';

  @override
  String get crTopicResume => '简历';

  @override
  String get crTopicCopied => '问题已复制——请粘贴到AI聊天中。';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul引导您内心的召唤，而$career塑造您外在的职业。';
  }

  @override
  String get rzTodayOutlook => '今日星座运势';

  @override
  String get rzPlanetaryEnergy => '今日行星能量';

  @override
  String get rzBestSign => '最佳星座';

  @override
  String get rzChallengingSign => '最具挑战星座';

  @override
  String get rzDominantPlanet => '主导行星';

  @override
  String get rzOverallMood => '整体氛围';

  @override
  String get rzMoodBright => '明朗活跃';

  @override
  String get rzMoodCalm => '平静稳定';

  @override
  String get rzMoodMixed => '能量参差';

  @override
  String get rzMoodTense => '紧张需谨慎';

  @override
  String get rzTodayEnergy => '今日能量';

  @override
  String get rzCaution => '需谨慎';

  @override
  String get rzWeak => '较弱';

  @override
  String get rzAllSigns => '全部星座';

  @override
  String get rzAiSummary => 'AI摘要';

  @override
  String get rzPlanetaryInfluence => '今日行星影响';

  @override
  String get rzStrongInfluences => '强烈影响';

  @override
  String get rzShowTechnical => '显示技术细节';

  @override
  String get rzOpportunities => '今日机遇';

  @override
  String get rzAvoidTitle => '今日应避免之事';

  @override
  String get rzTechnicalReason => '技术原因';

  @override
  String get rzAvoidDecisions => '仓促做出重要决定';

  @override
  String get rzAvoidArguments => '激烈争执';

  @override
  String get rzAvoidInvestments => '大额投资';

  @override
  String get rzAvoidOverthink => '对小事过度思虑';

  @override
  String get rzAvoidOverspend => '不必要的花费';

  @override
  String get rzAvoidStress => '压力与过度劳累';

  @override
  String get rzPlanetaryChart => '今日行星星盘';

  @override
  String get rzWhatChartMeans => '此星盘的含义';

  @override
  String get rzChartExplain =>
      '这张菱形图显示了今天各行星在天空中的位置，并对应到您的星座。位于有利宫位的行星会提升您今天的运势；位于不利宫位的行星则需要多加留意。';

  @override
  String get rzDoNetworking => '社交与建立联系';

  @override
  String get rzDoLearning => '学习新事物';

  @override
  String get rzDoMeditation => '冥想与平静';

  @override
  String get rzDoFamily => '家庭时光';

  @override
  String get rzDoCreative => '创意工作';

  @override
  String get rzDoRest => '休息与自我照顾';

  @override
  String get rzAiRecommendations => '今日AI建议';

  @override
  String get rzTechnical => '技术性占星细节';

  @override
  String get rzTransitScore => '行运评分';

  @override
  String get rzVedha => '维达（Vedha，阻碍）';

  @override
  String get rzGocharDetails => '行运（Gochar）详情';

  @override
  String get rzAdvancedOnly => '适合进阶用户';

  @override
  String get rzTomorrow => '明日预览';

  @override
  String get rzTomorrowEnergy => '明日能量';

  @override
  String get rzImproving => '逐渐好转';

  @override
  String get rzWeaker => '稍显疲弱';

  @override
  String get rzSteady => '保持平稳';

  @override
  String get rzTomorrowUpLine => '预计明日能量将会上升——请提前规划重要事项。';

  @override
  String get rzTomorrowDownLine => '明日能量可能略有下降——请保持轻松稳定的节奏。';

  @override
  String get rzTomorrowFlatLine => '明日能量保持平稳——将是平和均衡的一天。';

  @override
  String get rzWeeklyTrend => '每周趋势';

  @override
  String get rzMonthlyTrend => '每月趋势';

  @override
  String get rzBestDayWeek => '最佳日期';

  @override
  String get rzHardestDay => '最具挑战的日期';

  @override
  String get rzLuckyToday => '今日幸运';

  @override
  String get rzKarakaSun => '自信与活力';

  @override
  String get rzKarakaMoon => '情绪与内心平静';

  @override
  String get rzKarakaMars => '精力与干劲';

  @override
  String get rzKarakaMercury => '沟通与学习';

  @override
  String get rzKarakaJupiter => '智慧与成长';

  @override
  String get rzKarakaVenus => '人际关系与舒适感';

  @override
  String get rzKarakaSaturn => '自律与耐心';

  @override
  String get rzKarakaRahu => '野心与变化';

  @override
  String get rzKarakaKetu => '灵性与放下';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom奠定了今日的基调，而$chal则需要耐心与用心对待。';
  }

  @override
  String rzInsightGood(Object karaka) {
    return '今天适合关注$karaka。';
  }

  @override
  String rzInsightHard(Object karaka) {
    return '今天在$karaka方面请放慢脚步。';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '今天$karaka获得良好支持。';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '今天$karaka可能会遇到延迟。';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return '今天有利于$strong，而$weak则需要耐心与用心对待。';
  }

  @override
  String get fdEnergyScore => '今日能量评分';

  @override
  String get fdStatusAverage => '一般';

  @override
  String get fdStatusMixed => '参差不齐';

  @override
  String get fdStatusChallenging => '具有挑战性';

  @override
  String get fdTheme => '今日主题';

  @override
  String get fdExplainToday => '解读今日';

  @override
  String get fdTodaysFocus => '今日重点';

  @override
  String get fdTopRecommendation => '首要建议';

  @override
  String get fdTopCaution => '首要注意事项';

  @override
  String get fdReadingTime => '阅读时间';

  @override
  String get fdSeconds30 => '30秒';

  @override
  String get fdCareer => '事业';

  @override
  String get fdMoney => '财务';

  @override
  String get fdLove => '爱情';

  @override
  String get fdHealth => '健康';

  @override
  String get fdTravel => '出行';

  @override
  String get fdFamily => '家庭';

  @override
  String get fdBestToDo => '今日最适合做的事';

  @override
  String get fdAvoidToday => '今日应避免之事';

  @override
  String get fdConfidenceLabel => '可信度';

  @override
  String get fdBestTime => '最佳时间';

  @override
  String get fdRecommended => '推荐';

  @override
  String get fdReason => '原因';

  @override
  String get fdRisk => '风险';

  @override
  String get fdRecommendation => '建议';

  @override
  String get fdNoActions => '今天没有特别需要推进的大事——保持稳定平静的日常节奏即可。';

  @override
  String get fdNoCautions => '今天没有重大注意事项——保持平常心即可。';

  @override
  String get fdHighlights => '今日亮点';

  @override
  String get fdProbVeryHigh => '极高';

  @override
  String get fdProbHigh => '高';

  @override
  String get fdProbElevated => '偏高';

  @override
  String get fdProbCaution => '需谨慎';

  @override
  String get fdWhatToDo => '应对方法';

  @override
  String get fdLifeAreas => '人生领域';

  @override
  String get fdTapDetails => '点击查看详情';

  @override
  String get fdArea1 => '自我与健康';

  @override
  String get fdArea2 => '财富与家庭';

  @override
  String get fdArea3 => '沟通';

  @override
  String get fdArea4 => '居家与舒适';

  @override
  String get fdArea5 => '创造力与恋爱';

  @override
  String get fdArea6 => '工作与职责';

  @override
  String get fdArea7 => '人际关系';

  @override
  String get fdArea8 => '变化与深度';

  @override
  String get fdArea9 => '运气与出行';

  @override
  String get fdArea10 => '事业与地位';

  @override
  String get fdArea11 => '收益与人脉';

  @override
  String get fdArea12 => '休息与灵性';

  @override
  String get fdTodaysMeaning => '今日意涵';

  @override
  String get fdGoodFor => '有利于';

  @override
  String get fdAvoid => '避免';

  @override
  String get fdPlanetSupport => '行星支持';

  @override
  String get fdWhyPrediction => '为何有此预测？';

  @override
  String get fdAdvancedDetails => '进阶详情';

  @override
  String get fdAiRecommendation => 'AI建议';

  @override
  String get fdOverallStatus => '整体状态';

  @override
  String get fdNoPlanetTransit => '今天没有主要行星行运至该领域。';

  @override
  String get fdFinancialOutlook => '财务展望';

  @override
  String get fdIncomeProbability => '收入概率';

  @override
  String get fdExpenseProbability => '支出概率';

  @override
  String get fdNetBalance => '净财务余额';

  @override
  String get fdAvoidSpending => '应避免的支出';

  @override
  String get fdRelationshipOutlook => '感情展望';

  @override
  String get fdOverallScore => '总体评分';

  @override
  String get fdPartner => '伴侣';

  @override
  String get fdRomance => '浪漫';

  @override
  String get fdWorkplace => '职场';

  @override
  String get fdPublicImage => '公众形象';

  @override
  String get fdBestActivity => '最佳活动';

  @override
  String get fdWeakArea => '薄弱领域';

  @override
  String get fdBiggestOpportunity => '最大机遇';

  @override
  String get fdBiggestRisk => '最大风险';

  @override
  String get fdProbability => '概率';

  @override
  String get fdProtection => '保护建议';

  @override
  String get fdDescription => '描述';

  @override
  String get fdBestTimeToday => '今日最佳时间';

  @override
  String get fdAvoidDuring => '应避免的时段';

  @override
  String get fdPredictionConfidence => '预测可信度';

  @override
  String get fdConfBasis => '今日预测综合了';

  @override
  String get fdConfNatal => '本命盘';

  @override
  String get fdConfTransit => '当前行运';

  @override
  String get fdConfDasha => '行星运程';

  @override
  String get fdConfStrength => '行星力量';

  @override
  String get fdConfHouse => '宫位激活';

  @override
  String get fdAskAi => '咨询AI';

  @override
  String get fdAskAiSub => '点击问题以获取今日解答';

  @override
  String get fdQ1 => '为什么今天事业进展缓慢？';

  @override
  String get fdQ2 => '今天最佳的时间是什么时候？';

  @override
  String get fdQ3 => '今天适合处理财务事项吗？';

  @override
  String get fdQ4 => '今天适合出行吗？';

  @override
  String get fdQ5 => '今天我应该避免什么？';

  @override
  String get fdMoreSuggestions => '更多建议';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return '今天最适合专注于$top。$weak方面可能进展缓慢，请避免在该领域做重大决定。财务方面，今天看起来$fin。';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return '您今天的能量集中在$top——请顺势而为，其他方面则放缓节奏。';
  }

  @override
  String get gochToday => '今天';

  @override
  String get gochOverallScore => '整体行运评分';

  @override
  String get gochNeutral => '中性';

  @override
  String get gochChallenging => '具有挑战性';

  @override
  String get gochTopPositive => '最积极因素';

  @override
  String get gochTopChallenges => '最大挑战';

  @override
  String get gochFilterAll => '全部';

  @override
  String get gochFavorability => '有利程度';

  @override
  String get gochAlerts => '行运提醒';

  @override
  String get gochAlertCritical => '严重';

  @override
  String get gochAlertWarning => '需谨慎';

  @override
  String get gochAlertOpportunity => '机遇';

  @override
  String get gochAiFocus => '今日AI关注点';

  @override
  String get gochLifeScores => '人生领域评分';

  @override
  String get gochWhy => '为什么？';

  @override
  String get gochCurrentTransits => '当前生效行运';

  @override
  String get gochDailyPlan => '您的每日计划';

  @override
  String get gochMorning => '早晨';

  @override
  String get gochAfternoon => '下午';

  @override
  String get gochEvening => '傍晚';

  @override
  String get gochNight => '夜晚';

  @override
  String get gochSmartReco => '智能建议';

  @override
  String get gochExplain => '解读今日行运';

  @override
  String get gochDo => '宜';

  @override
  String get gochDont => '忌';

  @override
  String get gochDoWork => '处理重要工作';

  @override
  String get gochDoMeditate => '冥想与反思';

  @override
  String get gochDoStart => '启动新计划';

  @override
  String get gochDoFinish => '完成待办事项';

  @override
  String get gochDontArgue => '避免争执';

  @override
  String get gochDontImpulsive => '避免冲动决定';

  @override
  String get gochDontOverspend => '避免过度消费';

  @override
  String gochThemeGrowth(Object area) {
    return '今天是$area方面成长的一天——请顺势而为。';
  }

  @override
  String gochThemeChallenge(Object area) {
    return '今天在$area方面请保持耐心，稳步前行。';
  }

  @override
  String gochPosLine(Object area) {
    return '目前$area获得良好支持。';
  }

  @override
  String gochChalLine(Object area) {
    return '今天$area需要格外用心。';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return '今天请将精力投入到$a1，并在$a2方面放缓节奏。';
  }

  @override
  String get divBeginner => '初学者';

  @override
  String get divSearchHint => '搜索：事业、婚姻、教育……';

  @override
  String get divSummaryTitle => '分盘概览';

  @override
  String get divTotalCharts => '分盘总数';

  @override
  String get divMostImportant => '最重要';

  @override
  String get divRecommendedForYou => '为您推荐';

  @override
  String get divCatEssential => '核心分盘';

  @override
  String get divCatPersonal => '个人生活';

  @override
  String get divCatKnowledge => '知识类分盘';

  @override
  String get divCatAdvanced => '进阶分盘';

  @override
  String get divGoalProperty => '财产';

  @override
  String get divGoalKarma => '业力';

  @override
  String get divBadgeHighlyRec => '强烈推荐';

  @override
  String get divBadgeRec => '推荐';

  @override
  String get divBadgeUseful => '有用';

  @override
  String get divBadgeOptional => '可选';

  @override
  String get divBadgeAdvOnly => '仅限进阶';

  @override
  String get divRecommendBest => '推荐最佳分盘';

  @override
  String get divNoMatch => '没有符合搜索条件的分盘';

  @override
  String get divLifeAreas => '人生领域';

  @override
  String divAiUse(Object purpose) {
    return '使用此分盘来分析$purpose。';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return '您的$c1与$c2分盘尤为重要——建议先从这两者所涵盖的领域入手，再按需探索其他分盘。';
  }

  @override
  String divRecReasonHouse(Object house) {
    return '您的$house宫需要仔细审视——此分盘可深入展现其状况。';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet是一个关键但受考验的行星——此分盘可揭示其更深层的状态。';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return '您正处于$planet的大运（Mahadasha）中，因此此分盘现在尤为应景。';
  }

  @override
  String divRecSummary(Object c1) {
    return '根据您的星盘，$c1应是您的首要关注点。以下分盘按其当前与您的相关程度排序。';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return '当您想研究$purpose时，可打开此分盘。';
  }

  @override
  String get yogaHelpful => '有益';

  @override
  String get yogaInactive => '未激活';

  @override
  String get yogaTabMoney => '财富';

  @override
  String get yogaTabRare => '稀有';

  @override
  String get yogaSummaryTitle => '瑜伽概览';

  @override
  String get yogaActiveYogas => '已激活瑜伽';

  @override
  String get yogaTotalYogas => '瑜伽总数';

  @override
  String get yogaMostPowerful => '最强瑜伽';

  @override
  String get yogaFortuneRating => '整体运势';

  @override
  String get yogaBenefits => '益处';

  @override
  String get yogaSupportingPlanets => '支持行星';

  @override
  String get yogaRanking => '五大最强瑜伽';

  @override
  String get yogaExplain => '解读我的瑜伽';

  @override
  String get yogaExplainSubtitle => '您的瑜伽如何为您助力';

  @override
  String get yogaNoneActive => '尚无已激活的瑜伽';

  @override
  String get yogaNoneInCategory => '此类别中没有瑜伽';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return '您的星盘中有$count个已激活的瑜伽——这些是有利的行星组合。涉及$planets的组合对成长与成功尤其有益。';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name对$areas有支持作用，当其相关行星在大运或行运中活跃时，其益处会更加显著。';
  }

  @override
  String get yogaAiGeneric => '此瑜伽是您星盘中的一个有利组合，能增强其所关联的人生领域。';

  @override
  String get yogaExplainReassure =>
      '瑜伽是您星盘中的亮点——是对您有利的行星组合。较强的瑜伽会带来持久的益处，尤其是在构成它们的行星运程期间。';

  @override
  String get doshSevere => '严重';

  @override
  String get doshVeryMild => '非常轻微';

  @override
  String get doshLow => '轻微';

  @override
  String get doshHigh => '较高';

  @override
  String get doshCritical => '危急';

  @override
  String get doshSummaryTitle => '缺陷概览';

  @override
  String get doshActiveDoshas => '已激活缺陷';

  @override
  String get doshTotalChecked => '已检查总数';

  @override
  String get doshOverallSeverity => '整体严重程度';

  @override
  String get doshNoneActive => '没有已激活的缺陷——星盘十分清净！';

  @override
  String get doshCategory => '类别';

  @override
  String get doshConfidence => '可信度';

  @override
  String get doshWhyFormed => '形成原因';

  @override
  String get doshAffectedAreas => '受影响领域';

  @override
  String get doshTimeline => '时间线';

  @override
  String get doshDefinition => '定义';

  @override
  String get doshFormationRule => '形成规则';

  @override
  String get doshSupportingPlanets => '相关行星';

  @override
  String get doshCancellation => '抵消瑜伽';

  @override
  String get doshNoCancellation => '未发现';

  @override
  String get doshAreaChildren => '子女';

  @override
  String get doshAreaMind => '心智';

  @override
  String get remMantra => '真言（Mantra）';

  @override
  String get remGemstone => '宝石';

  @override
  String get remDonation => '布施';

  @override
  String get remTemple => '庙宇参拜';

  @override
  String get remFasting => '斋戒';

  @override
  String get remLifestyle => '生活方式';

  @override
  String get remLifestyleGeneric => '践行与此行星相关的感恩、自律与慈善，并保持良好品行。';

  @override
  String get doshExplain => '解读我的缺陷';

  @override
  String get doshExplainSubtitle => '以平和务实的角度看待您的缺陷';

  @override
  String get doshExplainReassure =>
      '缺陷十分常见——几乎每张星盘都会有一些。它们描述的是倾向，而非注定的命运。觉察、良好品行与简单的补救方法能够减轻其实际影响，因此无需过度担心。';

  @override
  String get doshAiGeneric => '此缺陷描述了您星盘中的一种倾向。其实际影响通常较轻，可以通过觉察与简单的补救方法来平衡。';

  @override
  String doshHeroSummary(Object active, Object total) {
    return '在检查的$total项缺陷中，您的星盘显示有$active项处于激活状态。大多数程度轻微，仅少数需要留意。通过理解与简单的补救方法，可以缓解其实际影响。';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return '此缺陷主要影响$areas。在$planet运程期间，其影响可能会更为明显，补救方法有助于平衡它。';
  }

  @override
  String doshTimelineLine(Object planet) {
    return '其影响在$planet的大运（Mahadasha）与子运（Antardasha）期间，以及$planet行运活跃时最为明显。';
  }

  @override
  String get sbLegendary => '传奇级';

  @override
  String get sbSthana => '位置力（Sthana Bala）';

  @override
  String get sbDig => '方位力（Dig Bala）';

  @override
  String get sbKala => '时间力（Kala Bala）';

  @override
  String get sbChesta => '运动力（Chesta Bala）';

  @override
  String get sbNaisargika => '自然力（Naisargika Bala）';

  @override
  String get sbDrik => '相位力（Drik Bala）';

  @override
  String get sbSummary => '行星力量概览';

  @override
  String get sbAverageStrength => '平均力量';

  @override
  String get sbHighestRupa => '最高鲁帕（Rupa）值';

  @override
  String get sbRupa => '鲁帕（Rupa）';

  @override
  String get sbRanking => '行星排名';

  @override
  String get sbRequired => '所需值';

  @override
  String get sbExcess => '超出值';

  @override
  String get sbDeficit => '不足值';

  @override
  String get sbTotalShadbala => '沙德巴拉（Shadbala）总值';

  @override
  String get sbExplain => '解读我的行星力量';

  @override
  String get sbExplainSubtitle => '您行星力量的简明概览';

  @override
  String get sbInfoTitle => '了解沙德巴拉（Shadbala）';

  @override
  String get sbQWhatIs => '什么是沙德巴拉（Shadbala）？';

  @override
  String get sbQRupas => '什么是鲁帕（Rupas）？';

  @override
  String get sbQHowCalc => '力量是如何计算的？';

  @override
  String get sbQHowUse => '如何使用这些信息';

  @override
  String get sbWhyStrong => '为何强劲';

  @override
  String get sbWhyWeak => '为何薄弱';

  @override
  String get sbDuringMahadasha => '在大运期间';

  @override
  String get sbEffects => '影响';

  @override
  String get sbLifeAreas => '人生领域';

  @override
  String get sbPlanetDetails => '行星详情';

  @override
  String get sbBodyWhatIs => '沙德巴拉（意为“六重力量”）通过累加六种独立的力量来源，衡量每颗行星实现其结果的能力大小。';

  @override
  String get sbBodyRupas =>
      '力量以鲁帕（Rupa）为单位计量（1鲁帕=60维鲁帕）。每颗行星需要达到最低鲁帕值才能被视为强劲；鲁帕值越高，意味着其结果实现得越充分。';

  @override
  String get sbBodyHowCalc =>
      '六种力量相加：位置力（Sthana）、方位力（Dig）、时间力（Kala）、运动力（Chesta）、自然力（Naisargika）与相位力（Drik）。总值与该行星所需的最低值进行比较，得出百分比。';

  @override
  String get sbBodyHowUse =>
      '力量超过100%的行星能轻松实现其所主管的事项；低于100%则需要支持。在重要事务上宜倚重最强的行星，对最薄弱的行星则应给予补救方法与耐心。';

  @override
  String get sbRemedyStrong => '支持充足——无需特殊补救；您可以自信地运用此行星的运程。';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP是您最强的行星，为$strongTrait提供了极佳的支持。$weakP最为薄弱，最能从补救方法中受益。';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet的沙德巴拉属于$category水平，因此其所主管的$karakatva也相应地受到影响。';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return '最强来源于$bala（$rupa鲁帕）。';
  }

  @override
  String sbWeakLine(Object bala) {
    return '在$bala方面最为薄弱，拉低了总值。';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return '在$planet的大运期间，其所主管的$karak会更为突出。';
  }

  @override
  String sbEffectStrong(Object karak) {
    return '由于沙德巴拉强劲，$karak自然获得支持。';
  }

  @override
  String sbEffectWeak(Object karak) {
    return '由于沙德巴拉较弱，$karak可能需要有意识地努力。';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return '通过真言、宝石或布施来增强$planet的力量，并在其运程期间保持耐心。';
  }

  @override
  String get bhOverview => '概览';

  @override
  String get bhDetailed => '详细';

  @override
  String get bhavaHouses => '宫位';

  @override
  String get bhStrengthOverview => '宫位力量概览';

  @override
  String get bhOverallAverage => '宫位整体平均值';

  @override
  String get bhStrongestHouse => '最强宫位';

  @override
  String get bhWeakestHouse => '最弱宫位';

  @override
  String get bhBestArea => '最佳人生领域';

  @override
  String get bhNeedsAttention => '需要关注';

  @override
  String get bhSavContribution => 'SAV贡献值';

  @override
  String get bhLordCondition => '宫主星状态';

  @override
  String get bhBenefic => '吉星影响';

  @override
  String get bhMalefic => '凶星影响';

  @override
  String get bhStrengthReasons => '评分原因';

  @override
  String get bhGoodEffects => '有利影响';

  @override
  String get bhChallenges => '挑战';

  @override
  String get bhRemedies => '补救方法';

  @override
  String get bhRanking => '宫位排名';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => '解读我的宫位';

  @override
  String get bhExplainSubtitle => '您12宫的简明概览';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return '您最强的宫位是$s1和$s2。$strongArea天生较强，而$weakArea则需要更多努力。';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return '其宫主星$lord处于$relation状态。';
  }

  @override
  String bhWhyLine(Object sav) {
    return '此宫位携带$sav个吉点（SAV）；其内的行星及所受相位共同塑造了余下的评分。';
  }

  @override
  String bhGoodLine(Object meaning) {
    return '当此宫位强劲时，有利于$meaning。';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return '当此宫位薄弱时，$meaning可能需要额外的努力与用心。';
  }

  @override
  String bhRemedyLine(Object lord) {
    return '增强其宫主星$lord的力量，并重视此宫位所涉及的事务，以提升其运势。';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return '您的$house处于$strengthWord状态。它主管$meaning。';
  }

  @override
  String get kunNavamsa => '纳瓦姆萨盘（D9）';

  @override
  String get kunD10 => '达萨姆萨盘（D10）';

  @override
  String get kunPlacement => '行星落位';

  @override
  String get kunHousesTitle => '宫位详情';

  @override
  String get kunPlanet => '行星';

  @override
  String get kunNakshatra => '星宿';

  @override
  String get kunPada => '分度（Pada）';

  @override
  String get kunLord => '主星';

  @override
  String get kunExplain => '解读我的星盘';

  @override
  String get kunExplainSubtitle => '您星盘的简明概览';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '第$ordinal宫主管$meaning。';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '落于此处的$planets塑造了其结果。';
  }

  @override
  String kunExplainAsc(Object asc) {
    return '您的上升星座是$asc，塑造了您的人生观以及他人对您的第一印象。';
  }

  @override
  String kunExplainMoon(Object moon) {
    return '您的心智与情绪受位于$moon的月亮所影响。';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet是您最强的行星——是一个天生轻松且获得支持的领域。';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet是您最受考验的行星——在此处付出耐心与努力会有所回报。';
  }

  @override
  String get plNature => '性质';

  @override
  String get plElement => '元素';

  @override
  String get plGender => '性别';

  @override
  String get plKarakatva => '徵象（Karakatva）';

  @override
  String get plLordship => '宫主权';

  @override
  String get plStrength => '力量';

  @override
  String get plAspectsGiven => '给出的相位';

  @override
  String get plAspectsReceived => '接收的相位';

  @override
  String get plConjunction => '合相';

  @override
  String get plHouseMeaning => '宫位含义';

  @override
  String get plNakshatraMeaning => '星宿含义';

  @override
  String get plAiInterpretation => 'AI解读';

  @override
  String get plSearchHint => '搜索任意行星';

  @override
  String get plNoResults => '未找到行星';

  @override
  String get plBenefic => '吉星';

  @override
  String get plMalefic => '凶星';

  @override
  String get plMale => '阳性';

  @override
  String get plFemale => '阴性';

  @override
  String get plNeutralGender => '中性';

  @override
  String get plOwnSign => '本位星座';

  @override
  String get plFriend => '友好星座';

  @override
  String get plEnemy => '敌对星座';

  @override
  String get plNeutral => '中立';

  @override
  String get sumEther => '以太';

  @override
  String plLordOfHouses(Object houses) {
    return '第$houses宫主星';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return '由$nakLord主管，带来$trait。';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet位于$sign星座，落在第$house宫。';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return '其核心徵象——$karak——在此获得了良好的支持。';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return '其核心徵象——$karak——在此可能需要有意识的努力。';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet处于旺相（exalted），能带来最佳的结果。';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet处于弱相（debilitated），需要支持才能发挥其结果。';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet处于焦伤（combust）状态，因受太阳光芒遮蔽，其作用较为隐晦。';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet处于同宫互映（Vargottama）状态——即在纳瓦姆萨盘中重复出现同一星座，是力量强劲的标志。';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet处于逆行（retrograde）状态，其能量转向内在并被强化。';
  }

  @override
  String get plHouse1 => '自我、身体、性格与活力';

  @override
  String get plHouse2 => '财富、家庭、言语与饮食';

  @override
  String get plHouse3 => '勇气、兄弟姐妹、沟通与短途旅行';

  @override
  String get plHouse4 => '家庭、母亲、舒适、财产与内心平静';

  @override
  String get plHouse5 => '子女、创造力、智力、恋爱与前世福报';

  @override
  String get plHouse6 => '健康、仇敌、债务、服务与日常工作';

  @override
  String get plHouse7 => '婚姻、伴侣关系与商业合作';

  @override
  String get plHouse8 => '寿元、蜕变、秘密与继承';

  @override
  String get plHouse9 => '福运、达摩、高等教育、导师与父亲';

  @override
  String get plHouse10 => '事业、地位、权威与公众业力';

  @override
  String get plHouse11 => '收益、收入、朋友、人脉与愿望实现';

  @override
  String get plHouse12 => '损失、支出、异国他乡、灵性与解脱';

  @override
  String get sumVeryStrong => '极强';

  @override
  String get sumStrong => '较强';

  @override
  String get sumAverage => '一般';

  @override
  String get sumWeak => '较弱';

  @override
  String get sumNeedsAttention => '需要关注';

  @override
  String get sumFire => '火象';

  @override
  String get sumEarth => '土象';

  @override
  String get sumAir => '风象';

  @override
  String get sumWater => '水象';

  @override
  String get sumMovable => '动相';

  @override
  String get sumFixed => '固定相';

  @override
  String get sumDual => '双重相';

  @override
  String get sumDirEast => '东方';

  @override
  String get sumDirWest => '西方';

  @override
  String get sumDirNorth => '北方';

  @override
  String get sumDirSouth => '南方';

  @override
  String get sumDirNE => '东北方';

  @override
  String get sumDirNW => '西北方';

  @override
  String get sumDirSE => '东南方';

  @override
  String get sumDirSW => '西南方';

  @override
  String get sumSnapshotTitle => '您的占星概览';

  @override
  String get sumMahadasha => '大运（Mahadasha）';

  @override
  String get sumAntardasha => '子运（Antardasha）';

  @override
  String get sumNakshatra => '出生星宿（Janma Nakshatra）';

  @override
  String get sumElement => '元素';

  @override
  String get sumModality => '属性';

  @override
  String get sumLuckyDirection => '幸运方位';

  @override
  String get sumHighlights => '重要亮点';

  @override
  String get sumStrongPlanet => '最强行星';

  @override
  String get sumWeakPlanet => '最弱行星';

  @override
  String get sumYogas => '瑜伽';

  @override
  String get sumDoshas => '缺陷';

  @override
  String get sumRetrograde => '逆行';

  @override
  String get sumCombust => '焦伤';

  @override
  String get sumExalted => '旺相';

  @override
  String get sumDebilitated => '弱相';

  @override
  String get sumVargottama => '同宫互映（Vargottama）';

  @override
  String get sumQuickInsights => '快速洞察';

  @override
  String get sumSpirituality => '灵性';

  @override
  String get sumTimezone => '时区';

  @override
  String get sumAyanamsa => '岁差校正（Ayanamsa）';

  @override
  String get sumCalendarType => '历法';

  @override
  String get sumCopied => '已复制到剪贴板';

  @override
  String get sumNatureFire => '您具有大胆、充满活力且富有开创精神的性格，善于身先士卒。';

  @override
  String get sumNatureEarth => '您具有务实、踏实且自律的性格，能够创造持久的成果。';

  @override
  String get sumNatureAir => '您具有好奇、善于沟通且富有智识的性格，在新想法中蓬勃发展。';

  @override
  String get sumNatureWater => '您具有直觉敏锐、情感丰富且富有同理心的性格，内心极为敏感。';

  @override
  String get sumGradePhraseExcellent => '支持强劲——只要持续努力，很可能获得有利的结果。';

  @override
  String get sumGradePhraseGood => '支持良好——只需稍加用心，整体趋势正面。';

  @override
  String get sumGradePhraseAverage => '支持参差——结果取决于努力程度与时机。';

  @override
  String get sumGradePhraseWeak => '需要关注——耐心与补救方法在此会有所帮助。';

  @override
  String get kDefCombust => '行星过于靠近太阳，导致其能量被“灼烧”而减弱。';

  @override
  String get kDefRetrograde => '看似逆向运行的行星；其效应会转向内在并被强化。';

  @override
  String get kDefNakshatra => '月亮与各行星运行经过的27个月宿之一。';

  @override
  String get kDefVargottama => '一颗行星在本命盘（D1）与纳瓦姆萨盘（D9）中处于相同星座——这是力量强劲的标志。';

  @override
  String get kDefOwnSign => '行星位于自己所主管的星座中，如鱼得水，能带来稳定的结果。';

  @override
  String get kDefExalted => '行星位于其力量最强的星座，能带来最佳的结果。';

  @override
  String get kDefDebilitated => '行星位于其最弱的星座，难以发挥应有的结果。';

  @override
  String get kDefMooltrikona => '行星本位星座中一段特殊的区间，在此区间内行星力量尤为强大。';

  @override
  String get kDefAscendant => '出生时在东方地平线上升起的星座——即上升星座（Lagna），是星盘的基础。';

  @override
  String get kDefMahadasha => '影响人生较长时段的主要行星运程。';

  @override
  String get kDefAntardasha => '大运内部的子运程，用以细化其结果。';

  @override
  String get kDefPada => '行星所处星宿中四个分度（Pada）之一。';

  @override
  String get aspGivesAspectTo => '投射相位于';

  @override
  String get aspReceivesAspectFrom => '接收相位来自';

  @override
  String get aspInfluences => '影响';

  @override
  String get aspNoInfluence => '无影响';

  @override
  String get aspNoAspect => '无相位';

  @override
  String get aspPresent => '存在';

  @override
  String get aspAbsent => '不存在';

  @override
  String get aspNotPresent => '不存在';

  @override
  String get aspSpecialAspect => '特殊相位';

  @override
  String get aspAspectWord => '相位';

  @override
  String get aspTotalGiven => '给出的相位';

  @override
  String get aspTotalReceived => '接收的相位';

  @override
  String get aspStrongestInfluence => '最强影响';

  @override
  String get aspMedium => '中等';

  @override
  String get aspAspectPresent => '存在相位';

  @override
  String get aspReason => '原因';

  @override
  String get aspBoth => '两者皆有';

  @override
  String get aspTargetHouse => '目标宫位';

  @override
  String get aspTargetSign => '目标星座';

  @override
  String get aspLagnaReceives => '上升星座接收相位来自';

  @override
  String get aspNoAspectFrom => '无相位来自';

  @override
  String get aspPlanetToPlanet => '行星对行星';

  @override
  String get aspSignToSign => '星座对星座';

  @override
  String get aspCombinedAspect => '综合相位';

  @override
  String get aspGrahaAspect => '行星相位（Graha Drishti）';

  @override
  String get aspRashiAspect => '星座相位（Rashi Drishti）';

  @override
  String get aspInfoTitle => '了解相位（Drishti）';

  @override
  String get aspQGraha => '什么是行星相位（Graha Drishti）？';

  @override
  String get aspQRashi => '什么是星座相位（Rashi Drishti）？';

  @override
  String get aspQDiff => '两者的区别';

  @override
  String get aspQPredict => '相位如何影响预测';

  @override
  String get aspGrahaBody =>
      '行星相位（Graha Drishti）是行星从其所在位置投射出的相位。每颗行星都会对自身第七宫/宫内行星形成完全相位（一种直接、面对面的影响）。此外，火星还会对第四宫和第八宫形成相位，木星对第五宫和第九宫，土星对第三宫和第十宫。罗睺与计都通常被视为对第五、七、九宫形成相位。行星的相位会以其自身的性质影响所落宫位或行星。';

  @override
  String get aspRashiBody =>
      '星座相位（Rashi Drishti）是遮米尼占星学中星座与星座之间的相位，与其中所居行星无关。动相星座对固定相星座形成相位（相邻星座除外），固定相星座对动相星座形成相位（相邻星座除外），双重相星座之间相互形成相位。此相位主要用于遮米尼预测以及判断宫位间的关系。';

  @override
  String get aspDiffBody =>
      '行星相位由行星投射，取决于该行星所在的位置。星座相位则属于星座本身，适用于落入其中的任何事物。行星相位具有方向性（行星A看向行星B），而星座相位通常在星座之间是相互的。当两者都指向同一目标时，其影响尤为强烈。';

  @override
  String get aspPredictBody =>
      '相位显示了一颗行星将其影响延伸到本宫之外的范围。吉星相位（木星、金星、状态良好的月亮/水星）会支持并保护目标；凶星相位（土星、火星、太阳、罗睺、计都）则可能带来压力、延迟或挑战。解读哪些行星对某个宫位或行星形成相位，有助于解释结果为何如此呈现。';

  @override
  String get aspTraitSun => '权威、领导力与活力';

  @override
  String get aspTraitMoon => '情感深度、舒适感与直觉';

  @override
  String get aspTraitMars => '精力、勇气与干劲';

  @override
  String get aspTraitMercury => '沟通、智力与适应能力';

  @override
  String get aspTraitJupiter => '智慧、成长与福运';

  @override
  String get aspTraitVenus => '爱、和谐与享受';

  @override
  String get aspTraitSaturn => '自律、责任感，以及需要耐心、有时会延迟到来的成功';

  @override
  String get aspTraitRahu => '野心、强度与非传统的转折';

  @override
  String get aspTraitKetu => '超然、灵性与突发的变化';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet正在影响$targets。这可能会为这些行星所代表的领域带来$trait。';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet在此未对其他任何行星形成特殊相位；其影响主要通过自身所在的星座与宫位发挥作用。';
  }

  @override
  String get avSummaryTitle => '阿什塔卡瓦尔加（Ashtakavarga）概览';

  @override
  String get avOverallScore => '整体SAV评分';

  @override
  String get avOverallRating => '整体评级';

  @override
  String get avStrongestSigns => '最强星座';

  @override
  String get avWeakestSigns => '最弱星座';

  @override
  String get avScore => '评分';

  @override
  String get avMeaning => '含义';

  @override
  String get avGrid => '网格';

  @override
  String get avList => '列表';

  @override
  String get avOverallScoreShort => '总体评分';

  @override
  String get avNatalSignScore => '本命星座评分';

  @override
  String get avBestSigns => '最佳星座';

  @override
  String get avWeakSigns => '薄弱星座';

  @override
  String get avAiInterpretation => 'AI解读';

  @override
  String get avVeryGood => '非常好';

  @override
  String get avVeryWeak => '非常弱';

  @override
  String get avTotalSav => 'SAV总值';

  @override
  String get avPlanetContributions => '各行星贡献值';

  @override
  String get avFinance => '财务';

  @override
  String get avOverallStrength => '整体力量';

  @override
  String get avWhatDoesThisMean => '这意味着什么？';

  @override
  String get avSimple => '简单';

  @override
  String get avAdvanced => '进阶';

  @override
  String get avInfoTitle => '了解阿什塔卡瓦尔加（Ashtakavarga）';

  @override
  String get avStrong => '强';

  @override
  String get avModerate => '中等';

  @override
  String get avQWhatIsAv => '什么是阿什塔卡瓦尔加（Ashtakavarga）？';

  @override
  String get avQWhatIsSav => '什么是SAV？';

  @override
  String get avQWhatIsBav => '什么是BAV？';

  @override
  String get avQHowToRead => '如何解读这些评分';

  @override
  String get avQSavVsBav => 'SAV与BAV的区别';

  @override
  String get avABody =>
      '阿什塔卡瓦尔加是吠陀占星学中一种基于点数的力量评估系统。每颗行星会根据其所处位置，向十二星座授予吉点（宾杜，Bindu，亦称Rekha）。某星座得分越高，意味着该领域在相关行星运程与行运期间会获得更顺畅的支持。';

  @override
  String get avSavBody =>
      'SAV（总阿什塔卡瓦尔加，Sarva Ashtakavarga）将七颗行星在每个星座上的点数相加。它为每个星座提供一个综合力量评分，让您能快速看出星盘中哪些星座——以及它们所落的宫位——获得了最好的支持。';

  @override
  String get avBavBody =>
      'BAV（单项阿什塔卡瓦尔加，Bhinna Ashtakavarga）显示单颗行星在十二星座上的点数分布。它告诉您某颗特定行星最支持哪些星座，这在该行星的大运或行运活跃时尤为重要。';

  @override
  String get avHowToReadBody =>
      '数值越高越好。就SAV而言，一个星座的平均得分约为28分——高于30分为强，低于25分则需要留意。就BAV而言，每个星座的得分范围为0至8分，4分为平均水平。重要行动宜倚重最强的星座，对最薄弱的星座则应保持耐心与自律。';

  @override
  String get avSavVsBavBody =>
      'SAV是所有行星的总和，展示一个星座的整体力量。BAV则是单颗行星的贡献值，显示是哪颗行星在支持该星座。使用SAV把握整体情况，使用BAV了解是哪颗行星驱动了该星座的力量。';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return '您的星盘在$s1、$s2和$s3方面最为强劲。这些星座在行星运程与行运期间能提供更好的支持。$weak目前支持最少，因此在与之相关的事务上，耐心与自律会有所帮助。';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet在$s1和$s2方面表现最为强劲。当这些星座被激活时，$planet所主管的事务往往会有所改善。';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return '您最强的星座是$s1和$s2——当行星行运至此时，适合开展重要的新计划。';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1获得的支持最少——请谨慎行事，避免在相关事务上过度投入。';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet携带的点数最多，因此其所主管的事项在您的人生中获得了良好的支持。';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet携带的点数最少，最能从补救方法与有意识的努力中受益。';
  }

  @override
  String avInsightAverage(Object avg) {
    return '得分高于您平均值$avg分的星座，往往能带来更顺畅、更可靠的结果。';
  }

  @override
  String get fcKey => '关键';

  @override
  String get fcActions => '行动建议';

  @override
  String get fcCautions => '注意事项';

  @override
  String get fc12House => '十二宫';

  @override
  String get fcProbabilities => '概率';

  @override
  String get fcHousesCaps => '宫位';

  @override
  String get fcCritical => '严重';

  @override
  String get fcFlags => '警示';

  @override
  String get fcAnalysis => '分析';

  @override
  String get fcConfidence => '可信度';

  @override
  String get fcQualityCaps => '质量';

  @override
  String get fcIncomeVs => '收入与';

  @override
  String get fcExpense => '支出';

  @override
  String get fcFinance => '财务';

  @override
  String get fcNetBalance => '净余额';

  @override
  String get fcSignature => '特征';

  @override
  String get fcBestTimeForIncome => '最佳收入时段';

  @override
  String get fcExpenseCaution => '支出注意事项';

  @override
  String get fcIncomeCaps => '收入';

  @override
  String get fcExpenseCaps => '支出';

  @override
  String get fcRelationships => '人际关系';

  @override
  String get fcAreasCaps => '领域';

  @override
  String get fcBestForMeetings => '最适合会面';

  @override
  String get fcOpportunitiesVs => '机遇与';

  @override
  String get fcRisks => '风险';

  @override
  String get fcOutlook => '展望';

  @override
  String get fcAction => '行动';

  @override
  String get fcProtect => '防护';

  @override
  String get fcOpportunityCaps => '机遇';

  @override
  String get fcRiskCaps => '风险';

  @override
  String get fcTopOpportunities => '主要机遇';

  @override
  String get fcTopRisks => '主要风险';

  @override
  String get fcTiming => '时机';

  @override
  String get fcWindows => '时段';

  @override
  String get fcSlotsCaps => '时段';

  @override
  String get fcBestWindows => '最佳时段';

  @override
  String get fcWorstWindows => '最差时段';

  @override
  String get fcAvoid => '避免';

  @override
  String get fcHouse => '宫位';

  @override
  String get fcFailed => '失败';

  @override
  String get lifeCareer => '事业';

  @override
  String get lifeHealth => '健康';

  @override
  String get lifeWealth => '财富';

  @override
  String get lifeFamily => '家庭';

  @override
  String get lifeMind => '心智';

  @override
  String get lifeEgo => '自我';

  @override
  String get lifeAggression => '攻击性';

  @override
  String get lifeConflict => '冲突';

  @override
  String get rashiElement => '元素';

  @override
  String get rashiQuality => '属性';

  @override
  String get rashiLuckyColor => '幸运颜色';

  @override
  String get rashiLuckyDay => '幸运日';

  @override
  String get rashiLuckyNumber => '幸运数字';

  @override
  String get rashiGemstone => '幸运宝石';

  @override
  String get rashiBody => '身体部位';

  @override
  String get gocharTodaysTransitChart => '今日行运星盘';

  @override
  String get gocharTransit => '行运';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get best => '最佳';

  @override
  String get worst => '最差';

  @override
  String get avg => '平均';

  @override
  String get favorableLoveWindowsLabel => '有利爱情时段';

  @override
  String get lordLabel => '主星';

  @override
  String get lordPlacementLabel => '主星落位';

  @override
  String get lordDignityLabel => '主星力量状态';

  @override
  String get categoriesSuffix => '类别';

  @override
  String get coreBlockerLabel => '核心阻碍';

  @override
  String get coreGiftLabel => '✦ 核心天赋';

  @override
  String get coreThemeLabel => '● 核心主题';

  @override
  String dominantLabel(Object value) {
    return '主导：$value';
  }

  @override
  String get karakasSuffix => '徵星';

  @override
  String get protectiveLabel => '保护性';

  @override
  String secondaryLabel(Object value) {
    return ' · 次要：$value';
  }

  @override
  String get tagCore => '核心';

  @override
  String get debtScoresHeader => '📉 债务评分';

  @override
  String get debtCurrentLoadStat => '当前\n债务负担';

  @override
  String get debtRecoveryCapacityStat => '恢复\n能力';

  @override
  String get debtIntensityStat => '强度';

  @override
  String get debtDefaultRiskStat => '违约风险';

  @override
  String get debtProfileTitle => '债务档案';

  @override
  String get debtKarmaLabel => '业力';

  @override
  String get debtPersonalityLabel => '性格';

  @override
  String get debtPhaseLabel => '阶段';

  @override
  String get debtPrimaryCategoryLabel => '主要类别';

  @override
  String get debtWord => '债务';

  @override
  String get debtYogasTitle => '债务瑜伽';

  @override
  String get debtCreatingLabel => '形成债务';

  @override
  String get debtClearingLabel => '清偿债务';

  @override
  String get yearlyDebtTitle => '年度债务';

  @override
  String get debtRepaymentTitle => '还款';

  @override
  String get debtDangerPeriodsTitle => '危险时期';

  @override
  String get debtDefaultPctStat => '违约率';

  @override
  String get debtBankruptcyPctStat => '破产率';

  @override
  String get debtChronicPctStat => '长期负债率';

  @override
  String get debtResilienceStat => '韧性';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return '恢复率：$pct% · 时间线：$years年';
  }

  @override
  String get debtFreeWindowLabel => '🎯 无债时段';

  @override
  String debtFreeYear(Object year) {
    return '第$year年';
  }

  @override
  String get legalScoresHeader => '⚖️ 法律评分';

  @override
  String get legalVulnerabilityStat => '法律\n脆弱度';

  @override
  String get legalVictoryPotentialStat => '胜诉\n潜力';

  @override
  String get legalConflictStat => '冲突';

  @override
  String get legalResolutionStat => '化解能力';

  @override
  String get legalProfileTitle => '法律档案';

  @override
  String get legalKarmaTypeLabel => '业力类型';

  @override
  String get legalConflictStyleLabel => '冲突风格';

  @override
  String get legalStrategyLabel => '策略';

  @override
  String get legalCaseDurationLabel => '案件时长';

  @override
  String get legalCurrentStatusLabel => '当前状态';

  @override
  String get legalWord => '法律';

  @override
  String get legalYogasTitle => '法律瑜伽';

  @override
  String get legalDisputePressureLabel => '纠纷压力';

  @override
  String get legalProtectionLabel => '法律保护力';

  @override
  String get legalStressTrendTitle => '法律压力';

  @override
  String get legalVisibleEnemiesStat => '明面仇敌';

  @override
  String get legalHiddenEnemiesStat => '隐藏仇敌';

  @override
  String get legalCriminalRiskStat => '涉刑风险';

  @override
  String get legalFalseAccusationStat => '被诬告风险';

  @override
  String get legalContractKarmaTitle => '合同业力';

  @override
  String get legalDocumentationLabel => '文档质量';

  @override
  String get legalFinePrintAwareLabel => '细则条款警觉性';

  @override
  String get legalNegotiationSkillLabel => '谈判技巧';

  @override
  String get legalSignatureCautionLabel => '签署谨慎度';

  @override
  String legalResilienceSubtitle(Object pct) {
    return '韧性：$pct/100';
  }

  @override
  String get legalVictoryWord => '胜诉';

  @override
  String get legalAnalysisSuffix => '分析';

  @override
  String get legalAsPlaintiff => '作为原告';

  @override
  String get legalAsDefendant => '作为被告';

  @override
  String get legalWinProbability => '胜诉概率';

  @override
  String get legalDisputeWord => '纠纷';

  @override
  String get lifepathScoresHeader => '🌟 人生路径评分';

  @override
  String get lifepathDharmaClarityStat => '达摩\n清晰度';

  @override
  String get lifepathFortuneBaselineStat => '运势\n基线';

  @override
  String get lifepathCoherenceStat => '人生路径\n一致性';

  @override
  String get lifepathKarmaStat => '业力';

  @override
  String get lifepathSpiritualStat => '灵性';

  @override
  String get lifepathFameStat => '声望';

  @override
  String get lifepathSoulContractTitle => '灵魂契约';

  @override
  String get lifepathAtmakarakaLabel => '灵魂行星';

  @override
  String get lifepathAkFocusLabel => '灵魂焦点';

  @override
  String get lifepathSoulPurposeLabel => '灵魂使命';

  @override
  String get lifepathLifeChapterLabel => '人生篇章';

  @override
  String get lifepathPrimaryDomainLabel => '主要领域';

  @override
  String get lifepathLeadershipStat => '领导力';

  @override
  String get lifepathWisdomTeachStat => '智慧/教导';

  @override
  String get lifepathServiceStat => '服务';

  @override
  String get lifepathHealingStat => '疗愈';

  @override
  String get lifepathFortuneYogasTitle => '运势瑜伽';

  @override
  String get lifepathLuckBlocksLabel => '运势阻碍';

  @override
  String get lifepathFortuneBoostersLabel => '运势助力';

  @override
  String get lifepathFortuneTrendTitle => '运势趋势';

  @override
  String get lifepathGoldenWindowsTitle => '黄金时段 ★';

  @override
  String get lifepathTransformationTitle => '转变';

  @override
  String get lifepathMilestonesTitle => '人生里程碑';

  @override
  String get lifepathKarmicLessonsTitle => '业力课题';

  @override
  String get lifepathRahuGrowthLabel => '罗睺成长';

  @override
  String get lifepathKetuSurrenderLabel => '计都放下';

  @override
  String get lifepathSaturnLessonLabel => '土星课题';

  @override
  String get lifepathLifeDifficultyLabel => '人生难度';

  @override
  String get lifepathSoulExperienceTitle => '★ 灵魂此生要体验的事';

  @override
  String get lifepathBlessingsTitle => '● 福泽';

  @override
  String get lifepathLifeWord => '人生';

  @override
  String get lifepathArchetypeSuffix => '原型';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return '实现度：$pct%';
  }

  @override
  String get lifepathDestinyVsWord => '命运与';

  @override
  String get lifepathFreeWillSuffix => '自由意志';

  @override
  String get lifepathDestinyStat => '命运';

  @override
  String get lifepathFreeWillStat => '自由意志';

  @override
  String get pastlifeScoresHeader => '🔮 前世评分';

  @override
  String get pastlifeSignatureStrengthStat => '印记\n强度';

  @override
  String get pastlifeCarryForwardStat => '延续\n程度';

  @override
  String get pastlifeMasteryPreservedStat => '保留的\n精通能力';

  @override
  String get pastlifeUnfinishedStat => '未完成';

  @override
  String get pastlifeKarmicDebtStat => '业力债务';

  @override
  String get pastlifeProfileTitle => '前世档案';

  @override
  String get pastlifeThemeLabel => '主题';

  @override
  String get pastlifeProfessionLabel => '职业';

  @override
  String get pastlifeSocialStandingLabel => '社会地位';

  @override
  String get pastlifeRegionLabel => '地域';

  @override
  String get pastlifeSpiritualLevelLabel => '灵性水平';

  @override
  String get pastlifeGenderLabel => '性别';

  @override
  String get pastlifeWealthLevelLabel => '财富水平';

  @override
  String get pastlifeFamilyRoleLabel => '家庭角色';

  @override
  String get pastlifeSkillsCarriedTitle => '★ 延续下来的技能';

  @override
  String get pastlifeNaturalAttractionsTitle => '● 天然吸引';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ 无法解释的恐惧';

  @override
  String get pastlifeMagneticPullsTitle => '→ 无形的吸引力';

  @override
  String get pastlifeRelationshipStat => '关系';

  @override
  String get pastlifeFinancialStat => '财务';

  @override
  String get pastlifeServiceStat => '服务';

  @override
  String get pastlifeDharmicStat => '达摩';

  @override
  String get pastlifeOnRelationsStat => '在人际关系方面';

  @override
  String get pastlifeOnCareerStat => '在事业方面';

  @override
  String get pastlifeOnHealthStat => '在健康方面';

  @override
  String get pastlifeOnSpiritualStat => '在灵性方面';

  @override
  String get pastlifeKarmicResolutionTitle => '业力化解';

  @override
  String get pastlifePrimaryPathLabel => '主要路径';

  @override
  String get pastlifeSecondaryPathLabel => '次要路径';

  @override
  String get pastlifeClearingProgressLabel => '清理进度';

  @override
  String get pastlifeRemainingWorkLabel => '剩余功课';

  @override
  String get pastlifeDebtTimelineLabel => '债务时间线';

  @override
  String get pastlifeMemoryAccessStat => '记忆通达度';

  @override
  String get pastlifeDreamVisitsStat => '梦境造访';

  @override
  String get pastlifeDejaVuStat => '似曾相识';

  @override
  String get pastlifeRegressionFitStat => '回溯疗法适配度';

  @override
  String get pastlifeActivationTitle => '前世激活';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return '成熟度：$maturity · 状态：$status';
  }

  @override
  String get pastlifeKetuWord => '计都';

  @override
  String get pastlifePastMasterySuffix => '前世精通';

  @override
  String get pastlifeKetuMasteredLabel => '计都 · 您所精通之事';

  @override
  String get pastlifeRahuWord => '罗睺';

  @override
  String get pastlifeFutureGrowthSuffix => '未来成长';

  @override
  String get pastlifeRahuPullsLabel => '罗睺 · 牵引您前行之事';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ 阴影：$shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 心理评分';

  @override
  String get mentalStabilityStat => '心理\n稳定性';

  @override
  String get mentalEmotionalBaselineStat => '情绪\n基线';

  @override
  String get mentalResilienceStat => '韧性';

  @override
  String get mentalAnxietyStat => '焦虑';

  @override
  String get mentalDepressionStat => '低落情绪';

  @override
  String get mentalRegulationStat => '调节能力';

  @override
  String get mentalProfileTitle => '心理档案';

  @override
  String get mentalConstitutionLabel => '体质';

  @override
  String get mentalStressDriverLabel => '压力来源';

  @override
  String get mentalStabilityAnchorLabel => '稳定之锚';

  @override
  String get mentalStressResponseLabel => '压力反应';

  @override
  String get mentalAttachmentStyleLabel => '依恋风格';

  @override
  String get mentalBurnoutStageLabel => '倦怠阶段';

  @override
  String get mentalWord => '心理';

  @override
  String get mentalYogasTitle => '心理瑜伽';

  @override
  String get mentalStressPressureLabel => '压力程度';

  @override
  String get mentalWellnessTrendTitle => '身心健康趋势';

  @override
  String get mentalHealthyCopingTitle => '✓ 健康的应对方式';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ 不健康的风险';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ 推荐的替代方式';

  @override
  String get mentalSleepQualityStat => '睡眠质量';

  @override
  String get mentalSocialSupportStat => '社会支持';

  @override
  String get mentalBurnoutVulnStat => '倦怠脆弱度';

  @override
  String get mentalSelfAwarenessStat => '自我觉察力';

  @override
  String get mentalAnxietyWord => '焦虑';

  @override
  String get mentalTypesSuffix => '类型';

  @override
  String get mentalTherapyWord => '心理治疗';

  @override
  String get mentalModalityFitSuffix => '疗法适配度';

  @override
  String get characterScoresHeader => '🔍 性格评分';

  @override
  String get characterStrengthStat => '性格\n力量';

  @override
  String get characterIntegrityStat => '正直度';

  @override
  String get characterResilienceStat => '韧性';

  @override
  String get characterAwarenessStat => '觉察力';

  @override
  String get characterStabilityStat => '稳定性';

  @override
  String get characterEthicsStat => '伦理';

  @override
  String get characterSurfacePersonalityTitle => '表层性格';

  @override
  String get characterLagnaLabel => '上升星座';

  @override
  String get characterConstitutionLabel => '体质';

  @override
  String get characterNakshatraLabel => '星宿';

  @override
  String get characterDeityLabel => '守护神';

  @override
  String get characterMoonManasTitle => '月亮心智';

  @override
  String get characterSignLabel => '星座';

  @override
  String get characterHouseLabel => '宫位';

  @override
  String get characterWarmthStat => '热情度';

  @override
  String get characterEmpathyStat => '同理心';

  @override
  String get characterLoyaltyStat => '忠诚度';

  @override
  String get characterBoundariesStat => '边界感';

  @override
  String get characterDharmaStat => '达摩';

  @override
  String get characterTruthStat => '真实度';

  @override
  String get characterCompassionStat => '慈悲心';

  @override
  String get characterGenerosityStat => '慷慨度';

  @override
  String get characterSignatureVirtuesTitle => '★ 标志性美德';

  @override
  String get characterNaturalTalentsTitle => '● 天生才能';

  @override
  String get characterShadowPatternsTitle => '⚠ 阴影模式';

  @override
  String get characterYogasTitle => '性格瑜伽';

  @override
  String get characterTestsLabel => '考验';

  @override
  String get characterGiftsLabel => '天赋';

  @override
  String get characterSelfAwareEiStat => '自我觉察情商';

  @override
  String get characterSelfRegulateStat => '自我调节';

  @override
  String get characterEmpathyEiStat => '同理心情商';

  @override
  String get characterSocialSkillsStat => '社交技能';

  @override
  String characterRealizationSubtitle(Object pct) {
    return '实现度：$pct%';
  }

  @override
  String get characterAtmakarakaWord => '灵魂行星（Atmakaraka）';

  @override
  String get characterSoulSignatureSuffix => '灵魂印记';

  @override
  String get characterAtmakarakaLabel => '灵魂行星';

  @override
  String get characterGunaWord => '古纳';

  @override
  String get characterProfileSuffix => '档案';

  @override
  String get characterSattvaLabel => '悦性（Sattva）';

  @override
  String get characterRajasLabel => '动性（Rajas）';

  @override
  String get characterTamasLabel => '惰性（Tamas）';

  @override
  String get healthScoresHeader => '🏥 健康评分';

  @override
  String get healthVitalityStat => '活力';

  @override
  String get healthImmunityStat => '免疫力';

  @override
  String get healthRecoveryStat => '恢复力';

  @override
  String get healthMentalStat => '心理';

  @override
  String get healthStressTolStat => '抗压能力';

  @override
  String get healthYogasTitle => '健康瑜伽';

  @override
  String get healthDiseasePressureLabel => '疾病压力';

  @override
  String get healthTrendTitle => '健康趋势';

  @override
  String get healthRecoveryWindowsTitle => '恢复时段';

  @override
  String get healthCautionPeriodsTitle => '需谨慎时期';

  @override
  String get healthFertilityStat => '生育力';

  @override
  String get healthBurnoutRiskStat => '职业倦怠风险';

  @override
  String get healthAddictionVulnStat => '成瘾脆弱度';

  @override
  String get healthWorkLifeBalStat => '工作生活平衡';

  @override
  String get healthAyurvedicWord => '阿育吠陀';

  @override
  String get healthConstitutionSuffix => '体质';

  @override
  String get healthBodyWord => '身体';

  @override
  String get healthSystemMapSuffix => '系统图谱';

  @override
  String get healthBodyZoneWord => '身体区域';

  @override
  String get healthVulnerabilitySuffix => '脆弱度';

  @override
  String get healthDiseaseWord => '疾病';

  @override
  String get healthSusceptibilitySuffix => '易感性';

  @override
  String get healthLifestyleFactorsTitle => '生活方式因素';

  @override
  String get healthSleepDisciplineLabel => '睡眠自律';

  @override
  String get healthDietDisciplineLabel => '饮食自律';

  @override
  String get healthExerciseNeedLabel => '运动需求';

  @override
  String get healthSunlightNeedLabel => '日照需求';

  @override
  String get healthSocialTypeLabel => '社交类型';

  @override
  String get healthHealingSpeedLabel => '疗愈速度';

  @override
  String get wealthScoresHeader => '💰 财富评分';

  @override
  String get wealthStrengthStat => '财富\n力量';

  @override
  String get wealthAccumulationStat => '积累\n能力';

  @override
  String get wealthIncomeFlowStat => '收入\n流';

  @override
  String get wealthSustainStat => '可持续性';

  @override
  String get wealthMultiStreamStat => '多元收入流';

  @override
  String get wealthRetentionStat => '留存能力';

  @override
  String get wealthWord => '财富';

  @override
  String get wealthYogasTitle => '财富瑜伽';

  @override
  String get wealthDrainsLabel => '消耗因素';

  @override
  String get wealthBoostersLabel => '助推因素';

  @override
  String get wealthYearlyTrendTitle => '年度趋势';

  @override
  String get wealthGrowthTitle => '财富增长';

  @override
  String get wealthCashPressureTitle => '现金压力';

  @override
  String get wealthMoneyPersonalityTitle => '金钱性格';

  @override
  String get wealthTypeLabel => '财富类型';

  @override
  String get wealthRiskAppetiteLabel => '风险偏好';

  @override
  String get wealthInvestmentStyleLabel => '投资风格';

  @override
  String get wealthMoneyPersonalityLabel => '金钱性格';

  @override
  String get wealthSpendingLabel => '消费习惯';

  @override
  String get wealthDebtProbStat => '负债概率%';

  @override
  String get wealthInheritanceStat => '继承概率%';

  @override
  String get wealthSuddenGainsStat => '意外获利概率%';

  @override
  String get wealthSpouseBoostStat => '配偶加成%';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return '成功概率：$pct%';
  }

  @override
  String get wealthLifetimeClassLabel => '一生财富等级';

  @override
  String wealthPrimaryLabel(Object value) {
    return '主要：$value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return '巅峰：$value';
  }

  @override
  String get wealthIncomeWord => '收入';

  @override
  String get wealthSourcesSuffix => '来源';

  @override
  String get wealthInvestmentWord => '投资';

  @override
  String get wealthMixSuffix => '组合';

  @override
  String wealthDrivenByLabel(Object planet) {
    return '由$planet驱动';
  }

  @override
  String get marriageScoresHeader => '💒 婚姻评分';

  @override
  String get marriageOverallStat => '整体\n婚姻';

  @override
  String get marriageHarmonyStat => '婚姻\n和谐度';

  @override
  String get marriageDomesticStabilityStat => '家庭\n稳定性';

  @override
  String get marriageLongevityStat => '长久度';

  @override
  String get marriageSatisfactionStat => '满意度';

  @override
  String get marriageClarityStat => '清晰度';

  @override
  String get marriageWindowsTitle => '婚姻时段';

  @override
  String get marriagePhasesTitle => '婚姻阶段';

  @override
  String get marriageInLawRelationsStat => '姻亲关系';

  @override
  String get marriageFamilyHarmonyStat => '家庭和谐';

  @override
  String get marriageFertilityStat => '生育力';

  @override
  String get marriageHomeOwnershipStat => '购房能力';

  @override
  String get marriageDivorceRiskStat => '离婚风险';

  @override
  String get marriageInfidelityStat => '不忠风险';

  @override
  String get marriageConflictStat => '冲突';

  @override
  String get marriageDistanceStat => '情感疏离';

  @override
  String get marriageSeekInPartnerTitle => '★ 寻找伴侣时应关注';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ 择偶时应避免';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return '实现度：$pct%';
  }

  @override
  String get marriageDarakarakaWord => '配偶徵星（Darakaraka）';

  @override
  String get marriageSpouseKarakaSuffix => '配偶徵星';

  @override
  String get marriageDarakarakaDkLabel => '配偶徵星（DK）';

  @override
  String get marriage7thWord => '第七宫';

  @override
  String get marriageSignLabel => '星座';

  @override
  String get marriageLordInLabel => '主星位于';

  @override
  String get marriageStrengthLabel => '力量';

  @override
  String get marriageSpouseWord => '配偶';

  @override
  String get marriageProfileSuffix => '档案';

  @override
  String get marriageSpouseTraitsTitle => '★ 配偶特质';

  @override
  String get marriageLikelyProfessionsTitle => '● 可能的职业';

  @override
  String get marriageHarmonyWord => '和谐度';

  @override
  String get marriageRadarSuffix => '雷达图';

  @override
  String get marriagePhysicalLabel => '身体层面';

  @override
  String get marriageSharedValuesLabel => '共同价值观';

  @override
  String get marriageConflictResolutionLabel => '冲突化解';

  @override
  String get marriageMangalDoshLabel => '⚠ 火星缺陷（Mangal Dosh）';

  @override
  String marriageSeveritySubtitle(Object value) {
    return '严重程度：$value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return '抵消情况：$value';
  }

  @override
  String get marriageD9Word => 'D9';

  @override
  String get marriageNavamsaSuffix => '纳瓦姆萨';

  @override
  String get multiChartTitleChild => '子女';

  @override
  String get multiChartTitleLove => '爱情';

  @override
  String get multiChartTitleKarma => '业力';

  @override
  String get multiChartTitleDefault => '多重星盘';

  @override
  String get multiChartSuffixProbability => '概率';

  @override
  String get multiChartSuffixCompatibility => '合盘';

  @override
  String get multiChartSuffixLinkage => '关联';

  @override
  String get multiChartSuffixReport => '报告';

  @override
  String get multiChartParticipantsLabel => '参与者';

  @override
  String get multiChartAnalysisWord => '分析';

  @override
  String get multiChartConfidenceSuffix => '可信度';

  @override
  String get multiChartQualityBadge => '质量';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return '请分析这份吠陀占星报告，并给出详细的解读：\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return '这是一份吠陀占星专项报告。请深入分析并提供可操作的建议：\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return '请审阅这份吠陀占星分析，并用简单易懂的语言解释关键发现：\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return '已为$label复制！';
  }

  @override
  String get childProbTitle1 => '子女';

  @override
  String get childProbTitle2 => '概率';

  @override
  String get childNumberOfChildrenHeader1 => '子女';

  @override
  String get childNumberOfChildrenHeader2 => '数量';

  @override
  String get childTimingHeader1 => '时机';

  @override
  String get childTimingHeader2 => '命主大运';

  @override
  String get child5thHouseHeader1 => '第五宫';

  @override
  String get analysisWord => '分析';

  @override
  String get jupiterWord => '木星';

  @override
  String get childD7Header1 => 'D7萨普塔姆萨';

  @override
  String get childBeejaHeader1 => '种子与田地';

  @override
  String get childBeejaHeader2 => '斯普塔（Sphuta）';

  @override
  String get childDoshaHeader1 => '缺陷';

  @override
  String get childVedicHeader1 => '吠陀';

  @override
  String get childVedicHeader2 => '补救方法';

  @override
  String get progenyProbabilityLabel => '子嗣概率';

  @override
  String get favorableWindowsLabel => '有利时段';

  @override
  String get partnerOneLabel => '伴侣一';

  @override
  String get partnerTwoLabel => '伴侣二';

  @override
  String get moonSignLabel => '月亮星座';

  @override
  String get lordInDusthana => '主星落陷宫（Dusthana）';

  @override
  String get lordStrengthLabel => '主星力量';

  @override
  String get houseStrengthLabel => '宫位力量';

  @override
  String get dignityLabel => '力量状态';

  @override
  String get directBadge => '顺行';

  @override
  String get notCombustBadge => '未焦伤';

  @override
  String get in5thHouseBadge => '位于第五宫';

  @override
  String get aspects5thBadge => '相位第五宫';

  @override
  String get no5thConnectionBadge => '与第五宫无关联';

  @override
  String jupiterInSignHeading(String sign) {
    return '木星位于$sign';
  }

  @override
  String get d7LagnaLabel => 'D7上升星座';

  @override
  String get d7FifthSignLabel => 'D7第五宫星座';

  @override
  String get d7FifthLordLabel => 'D7第五宫主星';

  @override
  String get jupiterInD7Label => '木星在D7中';

  @override
  String get jupiterDignityLabel => '木星力量状态';

  @override
  String get d7StrengthLabel => 'D7强度';

  @override
  String get yesWord => '是';

  @override
  String get noWord => '否';

  @override
  String get beejaSphutaTitle => '种子斯普塔';

  @override
  String get kshetraSphutaTitle => '田地斯普塔';

  @override
  String get degreeLabel => '度数';

  @override
  String get signLordLabel => '星座主星';

  @override
  String get presentInLabel => '存在于';

  @override
  String get netPenaltyLabel => '净扣分';

  @override
  String get remedyGemstone => '宝石补救';

  @override
  String get remedyMantra => '真言补救';

  @override
  String get remedyRitual => '仪式补救';

  @override
  String get remedyLifestyle => '生活方式补救';

  @override
  String get remedyCharitable => '慈善补救';

  @override
  String copiedForName(String name) {
    return '已为$name复制！';
  }

  @override
  String get mahadashaLabel => '大运（Mahadasha）';

  @override
  String get mdPeriodLabel => '大运期间';

  @override
  String get antardashaLabel => '子运（Antardasha）';

  @override
  String get adPeriodLabel => '子运期间';

  @override
  String get pratyantardashaLabel => '孙运（Pratyantardasha）';

  @override
  String get favorabilityLabel => '有利程度';

  @override
  String factorPrefix(String factor) {
    return '因素：$factor';
  }

  @override
  String appliesToLabel(String value) {
    return '适用于：$value';
  }

  @override
  String get qualityTag => '质量';

  @override
  String get reliabilityVeryHigh => '极高可靠性';

  @override
  String get reliabilityGuidanceLevel => '指导性解读';

  @override
  String get karmaLinkTitle1 => '业力';

  @override
  String get karmaLinkTitle2 => '关联';

  @override
  String get karmaFoundationHeader1 => '业力';

  @override
  String get karmaFoundationHeader2 => '基础';

  @override
  String get karmaPairwiseHeader1 => '两两';

  @override
  String get karmaPairwiseHeader2 => '关联';

  @override
  String get karmaGroupHeader1 => '群体';

  @override
  String get karmaGroupHeader2 => '模式';

  @override
  String get karmaPastLifeHeader1 => '前世';

  @override
  String get karmaPastLifeHeader2 => '目标';

  @override
  String get karmaCurrentLifeHeader1 => '今生';

  @override
  String get karmaCurrentLifeHeader2 => '课题';

  @override
  String get karmaDebtsHeader2 => '债务';

  @override
  String get karmaMoolaDashaHeader1 => '命主大运';

  @override
  String get karmaMoolaDashaHeader2 => '时机';

  @override
  String get karmaDeepAuditHeader1 => '深度审查';

  @override
  String get karmaDeepAuditHeader2 => '表格';

  @override
  String get karmaHeroLabel => '前世业力关联';

  @override
  String get karmaKetuMastery => '计都精通';

  @override
  String get nakshatraLabel => '星宿';

  @override
  String get deityLabel => '守护神';

  @override
  String get masteryScoreLabel => '精通评分';

  @override
  String get karmaRahuGrowth => '罗睺成长';

  @override
  String get growthScoreLabel => '成长评分';

  @override
  String get karmaAtmakaraka => '灵魂行星';

  @override
  String get karmaSaturnKarma => '土星业力';

  @override
  String get karma12thHouse => '第十二宫';

  @override
  String get karma9thHousePunya => '第九宫福报';

  @override
  String get bhavaScoreLabel => '宫位评分';

  @override
  String get karmaD60Signature => 'D60印记';

  @override
  String get depthScoreLabel => '深度评分';

  @override
  String get linkageStrengthLabel => '关联强度';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return '关联因素（$count项已激活）';
  }

  @override
  String get factorColumnLabel => '因素';

  @override
  String get weightColumnLabel => '权重';

  @override
  String get meaningColumnLabel => '含义';

  @override
  String get statusColumnLabel => '状态';

  @override
  String get karmaPastLifeConnection => '前世联系';

  @override
  String get karmaCurrentLifeDynamic => '今生动态';

  @override
  String get karmaWhatTheyTeach => '彼此教导之事';

  @override
  String get karmaGroupThemeHeader => '群体业力主题';

  @override
  String get karmaSharedSettingHeader => '共同的前世背景';

  @override
  String get karmaCollectiveKetuHeader => '集体计都模式';

  @override
  String get karmaCollectiveRahuHeader => '集体罗睺模式';

  @override
  String get housesPrefixLabel => '宫位：';

  @override
  String get signsPrefixLabel => '星座：';

  @override
  String get karmicCohesionLabel => '业力凝聚力';

  @override
  String get karmaGroupSoulContractHeader => '群体灵魂契约';

  @override
  String get goalLabel => '目标';

  @override
  String get karmaSharedGoalHeader => '共同的前世目标';

  @override
  String get howToGrowHeader => '如何成长';

  @override
  String moolaDashaPrefix(String value) {
    return '命主大运：$value';
  }

  @override
  String get karmaSharedLessonHeader => '群体共同课题';

  @override
  String get karmaMutualTeachingHeader => '相互教导图谱';

  @override
  String get karmaTeachingDynamicsPlaceholder => '随着业力联系的深化，教导动态将逐渐显现。';

  @override
  String get typeFieldLabel => '类型';

  @override
  String get basisFieldLabel => '依据';

  @override
  String get resolutionPathHeader => '化解路径';

  @override
  String dashaTimingPrefix(String value) {
    return '大运时机：$value';
  }

  @override
  String get mutualDebtsHeader => '相互业力债务';

  @override
  String get mdLabel => '大运（MD）';

  @override
  String get adLabel => '子运（AD）';

  @override
  String get pdLabel => '孙运（PD）';

  @override
  String get datesLabel => '日期';

  @override
  String get groupKarmicWindowHeader => '群体业力时段';

  @override
  String parametersAuditedHeading(int count) {
    return '已审查$count项参数';
  }

  @override
  String get valuePrefixLabel => '数值：';

  @override
  String weightPrefix(String value) {
    return '权重：$value';
  }

  @override
  String get loveCompatTitle1 => '爱情';

  @override
  String get loveCompatTitle2 => '合盘';

  @override
  String get loveAttractionHeader1 => '吸引力与';

  @override
  String get loveAttractionHeader2 => '化学反应';

  @override
  String get loveEmotionalHeader1 => '情感';

  @override
  String get loveEmotionalHeader2 => '和谐度';

  @override
  String get loveMentalHeader1 => '心灵';

  @override
  String get loveMentalHeader2 => '默契';

  @override
  String get lovePassionHeader1 => '激情与';

  @override
  String get lovePassionHeader2 => '身体吸引';

  @override
  String get loveLongtermHeader1 => '长期';

  @override
  String get loveKarmicHeader1 => '业力爱情';

  @override
  String get loveKarmicHeader2 => '纽带';

  @override
  String get loveChallengesHeader1 => '挑战与';

  @override
  String get loveChallengesHeader2 => '摩擦';

  @override
  String get loveTimingHeader1 => '爱情时机';

  @override
  String get loveRelationshipHeader1 => '关系';

  @override
  String get loveRelationshipHeader2 => '动态';

  @override
  String get loveRemediesHeader1 => '补救方法与';

  @override
  String get loveRemediesHeader2 => '指引';

  @override
  String get loveCompatHeroLabel => '爱情合盘';

  @override
  String get loveChipAttraction => '吸引力';

  @override
  String get loveChipPassion => '激情';

  @override
  String get loveChipChallenge => '挑战';

  @override
  String get venusSignLabel => '金星星座';

  @override
  String get attractionScoreLabel => '吸引力评分';

  @override
  String get activeContactsLabel => '活跃相位';

  @override
  String get magneticPullLabel => '无形吸引力';

  @override
  String get initialAttractionLabel => '初始吸引力';

  @override
  String get emotionalScoreLabel => '情感评分';

  @override
  String get elementMatchLabel => '元素匹配度';

  @override
  String get harmonyLabel => '和谐度';

  @override
  String get kootaYoni => '尤尼（Yoni）';

  @override
  String get kootaGana => '伽纳（Gana）';

  @override
  String get kootaTara => '塔拉（Tara）';

  @override
  String get doshaPresentBadge => '存在缺陷';

  @override
  String get noDoshaBadge => '无缺陷';

  @override
  String get axisLabel => '轴线';

  @override
  String get mentalScoreLabel => '心灵评分';

  @override
  String get mercuryDynamicsLabel => '水星动态';

  @override
  String get communicationStyleLabel => '沟通风格匹配度';

  @override
  String get intellectualConnectionLabel => '智识连接';

  @override
  String get passionScoreLabel => '激情评分';

  @override
  String get marsVenusLabel => '火星-金星互动';

  @override
  String get physicalChemistryLabel => '身体吸引力';

  @override
  String get yoniCompatLabel => '尤尼合盘度';

  @override
  String get longtermScoreLabel => '长期评分';

  @override
  String get seventhHouseSynastryLabel => '第七宫合盘分析';

  @override
  String get commitmentPotentialLabel => '承诺潜力';

  @override
  String get jupiterBlessingLabel => '木星祝福';

  @override
  String get d9NavamsaResonanceLabel => 'D9纳瓦姆萨共鸣';

  @override
  String get saturnLongevityLabel => '土星长久度';

  @override
  String get karmicScoreLabel => '业力评分';

  @override
  String get darakarakaLinkLabel => '配偶徵星关联';

  @override
  String get sourceLabel => '来源';

  @override
  String get emotionalGiverReceiverLabel => '情感付出者/接受者';

  @override
  String get powerBalanceLabel => '权力平衡';

  @override
  String get growthDynamicLabel => '成长动态';

  @override
  String get addressesLabel => '针对问题';

  @override
  String get loveScoresLabel => '爱情评分';

  @override
  String get loveCapacityLabel => '爱的\n能力';

  @override
  String get emotionalAvailabilityLabel => '情感\n开放度';

  @override
  String get romanticAttractionLabel => '浪漫\n吸引力';

  @override
  String get commitmentWord => '承诺';

  @override
  String get intimacyWord => '亲密度';

  @override
  String get fidelityWord => '忠诚度';

  @override
  String get loveProfileTitle => '爱情档案';

  @override
  String get loveStyleLabel => '爱情风格';

  @override
  String get attractionStyleLabel => '吸引风格';

  @override
  String get lovePathLabel => '爱情路径';

  @override
  String get currentPhaseLabel => '当前阶段';

  @override
  String get commitmentStyleLabel => '承诺风格';

  @override
  String get loveWord => '爱情';

  @override
  String get karakasWord => '徵星';

  @override
  String get attractedToLabel => '吸引类型';

  @override
  String get whatPartnerSeesLabel => '伴侣眼中的您';

  @override
  String get romancePatternTitle => '恋爱模式';

  @override
  String get firstLoveAgeLabel => '初恋年龄';

  @override
  String get relationshipCountLabel => '感情关系数量';

  @override
  String get avgDurationLabel => '平均持续时间';

  @override
  String get breakupTriggerLabel => '分手诱因';

  @override
  String get heartbreakRecoveryLabel => '心碎恢复力';

  @override
  String get loveTrendTitle => '爱情趋势';

  @override
  String get newLoveWindowsTitle => '新恋情时段';

  @override
  String get loveBlocksTitle => '爱情阻碍';

  @override
  String get activeBlocksLabel => '已激活的阻碍';

  @override
  String get loveMarriagePctLabel => '自由恋爱婚姻概率%';

  @override
  String get heartbreakVulnLabel => '心碎易感度';

  @override
  String get selfSabotageLabel => '自我破坏';

  @override
  String get emotionalIqLabel => '情商';

  @override
  String fulfillmentPctLabel(String pct) {
    return '实现度：$pct%';
  }

  @override
  String get languagesWord => '爱之语言';

  @override
  String get givesLabel => '付出方式';

  @override
  String get receivesLabel => '接受方式';

  @override
  String get idealWord => '理想';

  @override
  String get partnerWord => '伴侣';

  @override
  String get seekTheseTraitsLabel => '应寻找的特质';

  @override
  String get dealbreakersLabel => '无法接受的底线';

  @override
  String get propertyScoresLabel => '财产评分';

  @override
  String get acquisitionCapacityLabel => '置产\n能力';

  @override
  String get homeOwnershipPctLabel => '购房\n概率%';

  @override
  String get reWealthPotentialLabel => '房产财富\n潜力';

  @override
  String get rentalWord => '租赁';

  @override
  String get vehiclesWord => '车辆';

  @override
  String get landPctLabel => '土地拥有率%';

  @override
  String get propertyProfileTitle => '财产档案';

  @override
  String get karmaTypeLabel => '业力类型';

  @override
  String get environmentLabel => '环境';

  @override
  String get styleLabel => '风格';

  @override
  String get sizeLabel => '规模';

  @override
  String get locationLabel => '地点';

  @override
  String get actionNext12mLabel => '未来12个月行动';

  @override
  String get propertyWord => '财产';

  @override
  String get propertyYogasTitle => '财产瑜伽';

  @override
  String get drainsLabel => '消耗因素';

  @override
  String get boostersLabel => '助推因素';

  @override
  String get propertyTrendTitle => '财产趋势';

  @override
  String get buyingWindowsTitle => '购置时段';

  @override
  String get constructionWindowsTitle => '建造时段';

  @override
  String get maternalInherPctLabel => '母系继承率%';

  @override
  String get paternalInherPctLabel => '父系继承率%';

  @override
  String get multiHomePctLabel => '多套房产率%';

  @override
  String get investmentPctLabel => '投资率%';

  @override
  String get vehicleProfileTitle => '车辆档案';

  @override
  String get countLabel => '数量';

  @override
  String get firstAgeLabel => '首次年龄';

  @override
  String get categoryLabel => '类别';

  @override
  String get luxuryLabel => '奢华度';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return '一生数量：$count · 实现度：$pct%';
  }

  @override
  String get pressureWord => '压力';

  @override
  String get protectionWord => '保护力';

  @override
  String get astrologicalWord => '占星学';

  @override
  String get keyRisksHeader1 => '关键';

  @override
  String get keyRisksHeader2 => '风险';

  @override
  String get reportCopiedShort => '报告已复制！';

  @override
  String get keyScoresLabel => '关键评分';

  @override
  String allScoresCountLabel(int count) {
    return '所有评分（$count项）';
  }

  @override
  String get windowsWord => '时段';

  @override
  String get genericFailedMsg => '失败';

  @override
  String get unknownWord => '未知';

  @override
  String selectKarmaChartsLabel(int max) {
    return '选择2至$max个星盘';
  }

  @override
  String selectChartsLabelCount(int max) {
    return '选择$max个星盘';
  }

  @override
  String runningAnalysisLabel(String label) {
    return '正在进行$label分析…';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return '选择2至$max个星盘以分析业力关联';
  }

  @override
  String get pickMaleFemaleHint => '请选择一男一女的星盘';

  @override
  String get personOneLabel => '人物一';

  @override
  String get personTwoLabel => '人物二';

  @override
  String get analysisFailedMsg => '分析失败';

  @override
  String analyzeChartsCountLabel(int count) {
    return '分析$count个星盘';
  }

  @override
  String get contextGeneralLabel => '常规';

  @override
  String get contextLoveLabel => '爱情';

  @override
  String get contextBusinessLabel => '商业';

  @override
  String get contextFamilyLabel => '家庭';

  @override
  String get contextTeamLabel => '团队';

  @override
  String get contextFriendshipLabel => '友情';

  @override
  String get relationshipIntelTitle => '关系洞察';

  @override
  String analyzingChartsCountLabel(int count) {
    return '正在分析$count个星盘…';
  }

  @override
  String get relationshipContextLabel => '关系背景';

  @override
  String get kundliMilanReportTitle => '星盘合婚报告';

  @override
  String get runningMilanAnalysisLabel => '正在进行合婚分析…';

  @override
  String selectedCountOfTwoLabel(int count) {
    return '已选择$count/2';
  }

  @override
  String get runMilanAnalysisBtn => '开始合婚分析';

  @override
  String get noChartsCreateFirst => '暂无星盘。请先创建一份本命盘。';

  @override
  String get selectBirthChartAnalyze => '选择要分析的本命盘';

  @override
  String get doshAnalysis => '缺陷分析';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active项已激活 / 共检查$total项';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active项已激活 / 共检查$total项瑜伽';
  }

  @override
  String yogaActiveHeader(Object count) {
    return '已激活瑜伽（$count项）';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return '隐藏未激活瑜伽（$count项）';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return '显示未激活瑜伽（$count项）';
  }

  @override
  String get loadFailed => '加载失败';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet大运 → 子运';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet子运 → 孙运';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet孙运 → 曾孙运';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet子期';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return '出生主星：$lord • 剩余：$balance年';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return '上升星座：$lagna • 剩余：$balance年';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years年';
  }

  @override
  String get dashaCurrentPeriod => '当前大运期';

  @override
  String dashaAsOf(Object date) {
    return '截至：$date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return '当前运程中已激活的瑜伽（$count项）';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return '当前运程中已激活的缺陷（$count项）';
  }

  @override
  String get dashaNoYogasTriggered => '未触发任何瑜伽';

  @override
  String get dashaNoDoshasTriggered => '未触发任何缺陷';

  @override
  String get divD1Name => '本命盘（D1）';

  @override
  String get divD1Desc => '肉身存在，涵盖一切事项';

  @override
  String get divD2Name => '霍拉盘（D2）';

  @override
  String get divD2Desc => '财富、金钱';

  @override
  String get divD3Name => '德雷卡纳盘（D3）';

  @override
  String get divD3Desc => '兄弟姐妹、勇气';

  @override
  String get divD4Name => '查图尔塔姆萨盘（D4）';

  @override
  String get divD4Desc => '财产、住所、运势';

  @override
  String get divD5Name => '潘查姆萨盘（D5）';

  @override
  String get divD5Desc => '声望、权威、权力';

  @override
  String get divD6Name => '沙什塔姆萨盘（D6）';

  @override
  String get divD6Desc => '健康问题';

  @override
  String get divD7Name => '萨普塔姆萨盘（D7）';

  @override
  String get divD7Desc => '子女、孙辈';

  @override
  String get divD8Name => '阿什塔姆萨盘（D8）';

  @override
  String get divD8Desc => '突发麻烦、诉讼';

  @override
  String get divD9Name => '纳瓦姆萨盘（D9）';

  @override
  String get divD9Desc => '婚姻、配偶、达摩';

  @override
  String get divD10Name => '达萨姆萨盘（D10）';

  @override
  String get divD10Desc => '事业、职业';

  @override
  String get divD11Name => '鲁德拉姆萨盘（D11）';

  @override
  String get divD11Desc => '死亡、毁灭';

  @override
  String get divD12Name => '德瓦达萨姆萨盘（D12）';

  @override
  String get divD12Desc => '父母、血亲';

  @override
  String get divD16Name => '十六分盘（D16）';

  @override
  String get divD16Desc => '车辆、舒适、享乐';

  @override
  String get divD20Name => '温沙姆萨盘（D20）';

  @override
  String get divD20Desc => '灵性事务、宗教';

  @override
  String get divD24Name => '二十四分盘（D24）';

  @override
  String get divD24Desc => '学习、知识、教育';

  @override
  String get divD27Name => '星宿盘（D27）';

  @override
  String get divD27Desc => '优势、弱点、本性';

  @override
  String get divD30Name => '特灵沙姆萨盘（D30）';

  @override
  String get divD30Desc => '灾厄、潜意识、惩罚';

  @override
  String get divD40Name => '卡维达姆萨盘（D40）';

  @override
  String get divD40Desc => '吉凶祸福（母系）';

  @override
  String get divD45Name => '阿克沙维达姆萨盘（D45）';

  @override
  String get divD45Desc => '一切事项（父系）';

  @override
  String get divD60Name => '沙什提安萨盘（D60）';

  @override
  String get divD60Desc => '前世业力——最为重要';

  @override
  String get lifeAreaCareer => '事业';

  @override
  String get lifeAreaWealth => '财富';

  @override
  String get lifeAreaMarriage => '婚姻';

  @override
  String get lifeAreaHealth => '健康';

  @override
  String get lifeAreaSpirituality => '灵性';

  @override
  String lifeAreaGrade(Object grade) {
    return '等级：$grade';
  }

  @override
  String get lifeAreaFactorsLabel => '因素：';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return '星宿：$nakshatra（第$pada分度）';
  }

  @override
  String planetNakLord(Object lord) {
    return '星宿主：$lord';
  }

  @override
  String planetLongitude(Object value) {
    return '经度：$value°';
  }

  @override
  String get chakraOverallHealth => '整体健康';

  @override
  String get careerWord => '事业';

  @override
  String get failedToLoad => '加载失败';

  @override
  String get kundliAscendantLagna => '上升星座（Lagna）';

  @override
  String get kundliMoonSignRashi => '月亮星座（Rashi）';

  @override
  String get kundliSunSign => '太阳星座';

  @override
  String kundliEngineLabel(Object engine) {
    return '引擎：$engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return '度数：$degree° • 星宿：$nakshatra（第$pada分度）';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return '星宿主星：$lord • 力量状态：$dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return '$base盘 — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return '$base盘';
  }

  @override
  String get careerSummary => '事业概览';

  @override
  String get phase => '阶段';

  @override
  String get confidenceLabel => '可信度';

  @override
  String get careerScores => '事业评分';

  @override
  String get stabilityLabel => '稳定性';

  @override
  String get growthLabel => '成长性';

  @override
  String get gradeExcellent => '优秀';

  @override
  String get gradeGood => '良好';

  @override
  String get gradeAverage => '一般';

  @override
  String get gradeBelowAvg => '低于平均';

  @override
  String get gradeWeak => '较弱';

  @override
  String get careerTypeDomain => '事业与领域';

  @override
  String get careerTimeline => '事业时间线';

  @override
  String dashaLabel(Object dasha) {
    return '大运：$dasha';
  }

  @override
  String get improvementSuggestions => '改进建议';

  @override
  String get chartDetails => '星盘详情';

  @override
  String get keyHousesCareer => '关键宫位（事业）';

  @override
  String get keyCareerPlanets => '关键事业行星';

  @override
  String get empty => '空';

  @override
  String get guna => '古纳';

  @override
  String get dasha => '大运';

  @override
  String get satwik => '悦性（Satwik）';

  @override
  String get rajasik => '动性（Rajasik）';

  @override
  String get tamasik => '惰性（Tamasik）';

  @override
  String get charGroupCorePersonality => '核心性格';

  @override
  String get charGroupTrustHonesty => '信任与诚实';

  @override
  String get charGroupLoyaltyCommitment => '忠诚与承诺';

  @override
  String get charGroupStrategicPrivacy => '策略与隐私';

  @override
  String get charGroupFinancial => '财务';

  @override
  String get charGroupAngerConflict => '愤怒与冲突';

  @override
  String get charGroupMoralDharmic => '道德与达摩';

  @override
  String get charGroupIntellectCommunication => '智力与沟通';

  @override
  String get charGroupEmotionalProfile => '情感档案';

  @override
  String get charGroupMentalHealth => '心理健康';

  @override
  String get charGroupRomantic => '浪漫倾向';

  @override
  String get charGroupMarriageFamily => '婚姻与家庭';

  @override
  String get charGroupOverallLife => '整体人生';

  @override
  String get grahaDrishti => '行星相位（Graha Drishti）';

  @override
  String get grahaDrishtiSubtitle => '谁相位谁（%）';

  @override
  String get lagnaAspectsReceived => '上升星座接收的相位';

  @override
  String get rashiDrishti => '星座相位（Rashi Drishti）';

  @override
  String get shadbalaRupas => '鲁帕（Rupa）';

  @override
  String get bhavaHouse1 => '自我/身体';

  @override
  String get bhavaHouse2 => '财富/家庭';

  @override
  String get bhavaHouse3 => '兄弟姐妹/勇气';

  @override
  String get bhavaHouse4 => '家庭/母亲';

  @override
  String get bhavaHouse5 => '子女/智力';

  @override
  String get bhavaHouse6 => '仇敌/健康';

  @override
  String get bhavaHouse7 => '婚姻/伴侣';

  @override
  String get bhavaHouse8 => '寿元';

  @override
  String get bhavaHouse9 => '福运/导师';

  @override
  String get bhavaHouse10 => '事业/父亲';

  @override
  String get bhavaHouse11 => '收益/朋友';

  @override
  String get bhavaHouse12 => '损失/解脱';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • 主星：$lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV：$value';
  }

  @override
  String get sarvaAshtakavarga => '总阿什塔卡瓦尔加（SAV）';

  @override
  String savSubtitle(Object total, Object avg) {
    return '总计：$total点（星座平均值=$avg）';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return '总计：$total点 • 本命星座：$score';
  }

  @override
  String get today => '今天';

  @override
  String gocharTransitScores(Object date) {
    return '行运（Gochar，行运评分）— $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return '本命月亮：$sign';
  }

  @override
  String get gocharBest => '最佳';

  @override
  String get gocharWorst => '最差';

  @override
  String copiedOpening(Object ai) {
    return '已复制！正在打开$ai…';
  }

  @override
  String get openLink => '打开 ↗';

  @override
  String get discussReportWithAI => '与AI讨论此报告';

  @override
  String get reliabilityHigh => '高可靠性';

  @override
  String get reliabilityModerate => '中等可靠性';

  @override
  String get reliabilityLow => '较低——仅供参考';

  @override
  String get reliabilityGoodEdu => '良好可靠性 · 已通过D24验证';

  @override
  String get relationshipWord => '关系';

  @override
  String get intelligenceWord => '洞察';

  @override
  String get relationshipIntelligence => '关系洞察';

  @override
  String get typeLabel => '类型';

  @override
  String get trustLabel => '信任';

  @override
  String get dhokaRisk => '背叛风险';

  @override
  String get powerLabel => '权力';

  @override
  String get integrity => '正直度';

  @override
  String get warmth => '热情度';

  @override
  String get trustWord => '信任';

  @override
  String get assertLabel => '果断度';

  @override
  String get character => '性格';

  @override
  String get love => '爱情';

  @override
  String get businessWord => '商业';

  @override
  String get karmic => '业力';

  @override
  String get enmityRisk => '敌意风险';

  @override
  String get hdrChartProfiles => '星盘概况';

  @override
  String get hdrPairwiseAnalysis => '两两分析';

  @override
  String get hdrCriticalPatterns => '关键模式';

  @override
  String get hdrGroupRecommendations => '群体建议';

  @override
  String get sharedPractices => '共同实践';

  @override
  String get hdrIndividualGuidance => '个人指导';

  @override
  String get growthAreas => '成长领域';

  @override
  String get hdrCoreTheme => '核心主题';

  @override
  String get growthOriented => '成长导向';

  @override
  String get groupTheme => '群体主题';

  @override
  String get compatibility => '合盘度';

  @override
  String get unifiedScoreLabel => '综合评分';

  @override
  String get ashtakoot => '阿什塔库特';

  @override
  String get probability => '概率';

  @override
  String get hdrAshtakootSummary => '阿什塔库特概览';

  @override
  String get hdrGunBreakdown => '八项古纳明细';

  @override
  String get hdrMangalDosh => '火星缺陷（Mangal Dosh）';

  @override
  String get hdrD9CrossChart => 'D9交叉分析';

  @override
  String get d9Compatibility => 'D9合盘度';

  @override
  String get hdrDomainCompatibility => '各领域合盘度';

  @override
  String get emotional => '情感';

  @override
  String get intellectual => '智识';

  @override
  String get spiritual => '灵性';

  @override
  String get financial => '财务';

  @override
  String get domestic => '家庭生活';

  @override
  String get communicationWord => '沟通';

  @override
  String get sharedDharma => '共同达摩';

  @override
  String get familyCreation => '组建家庭';

  @override
  String get hdrMarriageTiming => '婚姻时机';

  @override
  String get jointMarriageWindows => '共同婚姻时段';

  @override
  String get engagementWindows => '订婚时段';

  @override
  String get recommendedLabel => '推荐';

  @override
  String get hdrKeyRisks => '关键风险';

  @override
  String get hdrFinalVerdict => '最终结论';

  @override
  String get marriageVerdict => '婚姻结论';

  @override
  String get educationWord => '教育';

  @override
  String get learningSuffix => '与学习';

  @override
  String get coreEducationScores => '核心教育评分';

  @override
  String get academicSuccess => '学业成就';

  @override
  String get learningCapacity => '学习能力';

  @override
  String get memory => '记忆力';

  @override
  String get intelligence => '智力';

  @override
  String get research => '研究能力';

  @override
  String get hdrIntellectualProfile => '智识档案';

  @override
  String get learningSignature => '学习印记';

  @override
  String get hdrSubjectKaraka => '学科徵星';

  @override
  String get hdrHouseFoundations => '宫位基础';

  @override
  String get hdrMercuryJupiter => '水星与木星';

  @override
  String get hdrEducationYogas => '教育瑜伽';

  @override
  String get hdrDivisionalValidation => '分盘验证';

  @override
  String get standing => '地位';

  @override
  String get hdrSubjectRanking => '学科排名';

  @override
  String get hdrDegreeLikelihood => '学位可能性';

  @override
  String get hdrStudyPeriods => '学习时期';

  @override
  String get earlySchooling => '早期教育';

  @override
  String get higherEducation => '高等教育';

  @override
  String get postgradResearch => '研究生·科研';

  @override
  String get hdrLearningPreferences => '学习偏好';

  @override
  String get hdrChallengesGifts => '挑战与天赋';

  @override
  String get challenges => '挑战';

  @override
  String get cognitiveGifts => '认知天赋';

  @override
  String get naturalAbilities => '天生能力';

  @override
  String get hdrSaraswatiRemedies => '妙音天女补救法';

  @override
  String get studentVerdict => '学业结论';

  @override
  String get educationCareerLinkage => '教育→职业关联';

  @override
  String get startupSuffix => '与创业';

  @override
  String get coreBusinessScores => '核心商业评分';

  @override
  String get overallBusiness => '整体商业';

  @override
  String get ventureSuccess => '创业成功率';

  @override
  String get eleventhHouse => '第十一宫';

  @override
  String get gains => '收益';

  @override
  String get investor => '投资者';

  @override
  String get hdrFounderArchetype => '创始人原型';

  @override
  String get hdrTenthEleventhHouses => '第十宫与第十一宫';

  @override
  String get hdrBusinessYogas => '商业瑜伽';

  @override
  String get hdrRecommendedDomains => '推荐领域';

  @override
  String get hdrBusinessStyle => '经商风格';

  @override
  String get hdrFounderSkills => '创始人技能';

  @override
  String get hdrFundingProfile => '融资档案';

  @override
  String get recommendedPath => '推荐路径';

  @override
  String get investorAttract => '投资者吸引力';

  @override
  String get familyBacking => '家庭支持';

  @override
  String get hybridViability => '混合模式可行性';

  @override
  String get launchWindow => '启动时段';

  @override
  String get scaleWindow => '扩张时段';

  @override
  String get hdrBusinessRisks => '商业风险';

  @override
  String get recoveryCapacity => '恢复能力';

  @override
  String get hdrRemediesSolutions => '补救方法与解决方案';

  @override
  String get aiConnectionLost => '连接已断开，请重试。';

  @override
  String get aiSomethingWrong => '出现了一些问题';

  @override
  String get aiNoResponse => '无响应';

  @override
  String get aiConnectionError => '连接错误，请重试。';

  @override
  String get aiAutoDetect => '自动检测';

  @override
  String aiAutoArrow(String lang) {
    return '自动 → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return '语言：$lang';
  }

  @override
  String get aiNoBirthCharts => '未找到本命盘';

  @override
  String get aiCreateChartFirst => '请先创建本命盘以便与AI对话';

  @override
  String get aiSelectChartBegin => '选择一份本命盘以开始分析';

  @override
  String aiAnalyzingName(String name) {
    return '正在分析：$name';
  }

  @override
  String get aiChange => '更换';

  @override
  String get aiAnalyzingChart => '正在分析您的星盘…';

  @override
  String get aiAskStarsHint => '向星辰询问任何问题…';

  @override
  String get aiSuggestedFollowups => '推荐追问';

  @override
  String get aiThinking => '思考中…';

  @override
  String get aiThanks => '谢谢！';

  @override
  String get aiFeedbackNoted => '已记录反馈';

  @override
  String get svcAll => '全部';

  @override
  String get svcNoServices => '暂无可用服务';

  @override
  String get svcFree => '免费';

  @override
  String get astroFailedStartCall => '无法发起通话';

  @override
  String get astroFailedStartChat => '无法发起聊天';

  @override
  String astroErrorDetail(String error) {
    return '错误：$error';
  }

  @override
  String get astroExperience => '经验';

  @override
  String get astroSessions => '咨询次数';

  @override
  String get astroMinutes => '分钟数';

  @override
  String get astroAbout => '关于';

  @override
  String get astroLanguages => '语言';

  @override
  String get astroRateCard => '价目表';

  @override
  String get astroVoice => '语音';

  @override
  String astroReviews(int count) {
    return '评价（$count条）';
  }

  @override
  String get astroNoReviews => '暂无评价';

  @override
  String get astroAnonymous => '匿名用户';

  @override
  String get forgotPasswordSubtitle => '请输入您的邮箱，我们将发送\n密码重置链接给您。';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => '重新发送链接';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => '您的宇宙之旅即将开始';

  @override
  String get home => '首页';

  @override
  String get astrologers => '占星师';

  @override
  String get services => '服务';

  @override
  String get wallet => '钱包';

  @override
  String get profile => '我的';

  @override
  String get live => '直播';

  @override
  String get kundli => '星盘';

  @override
  String get chat => '聊天';

  @override
  String get call => '通话';

  @override
  String get video => '视频';

  @override
  String get signIn => '登录';

  @override
  String get createAccount => '创建账户';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get fullName => '全名';

  @override
  String get phone => '电话';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get backToSignIn => '返回登录';

  @override
  String get dontHaveAccount => '还没有账户？';

  @override
  String get alreadyHaveAccount => '已经有账户了？';

  @override
  String get continueGoogle => '使用Google继续';

  @override
  String get required => '必填项';

  @override
  String get minSixChars => '最少6个字符';

  @override
  String get passwordsMismatch => '两次输入的密码不一致';

  @override
  String get validEmailRequired => '请输入有效的邮箱地址';

  @override
  String get loginFailed => '登录失败';

  @override
  String get signupFailed => '注册失败';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get todaysHoroscope => '今日运势';

  @override
  String get todaysRashi => '今日星座';

  @override
  String get tapDetails => '点击查看详情';

  @override
  String get allServices => '所有服务';

  @override
  String get seeAll => '查看全部';

  @override
  String get topAstrologers => '顶级占星师';

  @override
  String get onlineExperts => '在线专家随时为您咨询';

  @override
  String get searchAstrologers => '搜索占星师…';

  @override
  String get noAstrologersFound => '未找到占星师';

  @override
  String get online => '在线';

  @override
  String get offline => '离线';

  @override
  String get busy => '忙碌中';

  @override
  String get perMin => '/分钟';

  @override
  String get noCharts => '暂无本命盘';

  @override
  String get createFirst => '创建您的第一份出生星盘';

  @override
  String get createChart => '创建星盘';

  @override
  String get newBirthChart => '新建本命盘';

  @override
  String get clientName => '客户姓名';

  @override
  String get gender => '性别';

  @override
  String get male => '男';

  @override
  String get female => '女';

  @override
  String get other => '其他';

  @override
  String get dateOfBirth => '出生日期';

  @override
  String get timeOfBirth => '出生时间';

  @override
  String get birthPlace => '出生地点';

  @override
  String get birthPlaceHint => '输入城市名称进行搜索…';

  @override
  String get generateKundli => '生成星盘';

  @override
  String get birthChartCreated => '本命盘创建成功！';

  @override
  String get deleteChart => '删除星盘？';

  @override
  String get cannotUndo => '此操作无法撤销。';

  @override
  String get primary => '主要';

  @override
  String get viewKundli => '查看星盘';

  @override
  String get completeBirthChart => '完整本命盘';

  @override
  String get birthDetails => '出生信息';

  @override
  String get name => '姓名';

  @override
  String get dob => '出生日期';

  @override
  String get tob => '出生时间';

  @override
  String get place => '地点';

  @override
  String get summary => '概览';

  @override
  String get planets => '行星';

  @override
  String get divisions => '分盘';

  @override
  String get vimshottari => '维姆修塔里（Vimshottari）';

  @override
  String get moola => '命主大运（Moola）';

  @override
  String get gochar => '行运（Gochar）';

  @override
  String get dosh => '缺陷';

  @override
  String get yoga => '瑜伽';

  @override
  String get shadbala => '沙德巴拉（Shadbala）';

  @override
  String get ashtakavarga => '阿什塔卡瓦尔加（Ashtakavarga）';

  @override
  String get aspects => '相位';

  @override
  String get lifeAreas => '人生领域';

  @override
  String get bhava => '宫位（Bhava）';

  @override
  String get chakras => '脉轮';

  @override
  String get dashaActive => '当前大运';

  @override
  String get lagna => '上升星座';

  @override
  String get moon => '月亮';

  @override
  String get sun => '太阳';

  @override
  String get premiumSection => '高级内容';

  @override
  String get unlockReading => '解锁此解读以查看详细分析。';

  @override
  String get unlock => '解锁';

  @override
  String get retrograde => '逆行';

  @override
  String get combust => '焦伤';

  @override
  String get vargottama => '同宫互映（Vargottama）';

  @override
  String get exalted => '旺相';

  @override
  String get debilitated => '弱相';

  @override
  String get addBalance => '充值';

  @override
  String get amount => '金额';

  @override
  String get walletBalance => '钱包余额';

  @override
  String get recharge => '充值';

  @override
  String get bonus => '赠送金额';

  @override
  String get serviceLabel => '服务';

  @override
  String get refund => '退款';

  @override
  String get noTransactions => '暂无交易记录';

  @override
  String get editProfile => '编辑资料';

  @override
  String get savedAstrologers => '收藏的占星师';

  @override
  String get noSavedAstrologers => '暂无收藏的占星师';

  @override
  String get myOrders => '我的订单';

  @override
  String get communicationHistory => '沟通记录';

  @override
  String get chatHistory => '聊天记录';

  @override
  String get callHistory => '通话记录';

  @override
  String get logout => '退出登录';

  @override
  String get chatMessages => '聊天消息';

  @override
  String get typeMessage => '输入消息…';

  @override
  String get sessionEnded => '会话已结束';

  @override
  String get endChat => '结束聊天？';

  @override
  String get endChatConfirm => '您确定要结束此次聊天会话吗？';

  @override
  String get sendPhoto => '发送照片';

  @override
  String get sendPDF => '发送PDF';

  @override
  String get upload => '上传';

  @override
  String get fileNotFound => '未找到文件';

  @override
  String get voiceCall => '语音通话';

  @override
  String get videoCall => '视频通话';

  @override
  String get ringing => '响铃中…';

  @override
  String get connected => '已连接';

  @override
  String get endCall => '结束通话';

  @override
  String get mute => '静音';

  @override
  String get unmute => '取消静音';

  @override
  String get speaker => '扬声器';

  @override
  String get camera => '摄像头';

  @override
  String get flip => '切换镜头';

  @override
  String get liveStreams => '直播';

  @override
  String get noLiveStreams => '当前没有直播';

  @override
  String get astrologerUnavailable => '占星师不可用，直播即将结束。';

  @override
  String get streamEnded => '直播已结束';

  @override
  String get superChat => '超级留言';

  @override
  String get sendGift => '赠送礼物';

  @override
  String get goBack => '返回';

  @override
  String get appPermissions => '应用权限';

  @override
  String get grantPermissions => '授予权限';

  @override
  String get skipForNow => '暂时跳过';

  @override
  String get microphone => '麦克风';

  @override
  String get notifications => '通知';

  @override
  String get storage => '存储空间';

  @override
  String get ok => '确定';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get retry => '重试';

  @override
  String get send => '发送';

  @override
  String get refresh => '刷新';

  @override
  String get loading => '加载中…';

  @override
  String get noData => '暂无数据';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get language => '语言';

  @override
  String get english => '英语';

  @override
  String get myDetails => '我的信息';

  @override
  String get myKundlis => '我的星盘';

  @override
  String get walletRecharge => '钱包与充值';

  @override
  String get consultationHistory => '咨询记录';

  @override
  String get helpSupport => '帮助与支持';

  @override
  String get biometricLogin => '生物识别登录';

  @override
  String get pastVoiceConsultations => '历史语音咨询';

  @override
  String get pastTextConversations => '历史文字对话';

  @override
  String get comingSoon => '敬请期待';

  @override
  String get totalCredit => '总收入';

  @override
  String get totalDebit => '总支出';

  @override
  String get statement => '对账单';

  @override
  String get allTypes => '所有类型';

  @override
  String get prev => '上一页';

  @override
  String get next => '下一页';

  @override
  String get allInsights => '全部洞察';

  @override
  String get yourCompleteReading => '您的完整解读';

  @override
  String get expertEngines => '专业引擎';

  @override
  String get eachInsightConsultation => '每一项洞察都是一次完整的咨询';

  @override
  String get engines => '引擎';

  @override
  String get dataPoints => '数据点';

  @override
  String get singleChart => '单人';

  @override
  String get careerPurpose => '事业与使命';

  @override
  String get wealthAssets => '财富与资产';

  @override
  String get loveRelationships => '爱情与人际关系';

  @override
  String get healthWellness => '健康与身心';

  @override
  String get soulKarma => '灵魂与业力';

  @override
  String get specialistReports => '专项报告';

  @override
  String get searchByNameSpeciality => '按姓名、专长搜索…';

  @override
  String get sortedByRating => '按评分排序';

  @override
  String get initiatingChat => '正在发起聊天…';

  @override
  String get startingCall => '正在发起通话…';

  @override
  String get yrs => '年';

  @override
  String get chatWithAISpecialist => '与AI专家聊天';

  @override
  String get tapToStart => '点击开始';

  @override
  String get astrologer => '占星师';

  @override
  String get reports => '报告';

  @override
  String get milan => '合婚';

  @override
  String get forecast => '运势预测';

  @override
  String get rashi => '星座';

  @override
  String get jupiterFavorsBold => '木星有利于大胆行动';

  @override
  String get careerIlluminated => '您的事业宫得到照耀——请相信自己的直觉。';

  @override
  String get todaysForecast => '今日运势预测';

  @override
  String get engCareer => '事业与工作';

  @override
  String get engBusiness => '商业与创业';

  @override
  String get engEducation => '教育与学习';

  @override
  String get engLifePath => '人生路径与运势';

  @override
  String get engWealth => '财富与财务';

  @override
  String get engDebt => '债务与财务恢复';

  @override
  String get engProperty => '财产与资产';

  @override
  String get engLegal => '法律与纠纷';

  @override
  String get engLove => '爱情与恋爱';

  @override
  String get engMarriage => '婚姻与家庭';

  @override
  String get engKundliMilan => '星盘合婚';

  @override
  String get engRelationship => '关系洞察';

  @override
  String get engLoveCompat => '爱情合盘';

  @override
  String get engChildProb => '子女概率';

  @override
  String get engHealth => '健康与身心';

  @override
  String get engMental => '心理与压力';

  @override
  String get engCharacter => '性格分析';

  @override
  String get engPastLife => '前世与业力';

  @override
  String get engKarmaLink => '业力关联';

  @override
  String get noChatSessions => '暂无聊天记录';

  @override
  String get chatAppearHere => '您与占星师的对话将显示在这里。';

  @override
  String get noCallsYet => '暂无通话记录';

  @override
  String get callAppearHere => '您与占星师的通话记录将显示在这里。';

  @override
  String get chatWith => '与...聊天';

  @override
  String get msgs => '条消息';

  @override
  String get voiceCallLabel => '语音通话';

  @override
  String get videoCallLabel => '视频通话';

  @override
  String get pullToRefresh => '下拉刷新';

  @override
  String get sessionExpired => '会话已过期';

  @override
  String get connectionFailed => '连接失败';

  @override
  String get callActive => '通话进行中';

  @override
  String get lessThanOneMin => '剩余不到1分钟';

  @override
  String get noMessages => '此会话中没有消息';

  @override
  String get gocharForAllSigns => '今日全部12个星座的行运';

  @override
  String get selectChart => '选择要分析的星盘';

  @override
  String get selectTwoCharts => '选择两个星盘';

  @override
  String get analyzing => '分析中…';

  @override
  String get browseAstrologers => '浏览占星师';

  @override
  String get probableNumber => '可能数量';

  @override
  String get genderTendency => '性别倾向';

  @override
  String get son => '儿子';

  @override
  String get daughter => '女儿';

  @override
  String get occupants => '宫内行星';

  @override
  String get beneficAspects => '吉星相位';

  @override
  String get maleficAspects => '凶星相位';

  @override
  String get nextFavorableWindow => '下一个有利时段';

  @override
  String get totalDoshaPenalty => '总缺陷扣分';

  @override
  String get cancellationFactors => '抵消因素';

  @override
  String get combinedFertility => '综合生育力指标';

  @override
  String get planetPositions => '行星位置';

  @override
  String get bestWindows => '最佳时段';

  @override
  String get worstWindows => '最差时段';

  @override
  String get scoreComponents => '评分构成';

  @override
  String get topOpportunities => '主要机遇';

  @override
  String get topRisks => '主要风险';

  @override
  String get remedies => '补救方法';

  @override
  String get keyInsights => '核心洞察';

  @override
  String get overallVerdict => '总体结论';

  @override
  String get venusContacts => '金星交叉相位';

  @override
  String get contact => '相位';

  @override
  String get effect => '影响';

  @override
  String get moonSignCompat => '月亮星座合盘度';

  @override
  String get hisMoon => '男方月亮';

  @override
  String get herMoon => '女方月亮';

  @override
  String get nakshatraCompat => '星宿合盘度';

  @override
  String get ketuContacts => '计都相位';

  @override
  String get rahuContacts => '罗睺相位';

  @override
  String get pastLifeIndication => '前世指标';

  @override
  String get totalChallengePenalty => '总挑战扣分';

  @override
  String get manifestation => '显现方式';

  @override
  String get cancellation => '抵消';

  @override
  String get navigation => '应对方法';

  @override
  String get potentialStrengths => '潜在优势';

  @override
  String get areasToNurture => '需要培育的领域';

  @override
  String get relationshipGuidance => '关系指引';

  @override
  String get detailedSummary => '详细概览';

  @override
  String get discussWithAI => '与AI讨论';

  @override
  String get planet => '行星';

  @override
  String get sign => '星座';

  @override
  String get house => '宫位';

  @override
  String get strength => '力量';

  @override
  String get copy => '复制';

  @override
  String get confidence => '可信度';

  @override
  String get d7Saptamsa => 'D7萨普塔姆萨';

  @override
  String get numberExplanation => '数量说明';

  @override
  String get genderExplanation => '性别说明';

  @override
  String get inFifth => '是否位于第五宫？';

  @override
  String get primaryArchetype => '主要原型';

  @override
  String get mitigation => '缓解方法';

  @override
  String get soulCareerAlign => '灵魂与事业契合度';

  @override
  String get favorablePeriods => '有利时期';

  @override
  String get challengingPeriods => '挑战时期';

  @override
  String get keyHouses => '关键宫位';

  @override
  String get keyPlanets => '关键行星';

  @override
  String get characterOverview => '性格概览';

  @override
  String get noYogasActive => '此星盘中当前没有已激活的瑜伽。';

  @override
  String get basedOnPlanetStrengths => '基于行星力量与宫位落位';

  @override
  String get basedOnTransits => '基于当前行星行运';

  @override
  String get currentPlanetPositions => '以您的星座为第一宫的当前行星位置';

  @override
  String get favorablePeriodAdvice => '有利时期——专注于事业发展与人际关系。';

  @override
  String get noClassicalYogas => '虽无经典学习瑜伽，成功仍可通过持续努力获得。';

  @override
  String get walletDeduction => '此金额将从您的钱包中扣除';

  @override
  String get bhakootAxis => '巴库特轴（Bhakoot Axis）';

  @override
  String get basis => '依据';

  @override
  String get selectChartsForMilan => '选择2个星盘进行合婚分析';

  @override
  String get selectMultiCharts => '选择2至5个星盘';

  @override
  String get running => '进行中';

  @override
  String get past => '过去';

  @override
  String get topActiveDoshas => '主要已激活缺陷';

  @override
  String get allDoshas => '全部缺陷';

  @override
  String get activeYogas => '已激活瑜伽';

  @override
  String get activeDoshas => '已激活缺陷';

  @override
  String get yogaAnalysis => '瑜伽分析';

  @override
  String get factors => '因素';

  @override
  String get dominantPlanet => '主导行星';

  @override
  String get startSession => '开始会话';

  @override
  String get notesSaved => '笔记已保存';

  @override
  String get unlocked => '已解锁！尽情享受您的解读吧。';

  @override
  String get todaysGochar => '今日行运';

  @override
  String get todaysTransitChart => '今日行运星盘';

  @override
  String get lifeAreaPredictions => '人生领域预测';

  @override
  String get strengths => '优势';

  @override
  String get weaknesses => '弱点';

  @override
  String get ruledBy => '主管行星';

  @override
  String get kundliMilan => '星盘合婚';

  @override
  String get startKundliMilan => '开始星盘合婚';

  @override
  String get recommendations => '建议';

  @override
  String get cancellations => '抵消';

  @override
  String get dashaSync => '大运同步度';

  @override
  String get transitMarriageWindows => '行运婚姻时段';

  @override
  String get overlappingWindows => '重叠婚姻时段';

  @override
  String get overallStrength => '整体力量';

  @override
  String get stability => '稳定性';

  @override
  String get growth => '成长性';

  @override
  String get clarity => '清晰度';

  @override
  String get recognition => '认可度';

  @override
  String get satisfaction => '满意度';

  @override
  String get verdict => '结论';

  @override
  String get topRoles => '最佳角色';

  @override
  String get areasForGrowth => '成长领域';

  @override
  String get bestIndustries => '最佳行业';

  @override
  String get employment => '受雇工作';

  @override
  String get entrepreneurship => '创业';

  @override
  String get freelance => '自由职业';

  @override
  String get portfolio => '混合组合';

  @override
  String get burnoutRisk => '职业倦怠风险';

  @override
  String get careerStagnation => '事业停滞';

  @override
  String get workplaceConflict => '职场冲突';

  @override
  String get positioning => '定位';

  @override
  String get skillDevelopment => '技能发展';

  @override
  String get network => '人脉';

  @override
  String get visibility => '曝光度';

  @override
  String get lagnaLord => '上升主星';

  @override
  String get tenthLord => '第十宫主星';

  @override
  String get lord => '主星';

  @override
  String get lordPlacedIn => '主星落于';

  @override
  String get lordDignity => '主星力量状态';

  @override
  String get d9Dignity => 'D9力量状态';

  @override
  String get careerAnalysis => '事业分析';

  @override
  String get launchWindows => '启动时段';

  @override
  String get peakWindows => '巅峰时段';

  @override
  String get promotionWindows => '晋升时段';

  @override
  String get riskWindows => '风险时段';

  @override
  String get timingWindows => '时机窗口';

  @override
  String get careerRisks => '事业风险';

  @override
  String get astrologicalRemedies => '占星补救法';

  @override
  String get practicalSolutions => '实用解决方案';

  @override
  String get analysisConfidence => '分析可信度';

  @override
  String get careerArchetype => '事业原型';

  @override
  String get workStructure => '工作结构';

  @override
  String get teamLeadership => '团队领导力';

  @override
  String get idealEnvironment => '理想环境';

  @override
  String get idealOrgSize => '理想组织规模';

  @override
  String get fitScore => '契合度评分';

  @override
  String get recommended => '推荐';

  @override
  String get divisionalValidation => '分盘验证';

  @override
  String get houseAnalysis => '宫位分析';

  @override
  String get jaiminiKarakas => '遮米尼徵星（Jaimini Karakas）';

  @override
  String get copyFullReport => '复制完整报告数据';

  @override
  String get reportCopied => '报告数据已复制！';

  @override
  String get biometricNotAvailable => '此设备不支持生物识别';

  @override
  String biometricErrorMsg(Object error) {
    return '生物识别错误：$error';
  }

  @override
  String get biometricVerifyReason => '验证以启用生物识别登录';

  @override
  String get dobFormatLabel => '出生日期 (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => '出生时间 (HH:MM)';

  @override
  String get phoneLabel => '电话';

  @override
  String get activeBadge => '激活中';

  @override
  String get chartCategoryLabel => '类别';

  @override
  String get freePrimaryDescription => '免费主档案 — 用于每日星座运势和免费单图服务';

  @override
  String get searchChartsHint => '按姓名或出生日期搜索...';

  @override
  String unlockPriceLabel(Object price) {
    return '以$price解锁';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return '以$price（一次性）解锁此AI专家，通过应用商店安全购买。';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return '以$price（一次性）解锁此AI专家。金额将从您的钱包中扣除。';
  }

  @override
  String get specialistNotAvailablePurchase => '该专家暂不支持购买。';

  @override
  String get couldNotCompletePurchase => '无法完成购买。请重试。';

  @override
  String get couldNotUnlockWalletBalance => '无法解锁（请检查钱包余额）';

  @override
  String get freeBadge => '免费';

  @override
  String activeSessionInProgress(Object kind) {
    return '您有一个正在进行的$kind';
  }

  @override
  String get returnLabel => '返回';

  @override
  String get enableNotificationsForAlerts => '启用通知以获取咨询和优惠提醒';

  @override
  String get enableLabel => '启用';

  @override
  String get notificationsEnabled => '通知已启用';

  @override
  String get couldNotEnableNotifications => '无法启用 — 请在浏览器中允许通知';

  @override
  String get amountInrLabel => '金额 (₹)';

  @override
  String get noteOptionalLabel => '备注（可选）';

  @override
  String get txnDate => '日期';

  @override
  String get txnDescription => '描述';

  @override
  String get txnType => '类型';

  @override
  String get txnAmount => '金额';

  @override
  String get txnBalance => '余额';

  @override
  String get credit => '入账';

  @override
  String get debit => '出账';

  @override
  String get razorpayStripeNote => '💳 在生产环境中，这将跳转到 Razorpay/Stripe。';

  @override
  String get downloadPdf => '下载PDF';

  @override
  String get chatWithAiCta => '与AI聊天';

  @override
  String get pdfServiceUnavailable => 'PDF服务暂时不可用，请稍后再试。';

  @override
  String get pleaseUnlockFirst => '请先解锁此内容。';

  @override
  String get couldNotGeneratePdf => '无法生成PDF。请重试。';

  @override
  String get statConsults => '咨询次数';

  @override
  String get statCharts => '星盘数';

  @override
  String get statWallet => '钱包';

  @override
  String get firstChartPrimaryInfo => '您的第一张星盘是免费主档案。额外的星盘将单独解锁服务。';

  @override
  String get tryDifferentFilter => '尝试其他筛选条件';

  @override
  String get defaultChartName => '星盘';

  @override
  String get balAbbr => '余额';

  @override
  String get aiTimePassTitle => '选择聊天时长';

  @override
  String get aiTimePassHint => '从钱包支付。时间立即开始计算，再次购买会累加到剩余时间。';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes 分钟';
  }

  @override
  String aiTimePassPay(Object price) {
    return '支付 $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return '剩余 $minutes 分钟';
  }

  @override
  String get liveNow => '正在直播';
}
