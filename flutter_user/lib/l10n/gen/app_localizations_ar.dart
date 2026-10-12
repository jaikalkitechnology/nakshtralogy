// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get awChooseLanguage => 'اختر لغتك';

  @override
  String get awGoogleFailed =>
      'فشل تسجيل الدخول عبر Google. يُرجى المحاولة مرة أخرى.';

  @override
  String get awCompleteProfileTitle => 'أكمل ملفك الشخصي';

  @override
  String awWelcomeName(String name) {
    return 'مرحبًا، $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'بعض التفاصيل لتخصيص Nakshatralogy لك.';

  @override
  String get awRegionLabel => 'المنطقة';

  @override
  String get awRegionIndia => 'الهند';

  @override
  String get awRegionInternational => 'دولي';

  @override
  String get awPreferredLanguage => 'اللغة المفضلة';

  @override
  String get awFinishSetup => 'إنهاء الإعداد';

  @override
  String get awChatFileWebUnsupported =>
      'مشاركة الملفات غير متاحة على الويب بعد. يُرجى استخدام تطبيق الجوال.';

  @override
  String get awVideoUnsupported =>
      'المكالمات المرئية غير مدعومة في هذا المتصفح. يُرجى استخدام تطبيق الجوال أو متصفح سطح مكتب مدعوم.';

  @override
  String get awClose => 'إغلاق';

  @override
  String get pwPremiumTitle => 'تقرير مميز';

  @override
  String get pwLockedSubtitle => 'افتح التحليل الكامل لهذا المخطط';

  @override
  String pwUnlockFull(Object name) {
    return 'افتح $name كاملاً';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'فتح · $price';
  }

  @override
  String get pwOneTime => 'فتح لمرة واحدة — ملكك للأبد في هذا المخطط';

  @override
  String get pwWhatYouGet => 'ما الذي ستحصل عليه';

  @override
  String get pwYourBalance => 'رصيد محفظتك';

  @override
  String get pwInsufficient => 'الرصيد غير كافٍ';

  @override
  String get pwRechargeToUnlock => 'أعد الشحن للفتح';

  @override
  String get pwRechargeAmount => 'مبلغ الشحن (₹)';

  @override
  String get pwAddMoney => 'إضافة أموال';

  @override
  String get pwRechargeDone => 'تم شحن المحفظة';

  @override
  String get pwRechargeFailed => 'فشل الشحن. يرجى المحاولة مرة أخرى.';

  @override
  String get pwUnlockFailed => 'تعذر الفتح. يرجى المحاولة مرة أخرى.';

  @override
  String get pwUnlockedNow => 'تم الفتح! جارٍ تحميل تقريرك…';

  @override
  String get pwProcessing => 'جارٍ المعالجة…';

  @override
  String get pwPrimaryNoDelete =>
      'لا يمكن حذف Kundli الأساسي الخاص بك — فهو مجاني إلى الأبد.';

  @override
  String get pwPrimaryNoEdit => 'لا يمكن تعديل Kundli الأساسي الخاص بك.';

  @override
  String get pwLoadingAccess => 'جارٍ التحقق من إمكانية الوصول…';

  @override
  String get pwMaybeLater => 'ربما لاحقًا';

  @override
  String get updatePhoto => 'تحديث الصورة';

  @override
  String get takePhoto => 'الكاميرا';

  @override
  String get chooseFromGallery => 'المعرض';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get photoUpdated => 'تم تحديث الصورة';

  @override
  String get photoUploadFailed => 'تعذر رفع الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get tapToChangePhoto => 'اضغط لتغيير الصورة';

  @override
  String get klSubtitle =>
      'تقرير الارتباط الكرمي من حياة سابقة المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get klTitle => 'الارتباط الكرمي من حياة سابقة';

  @override
  String get klSnapshotHeader => 'لمحة عن الارتباط الكرمي';

  @override
  String get klGaugePairwise => 'متوسط الارتباط الثنائي';

  @override
  String get klGaugeCohesion => 'تماسك المجموعة';

  @override
  String get klGaugeRahuKetu => 'توافق Rahu-Ketu';

  @override
  String get klGaugeAtmakaraka => 'توافق الروح (Atmakaraka)';

  @override
  String get klGaugeD60 => 'توافق D60';

  @override
  String get klChipSoulResonance => 'توافق قوي في بصمة الروح';

  @override
  String get klChipD60Resonance => 'توافق قوي للحياة السابقة عبر D60';

  @override
  String get klChipCohesiveGroup => 'مجموعة متماسكة';

  @override
  String get klChipNoDebts => 'لم يتم رصد ديون كرمية';

  @override
  String get klProfilesTitle => 'ملفات المخططات';

  @override
  String get klKetuAt => 'Ketu في';

  @override
  String get klRahuAt => 'Rahu في';

  @override
  String get klFoundationTitle => 'الأساس الكرمي لكل مخطط';

  @override
  String get klFoundationSubtitle =>
      'إتقان الحياة السابقة لكل روح واتجاه الحياة الحالية';

  @override
  String get klKetuMastery => 'إتقان Ketu';

  @override
  String get klRahuGrowth => 'نمو Rahu';

  @override
  String get klNinthHousePunya => 'بونيا البيت التاسع';

  @override
  String get klD60Depth => 'العمق الكرمي D60';

  @override
  String get klAtmakarakaAgenda => 'أجندة الروح';

  @override
  String get klSaturnKarma => 'كارما زحل';

  @override
  String get klPairwiseTitle => 'الارتباطات الكرمية الثنائية';

  @override
  String get klActiveFactors => 'عوامل الارتباط النشطة';

  @override
  String get klGroupPatternTitle => 'النمط الكرمي للمجموعة';

  @override
  String get klSharedSetting => 'إطار الحياة السابقة المشترك';

  @override
  String get klCohesionScore => 'درجة التماسك الكرمي';

  @override
  String get klPastGoalsTitle => 'أهداف الحياة السابقة';

  @override
  String get klLearningTitle => 'تعلّم الحياة الحالية';

  @override
  String get klTeachingMap => 'خريطة التعليم المتبادل';

  @override
  String get klDebtsTitle => 'الديون الكرمية وحلولها';

  @override
  String get klNoDebtsDetected => 'لم يتم رصد ديون كرمية في هذه المجموعة';

  @override
  String get klTimingTitle => 'توقيت Moola Dasha الكرمي';

  @override
  String get klAuditTitle => 'جدول التدقيق المتعمق';

  @override
  String klAuditSubtitle(Object count) {
    return 'تم فحص $count معيار كرمي';
  }

  @override
  String get klTopicLinkage => 'ارتباطنا الكرمي العام';

  @override
  String get klTopicPairwise => 'الرابطة الكرمية بين شخصين محددين';

  @override
  String get klTopicDebts => 'الديون الكرمية التي يجب تسويتها';

  @override
  String get klTopicLessons => 'ما جئنا لنتعلمه';

  @override
  String get klTopicTiming => 'أفضل توقيت لمجموعتنا';

  @override
  String get klTopicGroup => 'قصتنا المشتركة من الحياة السابقة';

  @override
  String get lcSubtitle =>
      'تقرير التوافق العاطفي المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get lcTitle => 'التوافق العاطفي';

  @override
  String get lcSnapshotHeader => 'لمحة عن التوافق العاطفي';

  @override
  String get lcGaugeAttraction => 'الانجذاب';

  @override
  String get lcGaugeEmotional => 'الانسجام العاطفي';

  @override
  String get lcGaugeMental => 'التناغم الفكري';

  @override
  String get lcGaugePassion => 'الشغف';

  @override
  String get lcGaugeLongterm => 'الانسجام طويل الأمد';

  @override
  String get lcChipStrongMental => 'اتصال فكري قوي';

  @override
  String get lcChipStrongLongterm => 'إمكانات قوية للعلاقة طويلة الأمد';

  @override
  String get lcChipStrongPassion => 'انجذاب جسدي قوي';

  @override
  String get lcChipLowFriction => 'احتكاك منخفض بشكل عام';

  @override
  String get lcChipKarmicPull => 'جذب كرمي قوي';

  @override
  String get lcPartnersTitle => 'لمحة عن الشريكين';

  @override
  String get lcVenusSuffix => 'برج الزهرة';

  @override
  String get lcAttractionTitle => 'الانجذاب والكيمياء';

  @override
  String get lcAttractionScore => 'درجة الانجذاب';

  @override
  String get lcActiveContacts => 'اتصالات الزهرة النشطة';

  @override
  String get lcEmotionalTitle => 'الانسجام العاطفي';

  @override
  String get lcEmotionalScore => 'درجة الانسجام العاطفي';

  @override
  String get lcNakshatraCompat => 'توافق Nakshatra';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'محور Bhakoot';

  @override
  String get lcMentalTitle => 'التناغم الفكري';

  @override
  String get lcMentalScore => 'درجة التناغم الفكري';

  @override
  String get lcPassionTitle => 'الشغف والجانب الجسدي';

  @override
  String get lcPassionScore => 'درجة الشغف';

  @override
  String get lcLongtermTitle => 'الانسجام طويل الأمد';

  @override
  String get lcLongtermScore => 'درجة الانسجام طويل الأمد';

  @override
  String get lcCommitmentPotential => 'إمكانية الالتزام';

  @override
  String get lc7thHouseSynastry => 'توافق البيت السابع';

  @override
  String get lcJupiterBlessing => 'بركة المشتري';

  @override
  String get lcD9Resonance => 'توافق D9 Navamsa';

  @override
  String get lcSaturnLongevity => 'طول أمد زحل';

  @override
  String get lcKarmicTitle => 'الرابطة العاطفية الكرمية';

  @override
  String get lcKarmicScore => 'درجة الرابطة الكرمية';

  @override
  String get lcKetuContacts => 'اتصالات Ketu';

  @override
  String get lcRahuContacts => 'اتصالات Rahu';

  @override
  String get lcChallengesTitle => 'التحديات والاحتكاكات';

  @override
  String get lcNoChallenges =>
      'لم يتم رصد نقاط احتكاك جوهرية في أي من المخططين';

  @override
  String get lcTotalPenalty => 'إجمالي عقوبة التحديات';

  @override
  String get lcTimingTitle => 'توقيت الحب — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'ديناميكيات العلاقة';

  @override
  String get lcPowerBalance => 'توازن القوة';

  @override
  String get lcGiverReceiver => 'المانح/المتلقي العاطفي';

  @override
  String get lcGrowthDynamic => 'ديناميكية النمو';

  @override
  String get lcAreasToNurture => 'مجالات تحتاج إلى رعاية';

  @override
  String get lcTopicTiming => 'أفضل توقيت لعلاقتنا';

  @override
  String get lcTopicChallenges => 'التحديات التي يجب تجاوزها';

  @override
  String get lcTopicKarmic => 'رابطتنا الكرمية';

  @override
  String get lcTopicRemedies => 'العلاجات الموصى بها';

  @override
  String get lcTopicLongterm => 'إمكاناتنا على المدى الطويل';

  @override
  String get lcTopicDynamics => 'ديناميكيات علاقتنا';

  @override
  String get cpSubtitle =>
      'تقرير احتمالية الإنجاب المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get cpTitle => 'احتمالية الإنجاب';

  @override
  String get cpSnapshotHeader => 'لمحة عن احتمالية الإنجاب';

  @override
  String get cpGauge5thHouse => 'البيت الخامس';

  @override
  String get cpGaugeJupiter => 'المشتري/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'توقيت Dasha';

  @override
  String get cpChipStrongPutrakaraka => 'Putrakaraka قوي (المشتري)';

  @override
  String get cpChipLowDoshaPenalty => 'عقوبة دوشا منخفضة';

  @override
  String get cpChipFavorableTiming => 'توقيت Dasha مواتٍ';

  @override
  String get cpChipNoDoshas => 'لم يتم رصد دوشا متعلقة بالإنجاب';

  @override
  String get cpPartnersTitle => 'لمحة عن الشريكين';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'برج القمر';

  @override
  String get cpNumberTitle => 'عدد الأطفال والميل الجنسي';

  @override
  String get cpProbableNumber => 'العدد المحتمل';

  @override
  String get cpFirstChildTendency => 'ميل الطفل الأول';

  @override
  String get cpSpacing => 'ملاحظة حول التباعد';

  @override
  String get cpTimingTitle => 'التوقيت — Moola Dasha';

  @override
  String get cpCombinedTiming => 'التوقيت المشترك';

  @override
  String get cpNextWindow => 'النافذة المواتية القادمة';

  @override
  String get cp5thHouseTitle => 'تحليل البيت الخامس';

  @override
  String get cp5thHouseSubtitle => 'بيت الأطفال (Putra Bhava)، لكل شخص';

  @override
  String get cpJupiterTitle => 'المشتري — تحليل Putrakaraka';

  @override
  String get cpJupiterSubtitle => 'الدلالة الطبيعية للأطفال، لكل شخص';

  @override
  String get cpD7Title => 'تحليل D7 Saptamsa';

  @override
  String get cpD7Subtitle => 'المخطط التقسيمي المخصص للأطفال';

  @override
  String get cpD7Strength => 'قوة D7';

  @override
  String get cpSphutaTitle => 'Beeja و Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (البذرة)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (الحقل)';

  @override
  String get cpDoshaTitle => 'تحليل الدوشا';

  @override
  String get cpNoDoshasDetected =>
      'لم يتم رصد دوشا متعلقة بالإنجاب في أي من المخططين';

  @override
  String get cpRemediesTitle => 'العلاجات الموصى بها';

  @override
  String get cpAddresses => 'يعالج';

  @override
  String get cpTopicTiming => 'أفضل توقيت للحمل';

  @override
  String get cpTopicNumber => 'كم عدد الأطفال المحتمل';

  @override
  String get cpTopicDosha => 'أي دوشا يجب معالجتها';

  @override
  String get cpTopicRemedies => 'العلاجات الموصى بها';

  @override
  String get cpTopicFifthHouse => 'قوة بيتنا الخامس';

  @override
  String get cpTopicJupiter => 'دور المشتري في ذلك';

  @override
  String get riSubtitle =>
      'تقرير ذكاء العلاقات المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get riTitle => 'ذكاء العلاقات';

  @override
  String get riSnapshotHeader => 'لمحة عن المجموعة';

  @override
  String get riGaugeCohesion => 'تماسك المجموعة';

  @override
  String get riGaugeTrust => 'مناخ الثقة';

  @override
  String get riGaugeProductivity => 'الإنتاجية';

  @override
  String get riGaugeCreativity => 'الإبداع';

  @override
  String get riChipNoAlerts => 'لا توجد تنبيهات حرجة';

  @override
  String get riChipStrongCohesion => 'تماسك قوي للمجموعة';

  @override
  String get riChipHighTrust => 'مناخ ثقة عالٍ';

  @override
  String get riChipNoHiddenEnemy => 'لا توجد إشارة عدو خفي';

  @override
  String get riChipHealthyGroup => 'مجموعة صحية بشكل عام';

  @override
  String get riProfilesTitle => 'ملفات المخططات';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count أشخاص في هذه المجموعة';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'النزاهة';

  @override
  String get riWarmth => 'الدفء';

  @override
  String get riTrustworthiness => 'الجدارة بالثقة';

  @override
  String get riAssertiveness => 'الحزم';

  @override
  String get riGroupDynamicsTitle => 'نظرة عامة على ديناميكيات المجموعة';

  @override
  String get riMostSupportive => 'الأكثر دعمًا';

  @override
  String get riMostChallenged => 'الأكثر تحديًا';

  @override
  String get riHiddenEnemyAlert => 'تم رصد إشارة عدو خفي';

  @override
  String get riBestWorstTitle => 'أفضل الأزواج وأكثرها تحديًا';

  @override
  String get riBestPair => 'أقوى رابطة';

  @override
  String get riWorstPair => 'يحتاج إلى اهتمام';

  @override
  String get riAlliances => 'التحالفات المحتملة';

  @override
  String get riConflicts => 'نقاط الاحتكاك المحتملة';

  @override
  String get riPairwiseTitle => 'التحليل الثنائي';

  @override
  String riPairwiseSubtitle(Object count) {
    return 'تم تحليل $count زوج';
  }

  @override
  String get riDynamic => 'الديناميكية';

  @override
  String get riKarmicLink => 'الرابطة الكرمية';

  @override
  String get riMutualTrust => 'الثقة المتبادلة';

  @override
  String get riBetrayalRisk => 'خطر الخيانة';

  @override
  String get riPowerDistribution => 'توزيع القوة';

  @override
  String get riPowerHealth => 'صحة توازن القوة';

  @override
  String get riCriticalPatternsTitle => 'الأنماط الحرجة';

  @override
  String get riGroupRecsTitle => 'توصيات المجموعة';

  @override
  String get riSharedPractices => 'الممارسات المشتركة';

  @override
  String get riCommStyle => 'أسلوب التواصل الموصى به';

  @override
  String get riGrowthFocus => 'محور النمو الموصى به';

  @override
  String get riIndividualTitle => 'إرشادات فردية';

  @override
  String get riBestAllies => 'أفضل الحلفاء';

  @override
  String get riHandleWithCare => 'يتطلب التعامل بحذر';

  @override
  String get riCoreThemeTitle => 'الموضوع الجوهري للمجموعة';

  @override
  String get riLayerPairwise => 'اكتمال التحليل الثنائي';

  @override
  String get riLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'إشارة Jaimini';

  @override
  String get riLayerBehavior => 'وضوح السلوك';

  @override
  String get riLayerCoherence => 'تماسك المجموعة';

  @override
  String get riTopicDynamics => 'ديناميكيات مجموعتنا';

  @override
  String get riTopicPairwise => 'توافق زوج محدد';

  @override
  String get riTopicAlerts => 'أي تنبيهات حرجة';

  @override
  String get riTopicGrowth => 'كيف يمكننا أن ننمو معًا';

  @override
  String get riTopicRecs => 'الممارسات الموصى بها';

  @override
  String get riTopicTheme => 'موضوع مجموعتنا الجوهري';

  @override
  String get kmSubtitle =>
      'تقرير توافق Kundli Milan المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'لمحة عن التوافق';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'نسبة Ashtakoot';

  @override
  String get kmGaugeD9 => 'كارما الزواج D9';

  @override
  String get kmGaugeMangal => 'توازن Mangal';

  @override
  String get kmGaugePapa => 'التوازن الكرمي';

  @override
  String get kmGaugeAk => 'توافق الروح';

  @override
  String get kmChipNoNadi => 'لا يوجد Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'لا يوجد Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'تم إلغاء Mangal Dosh';

  @override
  String get kmChipPapaBalanced => 'عبء كرمي متوازن';

  @override
  String get kmChipStrongChemistry => 'انجذاب جسدي قوي';

  @override
  String get kmChipStrongD9 => 'كارما زواج قوية عبر D9';

  @override
  String get kmChipLongevity => 'توافق قوي في طول العمر';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'نظام المطابقة الكلاسيكي المكوّن من 8 نقاط، من أصل 36';

  @override
  String get kmNadiSeverity => 'شدة Nadi';

  @override
  String get kmBhakootSeverity => 'شدة Bhakoot';

  @override
  String get kmGanaSignature => 'بصمة Gana';

  @override
  String get kmMangalTitle => 'فحص Mangal Dosha';

  @override
  String get kmD9Title => 'D9 Navamsa — كارما الزواج';

  @override
  String get kmD9Subtitle =>
      'مخطط الزواج على مستوى الروح، ويُعتبر الأهم كلاسيكيًا';

  @override
  String get kmD9Score => 'توافق D9';

  @override
  String get kmLagnaRelation => 'علاقة Lagna';

  @override
  String get km7thLordRelation => 'علاقة سيد البيت السابع';

  @override
  String get kmKarakasTitle => 'كاراكات الروح والزوج/الزوجة';

  @override
  String get kmAtmakaraka => 'كوكب الروح';

  @override
  String get kmAkCompatibility => 'توافق بصمة الروح';

  @override
  String get kmUlCompatibility => 'توافق كاراكا الزوج/الزوجة';

  @override
  String get kmUlSigns => 'أسياد Upapada';

  @override
  String get kmChemistryTitle => 'كيمياء الزهرة والمريخ';

  @override
  String get kmPhysicalChemistry => 'الكيمياء الجسدية';

  @override
  String get kmEmotionalWarmth => 'الدفء العاطفي';

  @override
  String get kmAestheticAlignment => 'التوافق الجمالي';

  @override
  String get kmElementalSynthesis => 'التركيب العنصري';

  @override
  String get kmHouseCrossTitle => 'تحليل تقاطع البيتين السابع والثامن';

  @override
  String get km78Compatibility => 'توافق البيت السابع والثامن';

  @override
  String get km8thHouseSignature => 'بصمة طول العمر المشتركة';

  @override
  String get kmLongevityAlignment => 'توافق طول العمر';

  @override
  String get km7thLordFriendship => 'صداقة سيد البيت السابع';

  @override
  String get kmDomainsTitle => 'التوافق حسب كل مجال';

  @override
  String get kmConflictEngagement => 'أسلوب مواجهة الخلافات';

  @override
  String get kmDashaTitle => 'تزامن Dasha والانتقالات';

  @override
  String get kmDashaSync => 'تزامن Dasha';

  @override
  String get kmTransitAlignment => 'توافق الانتقالات';

  @override
  String get kmTimingTitle => 'توقيت الزواج';

  @override
  String get kmMarriageWindow => 'نافذة الزواج';

  @override
  String get kmEngagementWindow => 'نافذة الخطوبة';

  @override
  String get kmRecommendedRange => 'الإطار الزمني الموصى به';

  @override
  String get kmMuhurtaNotes => 'ملاحظات Muhurta';

  @override
  String get kmRisksTitle => 'مخاطر يجب معالجتها';

  @override
  String get kmConflictRisk => 'خطر النزاع';

  @override
  String get kmCommunicationRisk => 'خطر التواصل';

  @override
  String get kmFinanceRisk => 'خطر النزاع المالي';

  @override
  String get kmFamilyDynamicsRisk => 'خطر ديناميكيات الأسرة';

  @override
  String get kmMentalHealthRisk => 'خطر توافق الصحة النفسية';

  @override
  String get kmStrengthsTitle => 'أبرز نقاط قوة التوافق';

  @override
  String get kmSharedGrowth => 'إمكانات النمو المشترك';

  @override
  String get kmSharedCreative => 'الإمكانات الإبداعية المشتركة';

  @override
  String get kmJourneyTitle => 'مسيرة العلاقة ونموها';

  @override
  String get kmCurrentPhase => 'المرحلة الحالية';

  @override
  String get kmEarlyArc => 'بداية الزواج';

  @override
  String get kmMiddleArc => 'منتصف الزواج';

  @override
  String get kmMatureArc => 'الزواج الناضج';

  @override
  String get kmElderArc => 'سنوات الشيخوخة';

  @override
  String get kmPeakPhase => 'ذروة مرحلة الرفقة';

  @override
  String get kmGrowthAreas => 'مجالات النمو';

  @override
  String get kmCommProtocols => 'بروتوكولات التواصل';

  @override
  String get kmSharedPractices => 'الممارسات المشتركة';

  @override
  String get kmImprovementTitle => 'الموضوع الجوهري وخطة التحسين';

  @override
  String get kmVerdictTitle => 'الحكم النهائي';

  @override
  String get kmRealizationPotential => 'إمكانية تحقق العلاقة';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal و Papasamya';

  @override
  String get kmLayerVenusMars => 'الزهرة-المريخ';

  @override
  String get kmLayerDashaSync => 'تزامن Dasha';

  @override
  String get kmLayerH7H8 => 'تقاطع البيتين السابع والثامن';

  @override
  String get kmLayerAkResonance => 'توافق Atmakaraka';

  @override
  String get kmLayerDomains => 'أبعاد المجالات';

  @override
  String get kmTopicAshtakoot => 'درجة Ashtakoot لدينا';

  @override
  String get kmTopicMangal => 'مخاوف Mangal Dosha';

  @override
  String get kmTopicD9 => 'كارما زواجنا (D9)';

  @override
  String get kmTopicTiming => 'أفضل توقيت للزواج';

  @override
  String get kmTopicRisks => 'المخاطر التي يجب الاستعداد لها';

  @override
  String get kmTopicGrowth => 'كيف يمكننا أن ننمو معًا';

  @override
  String get kmTopicRemedies => 'العلاجات الموصى بها';

  @override
  String get kmTopicVerdict => 'هل يجب أن نمضي في الزواج';

  @override
  String get pkSubtitle =>
      'تقرير الحياة السابقة والكارما المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get pkTitle => 'الحياة السابقة والكارما';

  @override
  String get pkSnapshotHeader => 'لمحة عن الحياة السابقة';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'يُظهر مخططك بصمة حياة سابقة من نوع \'$theme\'، وهي حاليًا $relation في هذه الحياة. المسار الموصى به: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'قوة البصمة';

  @override
  String get pkGaugeMasteryPreserved => 'الإتقان المحفوظ';

  @override
  String get pkGaugeClearingProgress => 'تصفية الكارما';

  @override
  String get pkGaugeMaturity => 'نضج الحياة السابقة';

  @override
  String get pkGaugeMemoryAccess => 'الوصول إلى الذاكرة';

  @override
  String get pkChipGoodProgress => 'تقدم جيد في تصفية الكارما';

  @override
  String get pkChipLowDebt => 'دين كرمي منخفض';

  @override
  String get pkChipMatureSoul => 'بصمة روح ناضجة';

  @override
  String get pkChipGiftedPast => 'يحمل المخطط موهبة من حياة سابقة';

  @override
  String get pkChipAccomplished => 'حياة سابقة حافلة بالإنجاز';

  @override
  String get pkChipMasteryPreserved => 'إتقان قوي محمول إلى الحاضر';

  @override
  String get pkKetuTitle => 'Ketu — إتقانك السابق';

  @override
  String get pkKetuSubtitle => 'المهارات التي أتقنتها روحك بالفعل';

  @override
  String get pkMasteryStrength => 'قوة الإتقان';

  @override
  String get pkSkillsCarried => 'المهارات المحمولة إلى الحاضر';

  @override
  String get pkInstincts => 'القدرات الغريزية';

  @override
  String get pkKetuDignity => 'منزلة Ketu';

  @override
  String get pkRahuTitle => 'Rahu — حافة نمو روحك';

  @override
  String get pkRahuSubtitle => 'ما أتت روحك لإتمامه';

  @override
  String get pkUnmetDesires => 'الرغبات غير المحققة';

  @override
  String get pkProfileTitle => 'ملفك الشخصي من الحياة السابقة';

  @override
  String get pkProfession => 'المهنة المحتملة';

  @override
  String get pkSocialStanding => 'المكانة الاجتماعية';

  @override
  String get pkRegion => 'المنطقة المحتملة';

  @override
  String get pkCulturalArchetype => 'النموذج الثقافي';

  @override
  String get pkAccomplishment => 'مستوى الإنجاز';

  @override
  String get pkAuthority => 'مستوى السلطة';

  @override
  String get pkFamilyRole => 'الدور الأسري';

  @override
  String get pkSecondaryProfession => 'المهنة الثانوية';

  @override
  String get pkClimateAffinity => 'الميل المناخي';

  @override
  String get pkForeignResidence => 'كارما الإقامة في الخارج';

  @override
  String get pkRelationshipsTitle => 'العلاقات السابقة المحمولة إلى الحاضر';

  @override
  String get pkSpouseConnection => 'إعادة الارتباط بالزوج/الزوجة';

  @override
  String get pkChildrenConnection => 'إعادة الارتباط بالأطفال';

  @override
  String get pkCarriedRelationTypes => 'أنماط العلاقات';

  @override
  String get pkPartnerArchetype => 'نموذج الشريك من الحياة السابقة';

  @override
  String get pkDarakaraka => 'كاراكا الزوج/الزوجة';

  @override
  String get pkParentsKarma => 'نمط كارما الوالدين';

  @override
  String get pkSiblingKarma => 'نمط كارما الإخوة';

  @override
  String get pkSpiritualTitle => 'حياتك الروحية آنذاك';

  @override
  String get pkSpiritualLevel => 'المستوى الروحي';

  @override
  String get pkPracticeSignature => 'أسلوب الممارسة';

  @override
  String get pkMeditativeCapacity => 'القدرة على التأمل';

  @override
  String get pkDevotionalPractice => 'الممارسة التعبدية';

  @override
  String get pkYogicAttainment => 'التحصيل اليوغي';

  @override
  String get pkMokshaProximity => 'القرب من Moksha';

  @override
  String get pkKarmicDebtsTitle => 'الديون الكرمية والثروة آنذاك';

  @override
  String get pkTotalKarmicDebt => 'إجمالي الدين الكرمي';

  @override
  String get pkPrimaryDebtType => 'نوع الدين الأساسي';

  @override
  String get pkRelationshipDebt => 'دين العلاقات';

  @override
  String get pkFinancialDebt => 'الدين المالي';

  @override
  String get pkServiceDebt => 'دين الخدمة';

  @override
  String get pkDharmicDebt => 'الدين الدارمي';

  @override
  String get pkPitruKarma => 'كارما Pitru';

  @override
  String get pkMatruKarma => 'كارما Matru';

  @override
  String get pkWealthLevel => 'مستوى الثروة آنذاك';

  @override
  String get pkWealthKarmaCarried => 'كارما الثروة المحمولة';

  @override
  String get pkResourcePattern => 'إدارة الموارد';

  @override
  String get pkGainSource => 'مصدر الكسب';

  @override
  String get pkEchoesTitle => 'أصداء في هذه الحياة';

  @override
  String get pkOnRelationships => 'على العلاقات';

  @override
  String get pkOnCareer => 'على المسيرة المهنية';

  @override
  String get pkOnHealth => 'على الصحة';

  @override
  String get pkOnSpirituality => 'على الروحانية';

  @override
  String get pkDominantArea => 'أقوى أثر محمول';

  @override
  String get pkAttractions => 'الانجذابات الطبيعية';

  @override
  String get pkAversions => 'النفور الطبيعي';

  @override
  String get pkUnexplainedFears => 'المخاوف غير المبررة';

  @override
  String get pkMagneticPulls => 'الجواذب المغناطيسية';

  @override
  String get pkResolutionTitle => 'التسوية الكرمية والإتمام';

  @override
  String get pkPrimaryPathway => 'المسار الأساسي';

  @override
  String get pkSecondaryPathway => 'المسار الثانوي';

  @override
  String get pkClearingProgress => 'تقدم التصفية';

  @override
  String get pkRemainingWork => 'العمل المتبقي';

  @override
  String get pkSettlementTimeline => 'الجدول الزمني للتسوية';

  @override
  String get pkAccelerationPractices => 'ممارسات تُسرّع التسوية';

  @override
  String get pkPriorityAreas => 'مجالات الأولوية';

  @override
  String get pkVerificationTitle => 'تم التحقق عبر المخططات (D60)';

  @override
  String get pkD60Label => 'حقبة الحياة السابقة D60';

  @override
  String get pkD60Ketu => 'موضع Ketu في D60';

  @override
  String get pkD60Standing => 'المكانة العامة';

  @override
  String get pkMemoryTitle => 'الذاكرة والحدس';

  @override
  String get pkMemoryAccess => 'الوصول إلى الذاكرة';

  @override
  String get pkRegressionFit => 'مدى ملاءمة العلاج بالرجوع للحياة السابقة';

  @override
  String get pkDreamVisits => 'الزيارات في الأحلام';

  @override
  String get pkDejaVuFrequency => 'تكرار الشعور بالحدوث المسبق';

  @override
  String get pkSpontaneousRemembrance => 'التذكر التلقائي';

  @override
  String get pkRemembrancePractices => 'ممارسات التذكر';

  @override
  String get pkTimelineTitle => 'الجدول الزمني للتفعيل';

  @override
  String get pkGiftsActivation => 'تفعيل هبات الحياة السابقة';

  @override
  String get pkSurfaceWindow => 'نافذة الظهور';

  @override
  String get pkRisksTitle => 'المخاطر والأنماط المزمنة';

  @override
  String get pkTraumaResidue => 'بقايا الصدمة';

  @override
  String get pkSpiritualBypass => 'خطر التجاوز الروحي';

  @override
  String get pkMajorRisks => 'المخاطر الرئيسية';

  @override
  String get pkChronicImprints => 'الانطباعات المزمنة';

  @override
  String get pkKarmicLoops => 'الحلقات الكرمية';

  @override
  String get pkImprovementTitle => 'خطة التحسين';

  @override
  String get pkRoadmapTitle => 'خارطة طريق حياتك السابقة';

  @override
  String get pkMaturity => 'نضج الحياة السابقة';

  @override
  String get pkLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'عمق Ketu';

  @override
  String get pkLayerAtmakaraka => 'كوكب الروح (Atmakaraka)';

  @override
  String get pkTopicMastery => 'إتقاني من حياتي السابقة';

  @override
  String get pkTopicUnfinished => 'كارماي غير المكتملة';

  @override
  String get pkTopicRelationships => 'علاقاتي من الحياة السابقة';

  @override
  String get pkTopicDebts => 'ديوني الكرمية';

  @override
  String get pkTopicResolution => 'كيف أسوّي كارماي';

  @override
  String get pkTopicMemory => 'الوصول إلى ذاكرة الحياة السابقة';

  @override
  String get pkTopicTiming => 'أفضل نوافذ التوقيت';

  @override
  String get pkTopicProfile => 'من كنت في حياتي السابقة';

  @override
  String get chSubtitle =>
      'تقرير تحليل الشخصية المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get chTitle => 'تحليل الشخصية';

  @override
  String get chSnapshotHeader => 'لمحة عن الشخصية';

  @override
  String get chGaugeIntegrity => 'النزاهة';

  @override
  String get chGaugeResilience => 'المرونة';

  @override
  String get chGaugeSelfAwareness => 'الوعي الذاتي';

  @override
  String get chGaugeStability => 'الاستقرار العاطفي';

  @override
  String get chGaugeMoralFabric => 'النسيج الأخلاقي';

  @override
  String get chChipRajaYoga => 'وجود Raja Yoga';

  @override
  String get chChipHighIntegrity => 'نزاهة عالية';

  @override
  String get chChipResilient => 'طبيعة مرنة';

  @override
  String get chChipDharmic => 'توجه قوي نحو الدارما';

  @override
  String get chChipEmpathetic => 'متعاطف بطبعه';

  @override
  String get chChipLoyal => 'وفي بعمق';

  @override
  String get chChipGiftedCharacter => 'يحمل المخطط هبة في الشخصية';

  @override
  String get chSoulTitle => 'بصمة روحك';

  @override
  String get chSoulIntegration => 'تكامل الروح والشخصية';

  @override
  String get chAmatyakarakaTheme => 'صوت الشخصية الداعم';

  @override
  String get chAtmakarakaDignity => 'منزلة كوكب الروح';

  @override
  String get chAtmakarakaHouse => 'موضع البيت';

  @override
  String get chSurfaceTitle => 'الشخصية الظاهرية والبنية';

  @override
  String get chLagnaSign => 'برج الطالع';

  @override
  String get chConstitution => 'البنية';

  @override
  String get chSurfaceSignature => 'الانطباع الذي تتركه';

  @override
  String get chPhysicalConstitution => 'البنية الجسدية';

  @override
  String get chLagnaLord => 'سيد الطالع';

  @override
  String get chLagnaOccupants => 'الكواكب في الطالع';

  @override
  String get chMindEmotionsTitle => 'العقل والعواطف والأنا';

  @override
  String get chEmotionalNature => 'طبيعتك العاطفية';

  @override
  String get chMentalStability => 'الاستقرار الذهني';

  @override
  String get chSelfConfidence => 'ثقة صحية بالنفس';

  @override
  String get chEgoNature => 'أناك ومفهومك الذاتي';

  @override
  String get chAuthorityRelationship => 'العلاقة مع السلطة';

  @override
  String get chPrideTendency => 'الميل إلى الكبرياء';

  @override
  String get chMoodPatterns => 'أنماط المزاج';

  @override
  String get chKemadrumaPresent =>
      'وجود Kemadruma Yoga — العناية الذاتية العاطفية الإضافية مفيدة.';

  @override
  String get chFatherImprint => 'جودة انطباع الأب';

  @override
  String get chCommunicationTitle => 'أسلوب التواصل والفكر';

  @override
  String get chIntellectStyle => 'أسلوب الفكر';

  @override
  String get chCommStyle => 'أسلوب التواصل';

  @override
  String get chDecisionStyle => 'أسلوب اتخاذ القرار';

  @override
  String get chDiscrimination => 'القدرة على التمييز';

  @override
  String get chPersonaTitle => 'الصورة العامة مقابل الذات الحقيقية';

  @override
  String get chAuthenticityGap => 'فجوة الأصالة';

  @override
  String get chGunaTitle => 'ملف الغونا والدوشا';

  @override
  String get chGunaSubtitle =>
      'طبيعتك الداخلية وبنيتك، بالأسلوب الفيدي الكلاسيكي';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'الغونا السائدة';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'الدوشا السائدة';

  @override
  String get chRahuRestlessness => 'قلق Rahu';

  @override
  String get chKetuDetachment => 'انفصال Ketu';

  @override
  String get chYogasTitle => 'يوغات الشخصية';

  @override
  String get chRajaYogaStrength => 'قوة Raja Yoga';

  @override
  String get chGiftYogas => 'يوغات الهبة';

  @override
  String get chTestYogas => 'يوغات الاختبار';

  @override
  String get chStrengthsTitle => 'نقاط القوة والمواهب';

  @override
  String get chSignatureVirtues => 'الفضائل المميزة';

  @override
  String get chNaturalTalents => 'المواهب الطبيعية';

  @override
  String get chSoftSkills => 'المهارات الشخصية';

  @override
  String get chHiddenStrengths => 'نقاط قوة خفية يجب تطويرها';

  @override
  String get chShadowTitle => 'الجانب الخفي ومجالات النمو';

  @override
  String get chShadowSubtitle => 'وعي لطيف بالأنماط التي تستحق العمل عليها';

  @override
  String get chShadowPatterns => 'الأنماط الخفية';

  @override
  String get chBlindSpots => 'النقاط العمياء';

  @override
  String get chEmotionalWounds => 'الجروح العاطفية';

  @override
  String get chShadowWorkPriorities => 'أولويات العمل على الجانب الخفي';

  @override
  String get chMoralTests => 'الاختبارات الأخلاقية';

  @override
  String get chRelationshipsTitle => 'العلاقات والأسلوب الاجتماعي';

  @override
  String get chWarmth => 'الدفء بين الأشخاص';

  @override
  String get chEmpathy => 'القدرة على التعاطف';

  @override
  String get chLoyalty => 'القدرة على الوفاء';

  @override
  String get chBoundaries => 'وضع الحدود';

  @override
  String get chSocialConfidence => 'الثقة الاجتماعية';

  @override
  String get chTrustGiving => 'مستوى منح الثقة';

  @override
  String get chConflictStyle => 'أسلوب مواجهة الخلافات';

  @override
  String get chEthicsTitle => 'الأخلاق والبوصلة الأخلاقية';

  @override
  String get chDharmaOrientation => 'التوجه نحو الدارما';

  @override
  String get chTruthfulness => 'الصدق';

  @override
  String get chCompassion => 'الرحمة';

  @override
  String get chGenerosity => 'الكرم';

  @override
  String get chEthicalConsistency => 'الثبات الأخلاقي';

  @override
  String get chIntegrityPressure => 'النزاهة تحت الضغط';

  @override
  String get chJusticeFairness => 'العدالة والإنصاف';

  @override
  String get chMoralTrajectory => 'التطور الأخلاقي';

  @override
  String get chEiTitle => 'الذكاء العاطفي';

  @override
  String get chEiSelfAwareness => 'الوعي الذاتي';

  @override
  String get chEiSelfRegulation => 'ضبط الذات';

  @override
  String get chEiEmpathy => 'التعاطف';

  @override
  String get chEiSocialSkills => 'المهارات الاجتماعية';

  @override
  String get chMotivation => 'الدافع الداخلي';

  @override
  String get chVulnerabilityComfort => 'الارتياح للانكشاف العاطفي';

  @override
  String get chEmotionalExpression => 'الارتياح للتعبير العاطفي';

  @override
  String get chEmotionalReceptivity => 'التقبل العاطفي';

  @override
  String get chVerificationTitle => 'تم التحقق عبر المخططات (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'دارما-الشخصية D9';

  @override
  String get chD12Label => 'الميراث السلفي D12';

  @override
  String get chD30Label => 'ملف الجانب الخفي D30';

  @override
  String get chD60Label => 'شخصية الحياة السابقة D60';

  @override
  String get chD30Standing => 'مكانة الجانب الخفي';

  @override
  String get chMaternalInheritance => 'الميراث من الأم';

  @override
  String get chAncestralKarmaWeight => 'وزن الكارما السلفية';

  @override
  String get chTimelineTitle => 'الجدول الزمني للشخصية';

  @override
  String get chFormationWindow => 'نافذة التكوين';

  @override
  String get chMaturationWindow => 'نافذة النضج';

  @override
  String get chLegacyWindow => 'نافذة الإرث';

  @override
  String get chPeakMaturationAge => 'عمر ذروة النضج';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'العمر $ageRange';
  }

  @override
  String get chImprovementTitle => 'خطة التحسين';

  @override
  String get chRoadmapTitle => 'خارطة طريق شخصيتك';

  @override
  String get chAuthenticExpression => 'التعبير الأصيل عن الذات';

  @override
  String get chRealizationPotential => 'إمكانية تحقيق الشخصية';

  @override
  String get chLayerAtmakaraka => 'كوكب الروح (Atmakaraka)';

  @override
  String get chLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'الطالع والقمر';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'نقاط قوة شخصيتي';

  @override
  String get chTopicShadow => 'أنماطي الخفية';

  @override
  String get chTopicSoul => 'بصمة روحي';

  @override
  String get chTopicRelationships => 'أسلوبي في العلاقات';

  @override
  String get chTopicEthics => 'أخلاقي وقيمي';

  @override
  String get chTopicGuna => 'ملف الغونا والدوشا لدي';

  @override
  String get chTopicGrowth => 'كيف أطوّر شخصيتي';

  @override
  String get chTopicTiming => 'أفضل توقيت للعمل على الشخصية';

  @override
  String get lpSubtitle =>
      'تقرير مسار الحياة والحظ المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get lpTitle => 'مسار الحياة والحظ';

  @override
  String get lpSnapshotHeader => 'لمحة عن مسار الحياة';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'أنت $archetype وهدفك الأساسي في $domain. يُظهر تحليلنا إمكانية تحقيق حياة عامة بنسبة $probability%.';
  }

  @override
  String get lpGaugeDharma => 'وضوح الدارما';

  @override
  String get lpGaugeFortune => 'خط أساس الحظ';

  @override
  String get lpGaugeCoherence => 'تماسك المسار';

  @override
  String get lpGaugeFulfillment => 'التحقق والإنجاز';

  @override
  String get lpGaugeMomentum => 'الزخم الكرمي';

  @override
  String get lpChipRareGift => 'هبة قدرية نادرة';

  @override
  String get lpChipFreeWillStrong => 'إرادة حرة قوية';

  @override
  String get lpChipGraceSupported => 'مدعوم بالنعمة';

  @override
  String get lpChipLightKarma => 'عبء كرمي خفيف';

  @override
  String get lpChipRecognitionPotential => 'إمكانية للتقدير والشهرة';

  @override
  String get lpChipSpiritualPath => 'ميل روحي قوي';

  @override
  String get lpChipBlessed => 'يحمل المخطط بركات';

  @override
  String get lpSoulPathTitle => 'مسار روحك';

  @override
  String get lpSoulPlanet => 'كوكب الروح';

  @override
  String get lpCareerPlanet => 'كوكب الهدف';

  @override
  String get lpSoulClarity => 'وضوح الهدف';

  @override
  String get lpLifeChapter => 'فصل الحياة الحالي';

  @override
  String get lpPrimaryDomain => 'مجال الهدف الأساسي';

  @override
  String get lpKarakaTitle => 'كواكب الدارما لديك';

  @override
  String get lpKarakaSubtitle => 'مدى دعم كل كوكب لهدف حياتك';

  @override
  String get lpVerificationTitle => 'تم التحقق عبر المخططات (D9 / D60)';

  @override
  String get lpD9Label => 'توافق الروح D9';

  @override
  String lpD9Explain(Object stage) {
    return 'مرحلة تطور روحك هي \'$stage\' في مخطط Navamsa.';
  }

  @override
  String get lpD9JupiterDignity => 'منزلة المشتري';

  @override
  String get lpD9DharmaMultiplier => 'مضاعِف الدارما';

  @override
  String get lpD60Label => 'بصمة الحياة السابقة D60';

  @override
  String get lpKarmaType => 'نوع كارما الحياة السابقة';

  @override
  String get lpKetuMastery => 'إتقان Ketu من الحياة السابقة';

  @override
  String get lpRahuGrowthDir => 'اتجاه نمو Rahu';

  @override
  String get lpYogasTitle => 'يوغات الحظ وعوائق الحظ';

  @override
  String get lpFortuneBoost => 'دفعة الحظ';

  @override
  String get lpLuckDrain => 'استنزاف الحظ';

  @override
  String get lpFortuneBoosters => 'معززات الحظ';

  @override
  String get lpLuckBlocks => 'عوائق الحظ';

  @override
  String get lpPurposeTitle => 'مجالات الهدف والشهرة';

  @override
  String get lpDomainLeadership => 'القيادة';

  @override
  String get lpDomainWisdom => 'الحكمة والتعليم';

  @override
  String get lpDomainService => 'الخدمة';

  @override
  String get lpDomainHealing => 'الشفاء';

  @override
  String get lpDomainCreative => 'التعبير الإبداعي';

  @override
  String get lpPrimaryDomainBadge => 'أساسي';

  @override
  String get lpFameRecognition => 'الشهرة والتقدير';

  @override
  String get lpSocialInfluence => 'التأثير الاجتماعي';

  @override
  String get lpRecognitionDomain => 'مجال التقدير';

  @override
  String get lpPublicImage => 'الصورة العامة';

  @override
  String get lpHistoricalImpact => 'إمكانية الأثر التاريخي';

  @override
  String get lpTimelineTitle => 'الجدول الزمني للحظ والحياة';

  @override
  String get lpCurrentPhase => 'مرحلة الحظ الحالية';

  @override
  String get lpJupiterReturn => 'عودة المشتري';

  @override
  String get lpSaturnReturn => 'عودة زحل';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'النافذة الذهبية';

  @override
  String get lpTransformationWindow => 'نافذة التحول';

  @override
  String get lpPeakYears => 'سنوات ذروة الحظ';

  @override
  String get lpChallengingYears => 'السنوات الصعبة';

  @override
  String get lpMilestonesTitle => 'المحطات الرئيسية ونقاط التحول';

  @override
  String get lpFirstTurningPoint => 'نقطة التحول الرئيسية الأولى';

  @override
  String get lpMidlifeTransform => 'تحول منتصف العمر';

  @override
  String get lpLateLifeFulfillment => 'تحقق أواخر العمر';

  @override
  String lpDharmicMilestone(Object age) {
    return 'محطة دارمية (العمر $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'العمر $age';
  }

  @override
  String get lpDestinyTitle => 'القدر مقابل الإرادة الحرة';

  @override
  String get lpDestinyStat => 'وزن القدر';

  @override
  String get lpFreeWillStat => 'نفوذ الإرادة الحرة';

  @override
  String get lpFateStrength => 'قوة بصمة القدر';

  @override
  String get lpSelfCreation => 'القدرة على صنع الذات';

  @override
  String get lpEffortGrace => 'الجهد مقابل النعمة';

  @override
  String get lpKarmicTitle => 'الدروس الكرمية';

  @override
  String get lpRahuGrowthLabel => 'Rahu — تحدي النمو';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — موضوع الاستسلام';

  @override
  String get lpSaturnLessonLabel => 'زحل — درس الانضباط';

  @override
  String get lpTestDifficulty => 'صعوبة اختبارات الحياة';

  @override
  String get lpLessonsInProgress => 'دروس قيد التعلم';

  @override
  String get lpSoulContract => 'مجالات عقد الروح';

  @override
  String get lpSoulExperience => 'ما جاءت روحك لتختبره';

  @override
  String get lpSoulMastery => 'ما جاءت روحك لتتقنه';

  @override
  String get lpSpiritualTitle => 'المسار الروحي';

  @override
  String get lpSpiritualInclination => 'الميل الروحي';

  @override
  String get lpMeditationReceptivity => 'التقبل للتأمل';

  @override
  String get lpTeacherKarma => 'كارما المعلم/المرشد';

  @override
  String get lpPilgrimageBenefit => 'فائدة الحج والزيارة الروحية';

  @override
  String get lpSelfRealization => 'إمكانية تحقيق الذات';

  @override
  String get lpDivineConnection => 'الاتصال الإلهي';

  @override
  String get lpTraditionAffinity => 'الميل نحو التقاليد';

  @override
  String get lpIntuitionStrength => 'قوة الحدس';

  @override
  String get lpMantraEfficacy => 'فعالية الدعاء/المانترا';

  @override
  String get lpInnerGuidance => 'الثقة بالتوجيه الداخلي';

  @override
  String get lpPropheticDreams => 'الحساسية للأحلام النبوئية';

  @override
  String get lpDifficultyTitle => 'صعوبات الحياة وتحدياتها';

  @override
  String get lpEarlyLife => 'بداية الحياة';

  @override
  String get lpMidlife => 'منتصف العمر';

  @override
  String get lpLateLife => 'أواخر العمر';

  @override
  String get lpStruggleToSuccess => 'كارما الكفاح نحو النجاح';

  @override
  String get lpUnlivedLifeRisk => 'خطر الحياة غير المعاشة';

  @override
  String get lpChallenges => 'تحديات الحياة';

  @override
  String get lpFortuneDrains => 'استنزافات الحظ المزمنة';

  @override
  String get lpRegretAreas => 'مجالات عرضة للندم';

  @override
  String get lpRedFlags => 'إشارات تحذيرية في الاتجاه';

  @override
  String get lpBlessingsTitle => 'البركات وموضوع الحياة الجوهري';

  @override
  String get lpKarmicRoot => 'الجذر الكرمي';

  @override
  String get lpBlessingsList => 'بركاتك';

  @override
  String get lpFulfillmentPriorities => 'أولويات التحقق والإنجاز';

  @override
  String get lpImprovementTitle => 'خطة التحسين';

  @override
  String get lpDharmaPriorities => 'أولويات الدارما';

  @override
  String get lpRoadmapTitle => 'خارطة طريق قدرك';

  @override
  String get lpStrategy => 'الاستراتيجية';

  @override
  String get lpFulfillmentPotential => 'إمكانية التحقق والإنجاز';

  @override
  String get lpNext12Focus => 'التركيز خلال الـ 12 شهرًا القادمة';

  @override
  String get lpLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'توقيت Dasha';

  @override
  String get lpLayerTransit => 'الانتقالات الحالية';

  @override
  String get lpTopicPurpose => 'هدف حياتي';

  @override
  String get lpTopicFortune => 'يوغات حظي';

  @override
  String get lpTopicKarma => 'دروسي الكرمية';

  @override
  String get lpTopicMilestones => 'المحطات القادمة';

  @override
  String get lpTopicDestiny => 'القدر مقابل الإرادة الحرة';

  @override
  String get lpTopicSpiritual => 'مساري الروحي';

  @override
  String get lpTopicChallenges => 'تحديات حياتي';

  @override
  String get lpTopicTiming => 'أفضل نوافذ التوقيت';

  @override
  String get dbSubtitle =>
      'تقرير الديون والتعافي المالي المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get dbTitle => 'الديون والتعافي المالي';

  @override
  String get dbSnapshotHeader => 'لمحة عن التعافي من الديون';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'أنت حاليًا في مرحلة \'$phase\' وتتبع نهجًا $personality تجاه المال. يُظهر تحليلنا احتمالية $probability% للتخلص من الديون خلال نحو $years سنوات.';
  }

  @override
  String get dbGaugeCapacity => 'القدرة على التعافي';

  @override
  String get dbGaugeProbability => 'فرصة التعافي';

  @override
  String get dbGaugeFreedomNow => 'التحرر الحالي من الديون';

  @override
  String get dbGaugeDti => 'صحة الدخل';

  @override
  String get dbGaugeResilience => 'المرونة';

  @override
  String get dbChipCleanKarma => 'كارما ديون نظيفة';

  @override
  String get dbChipStrongRecovery => 'قدرة تعافٍ قوية';

  @override
  String get dbChipHealthyDti => 'نسبة دين إلى دخل صحية';

  @override
  String get dbChipResilient => 'مرونة نفسية عالية';

  @override
  String get dbChipCycleBreakable => 'دورة الديون قابلة للكسر';

  @override
  String get dbChipLowReindebt => 'خطر منخفض للعودة إلى المديونية';

  @override
  String get dbChipGoodNegotiator => 'فرص جيدة للتفاوض';

  @override
  String get dbProfileTitle => 'ملف ديونك';

  @override
  String get dbPhaseLabel => 'المرحلة الحالية';

  @override
  String get dbPrimaryCategoryLabel => 'الفئة الرئيسية';

  @override
  String get dbKarakaLabel => 'كاراكا الديون';

  @override
  String get dbProtectorLabel => 'الحماية من الدائنين';

  @override
  String get dbSecondaryCategories => 'الفئات الثانوية';

  @override
  String get dbUnsecuredRatio => 'نسبة الديون غير المضمونة';

  @override
  String get dbKarakaTitle => 'كواكب ديونك';

  @override
  String get dbKarakaSubtitle => 'مدى دعم كل كوكب لتعافيك من الديون';

  @override
  String get dbVerificationTitle => 'تم التحقق عبر المخططات (D6)';

  @override
  String get dbD6Label => 'مخطط D6 للديون والأعداء';

  @override
  String get dbD6LordDignity => 'قوة سيد البيت السادس';

  @override
  String get dbD6Severity => 'شدة كارما الديون';

  @override
  String get dbD6Multiplier => 'مضاعِف ديون D6';

  @override
  String get dbYogasTitle => 'يوغات الديون والحماية';

  @override
  String get dbPressureNow => 'ضغط الديون الحالي';

  @override
  String get dbRecoveryBoost => 'دفعة التعافي';

  @override
  String get dbClearingLabel => 'يوغات تصفية الديون';

  @override
  String get dbCreatingLabel => 'يوغات مسببة للديون';

  @override
  String get dbCategoriesTitle => 'فئات الديون التي تستدعي المراقبة';

  @override
  String get dbCategoriesSubtitle =>
      'أي أنواع الديون تحتاج إلى أكبر قدر من الاهتمام';

  @override
  String get dbTimelineTitle => 'الجدول الزمني للتحرر من الديون';

  @override
  String get dbFreeWindowLabel => 'نافذة التحرر من الديون';

  @override
  String get dbClearanceEstimate => 'تقدير التصفية الكاملة';

  @override
  String get dbPeakYears => 'سنوات ذروة الديون';

  @override
  String get dbClearanceYears => 'سنوات التصفية';

  @override
  String get dbBorrowTitle => 'دليل الاقتراض الذكي';

  @override
  String get dbLoanSuitability => 'مدى ملاءمة القرض';

  @override
  String get dbBestLoanType => 'أفضل نوع قرض';

  @override
  String get dbLeverageCeiling => 'سقف الاستدانة';

  @override
  String get dbNegotiationSuccess => 'نجاح التفاوض';

  @override
  String get dbCreditorAggression => 'خطر ضغط الدائنين';

  @override
  String get dbLegalEscalation => 'خطر التصعيد القانوني';

  @override
  String get dbNegotiationApproach => 'النهج الموصى به';

  @override
  String get dbAvoidLoanTypes => 'أنواع القروض التي يجب تجنبها';

  @override
  String get dbRiskTitle => 'مراقبة المخاطر ونقاط الضعف';

  @override
  String get dbRiskDefault => 'خطر التعثر في السداد';

  @override
  String get dbRiskDefaultExp =>
      'احتمال تفويت موعد سداد بشكل يؤدي إلى حالة تعثر مع الجهة المقرضة.';

  @override
  String get dbRiskDefaultFix =>
      'قم بأتمتة الحد الأدنى من الدفعات واحتفظ باحتياطي لشهر واحد حتى لا تتسبب دورة دخل فائتة في تسلسل من المشاكل.';

  @override
  String get dbRiskBankruptcy => 'خطر الإفلاس';

  @override
  String get dbRiskBankruptcyExp =>
      'احتمال أن ينمو عبء الديون إلى ما يفوق ما يمكن للدخل والأصول تغطيته فعليًا.';

  @override
  String get dbRiskBankruptcyFix =>
      'احصل على مراجعة مهنية لديونك قبل أخذ أي قرض أو خط ائتمان جديد.';

  @override
  String get dbRiskAssetSeizure => 'خطر الحجز على الأصول';

  @override
  String get dbRiskAssetSeizureExp =>
      'احتمال أن يؤدي التعثر في قرض مضمون إلى استيلاء الجهة المقرضة على الضمان أو الممتلكات.';

  @override
  String get dbRiskAssetSeizureFix =>
      'أعطِ الأولوية لسداد القروض المضمونة أولاً، وأعد التمويل مبكرًا إذا بدت فجوة في السداد محتملة.';

  @override
  String get dbRiskChronic => 'خطر العودة المزمنة إلى الديون';

  @override
  String get dbRiskChronicExp =>
      'الميل للعودة إلى الديون مرة أخرى حتى بعد تصفية العبء الحالي.';

  @override
  String get dbRiskChronicFix =>
      'ابنِ صندوق طوارئ مخصصًا قبل زيادة الإنفاق على نمط الحياة بعد التصفية.';

  @override
  String get dbReindebtTrigger => 'محفز العودة إلى الديون';

  @override
  String get dbCycleBreakFeasibility => 'إمكانية كسر الدورة';

  @override
  String get dbMajorRisks => 'المخاطر الرئيسية';

  @override
  String get dbHiddenSignals => 'إشارات ديون خفية';

  @override
  String get dbCrisisTitle => 'الاستعداد للأزمات';

  @override
  String get dbCrisisSubtitle => 'كيفية اكتشاف المشكلة مبكرًا والاستجابة بهدوء';

  @override
  String get dbWarningSigns => 'علامات الإنذار المبكر';

  @override
  String get dbMitigationActions => 'ما يجب فعله حيال ذلك';

  @override
  String get dbFamilyTitle => 'ديون الأسرة والأسلاف';

  @override
  String get dbInheritedDebtProb => 'احتمال الديون الموروثة';

  @override
  String get dbFamilyDrag => 'عبء ديون الأسرة';

  @override
  String get dbInheritedSource => 'المصدر المحتمل';

  @override
  String get dbCoreBlockerLabel => 'العائق الجوهري';

  @override
  String get dbPsychologyTitle => 'نفسيتك المالية';

  @override
  String get dbResilience => 'المرونة';

  @override
  String get dbDiscipline => 'الانضباط تحت الضغط';

  @override
  String get dbSocialSupport => 'الدعم الاجتماعي';

  @override
  String get dbDepressionRisk => 'قابلية التأثر بالضغط المالي';

  @override
  String get dbStressTolerance => 'تحمّل الضغط';

  @override
  String get dbRootCause => 'السبب السلوكي الجذري';

  @override
  String get dbImprovementTitle => 'خطة التحسين';

  @override
  String get dbRoadmapTitle => 'خارطة طريقك للتحرر من الديون';

  @override
  String get dbRecoveryProbability => 'احتمالية التعافي';

  @override
  String get dbClearanceTimeline => 'الجدول الزمني للتصفية';

  @override
  String get dbYears => 'سنوات';

  @override
  String get dbDtiHealth => 'صحة نسبة الدين إلى الدخل';

  @override
  String get dbDtiCategory => 'فئة نسبة الدين إلى الدخل';

  @override
  String get dbBreakEvenMonths => 'أشهر للوصول إلى نقطة التعادل';

  @override
  String get dbIncomeAcceleration => 'النمو المطلوب في الدخل';

  @override
  String get dbLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get dbLayerD6 => 'الديون والأعداء (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'توقيت Dasha';

  @override
  String get dbLayerTransit => 'الانتقالات الحالية';

  @override
  String get dbTopicRecovery => 'جدولي الزمني للتعافي';

  @override
  String get dbTopicNegotiate => 'التفاوض مع الدائنين';

  @override
  String get dbTopicBorrowing => 'هل من الآمن الاقتراض الآن';

  @override
  String get dbTopicCrisis => 'الاستعداد لأزمة';

  @override
  String get dbTopicAncestral => 'كارما الديون السلفية';

  @override
  String get dbTopicTimeline => 'أفضل السنوات لتصفية الديون';

  @override
  String get dbTopicPsychology => 'نفسيتي المالية';

  @override
  String get dbTopicCategories => 'أي الديون يجب أن تُعطى الأولوية';

  @override
  String get mnSubtitle =>
      'تقرير العافية النفسية المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get mnTitle => 'الحالة النفسية والتوتر';

  @override
  String get mnSnapshotHeader => 'لمحة عن العافية النفسية';

  @override
  String get mnResilience => 'المرونة';

  @override
  String get mnStability => 'الاستقرار';

  @override
  String get mnEmotionalBalance => 'التوازن العاطفي';

  @override
  String get mnInnerCalm => 'الهدوء الداخلي';

  @override
  String get mnSelfAwareness => 'الوعي الذاتي';

  @override
  String get mnStatusThriving => 'مزدهر';

  @override
  String get mnStatusSteady => 'ثابت ومستقر';

  @override
  String get mnStatusBuildingStrength => 'في طور بناء القوة';

  @override
  String get mnStatusNeedsGentleCare => 'يحتاج إلى رعاية لطيفة';

  @override
  String get mnStatusReachOut => 'حان وقت طلب الدعم';

  @override
  String get mnChipStable => 'مستقر عاطفيًا';

  @override
  String get mnChipSupported => 'مدعوم جيدًا';

  @override
  String get mnChipSelfAware => 'وعي ذاتي عالٍ';

  @override
  String get mnChipResilient => 'يتعافى بسرعة';

  @override
  String get mnChipSecureAttachment => 'ارتباط آمن';

  @override
  String get mnChipHealingReady => 'جاهز للشفاء';

  @override
  String get mnChipMindBodyBalance => 'توازن العقل والجسد';

  @override
  String get mnSupportBannerTitle => 'ملاحظة لطيفة';

  @override
  String get mnSupportBannerBody =>
      'يشير مخططك إلى أن هذا قد يكون وقتًا مناسبًا للاعتماد على دعم إضافي — صديق موثوق، أحد أفراد الأسرة، أو مختص. طلب المساعدة علامة قوة، لا ضعف.';

  @override
  String get mnProfileTitle => 'مخططك العاطفي';

  @override
  String get mnStressDriver => 'محفز التوتر';

  @override
  String get mnStabilityAnchor => 'مرساة الاستقرار';

  @override
  String get mnSoulLevelKarma => 'النمط على مستوى الروح';

  @override
  String get mnSubtleSignature => 'البصمة العاطفية الدقيقة';

  @override
  String get mnKarakaTitle => 'عقلك والكواكب';

  @override
  String get mnKarakaSubtitle => 'أي الكواكب تشكّل عالمك الداخلي';

  @override
  String get mnYogasTitle => 'نقاط القوة ومجالات النمو';

  @override
  String get mnCurrentPhase => 'المرحلة الحالية';

  @override
  String get mnCurrentStressLevel => 'مستوى التوتر الحالي';

  @override
  String get mnRecentStrain => 'الضغط العاطفي الأخير';

  @override
  String get mnStrengths => 'نقاط القوة';

  @override
  String get mnGrowthAreas => 'مجالات النمو';

  @override
  String get mnSadeSatiStatus => 'حالة Sade Sati';

  @override
  String get mnVerificationTitle => 'تم التحقق عبر المخططات';

  @override
  String get mnD9Confirmation => 'تأكيد D9';

  @override
  String get mnD30Confirmation => 'تأكيد D30';

  @override
  String get mnMoodPatternsTitle => 'أنماط المزاج والقلق';

  @override
  String get mnMoodPatternsSubtitle => 'وعي لطيف، وليس تشخيصًا';

  @override
  String get mnAnxietyPatterns => 'أنماط القلق';

  @override
  String get mnMoodPatterns => 'أنماط انخفاض المزاج';

  @override
  String get mnPrimaryPattern => 'النمط الأساسي';

  @override
  String get mnRumination => 'ميل الإفراط في التفكير';

  @override
  String get mnHypervigilance => 'فرط اليقظة';

  @override
  String get mnHopelessnessVuln => 'الحساسية لانخفاض المزاج';

  @override
  String get mnEnergyDepletion => 'ميل استنزاف الطاقة';

  @override
  String get mnMotivationBaseline => 'خط أساس الدافعية';

  @override
  String get mnRegulationTitle => 'التنظيم العاطفي والتأقلم';

  @override
  String get mnEmotionalRegulation => 'التنظيم العاطفي';

  @override
  String get mnSelfSoothing => 'القدرة على تهدئة الذات';

  @override
  String get mnExpressionStyle => 'أسلوب التعبير';

  @override
  String get mnRecoveryTime => 'وقت التعافي';

  @override
  String get mnTriggerIntensity => 'شدة المحفزات';

  @override
  String get mnHealthyCoping => 'عادات التأقلم الصحية';

  @override
  String get mnWatchFor => 'انتبه بلطف لـ';

  @override
  String get mnSleepTitle => 'النوم والراحة';

  @override
  String get mnSleepQuality => 'جودة النوم';

  @override
  String get mnSleepAsRegulator => 'النوم كمنظّم عاطفي';

  @override
  String get mnInsomniaTendency => 'ميل الأرق الليلي';

  @override
  String get mnNightmareTendency => 'ميل الأحلام الحية';

  @override
  String get mnSleepHygienePriority => 'أولوية نظافة النوم';

  @override
  String get mnBurnoutTitle => 'الإرهاق والطاقة';

  @override
  String get mnBurnoutVulnerability => 'الحساسية للإرهاق';

  @override
  String get mnBurnoutRecovery => 'القدرة على التعافي من الإرهاق';

  @override
  String get mnBurnoutStage => 'مرحلة الإرهاق الحالية';

  @override
  String get mnSelfDrivingTendency => 'ميل دفع الذات الزائد';

  @override
  String get mnBurnoutTriggers => 'محفزات الإرهاق';

  @override
  String get mnConnectionTitle => 'التواصل والدعم';

  @override
  String get mnSocialSupport => 'جودة الدعم الاجتماعي';

  @override
  String get mnLonelinessVuln => 'الحساسية للوحدة';

  @override
  String get mnSolitudeNeed => 'الحاجة إلى العزلة';

  @override
  String get mnSocialComfort => 'الارتياح الاجتماعي';

  @override
  String get mnTraumaSensitivity => 'الحساسية للصدمات';

  @override
  String get mnHealingReadiness => 'الجاهزية للشفاء';

  @override
  String get mnProcessingStyle => 'أسلوب المعالجة';

  @override
  String get mnMindBodyIntegration => 'تكامل العقل والجسد';

  @override
  String get mnPtsdVuln => 'الحساسية لاستجابة الصدمة';

  @override
  String get mnSelfAwarenessTitle => 'الوعي الذاتي والنمو';

  @override
  String get mnSelfAwarenessScore => 'الوعي الذاتي';

  @override
  String get mnEmotionalVocabulary => 'المفردات العاطفية';

  @override
  String get mnTherapyReadiness => 'الجاهزية للعلاج';

  @override
  String get mnJournalingBenefit => 'فائدة كتابة اليوميات';

  @override
  String get mnInnerDialogue => 'جودة الحوار الداخلي';

  @override
  String get mnAwarenessOfPatterns => 'الوعي بالأنماط';

  @override
  String get mnEscapePatternVuln => 'الحساسية لأنماط الهروب';

  @override
  String get mnEscapeChannels => 'انتبه بلطف لـ';

  @override
  String get mnHealthyAlternatives => 'بدائل صحية';

  @override
  String get mnTherapyFitTitle => 'ملاءمة العلاج والدعم';

  @override
  String get mnCrisisSupportRec => 'توصية الدعم';

  @override
  String get mnSupportNetwork => 'فعّل شبكة دعمك';

  @override
  String get mnSelfAdvocacy => 'الجاهزية للدفاع عن الذات';

  @override
  String get mnMedicationReceptivity => 'التقبل للعلاج الدوائي';

  @override
  String get mnTimelineTitle => 'الجدول الزمني للعافية';

  @override
  String get mnPeakWellnessYears => 'سنوات ذروة العافية';

  @override
  String get mnExtraCareYears => 'سنوات تتطلب عناية ذاتية إضافية';

  @override
  String get mnTransformationWindows => 'نوافذ التحول الإيجابي';

  @override
  String get mnTherapyWindow => 'النافذة الموصى بها للعلاج';

  @override
  String get mnPracticesTitle => 'ممارسات العافية اليومية';

  @override
  String get mnMorningPractices => 'ممارسات صباحية';

  @override
  String get mnEveningPractices => 'ممارسات مسائية';

  @override
  String get mnBreathwork => 'تمارين التنفس';

  @override
  String get mnMovement => 'الحركة';

  @override
  String get mnNutrition => 'التغذية';

  @override
  String get mnNatureExposure => 'الحاجة للتواصل مع الطبيعة';

  @override
  String get mnDigitalDetox => 'الحاجة لتقليل استخدام الأجهزة الرقمية';

  @override
  String get mnImprovementTitle => 'خطة التحسين';

  @override
  String get mnReliabilityTitle => 'الموثوقية';

  @override
  String get mnLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get mnLayerD9 => 'مخطط الروح (D9)';

  @override
  String get mnLayerD30 => 'مخطط D30';

  @override
  String get mnLayerDasha => 'توقيت Dasha';

  @override
  String get mnLayerTransit => 'الانتقالات';

  @override
  String get mnTopicResilience => 'ما مدى مرونتي العاطفية؟';

  @override
  String get mnTopicCoping => 'ما أفضل استراتيجيات التأقلم لدي؟';

  @override
  String get mnTopicSleep => 'كيف يمكنني تحسين نومي؟';

  @override
  String get mnTopicBurnout => 'هل أنا معرض لخطر الإرهاق؟';

  @override
  String get mnTopicTherapy => 'أي أسلوب علاج يناسبني؟';

  @override
  String get mnTopicPractices => 'ما الممارسات اليومية التي تساعدني أكثر؟';

  @override
  String get mnTopicTiming => 'متى هي أفضل سنوات العافية لدي؟';

  @override
  String get mnTopicSupport => 'كيف أبني شبكة دعم قوية؟';

  @override
  String get lgSubtitle =>
      'التقرير القانوني المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get lgTitle => 'الشؤون القانونية والنزاعات';

  @override
  String get lgSnapshotHeader => 'لمحة قانونية';

  @override
  String get lgResilience => 'المرونة القانونية';

  @override
  String get lgResolutionCapacity => 'القدرة على التسوية';

  @override
  String get lgVictoryPotential => 'إمكانية الفوز';

  @override
  String get lgLegalSafety => 'السلامة القانونية';

  @override
  String get lgNegotiationSkill => 'مهارة التفاوض';

  @override
  String get lgStatusExcellent => 'ممتاز';

  @override
  String get lgStatusStrong => 'قوي';

  @override
  String get lgStatusModerate => 'متوسط';

  @override
  String get lgStatusDeveloping => 'قيد التطور';

  @override
  String get lgStatusChallenging => 'صعب';

  @override
  String get lgChipResolver => 'ماهر في التسوية';

  @override
  String get lgChipWinner => 'فوز في القضايا القوية';

  @override
  String get lgChipNegotiator => 'مفاوض بالفطرة';

  @override
  String get lgChipDocumented => 'موثّق جيدًا';

  @override
  String get lgChipLowRisk => 'خطر قانوني منخفض';

  @override
  String get lgChipMoralAuthority => 'سلطة أخلاقية';

  @override
  String get lgChipLegalAptitude => 'استعداد قانوني';

  @override
  String get lgProfileTitle => 'ملفك القانوني وكارماك';

  @override
  String get lgPrimaryDriver => 'المحرك الأساسي';

  @override
  String get lgDharmaAnchor => 'مرساة الدارما';

  @override
  String get lgAggressionMarker => 'مؤشر العدوانية';

  @override
  String get lgDocumentationKaraka => 'جودة التوثيق';

  @override
  String get lgKarakaTitle => 'كواكبك القانونية';

  @override
  String get lgKarakaSubtitle => 'أي الكواكب تشكّل حظك القانوني';

  @override
  String get lgYogasTitle => 'يوغات الحماية القانونية';

  @override
  String get lgCurrentPhase => 'المرحلة الحالية';

  @override
  String get lgProtections => 'أوجه الحماية';

  @override
  String get lgDisputePressures => 'ضغوط النزاعات';

  @override
  String get lgVerificationTitle => 'تم التحقق عبر المخططات';

  @override
  String get lgD6Litigation => 'مخطط التقاضي D6';

  @override
  String get lgD9Dharma => 'مخطط الدارما D9';

  @override
  String get lgMoralAuthority => 'السلطة الأخلاقية';

  @override
  String get lgVictoryTitle => 'تحليل الفوز';

  @override
  String get lgAsPlaintiff => 'بصفتك المدّعي';

  @override
  String get lgAsDefendant => 'بصفتك المدّعى عليه';

  @override
  String get lgSettlementPreference => 'تفضيل التسوية الودية';

  @override
  String get lgDisputeCategoriesTitle => 'فئات النزاعات التي تستدعي المراقبة';

  @override
  String get lgLowRiskCategories => 'الفئات منخفضة الخطورة';

  @override
  String get lgConflictStyleTitle => 'أسلوب مواجهة الخلافات والأعداء';

  @override
  String get lgConfrontationComfort => 'الارتياح للمواجهة';

  @override
  String get lgArgumentPersuasiveness => 'قوة الإقناع بالحجة';

  @override
  String get lgEmotionalRegulation => 'التنظيم العاطفي';

  @override
  String get lgGrudgeHolding => 'ميل حمل الضغينة';

  @override
  String get lgEnemyAnalysisLabel => 'تحليل الأعداء';

  @override
  String get lgVisibleEnemies => 'الأعداء الظاهرون';

  @override
  String get lgHiddenEnemies => 'الأعداء الخفيون';

  @override
  String get lgWorkplaceEnemies => 'أعداء مكان العمل';

  @override
  String get lgFamilyEnemies => 'أعداء من الأسرة';

  @override
  String get lgLegalEnemies => 'خصوم قانونيون';

  @override
  String get lgEnemyDefeatCapacity => 'القدرة على هزيمة الأعداء';

  @override
  String get lgCriminalFinancialTitle => 'مراقبة المخاطر الجنائية والمالية';

  @override
  String get lgCriminalRisk => 'خطر التورط الجنائي';

  @override
  String get lgVictimOfCrime => 'احتمال الوقوع ضحية جريمة';

  @override
  String get lgFalseAccusation => 'خطر الاتهام الباطل';

  @override
  String get lgImprisonmentRisk => 'خطر السجن';

  @override
  String get lgTaxDisputeRisk => 'خطر النزاع الضريبي';

  @override
  String get lgFinancialFraudRisk => 'خطر الاحتيال المالي';

  @override
  String get lgBusinessLitigationRisk => 'خطر التقاضي التجاري';

  @override
  String get lgBankruptcyRisk => 'خطر الإفلاس';

  @override
  String get lgAuditVulnerability => 'قابلية التدقيق';

  @override
  String get lgProtectionPriority => 'أولوية الحماية';

  @override
  String get lgContractsTitle => 'العقود والتفاوض';

  @override
  String get lgContractClarity => 'وضوح العقد';

  @override
  String get lgDocumentationDiscipline => 'انضباط التوثيق';

  @override
  String get lgFinePrintAwareness => 'الوعي بالشروط الدقيقة';

  @override
  String get lgSignatureCaution => 'الحذر عند التوقيع';

  @override
  String get lgMediationReceptivity => 'التقبل للوساطة';

  @override
  String get lgNegotiationSkillFull => 'مهارة التفاوض';

  @override
  String get lgCompromiseWillingness => 'الاستعداد للتنازل';

  @override
  String get lgFaceSavingNeeds => 'الحاجة لحفظ ماء الوجه';

  @override
  String get lgMediatorHireRecommendation => 'توصية بالاستعانة بوسيط';

  @override
  String get lgTypicalContractIssues => 'المشكلات المعتادة في العقود';

  @override
  String get lgCareerFitTitle => 'الملاءمة المهنية القانونية';

  @override
  String get lgProfessionAffinity => 'الميل المهني';

  @override
  String get lgRoleFit => 'أفضل ملاءمة للدور';

  @override
  String get lgLawStudentSuccess => 'النجاح كطالب حقوق';

  @override
  String get lgBarExamSuccess => 'النجاح في امتحان المحاماة';

  @override
  String get lgTimelineTitle => 'الجدول الزمني القانوني';

  @override
  String get lgNewMatterChance => 'احتمال قضية جديدة (الـ 12 شهرًا القادمة)';

  @override
  String get lgOngoingCaseOutcome => 'نتيجة القضية الجارية';

  @override
  String get lgRecommendedAction => 'الإجراء الموصى به';

  @override
  String get lgPeakDisputeYears => 'سنوات ذروة النزاعات';

  @override
  String get lgClarityYears => 'سنوات الوضوح القانوني';

  @override
  String get lgAvoidancePeriods => 'فترات حرجة يجب تجنبها';

  @override
  String get lgFavorableWindows => 'نوافذ مواتية للتسوية';

  @override
  String get lgRisksTitle => 'المخاطر ونقاط الضعف';

  @override
  String get lgChronicVulnerabilities => 'نقاط ضعف مزمنة';

  @override
  String get lgAvoidDashaPeriods => 'فترات Dasha التي تستدعي الحذر';

  @override
  String get lgPreventivePriorities => 'أولويات وقائية';

  @override
  String get lgRedFlags => 'مواقف تحذيرية';

  @override
  String get lgImprovementTitle => 'خطة التحسين';

  @override
  String get lgReliabilityTitle => 'الموثوقية';

  @override
  String get lgLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get lgLayerD6 => 'مخطط التقاضي (D6)';

  @override
  String get lgLayerD9 => 'مخطط الدارما (D9)';

  @override
  String get lgLayerDasha => 'توقيت Dasha';

  @override
  String get lgLayerTransit => 'الانتقالات';

  @override
  String get lgTopicWinChance => 'ما هي فرصي في الفوز؟';

  @override
  String get lgTopicStrategy => 'ما أفضل استراتيجية قانونية لي؟';

  @override
  String get lgTopicContract => 'ما مخاطر العقود التي يجب مراقبتها؟';

  @override
  String get lgTopicTiming => 'ما أفضل توقيت لتسوية النزاعات؟';

  @override
  String get lgTopicSettlement => 'هل يجب أن أسوّي أم أخوض القضية؟';

  @override
  String get lgTopicEnemies => 'من هم أعدائي الخفيون؟';

  @override
  String get lgTopicProtection => 'كيف أحمي نفسي قانونيًا؟';

  @override
  String get lgTopicCareer => 'هل أنا مناسب لمهنة قانونية؟';

  @override
  String get prSubtitle =>
      'تقرير الممتلكات والأصول المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get prTitle => 'الممتلكات والأصول';

  @override
  String get prSnapshotHeader => 'لمحة عن الممتلكات';

  @override
  String get prAcquisitionCapacity => 'القدرة على الاقتناء';

  @override
  String get prHomeOwnership => 'ملكية المنزل';

  @override
  String get prWealthPotential => 'إمكانية الثروة';

  @override
  String get prRentalIncome => 'دخل الإيجار';

  @override
  String get prLandOwnership => 'ملكية الأرض';

  @override
  String get prStatusExcellent => 'ممتاز';

  @override
  String get prStatusStrong => 'قوي';

  @override
  String get prStatusModerate => 'متوسط';

  @override
  String get prStatusDeveloping => 'قيد التطور';

  @override
  String get prStatusChallenging => 'صعب';

  @override
  String get prChipHomeOwner => 'مالك منزل';

  @override
  String get prChipWealthBuilder => 'بانِ ثروة';

  @override
  String get prChipLandOwner => 'مالك أرض';

  @override
  String get prChipInvestor => 'مستثمر عقاري';

  @override
  String get prChipInheritance => 'ميراث محتمل';

  @override
  String get prChipVehicle => 'مالك مركبة';

  @override
  String get prChipGlobalAsset => 'ميل نحو الأصول العالمية';

  @override
  String get prProfileTitle => 'أسلوبك في الممتلكات';

  @override
  String get prHomeAesthetics => 'جماليات المنزل';

  @override
  String get prHomeSanctuary => 'المنزل كملاذ';

  @override
  String get prComfortInvestment => 'الاستثمار في الراحة';

  @override
  String get prVastuPriority => 'أولوية Vastu';

  @override
  String get prNaturalElements => 'العناصر الطبيعية';

  @override
  String get prNextActionLabel => 'الخطوة التالية';

  @override
  String get prKarakaTitle => 'كواكب ممتلكاتك';

  @override
  String get prKarakaSubtitle => 'أي الكواكب تشكّل حظك العقاري';

  @override
  String get prPrimaryKaraka => 'الكاراكا الأساسي';

  @override
  String get prDurableAsset => 'كاراكا الأصول الدائمة';

  @override
  String get prYogasTitle => 'يوغات ودوشات الممتلكات';

  @override
  String get prCurrentPhase => 'المرحلة الحالية';

  @override
  String get prBoosters => 'معززات';

  @override
  String get prDrains => 'استنزافات';

  @override
  String get prVerificationTitle => 'تم التحقق عبر المخططات';

  @override
  String get prD4Property => 'مخطط الممتلكات D4';

  @override
  String get prD16Vehicle => 'مخطط المركبات D16';

  @override
  String get prVehicleFit => 'ملاءمة المركبة';

  @override
  String get prJourneyTitle => 'مسيرة الملكية والجدول الزمني';

  @override
  String get prFirstHomeAge => 'عمر اقتناء أول منزل';

  @override
  String get prFirstHomeType => 'نوع أول منزل';

  @override
  String get prMultipleHomes => 'منازل متعددة';

  @override
  String get prNewPropertySoon => 'ممتلكات جديدة قريبًا';

  @override
  String get prFirstMajorWindow => 'أول نافذة رئيسية';

  @override
  String get prBuyingWindow => 'نافذة الشراء';

  @override
  String get prConstructionWindow => 'نافذة البناء';

  @override
  String get prNextOpportunity => 'الفرصة القادمة';

  @override
  String get prLifetimePropertyCount => 'عدد الممتلكات مدى الحياة';

  @override
  String get prInheritanceTitle => 'الميراث وممتلكات الأسرة';

  @override
  String get prMaternalInheritance => 'الميراث من الأم';

  @override
  String get prPaternalInheritance => 'الميراث من الأب';

  @override
  String get prAncestralProperty => 'الممتلكات الموروثة عن الأسلاف';

  @override
  String get prFamilyDisputeRisk => 'خطر النزاع الأسري';

  @override
  String get prInheritanceTiming => 'توقيت الميراث';

  @override
  String get prInheritanceType => 'نوع الميراث';

  @override
  String get prLandInvestTitle => 'الأراضي والاستثمار والممتلكات العالمية';

  @override
  String get prPropertyInvestor => 'درجة المستثمر العقاري';

  @override
  String get prAppreciationLuck => 'حظ ارتفاع القيمة';

  @override
  String get prInvestorMindset => 'عقلية المستثمر';

  @override
  String get prLandType => 'نوع الأرض';

  @override
  String get prRentalCount => 'عدد الممتلكات المؤجرة';

  @override
  String get prMultipleLand => 'قطع أراضٍ متعددة';

  @override
  String get prFarmEstate => 'احتمال امتلاك مزرعة / عقار كبير';

  @override
  String get prGlobalPropertyLabel => 'ممتلكات عالمية';

  @override
  String get prForeignProperty => 'ممتلكات في الخارج';

  @override
  String get prNriAffinity => 'ميل أصول المغتربين';

  @override
  String get prVehiclesTitle => 'المركبات';

  @override
  String get prVehicleCount => 'عدد المركبات';

  @override
  String get prVehicleFirstAge => 'عمر اقتناء أول مركبة';

  @override
  String get prVehicleCategory => 'فئة المركبة';

  @override
  String get prVehicleQuality => 'جودة المركبة';

  @override
  String get prLuxuryAffinity => 'الميل نحو الفخامة';

  @override
  String get prVehicleLossRisk => 'خطر فقدان/تلف المركبة';

  @override
  String get prLegalRiskTitle => 'مراقبة المخاطر القانونية';

  @override
  String get prBoundaryDisputes => 'نزاعات الحدود';

  @override
  String get prPartitionDisputes => 'نزاعات التقسيم';

  @override
  String get prTitleIssues => 'مشكلات في سند الملكية / التوثيق';

  @override
  String get prTenantConflict => 'نزاع بين المستأجر والمالك';

  @override
  String get prForcedSale => 'خطر البيع القسري';

  @override
  String get prPropertyDamage => 'خطر تلف الممتلكات';

  @override
  String get prInsurancePriority => 'أولوية التأمين';

  @override
  String get prProtectionUrgency => 'إلحاحية الحماية';

  @override
  String get prProtectiveFactors => 'عوامل الحماية';

  @override
  String get prChronicVulnerabilities => 'نقاط ضعف مزمنة';

  @override
  String get prDueDiligenceTitle => 'قائمة العناية الواجبة';

  @override
  String get prPreventiveMeasures => 'التدابير الوقائية';

  @override
  String get prImprovementTitle => 'خطة التحسين';

  @override
  String get prReliabilityTitle => 'الموثوقية';

  @override
  String get prLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get prLayerD4 => 'مخطط الممتلكات (D4)';

  @override
  String get prLayerD16 => 'مخطط المركبات (D16)';

  @override
  String get prLayerDasha => 'توقيت Dasha';

  @override
  String get prLayerTransit => 'الانتقالات';

  @override
  String get prTopicBuying => 'ما أفضل وقت للشراء؟';

  @override
  String get prTopicInherit => 'هل سأرث ممتلكات؟';

  @override
  String get prTopicVehicle => 'متى سأحصل على مركبة؟';

  @override
  String get prTopicRental => 'ما إمكانية دخل الإيجار؟';

  @override
  String get prTopicLand => 'ما فرص امتلاك أرض؟';

  @override
  String get prTopicLegal => 'ما المخاطر القانونية التي يجب مراقبتها؟';

  @override
  String get prTopicForeign => 'ما فرص امتلاك ممتلكات في الخارج؟';

  @override
  String get prTopicTiming => 'ما أفضل نوافذ توقيت للممتلكات؟';

  @override
  String get edTitle => 'تحليل التعليم والتعلم';

  @override
  String get edSubtitle =>
      'تقرير التعليم المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get edSnapshotHeader => 'لمحة عن تعليمك';

  @override
  String get edOverallStrength => 'القوة العامة';

  @override
  String get edAcademicSuccess => 'النجاح الأكاديمي';

  @override
  String get edLearningCapacity => 'القدرة على التعلم';

  @override
  String get edIntellect => 'الذكاء';

  @override
  String get edMemory => 'الذاكرة';

  @override
  String get edStatusExcellent => 'إمكانية ممتازة';

  @override
  String get edStatusStrong => 'إمكانية قوية';

  @override
  String get edStatusModerate => 'إمكانية متوسطة';

  @override
  String get edStatusDeveloping => 'إمكانية قيد التطور';

  @override
  String get edStatusChallenging => 'مرحلة صعبة';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'قدرة بحثية قوية';

  @override
  String get edChipScholarship => 'إمكانية الحصول على منحة دراسية';

  @override
  String get edChipDoctorate => 'إمكانية الحصول على دكتوراه';

  @override
  String get edChipForeign => 'دعم للتعليم في الخارج';

  @override
  String get edChipLifelong => 'متعلم مدى الحياة';

  @override
  String get edLearningStyleTitle => 'أسلوبك في التعلم';

  @override
  String get edSoulPlanet => 'كوكب الروح';

  @override
  String get edSoulHint => 'أعمق دافع داخلي لديك وهدف حياتك';

  @override
  String get edSubjectPlanet => 'كوكب المواد الدراسية';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (تقني)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (تقني)';

  @override
  String get edSubjectKarakaStrength => 'قوة كاراكا المواد الدراسية';

  @override
  String get edFoundationTitle => 'أساس التعليم';

  @override
  String get edHouse4 => 'التعليم المبكر';

  @override
  String get edHouse5 => 'الذكاء';

  @override
  String get edHouse9 => 'التعليم العالي';

  @override
  String get edPurvaPunya => 'فضل من حياة سابقة';

  @override
  String get edStudyPlanetsTitle => 'كواكب دراستك';

  @override
  String get edYogasTitle => 'يوغات التعليم في مخططك';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'موجودة';

  @override
  String get edYogaAbsent => 'غير موجودة';

  @override
  String get edYogaNoneNote =>
      'لا توجد يوغات تعليمية كلاسيكية — يأتي النجاح من الجهد المستمر والانضباط.';

  @override
  String get edVerificationTitle => 'التحقق عبر المخططات';

  @override
  String get edD24Learning => 'D24 — مخطط التعلم العميق';

  @override
  String get edD4Formal => 'D4 — مخطط التعليم الرسمي';

  @override
  String get edD9Dharma => 'D9 — مخطط دارما التعلم';

  @override
  String get edD60Karma => 'D60 — كارما التعلم من الحياة السابقة';

  @override
  String get edSubjectsTitle => 'أفضل المواد الدراسية لك';

  @override
  String get edSubjectsSubtitle => 'مرتبة حسب توافق المخطط';

  @override
  String get edLowAffinity => 'مواد ذات توافق أقل';

  @override
  String get edDegreesTitle => 'احتمالية الدرجة العلمية والمستوى';

  @override
  String get edExpectedLevel => 'المستوى المتوقع';

  @override
  String get edDegreeFormal => 'شهادة رسمية';

  @override
  String get edDegreePostgrad => 'دراسات عليا';

  @override
  String get edDegreeDoctorate => 'دكتوراه';

  @override
  String get edDegreeForeign => 'تعليم في الخارج';

  @override
  String get edTimelineTitle => 'الجدول الزمني للدراسة';

  @override
  String get edEarlySchooling => 'نافذة التعليم المبكر';

  @override
  String get edHigherEducation => 'نافذة التعليم العالي';

  @override
  String get edPostgradResearch => 'نافذة الدراسات العليا / البحث';

  @override
  String get edPeakLearningAge => 'عمر ذروة التعلم';

  @override
  String get edPreferencesTitle => 'تفضيلات التعلم والدعم';

  @override
  String get edPrefStudyMode => 'نمط الدراسة';

  @override
  String get edPrefTiming => 'أفضل وقت';

  @override
  String get edPrefEnvironment => 'البيئة';

  @override
  String get edPrefLocation => 'الموقع';

  @override
  String get edPrefForeign => 'الدراسة في الخارج';

  @override
  String get edGuruRelationship => 'الرابطة مع المعلم/المرشد';

  @override
  String get edMentorAvailability => 'توفر مرشد';

  @override
  String get edPeerLearning => 'التعلم مع الأقران';

  @override
  String get edAuthorityDeference => 'احترام السلطة';

  @override
  String get edStrengthsTitle => 'نقاط القوة والتحديات';

  @override
  String get edCognitiveGifts => 'المواهب المعرفية';

  @override
  String get edNaturalAbilities => 'قدرات التعلم الطبيعية';

  @override
  String get edHiddenCapacities => 'القدرات الخفية';

  @override
  String get edConcentration => 'صعوبة التركيز';

  @override
  String get edBreakRisk => 'خطر انقطاع التعليم';

  @override
  String get edDisciplineConsistency => 'ثبات الانضباط';

  @override
  String get edScholarshipLikelihood => 'احتمالية الحصول على منحة';

  @override
  String get edCareerLinkTitle => 'مسار التعليم إلى المسيرة المهنية';

  @override
  String get edDirectionRec => 'الاتجاه الموصى به';

  @override
  String get edIntegrationStrategy => 'استراتيجية التكامل';

  @override
  String get edCareerLinkage => 'الارتباط المهني';

  @override
  String get edAlignedSubjects => 'مواد متوافقة مع المسيرة المهنية';

  @override
  String get edDegreeUtility => 'فائدة الشهادة للمسيرة المهنية';

  @override
  String get edImprovementTitle => 'خطة التحسين';

  @override
  String get edReliabilityTitle => 'موثوقية التوقع';

  @override
  String get edLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get edLayerD4 => 'التعليم الرسمي (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'التعلم العميق (D24)';

  @override
  String get edLayerD60 => 'تعلم الحياة السابقة (D60)';

  @override
  String get edLayerAmk => 'كاراكا المواد الدراسية';

  @override
  String get edLayerMj => 'عطارد-المشتري';

  @override
  String get edLayerDasha => 'توقيت الكواكب';

  @override
  String get edTopicSubjects => 'أفضل المواد الدراسية لي';

  @override
  String get edTopicDegree => 'فرص الحصول على شهادة';

  @override
  String get edTopicAbroad => 'الدراسة في الخارج';

  @override
  String get edTopicExam => 'الأداء في الامتحانات';

  @override
  String get edTopicHabits => 'عادات الدراسة';

  @override
  String get edTopicCareerLink => 'الرابط بين التعليم والمسيرة المهنية';

  @override
  String get edTopicTiming => 'نوافذ توقيت التعليم';

  @override
  String get edTopicScholarship => 'فرص الحصول على منحة';

  @override
  String get hwTitle => 'تحليل الصحة والعافية';

  @override
  String get hwSubtitle =>
      'تقرير الصحة والعافية المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get hwSnapshotHeader => 'لمحة عن صحتك';

  @override
  String get hwOverallVitality => 'الحيوية';

  @override
  String get hwImmunity => 'المناعة';

  @override
  String get hwRecovery => 'التعافي';

  @override
  String get hwMentalWellness => 'العافية النفسية';

  @override
  String get hwStressTolerance => 'تحمّل الضغط';

  @override
  String get hwStatusThriving => 'مزدهر';

  @override
  String get hwStatusGood => 'حيوية جيدة';

  @override
  String get hwStatusBalanced => 'متوازن';

  @override
  String get hwStatusNeedsCare => 'يحتاج إلى عناية';

  @override
  String get hwStatusNeedsAttention => 'يحتاج إلى اهتمام';

  @override
  String get hwChipImmunity => 'مناعة قوية';

  @override
  String get hwChipRecovery => 'تعافٍ سريع';

  @override
  String get hwChipMentalBalance => 'عقل متوازن';

  @override
  String get hwChipStressResilience => 'مرن أمام الضغط';

  @override
  String get hwChipFertility => 'دعم الخصوبة';

  @override
  String get hwChipWorkLife => 'توازن جيد بين العمل والحياة';

  @override
  String get hwChipLowAddiction => 'خطر إدمان منخفض';

  @override
  String get hwConstitutionTitle => 'نوع بنيتك الجسدية';

  @override
  String get hwConstitutionSubtitle => 'البنية الأيورفيدية وفق مخططك';

  @override
  String get hwDominantDosha => 'السائد';

  @override
  String get hwSecondaryDosha => 'الثانوي';

  @override
  String get hwPrimaryKaraka => 'المؤشر الصحي الرئيسي';

  @override
  String get hwStrongestSystem => 'أقوى جهاز';

  @override
  String get hwWeakestSystem => 'جهاز يحتاج إلى دعم';

  @override
  String get hwBodyMapTitle => 'خريطة جسدك الكوكبية';

  @override
  String get hwBodyMapSubtitle => '9 كواكب، 9 أجهزة جسدية';

  @override
  String get hwYogaTitle => 'الأنماط الصحية في مخططك';

  @override
  String get hwYogaSubtitle => 'يوغات الحماية مقابل يوغات ضغط المرض';

  @override
  String get hwDiseasePressureLabel => 'ضغط المرض';

  @override
  String get hwAreasTitle => 'مناطق الجسد التي تستدعي المراقبة';

  @override
  String get hwAreasSubtitle => 'قابلية التأثر حسب منطقة الجسد';

  @override
  String get hwProtectedAreas => 'مناطق محمية جيدًا';

  @override
  String get hwCategoriesTitle => 'مراقبة فئات الأمراض';

  @override
  String get hwCategoriesSubtitle =>
      'القابلية للتأثر عبر الفئات الصحية الرئيسية';

  @override
  String get hwLowRiskCategories => 'فئات منخفضة الخطورة';

  @override
  String get hwMentalTitle => 'العافية النفسية والعاطفية';

  @override
  String get hwMentalSubtitle => 'المرونة العاطفية واحتياجات الدعم';

  @override
  String get hwMentalVulnerability => 'الحساسية العاطفية';

  @override
  String get hwEmotionalRegulation => 'التنظيم العاطفي';

  @override
  String get hwSupportRec => 'توصية الدعم';

  @override
  String get hwTendencies => 'الميول النفسية';

  @override
  String get hwTimelineTitle => 'الجدول الزمني الصحي';

  @override
  String get hwTimelineSubtitle => 'سنوات الذروة، سنوات الحذر ونوافذ التعافي';

  @override
  String get hwPeakYears => 'سنوات ذروة العافية';

  @override
  String get hwCautionYears => 'سنوات الحذر';

  @override
  String get hwRecoveryWindow => 'نافذة التعافي';

  @override
  String get hwCheckupYears => 'سنوات موصى بها للفحص الطبي';

  @override
  String get hwCurrentPhase => 'المرحلة الحالية';

  @override
  String get hwLifestyleTitle => 'دليل نمط حياتك';

  @override
  String get hwLifestyleSubtitle => 'ما يقوله مخططك عن عاداتك اليومية';

  @override
  String get hwSleepDiscipline => 'أثر انضباط النوم';

  @override
  String get hwDietDiscipline => 'أثر انضباط الحمية الغذائية';

  @override
  String get hwExerciseNeed => 'الحاجة إلى الرياضة';

  @override
  String get hwSunlightNeed => 'الحاجة إلى ضوء الشمس';

  @override
  String get hwStressSusceptibility => 'القابلية للتأثر بالضغط';

  @override
  String get hwHydrationSensitivity => 'الحساسية للترطيب';

  @override
  String get hwSocialType => 'نمط الطاقة الاجتماعية';

  @override
  String get hwHealingSpeed => 'سرعة الشفاء';

  @override
  String get hwTreatmentResponse => 'الاستجابة للعلاج';

  @override
  String get hwAltHealing => 'الميل للعلاج البديل';

  @override
  String get hwSpecialTitle => 'مراحل الحياة ومواضيع خاصة';

  @override
  String get hwSpecialSubtitle => 'الخصوبة، صحة الطفولة، العادات والإرهاق';

  @override
  String get hwFertility => 'مؤشر الخصوبة';

  @override
  String get hwHormonalBalance => 'التوازن الهرموني';

  @override
  String get hwReproductiveStrength => 'قوة الجهاز التناسلي';

  @override
  String get hwChildhoodVuln => 'قابلية التأثر الصحي في الطفولة';

  @override
  String get hwChildhoodStatus => 'صحة الطفولة';

  @override
  String get hwAddictionVuln => 'قابلية التأثر بالإدمان';

  @override
  String get hwAddictionRecovery => 'القدرة على التعافي';

  @override
  String get hwBurnoutVuln => 'قابلية التأثر بالإرهاق';

  @override
  String get hwWorkLifeBalance => 'التوازن بين العمل والحياة';

  @override
  String get hwStressTriggers => 'محفزات الضغط';

  @override
  String get hwProtectiveFactors => 'عوامل الحماية';

  @override
  String get hwChallengesTitle => 'تحديات تستدعي المراقبة';

  @override
  String get hwChallengesSubtitle => 'أين تركّز الرعاية الوقائية';

  @override
  String get hwMitigation => 'كيفية الإدارة';

  @override
  String get hwChronicAreas => 'مجالات ضعف مزمنة';

  @override
  String get hwPreventivePriorities => 'أولويات وقائية';

  @override
  String get hwImprovementTitle => 'خطة عافيتك';

  @override
  String get hwImprovementSubtitle => 'خطوات عملية + علاجات تقليدية';

  @override
  String get hwReliabilityTitle => 'موثوقية القراءة';

  @override
  String get hwLayerD1 => 'مخطط الميلاد (D1)';

  @override
  String get hwLayerD6 => 'المخطط الصحي (D6)';

  @override
  String get hwLayerD30 => 'مخطط الصحة الدقيق (D30)';

  @override
  String get hwLayerDasha => 'توقيت الكواكب';

  @override
  String get hwLayerTransit => 'الانتقالات الحالية';

  @override
  String get hwDisclaimerLabel => 'إخلاء مسؤولية طبي';

  @override
  String get hwTopicImmunity => 'تعزيز المناعة';

  @override
  String get hwTopicSleep => 'النوم والراحة';

  @override
  String get hwTopicStress => 'إدارة الضغط';

  @override
  String get hwTopicFertility => 'توقيت الخصوبة';

  @override
  String get hwTopicDiet => 'الحمية الغذائية والتغذية';

  @override
  String get hwTopicTiming => 'نوافذ التوقيت الصحي';

  @override
  String get hwTopicMental => 'العافية النفسية';

  @override
  String get hwTopicPrevention => 'خطة الرعاية الوقائية';

  @override
  String get lvSubtitle =>
      'تقرير الحب المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get lvTitle => 'الحب والعلاقات';

  @override
  String get lvLovePotential => 'إمكانية الحب';

  @override
  String get lvEmotionalAvail => 'منفتح عاطفيًا';

  @override
  String get lvAttraction => 'الانجذاب';

  @override
  String get lvCommitment => 'الالتزام';

  @override
  String get lvCommunication => 'التواصل';

  @override
  String get lvFidelity => 'الوفاء';

  @override
  String get lvChipLoyal => 'قلب وفي';

  @override
  String get lvChipOpenHeart => 'قلب منفتح';

  @override
  String get lvChipCommunicator => 'متواصل بارع';

  @override
  String get lvChipMature => 'يتعامل بنضج مع الخلافات';

  @override
  String get lvChipEmotionallyWise => 'حكيم عاطفيًا';

  @override
  String get lvLoveStyle => 'أسلوبك في الحب';

  @override
  String get lvAttractionStyle => 'أسلوب الانجذاب';

  @override
  String get lvLangGiven => 'تعبّر عن الحب عبر';

  @override
  String get lvLangReceived => 'تشعر بالحب عبر';

  @override
  String get lvLovePlanets => 'كواكب الحب لديك';

  @override
  String get lvLoveKaraka => 'الحب';

  @override
  String get lvEmotionKaraka => 'العاطفة';

  @override
  String get lvPassionKaraka => 'الشغف';

  @override
  String get lvPathToLove => 'مسارك نحو الحب';

  @override
  String get lvPathSub => 'الحب مقابل الزواج المرتب';

  @override
  String get lvLoveMarriage => 'زواج حب';

  @override
  String get lvArrangedMarriage => 'زواج مرتب';

  @override
  String get lvParentalAccept => 'موافقة الوالدين';

  @override
  String get lvInterCaste => 'زواج بين طبقات/أديان مختلفة';

  @override
  String get lvIdealPartner => 'شريكك المثالي';

  @override
  String get lvPersonality => 'الشخصية';

  @override
  String get lvAppearance => 'المظهر';

  @override
  String get lvIdealTraits => 'السمات المثالية';

  @override
  String get lvWhatMatters => 'ما الأهم';

  @override
  String get lvDrawnTo => 'تنجذب إلى';

  @override
  String get lvDealbreakers => 'أسباب القطيعة';

  @override
  String get lvYourAppeal => 'جاذبيتك';

  @override
  String get lvLoveStory => 'قصة حبك';

  @override
  String get lvLoveStorySub => 'أنماط العلاقات';

  @override
  String get lvFirstLove => 'الحب الأول';

  @override
  String get lvRelationCount => 'الروابط المهمة';

  @override
  String get lvDuration => 'المدة المعتادة';

  @override
  String get lvDepth => 'العمق العاطفي';

  @override
  String get lvDatingPattern => 'نمط المواعدة';

  @override
  String get lvCommitIntimacy => 'الالتزام والحميمية';

  @override
  String get lvCommitReady => 'الجاهزية للالتزام';

  @override
  String get lvIntimacyDrive => 'دافع الحميمية';

  @override
  String get lvSensuality => 'الحسية';

  @override
  String get lvEmpathy => 'التعاطف';

  @override
  String get lvCommitStyle => 'أسلوب الالتزام';

  @override
  String get lvChemistry => 'أسلوب الانسجام';

  @override
  String get lvMakesCommit => 'ما يدفعك للالتزام';

  @override
  String get lvMakesFlee => 'ما يبعدك';

  @override
  String get lvEmotional => 'الذكاء العاطفي';

  @override
  String get lvEmotionalIQ => 'معدل الذكاء العاطفي';

  @override
  String get lvConflictStyle => 'أسلوب مواجهة الخلافات';

  @override
  String get lvTiming => 'توقيت الحب';

  @override
  String get lvNewLove12 => 'حب جديد خلال 12 شهرًا';

  @override
  String get lvEnergyNow => 'الطاقة الحالية';

  @override
  String get lvPhaseNow => 'المرحلة الحالية';

  @override
  String get lvPeakRomance => 'سنوات ذروة الرومانسية';

  @override
  String get lvNewLoveWindow => 'نافذة الحب الجديد';

  @override
  String get lvChallenges => 'تحديات تستدعي المراقبة';

  @override
  String get lvRiskHeartbreak => 'قابلية التأثر بخيبة القلب';

  @override
  String get lvRiskSabotage => 'تخريب الذات';

  @override
  String get lvRiskCommitFear => 'الخوف من الالتزام';

  @override
  String get lvRiskRepeat => 'الأنماط المتكررة';

  @override
  String get lvRiskWorkaholic => 'تفضيل العمل على الحب';

  @override
  String get lvRedFlags => 'إشارات تحذيرية يجب مراقبتها';

  @override
  String get lvHealing => 'ما يجب شفاؤه';

  @override
  String get lvFocusArea => 'مجال التركيز';

  @override
  String get lvHealDir => 'اتجاه الشفاء';

  @override
  String get lvImprovementPlan => 'خطة التحسين';

  @override
  String get lvReliability => 'موثوقية التوقع';

  @override
  String get lvLayerBirth => 'مخطط الميلاد (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'توقيت Dasha';

  @override
  String get lvLayerTransit => 'الانتقالات الحالية';

  @override
  String get lvTopicWhen => 'متى سأجد الحب؟';

  @override
  String get lvTopicSoulmate => 'عن شريك روحي';

  @override
  String get lvTopicCurrent => 'علاقتي الحالية';

  @override
  String get lvTopicHeal => 'الشفاء من الماضي';

  @override
  String get lvTopicCommit => 'المساعدة على الالتزام';

  @override
  String get lvTopicLoveVsArranged => 'الحب مقابل الزواج المرتب';

  @override
  String get lvTopicHeartbreak => 'تجنب خيبة القلب';

  @override
  String get lvTopicConfidence => 'الثقة في الحب';

  @override
  String get mrSubtitle =>
      'تقرير الزواج المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get mrTitle => 'الزواج والأسرة';

  @override
  String get mrMarriagePotential => 'إمكانية الزواج';

  @override
  String get mrHarmony => 'الانسجام';

  @override
  String get mrLongevity => 'الديمومة';

  @override
  String get mrSatisfaction => 'الرضا';

  @override
  String get mrStability => 'استقرار المنزل';

  @override
  String get mrClarity => 'الوضوح';

  @override
  String get mrChipHarmony => 'رابطة منسجمة';

  @override
  String get mrChipNoMangal => 'لا يوجد Mangal Dosh';

  @override
  String get mrChipLongLasting => 'طويلة الأمد';

  @override
  String get mrChipHome => 'امتلاك منزل محتمل';

  @override
  String get mrChipInLaws => 'علاقة جيدة مع الأصهار';

  @override
  String get mrChipChildren => 'مبارك بالأطفال';

  @override
  String get mrSpouse => 'زوجك/زوجتك المستقبلية';

  @override
  String get mrSpouseSub => 'ما يشير إليه المخطط';

  @override
  String get mrSpouseTraits => 'الشخصية المحتملة';

  @override
  String get mrSpouseWork => 'المهنة المحتملة';

  @override
  String get mrAgeDiff => 'فرق العمر';

  @override
  String get mrCulture => 'التوافق الثقافي';

  @override
  String get mrEducation => 'التعليم';

  @override
  String get mrFamilyBg => 'الخلفية الأسرية';

  @override
  String get mrSoulPartnership => 'الروح والشراكة';

  @override
  String get mrSelfPlanet => 'أنت في الرابطة';

  @override
  String get mrSpousePlanet => 'كوكب زوجك/زوجتك';

  @override
  String get mrSoulAlignment => 'توافق الروح';

  @override
  String get mrAlignStrong =>
      'روحك وشريكك المثالي متوافقان بقوة — رابطة عميقة ومُرضية مدعومة جيدًا.';

  @override
  String get mrAlignModerate =>
      'روحك وشريكك المثالي متوافقان بشكل معتدل — تنمو الرابطة المُرضية بجهد واعٍ.';

  @override
  String get mrAlignLow =>
      'تحتاج روحك وشراكتك إلى تكامل واعٍ — اختر شريكًا يتوافق فعلًا مع قيمك الداخلية.';

  @override
  String get mrTechDarakaraka => 'كوكب الزوج/الزوجة (Darakaraka)';

  @override
  String get mrUpapada => 'نقطة الزواج (Upapada)';

  @override
  String get mrUpapadaLord => 'حاكم Upapada';

  @override
  String get mrFoundation => 'أساس الزواج';

  @override
  String get mrMarriageSign => 'برج الزواج';

  @override
  String get mrMarriageLord => 'حاكم الزواج';

  @override
  String get mrHouseStrength => 'قوة البيت';

  @override
  String get mrPartnerHint => 'تلميح عن الشريك من مخططك';

  @override
  String get mrHarmonyHdr => 'انسجام التوافق';

  @override
  String get mrHarmonySub => 'كيف ستتواصلان';

  @override
  String get mrEmotional => 'العاطفي';

  @override
  String get mrIntellectual => 'الفكري';

  @override
  String get mrPhysical => 'الحميمية الجسدية';

  @override
  String get mrFinancial => 'المالي';

  @override
  String get mrCommunication => 'التواصل';

  @override
  String get mrSharedValues => 'القيم المشتركة';

  @override
  String get mrSpiritual => 'الروحي';

  @override
  String get mrConflictRes => 'حل الخلافات';

  @override
  String get mrTiming => 'توقيت الزواج';

  @override
  String get mrFirstMarriageAge => 'عمر الزواج المحتمل';

  @override
  String get mrDelayChance => 'احتمال التأخير';

  @override
  String get mrMarriageWindow => 'نافذة الزواج';

  @override
  String get mrSecondaryWindow => 'نافذة بديلة';

  @override
  String get mrCurrentReadiness => 'الآن';

  @override
  String get mrJourney => 'مسيرة الزواج';

  @override
  String get mrJourneySub => 'كيف تتطور الرابطة';

  @override
  String get mrPhaseEarly => 'السنوات الأولى';

  @override
  String get mrPhaseMid => 'السنوات الوسطى';

  @override
  String get mrPhaseMature => 'سنوات النضج';

  @override
  String get mrPhaseLate => 'السنوات المتأخرة';

  @override
  String get mrTip => 'نصيحة';

  @override
  String get mrFamilyHome => 'الأسرة والمنزل';

  @override
  String get mrInLaws => 'علاقات الأصهار';

  @override
  String get mrFamilyHarmony => 'الانسجام الأسري';

  @override
  String get mrHomeOwnership => 'ملكية المنزل';

  @override
  String get mrDomesticPeace => 'السلام المنزلي';

  @override
  String get mrFertility => 'الخصوبة';

  @override
  String get mrParenting => 'انسجام التربية';

  @override
  String get mrChildren => 'الأطفال';

  @override
  String get mrLikelyCount => 'العدد المحتمل';

  @override
  String get mrVerification => 'التحقق عبر المخططات';

  @override
  String get mrD9 => 'مخطط الزواج (D9)';

  @override
  String get mrD10 => 'مخطط المسيرة المهنية والزوج (D10)';

  @override
  String get mrD60 => 'مخطط الكارما (D60)';

  @override
  String get mrChallenges => 'تحديات تستدعي المراقبة';

  @override
  String get mrMangalPresent =>
      'يوجد Mangal Dosh في المخطط — راجع العلاجات والتوافق بعناية.';

  @override
  String get mrMangalAbsent => 'لم يتم رصد Mangal Dosh — مؤشر داعم للزواج.';

  @override
  String get mrRiskConflict => 'النزاع';

  @override
  String get mrRiskSeparation => 'الانفصال';

  @override
  String get mrRiskDistance => 'المسافة العاطفية';

  @override
  String get mrRiskInfidelity => 'الخيانة الزوجية';

  @override
  String get mrRiskFinance => 'الخلافات المالية';

  @override
  String get mrPartnerGuide => 'دليل الشريك';

  @override
  String get mrPartnerGuideSub => 'ما الذي يجب البحث عنه';

  @override
  String get mrSeek => 'ابحث عن';

  @override
  String get mrMatchingPriorities => 'أولويات المطابقة';

  @override
  String get mrImprovementPlan => 'خطة التحسين';

  @override
  String get mrReliability => 'موثوقية التوقع';

  @override
  String get mrLayerBirth => 'مخطط الميلاد (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'الكارما (D60)';

  @override
  String get mrLayerDarakaraka => 'كوكب الزوج/الزوجة';

  @override
  String get mrTopicWhen => 'متى سأتزوج؟';

  @override
  String get mrTopicSpouse => 'عن زوجي/زوجتي';

  @override
  String get mrTopicCompat => 'نصائح التوافق';

  @override
  String get mrTopicDelay => 'تأخر الزواج';

  @override
  String get mrTopicMangal => 'Mangal Dosh';

  @override
  String get mrTopicChildren => 'توقيت الإنجاب';

  @override
  String get mrTopicInLaws => 'علاقات الأصهار';

  @override
  String get mrTopicHarmony => 'بناء الانسجام';

  @override
  String get wlSubtitle =>
      'تقرير الثروة المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get wlTitle => 'الثروة والمال';

  @override
  String get wlWealthPotential => 'إمكانية الثروة';

  @override
  String get wlAccumulation => 'التراكم';

  @override
  String get wlIncomeFlow => 'تدفق الدخل';

  @override
  String get wlRetention => 'الاحتفاظ';

  @override
  String get wlSustainability => 'الاستدامة';

  @override
  String get wlSavings => 'انضباط الادخار';

  @override
  String get wlChipSaver => 'مدخر بالفطرة';

  @override
  String get wlChipMultiIncome => 'مصادر دخل متعددة';

  @override
  String get wlChipStrongYogas => 'يوغات الثروة';

  @override
  String get wlChipLowDebt => 'ديون منخفضة';

  @override
  String get wlChipInheritance => 'ميراث محتمل';

  @override
  String get wlChipInvestor => 'مستثمر ذكي';

  @override
  String get wlWealthClass => 'فئة الثروة';

  @override
  String get wlWealthType => 'نوع الثروة الرئيسي';

  @override
  String get wlPrimarySource => 'الدخل الأساسي';

  @override
  String get wlPeakAge => 'عمر ذروة الثروة';

  @override
  String get wlBoosters => 'ما يعزز ثروتك';

  @override
  String get wlBoostersSub => 'تركيبات مالية قوية';

  @override
  String get wlWealthImpact => 'تعزيز';

  @override
  String get wlDrains => 'استنزافات الثروة';

  @override
  String get wlIncomeSources => 'مصادر الدخل';

  @override
  String get wlIncomeSourcesSub => 'من أين يأتي مالك';

  @override
  String get wlPrimary => 'أساسي';

  @override
  String get wlInvestment => 'خطة الاستثمار';

  @override
  String get wlInvestmentSub => 'مزيج الأصول المثالي';

  @override
  String get wlRiskAppetite => 'الرغبة في المخاطرة';

  @override
  String get wlInvestStyle => 'أسلوب الاستثمار';

  @override
  String get wlDrivenBy => 'مدفوع بـ';

  @override
  String get wlMoneyPersonality => 'شخصية التعامل مع المال';

  @override
  String get wlMoneyType => 'نوع المال';

  @override
  String get wlSpending => 'الإنفاق';

  @override
  String get wlSavingsDiscipline => 'انضباط الادخار';

  @override
  String get wlCharity => 'الميل نحو العطاء الخيري';

  @override
  String get wlLuxury => 'الإنفاق على الفخامة';

  @override
  String get wlWindfalls => 'المكاسب المفاجئة والفرص';

  @override
  String get wlWindfallsSub => 'المال القائم على الحظ';

  @override
  String get wlInheritanceChance => 'الميراث';

  @override
  String get wlSuddenGains => 'مكاسب مفاجئة';

  @override
  String get wlLottery => 'اليانصيب / المضاربة';

  @override
  String get wlInsurance => 'مطالبات التأمين';

  @override
  String get wlWindfallSource => 'المصدر المحتمل للمكسب المفاجئ';

  @override
  String get wlMoneyPlanets => 'كواكب المال لديك';

  @override
  String get wlPrimaryKaraka => 'كوكب المال الأساسي';

  @override
  String get wlSecondaryKaraka => 'كوكب المال الثانوي';

  @override
  String get wlTimeline => 'الجدول الزمني للثروة';

  @override
  String get wlPeakYears => 'سنوات الذروة';

  @override
  String get wlGoodPeriod => 'فترة الازدهار';

  @override
  String get wlSuddenGainWindow => 'نافذة المكسب المفاجئ';

  @override
  String get wlToughPeriod => 'فترة الحذر';

  @override
  String get wlDebtRisks => 'مخاطر الديون والمال';

  @override
  String get wlDebtChance => 'احتمالية الديون';

  @override
  String get wlLoanBurden => 'عبء القروض';

  @override
  String get wlDrainSources => 'انتبه لـ';

  @override
  String get wlStrengthen => 'ما يجب تعزيزه';

  @override
  String get wlWeakestDriver => 'أضعف محرك مالي';

  @override
  String get wlHowToFix => 'كيفية التعزيز';

  @override
  String get wlImprovementPlan => 'خطة التحسين';

  @override
  String get wlReliability => 'موثوقية التوقع';

  @override
  String get wlLayerBirth => 'بيوت الثروة (D1)';

  @override
  String get wlLayerHora => 'مخطط Hora (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'توقيت Dasha';

  @override
  String get wlLayerTransit => 'الانتقالات الحالية';

  @override
  String get wlTopicGrow => 'كيفية تنمية الثروة';

  @override
  String get wlTopicInvest => 'أين أستثمر';

  @override
  String get wlTopicDebt => 'إدارة الديون';

  @override
  String get wlTopicProperty => 'شراء ممتلكات';

  @override
  String get wlTopicRetire => 'التخطيط للتقاعد';

  @override
  String get wlTopicPassive => 'الدخل السلبي';

  @override
  String get wlTopicWindfall => 'المكاسب المفاجئة';

  @override
  String get wlTopicTiming => 'أفضل توقيت مالي';

  @override
  String get bzSubtitle =>
      'تقرير الأعمال المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get bzTitle => 'الأعمال والمشاريع الناشئة';

  @override
  String get bzBusinessPotential => 'إمكانية النجاح في الأعمال';

  @override
  String get bzEntrepreneurship => 'روح ريادية';

  @override
  String get bzVenture => 'نجاح المشروع';

  @override
  String get bzWealth => 'الثروة عبر الأعمال';

  @override
  String get bzRiskAppetite => 'الرغبة في المخاطرة';

  @override
  String get bzLongevity => 'الديمومة';

  @override
  String get bzChipWealthMagnet => 'جاذب للثروة';

  @override
  String get bzChipMoneyYoga => 'يوغا المال';

  @override
  String get bzChipLeadership => 'القيادة';

  @override
  String get bzChipPartnerFit => 'ملاءمة ممتازة للشراكة';

  @override
  String get bzChipGains => 'مكاسب قوية';

  @override
  String get bzChipInvestor => 'جاذبية للمستثمرين';

  @override
  String get bzChipFounder => 'عقلية المؤسس';

  @override
  String get bzWhatsWorking => 'ما يعمل لصالحك';

  @override
  String get bzWhatsWorkingSub => 'مواهبك في الأعمال';

  @override
  String get bzClassicYogas => 'تركيبات الثروة الكلاسيكية';

  @override
  String get bzFounderType => 'نوع المؤسس لديك';

  @override
  String get bzSoulBusiness => 'الروح وهدف الأعمال';

  @override
  String get bzSoulPlanet => 'محرك روحك';

  @override
  String get bzBusinessPlanet => 'عقلك التجاري';

  @override
  String get bzDirectionStrength => 'وضوح الاتجاه';

  @override
  String get bzAlignStrong =>
      'هدف روحك واتجاه أعمالك متوافقان بقوة — بناء مشروع يبدو طبيعيًا ومُرضيًا.';

  @override
  String get bzAlignModerate =>
      'هدف روحك واتجاه أعمالك متوافقان بشكل معتدل — يعمل المشروع بشكل أفضل عندما يعكس قيمك العميقة.';

  @override
  String get bzAlignLow =>
      'يحتاج هدف روحك واتجاه أعمالك إلى توافق واعٍ — اختر مشروعًا يتطابق فعلًا مع من أنت.';

  @override
  String get bzTechAtmakaraka => 'كوكب الروح (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'كوكب الأعمال (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'كوكب الشريك (Darakaraka)';

  @override
  String get bzFoundation => 'أساس الأعمال';

  @override
  String get bzCareerHouse => 'بيت المسيرة المهنية';

  @override
  String get bzGainsHouse => 'بيت المكاسب';

  @override
  String get bzLord => 'الحاكم';

  @override
  String get bzGainsPotential => 'إمكانية المكاسب';

  @override
  String get bzNetwork => 'قوة الشبكة';

  @override
  String get bzRecovery => 'قوة التعافي';

  @override
  String get bzVerification => 'التحقق عبر المخططات';

  @override
  String get bzD10 => 'مخطط المسيرة المهنية (D10)';

  @override
  String get bzD11 => 'مخطط المكاسب (D11)';

  @override
  String get bzD9 => 'مخطط الهدف (D9)';

  @override
  String get bzD60 => 'مخطط الكارما (D60)';

  @override
  String get bzFounderSkills => 'مهارات المؤسس';

  @override
  String get bzSkillStrategy => 'التفكير الاستراتيجي';

  @override
  String get bzSkillExecution => 'التنفيذ';

  @override
  String get bzSkillPeople => 'إدارة الأفراد';

  @override
  String get bzSkillSales => 'المبيعات والإقناع';

  @override
  String get bzSkillFinance => 'الحس المالي';

  @override
  String get bzSkillOps => 'الانضباط التشغيلي';

  @override
  String get bzTopSkill => 'أبرز مهارة';

  @override
  String get bzDomains => 'أفضل مجالات الأعمال';

  @override
  String get bzDomainsSub => 'مرتبة حسب الملاءمة الطبيعية';

  @override
  String get bzFit => 'الملاءمة';

  @override
  String get bzBusinessStyleHdr => 'أسلوب العمل';

  @override
  String get bzStyleService => 'منتج مقابل خدمة';

  @override
  String get bzStyleMarket => 'تركيز السوق';

  @override
  String get bzStyleTech => 'النهج التقني';

  @override
  String get bzStyleLeadership => 'أسلوب القيادة';

  @override
  String get bzStylePartnership => 'منفرد أم شراكة';

  @override
  String get bzWhereBuild => 'المدى';

  @override
  String get bzExpansion => 'التوسع';

  @override
  String get bzSetup => 'الإعداد';

  @override
  String get bzPartnership => 'الشراكة والفريق';

  @override
  String get bzIdealCofounder => 'الشريك المؤسس المثالي';

  @override
  String get bzPartnerViability => 'ملاءمة الشراكة';

  @override
  String get bzTeamBuilding => 'بناء الفريق';

  @override
  String get bzCofounderFit => 'ملاءمة الشريك المؤسس';

  @override
  String get bzAdvisorNetwork => 'شبكة المستشارين';

  @override
  String get bzFunding => 'التمويل والمال';

  @override
  String get bzRecommendedPath => 'مسار التمويل الموصى به';

  @override
  String get bzInvestorAttract => 'جاذبية المستثمرين';

  @override
  String get bzFamilyBacking => 'دعم الأسرة';

  @override
  String get bzHybridViability => 'مزيج الوظيفة والعمل الحر';

  @override
  String get bzFallback => 'الوظيفة كخطة احتياطية';

  @override
  String get bzDebtStyle => 'أسلوب الديون';

  @override
  String get bzTimeline => 'الجدول الزمني للأعمال';

  @override
  String get bzCurrentPhase => 'الآن';

  @override
  String get bzLaunchWindow => 'نافذة الإطلاق';

  @override
  String get bzScaleWindow => 'نافذة النمو';

  @override
  String get bzPeakAge => 'سنوات الذروة';

  @override
  String get bzChallenges => 'تحديات تستدعي المراقبة';

  @override
  String get bzRiskFinancial => 'الخسارة المالية';

  @override
  String get bzRiskBurnout => 'الإرهاق';

  @override
  String get bzRiskTeam => 'نزاع الفريق';

  @override
  String get bzRiskLegal => 'قانوني / تنظيمي';

  @override
  String get bzFinancialExp =>
      'خطر خسارة المال بسبب الإفراط في الاستثمار أو سوء توقيت التدفق النقدي أثناء المشروع.';

  @override
  String get bzFinancialFix =>
      'احتفظ باحتياطي نقدي، ابدأ بحجم صغير، وتحقق من الطلب قبل زيادة الإنفاق.';

  @override
  String get bzBurnoutExp =>
      'الاندفاع بشدة لفترة طويلة قد يستنزف طاقتك وتركيزك.';

  @override
  String get bzBurnoutFix =>
      'احمِ وقت راحتك، فوّض المهام مبكرًا، ونظّم الدفعات الكبيرة حول الفترات الداعمة.';

  @override
  String get bzTeamExp =>
      'الاحتكاك مع الشركاء المؤسسين أو الموظفين قد يبطئ العمل.';

  @override
  String get bzTeamFix =>
      'حدّد الأدوار والتوقعات كتابيًا بوضوح، وتواصل بانتظام.';

  @override
  String get bzLegalExp =>
      'قد تخلق قضايا الامتثال أو العقود أو التنظيمات عقبات.';

  @override
  String get bzLegalFix =>
      'راجع العقود، حافظ على تنظيم الأوراق، واستشر المختصين مبكرًا.';

  @override
  String get bzImprovementPlan => 'خطة التحسين';

  @override
  String get bzBestDirection => 'أفضل اتجاه';

  @override
  String get bzStrategy => 'استراتيجية البناء';

  @override
  String get bzTopFields => 'أبرز المجالات';

  @override
  String get bzEmploymentPath => 'الوظيفة مقابل العمل الحر';

  @override
  String get bzRoadmap => 'خارطة طريق النمو';

  @override
  String get bzRoadmapSub => 'خطة مشروعك';

  @override
  String get bzReliability => 'موثوقية التوقع';

  @override
  String get bzLayerBirth => 'مخطط الميلاد (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'المسيرة المهنية (D10)';

  @override
  String get bzLayerLabhamsa => 'المكاسب (D11)';

  @override
  String get bzLayerShashtiamsa => 'الكارما (D60)';

  @override
  String get bzTopicStart => 'هل يجب أن أبدأ الآن؟';

  @override
  String get bzTopicIdea => 'أفضل فكرة تجارية';

  @override
  String get bzTopicPartner => 'إيجاد شريك مؤسس';

  @override
  String get bzTopicFunding => 'كيفية تمويل المشروع';

  @override
  String get bzTopicScale => 'متى أتوسع';

  @override
  String get bzTopicRisk => 'إدارة المخاطر';

  @override
  String get bzTopicJob => 'الوظيفة مقابل العمل الحر';

  @override
  String get bzTopicTiming => 'أفضل توقيت';

  @override
  String get crTitle => 'تحليل المسيرة المهنية والوظيفة';

  @override
  String get crSubtitle =>
      'تقرير المسيرة المهنية المدعوم بالذكاء الاصطناعي وفق علم التنجيم الفيدي';

  @override
  String get crCrumbHome => 'الرئيسية';

  @override
  String get crCrumbReports => 'التقارير';

  @override
  String get crCareerPotential => 'إمكانية المسيرة المهنية';

  @override
  String get crStatusStrong => 'إمكانية قوية';

  @override
  String get crStatusGood => 'إمكانية جيدة';

  @override
  String get crStatusModerate => 'إمكانية متوسطة';

  @override
  String get crStatusDeveloping => 'إمكانية قيد التطور';

  @override
  String get crStatusChallenging => 'مرحلة صعبة';

  @override
  String get crOverallCareer => 'المسيرة المهنية العامة';

  @override
  String get crStability => 'استقرار المسيرة المهنية';

  @override
  String get crGrowth => 'إمكانية النمو';

  @override
  String get crRecognition => 'التقدير';

  @override
  String get crSatisfaction => 'الرضا';

  @override
  String get crChipLeadership => 'القيادة';

  @override
  String get crChipCreativity => 'الإبداع';

  @override
  String get crChipBusiness => 'الأعمال';

  @override
  String get crChipStableIncome => 'دخل مستقر';

  @override
  String get crChipLearning => 'التعلم';

  @override
  String get crChipGrowth => 'نمو طويل الأمد';

  @override
  String get crChipTechnical => 'مهارة تقنية';

  @override
  String get crChipRecognition => 'التقدير';

  @override
  String get crTopInsights => 'أبرز الرؤى';

  @override
  String get crWhatDefines => 'ما الذي يحدد مسيرتك المهنية؟';

  @override
  String get crSoulCareer => 'الروح وهدف المسيرة المهنية';

  @override
  String get crSoulPlanet => 'كوكب هدف الروح';

  @override
  String get crCareerPlanet => 'كوكب المسيرة المهنية';

  @override
  String get crMeaning => 'المعنى';

  @override
  String get crAlignment => 'توافق الروح والمسيرة المهنية';

  @override
  String get crAlignStrong => 'اهتماماتك الطبيعية ومسارك المهني متوافقان بقوة.';

  @override
  String get crAlignModerate =>
      'اهتماماتك الطبيعية ومسارك المهني متوافقان بشكل معتدل.';

  @override
  String get crAlignLow =>
      'تحتاج اهتماماتك الطبيعية ومسارك المهني إلى توافق واعٍ.';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (مؤشر الروح)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (مؤشر المسيرة المهنية)';

  @override
  String get crDegrees => 'الدرجات';

  @override
  String get crDignity => 'المنزلة';

  @override
  String get crFoundation => 'أساس المسيرة المهنية';

  @override
  String get crCareerSign => 'برج المسيرة المهنية';

  @override
  String get crCareerLord => 'حاكم المسيرة المهنية';

  @override
  String get crLordPosition => 'موضع الحاكم';

  @override
  String get crCareerStrength => 'قوة المسيرة المهنية';

  @override
  String get crProfStyle => 'الأسلوب المهني';

  @override
  String get crBestFields => 'أفضل المجالات';

  @override
  String get crTechnicalDetails => 'التفاصيل التقنية';

  @override
  String get crHouseLabel => 'البيت';

  @override
  String get crVerification => 'التحقق من المسيرة المهنية عبر المخططات';

  @override
  String get crD10Career => 'D10 · المسيرة المهنية';

  @override
  String get crD9Purpose => 'D9 · الهدف';

  @override
  String get crD60Karma => 'D60 · الكارما';

  @override
  String get crStatusNeedsImprovement => 'يحتاج إلى تحسين';

  @override
  String get crStatusWellAligned => 'متوافق جيدًا';

  @override
  String get crStatusStrongSupport => 'دعم قوي';

  @override
  String get crStatusModerateSupport => 'دعم متوسط';

  @override
  String get crChartDetails => 'تفاصيل المخطط التقنية';

  @override
  String get crPersonality => 'شخصيتك المهنية';

  @override
  String get crGrowthAreas => 'مجالات النمو';

  @override
  String get crBestRoles => 'أفضل الأدوار';

  @override
  String get crBestIndustries => 'أفضل الصناعات';

  @override
  String get crEnvironment => 'بيئة العمل';

  @override
  String get crWorkStyle => 'أفضل أسلوب عمل';

  @override
  String get crEmployment => 'التوظيف';

  @override
  String get crBusiness => 'الأعمال الحرة';

  @override
  String get crFreelance => 'العمل الحر / الاستشارات';

  @override
  String get crPortfolio => 'محفظة مختلطة';

  @override
  String get crLeadership => 'القيادة';

  @override
  String get crFit => 'الملاءمة';

  @override
  String get crBestFit => 'أفضل ملاءمة';

  @override
  String get crTimeline => 'الجدول الزمني للمسيرة المهنية';

  @override
  String get crPastPeak => 'ذروة سابقة';

  @override
  String get crPresentPhase => 'المرحلة الحالية';

  @override
  String get crUpcoming => 'فرصة قادمة';

  @override
  String get crFutureExpansion => 'توسع مستقبلي';

  @override
  String get crRiskPeriod => 'فترة خطر';

  @override
  String get crViewDasha => 'الفترة الكوكبية (تقني)';

  @override
  String get crChallenges => 'تحديات تستدعي المراقبة';

  @override
  String get crRiskBurnout => 'الإرهاق';

  @override
  String get crRiskRecognition => 'تأخر التقدير';

  @override
  String get crRiskConflict => 'نزاع في مكان العمل';

  @override
  String get crRiskFinancial => 'عدم الاستقرار المالي';

  @override
  String get crRiskOverqual => 'عدم الاستغلال الكامل للقدرات';

  @override
  String get crPrevention => 'الوقاية';

  @override
  String get crBurnoutExp =>
      'قد تستنزف المراحل الطويلة والمرهقة طاقتك مع مرور الوقت.';

  @override
  String get crBurnoutFix =>
      'احمِ وقت راحتك، وضع حدودًا، ونظّم الدفعات الكبيرة.';

  @override
  String get crRecognitionExp => 'قد تصل المكافآت والتقدير أبطأ من جهدك.';

  @override
  String get crRecognitionFix =>
      'وثّق إنجازاتك واجعل مساهماتك واضحة أمام الإدارة.';

  @override
  String get crConflictExp => 'قد يظهر أحيانًا احتكاك مع الزملاء أو السلطة.';

  @override
  String get crConflictFix => 'تواصل بهدوء واختر معاركك بحكمة.';

  @override
  String get crFinancialExp => 'قد يشعر الدخل بعدم الانتظام خلال مراحل معينة.';

  @override
  String get crFinancialFix =>
      'احتفظ باحتياطي وتجنب الالتزامات المالية الزائدة.';

  @override
  String get crOverqualExp =>
      'قد تشعر أحيانًا بعدم الاستغلال الكافي أو نقص التحدي.';

  @override
  String get crOverqualFix =>
      'ابحث عن أدوار تتحدى قدراتك واستمر في التعلم لتبقى متحفزًا.';

  @override
  String get crImprovementPlan => 'خطة تحسين المسيرة المهنية';

  @override
  String get crCatPlanetary => 'كوكبي وروحي';

  @override
  String get crCatPractical => 'خطوات عملية';

  @override
  String get crTraditionalExplain => 'الشرح التنجيمي التقليدي';

  @override
  String get crActionPlan => 'خطة عمل مهنية لمدة 30 يومًا';

  @override
  String get crWeek1 => 'الأسبوع 1 · تحسين الملف الشخصي';

  @override
  String get crWeek2 => 'الأسبوع 2 · بناء المهارات';

  @override
  String get crWeek3 => 'الأسبوع 3 · التواصل المهني';

  @override
  String get crWeek4 => 'الأسبوع 4 · إبراز حضورك المهني';

  @override
  String get crWeek1Tip =>
      'حدّث سيرتك الذاتية وملفك على LinkedIn حول أقوى محور في مسيرتك المهنية.';

  @override
  String get crWeek2Tip =>
      'اختر مهارة عالية القيمة في أفضل مجالاتك ومارسها يوميًا.';

  @override
  String get crWeek3Tip =>
      'أعد التواصل مع الموجّهين وتواصل مع شخصين جديدين في مجالك.';

  @override
  String get crWeek4Tip => 'شارك عملك علنًا وتطوع في مشروع بارز.';

  @override
  String get crPriority => 'الأولوية';

  @override
  String get crTimeRequired => 'الوقت';

  @override
  String get crExpectedBenefit => 'الفائدة';

  @override
  String get crPriorityHigh => 'عالية';

  @override
  String get crPriorityMedium => 'متوسطة';

  @override
  String get crRoadmap => 'خارطة طريق مهنية بالذكاء الاصطناعي';

  @override
  String get crNext12 => 'الـ 12 شهرًا القادمة';

  @override
  String get crBestFocus => 'أفضل تركيز';

  @override
  String get crSkillsLearn => 'مهارات لتعلمها';

  @override
  String get crIndustriesTarget => 'صناعات مستهدفة';

  @override
  String get crExpectedOutcome => 'النتيجة المتوقعة';

  @override
  String get crReliability => 'موثوقية التوقع';

  @override
  String get crReliabilityHigh => 'موثوقية عالية';

  @override
  String get crReliabilityGood => 'موثوقية جيدة';

  @override
  String get crReliabilityModerate => 'موثوقية متوسطة';

  @override
  String get crReliabilityExplain =>
      'يجمع هذا التقرير بين مخطط ميلادك والمخططات التقسيمية ومؤشرات Jaimini. تعكس الدرجة مدى اتفاق هذه الطبقات مع بعضها.';

  @override
  String get crChartLayers => 'طبقات المخطط وأوزانها';

  @override
  String get crBirthChart => 'مخطط الميلاد (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'ناقش مع الذكاء الاصطناعي';

  @override
  String get crAskAbout => 'اسأل عن';

  @override
  String get crTopicChange => 'تغيير المسيرة المهنية';

  @override
  String get crTopicGovt => 'وظيفة حكومية';

  @override
  String get crTopicBusiness => 'الأعمال';

  @override
  String get crTopicPromotion => 'الترقية';

  @override
  String get crTopicMarriage => 'الزواج مقابل المسيرة المهنية';

  @override
  String get crTopicAbroad => 'الخارج';

  @override
  String get crTopicIncome => 'الدخل';

  @override
  String get crTopicPurpose => 'الهدف';

  @override
  String get crTopicResume => 'السيرة الذاتية';

  @override
  String get crTopicCopied =>
      'تم نسخ السؤال — الصقه في محادثة الذكاء الاصطناعي.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return 'يوجّه $soul دعوتك الداخلية، بينما يشكّل $career مهنتك الظاهرة.';
  }

  @override
  String get rzTodayOutlook => 'توقعات الأبراج لهذا اليوم';

  @override
  String get rzPlanetaryEnergy => 'طاقة الكواكب اليوم';

  @override
  String get rzBestSign => 'أفضل برج';

  @override
  String get rzChallengingSign => 'الأكثر تحديًا';

  @override
  String get rzDominantPlanet => 'الكوكب المهيمن';

  @override
  String get rzOverallMood => 'المزاج العام';

  @override
  String get rzMoodBright => 'مشرق ونشط';

  @override
  String get rzMoodCalm => 'هادئ وثابت';

  @override
  String get rzMoodMixed => 'طاقة متباينة';

  @override
  String get rzMoodTense => 'متوتر ويتطلب الحذر';

  @override
  String get rzTodayEnergy => 'طاقة اليوم';

  @override
  String get rzCaution => 'تحذير';

  @override
  String get rzWeak => 'ضعيف';

  @override
  String get rzAllSigns => 'جميع الأبراج';

  @override
  String get rzAiSummary => 'ملخص الذكاء الاصطناعي';

  @override
  String get rzPlanetaryInfluence => 'تأثير الكواكب اليوم';

  @override
  String get rzStrongInfluences => 'تأثيرات قوية';

  @override
  String get rzShowTechnical => 'عرض التفاصيل التقنية';

  @override
  String get rzOpportunities => 'فرص اليوم';

  @override
  String get rzAvoidTitle => 'أمور يجب تجنبها اليوم';

  @override
  String get rzTechnicalReason => 'السبب التقني';

  @override
  String get rzAvoidDecisions => 'التسرع في القرارات المهمة';

  @override
  String get rzAvoidArguments => 'الجدالات الحادة';

  @override
  String get rzAvoidInvestments => 'الاستثمارات الكبيرة';

  @override
  String get rzAvoidOverthink => 'الإفراط في التفكير بأمور بسيطة';

  @override
  String get rzAvoidOverspend => 'الإنفاق غير الضروري';

  @override
  String get rzAvoidStress => 'التوتر والإفراط في العمل';

  @override
  String get rzPlanetaryChart => 'مخطط الكواكب اليوم';

  @override
  String get rzWhatChartMeans => 'ماذا يعني هذا المخطط';

  @override
  String get rzChartExplain =>
      'يوضح هذا المخطط الماسي موضع كل كوكب في السماء اليوم، مُسقطًا على برجك. الكواكب في البيوت الداعمة ترفع من طاقة اليوم؛ أما تلك في البيوت الصعبة فتتطلب عناية.';

  @override
  String get rzDoNetworking => 'التواصل وبناء العلاقات';

  @override
  String get rzDoLearning => 'تعلّم شيء جديد';

  @override
  String get rzDoMeditation => 'التأمل والهدوء';

  @override
  String get rzDoFamily => 'وقت مع الأسرة';

  @override
  String get rzDoCreative => 'العمل الإبداعي';

  @override
  String get rzDoRest => 'الراحة والعناية بالذات';

  @override
  String get rzAiRecommendations => 'توصيات الذكاء الاصطناعي لليوم';

  @override
  String get rzTechnical => 'التنجيم التقني';

  @override
  String get rzTransitScore => 'درجة الانتقال';

  @override
  String get rzVedha => 'Vedha (العوائق)';

  @override
  String get rzGocharDetails => 'تفاصيل Gochar';

  @override
  String get rzAdvancedOnly => 'للمستخدمين المتقدمين';

  @override
  String get rzTomorrow => 'معاينة الغد';

  @override
  String get rzTomorrowEnergy => 'طاقة الغد';

  @override
  String get rzImproving => 'في تحسن';

  @override
  String get rzWeaker => 'أضعف قليلاً';

  @override
  String get rzSteady => 'ثابتة';

  @override
  String get rzTomorrowUpLine =>
      'من المتوقع أن ترتفع الطاقة غدًا — خطط مسبقًا للمهام المهمة.';

  @override
  String get rzTomorrowDownLine =>
      'قد تنخفض الطاقة قليلاً غدًا — اجعل اليوم خفيفًا وثابتًا.';

  @override
  String get rzTomorrowFlatLine =>
      'تبقى الطاقة ثابتة غدًا — يوم هادئ ومتوازن ينتظرك.';

  @override
  String get rzWeeklyTrend => 'الاتجاه الأسبوعي';

  @override
  String get rzMonthlyTrend => 'الاتجاه الشهري';

  @override
  String get rzBestDayWeek => 'أفضل يوم';

  @override
  String get rzHardestDay => 'أصعب يوم';

  @override
  String get rzLuckyToday => 'المحظوظ اليوم';

  @override
  String get rzKarakaSun => 'الثقة والحيوية';

  @override
  String get rzKarakaMoon => 'العواطف وراحة البال';

  @override
  String get rzKarakaMars => 'الطاقة والدافع';

  @override
  String get rzKarakaMercury => 'التواصل والتعلم';

  @override
  String get rzKarakaJupiter => 'الحكمة والنمو';

  @override
  String get rzKarakaVenus => 'العلاقات والراحة';

  @override
  String get rzKarakaSaturn => 'الانضباط والصبر';

  @override
  String get rzKarakaRahu => 'الطموح والتغيير';

  @override
  String get rzKarakaKetu => 'الروحانية والتخلي';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return 'يحدد $dom طابع اليوم، بينما يتطلب $chal الصبر والعناية.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'يوم جيد لـ $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'تمهّل مع $karaka اليوم.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka مدعوم جيدًا اليوم.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return 'قد يواجه $karaka تأخيرات اليوم.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'يدعم اليوم $strong، بينما يحتاج $weak إلى الصبر والعناية.';
  }

  @override
  String get fdEnergyScore => 'درجة طاقة اليوم';

  @override
  String get fdStatusAverage => 'متوسط';

  @override
  String get fdStatusMixed => 'متباين';

  @override
  String get fdStatusChallenging => 'صعب';

  @override
  String get fdTheme => 'موضوع اليوم';

  @override
  String get fdExplainToday => 'اشرح اليوم';

  @override
  String get fdTodaysFocus => 'تركيز اليوم';

  @override
  String get fdTopRecommendation => 'أبرز توصية';

  @override
  String get fdTopCaution => 'أبرز تحذير';

  @override
  String get fdReadingTime => 'مدة القراءة';

  @override
  String get fdSeconds30 => '30 ثانية';

  @override
  String get fdCareer => 'المسيرة المهنية';

  @override
  String get fdMoney => 'المال';

  @override
  String get fdLove => 'الحب';

  @override
  String get fdHealth => 'الصحة';

  @override
  String get fdTravel => 'السفر';

  @override
  String get fdFamily => 'الأسرة';

  @override
  String get fdBestToDo => 'أفضل الأمور للقيام بها اليوم';

  @override
  String get fdAvoidToday => 'تجنّب اليوم';

  @override
  String get fdConfidenceLabel => 'درجة الثقة';

  @override
  String get fdBestTime => 'أفضل وقت';

  @override
  String get fdRecommended => 'موصى به';

  @override
  String get fdReason => 'السبب';

  @override
  String get fdRisk => 'الخطر';

  @override
  String get fdRecommendation => 'التوصية';

  @override
  String get fdNoActions =>
      'لا شيء مهم للتركيز عليه اليوم — حافظ على روتين ثابت وهادئ.';

  @override
  String get fdNoCautions => 'لا توجد تحذيرات كبيرة اليوم — تابع بوعي طبيعي.';

  @override
  String get fdHighlights => 'أبرز أحداث اليوم';

  @override
  String get fdProbVeryHigh => 'عالية جدًا';

  @override
  String get fdProbHigh => 'عالية';

  @override
  String get fdProbElevated => 'مرتفعة';

  @override
  String get fdProbCaution => 'تحذير';

  @override
  String get fdWhatToDo => 'ما يجب فعله';

  @override
  String get fdLifeAreas => 'مجالات الحياة';

  @override
  String get fdTapDetails => 'اضغط للتفاصيل';

  @override
  String get fdArea1 => 'الذات والصحة';

  @override
  String get fdArea2 => 'الثروة والأسرة';

  @override
  String get fdArea3 => 'التواصل';

  @override
  String get fdArea4 => 'المنزل والراحة';

  @override
  String get fdArea5 => 'الإبداع والرومانسية';

  @override
  String get fdArea6 => 'العمل والواجبات';

  @override
  String get fdArea7 => 'العلاقات';

  @override
  String get fdArea8 => 'التغيير والعمق';

  @override
  String get fdArea9 => 'الحظ والسفر';

  @override
  String get fdArea10 => 'المسيرة المهنية والمكانة';

  @override
  String get fdArea11 => 'المكاسب والشبكة';

  @override
  String get fdArea12 => 'الراحة والروحانية';

  @override
  String get fdTodaysMeaning => 'معنى اليوم';

  @override
  String get fdGoodFor => 'جيد لـ';

  @override
  String get fdAvoid => 'تجنّب';

  @override
  String get fdPlanetSupport => 'دعم الكوكب';

  @override
  String get fdWhyPrediction => 'لماذا هذا التوقع؟';

  @override
  String get fdAdvancedDetails => 'تفاصيل متقدمة';

  @override
  String get fdAiRecommendation => 'توصية الذكاء الاصطناعي';

  @override
  String get fdOverallStatus => 'الحالة العامة';

  @override
  String get fdNoPlanetTransit => 'لا يوجد كوكب رئيسي يعبر هذا المجال اليوم.';

  @override
  String get fdFinancialOutlook => 'التوقعات المالية';

  @override
  String get fdIncomeProbability => 'احتمالية الدخل';

  @override
  String get fdExpenseProbability => 'احتمالية المصروفات';

  @override
  String get fdNetBalance => 'الرصيد المالي الصافي';

  @override
  String get fdAvoidSpending => 'تجنب الإنفاق';

  @override
  String get fdRelationshipOutlook => 'توقعات العلاقات';

  @override
  String get fdOverallScore => 'الدرجة العامة';

  @override
  String get fdPartner => 'الشريك';

  @override
  String get fdRomance => 'الرومانسية';

  @override
  String get fdWorkplace => 'مكان العمل';

  @override
  String get fdPublicImage => 'الصورة العامة';

  @override
  String get fdBestActivity => 'أفضل نشاط';

  @override
  String get fdWeakArea => 'مجال ضعيف';

  @override
  String get fdBiggestOpportunity => 'أكبر فرصة';

  @override
  String get fdBiggestRisk => 'أكبر خطر';

  @override
  String get fdProbability => 'الاحتمالية';

  @override
  String get fdProtection => 'نصيحة الحماية';

  @override
  String get fdDescription => 'الوصف';

  @override
  String get fdBestTimeToday => 'أفضل وقت اليوم';

  @override
  String get fdAvoidDuring => 'تجنّب خلال';

  @override
  String get fdPredictionConfidence => 'درجة الثقة في التوقع';

  @override
  String get fdConfBasis => 'يجمع توقع اليوم بين';

  @override
  String get fdConfNatal => 'مخطط الميلاد';

  @override
  String get fdConfTransit => 'الانتقال الحالي';

  @override
  String get fdConfDasha => 'الفترات الكوكبية';

  @override
  String get fdConfStrength => 'قوة الكوكب';

  @override
  String get fdConfHouse => 'تفعيل البيت';

  @override
  String get fdAskAi => 'اسأل الذكاء الاصطناعي';

  @override
  String get fdAskAiSub => 'اضغط على سؤال للحصول على إجابة اليوم';

  @override
  String get fdQ1 => 'لماذا المسيرة المهنية بطيئة اليوم؟';

  @override
  String get fdQ2 => 'ما أفضل وقت اليوم؟';

  @override
  String get fdQ3 => 'هل اليوم جيد للأمور المالية؟';

  @override
  String get fdQ4 => 'هل اليوم جيد للسفر؟';

  @override
  String get fdQ5 => 'ما الذي يجب أن أتجنبه اليوم؟';

  @override
  String get fdMoreSuggestions => 'المزيد من الاقتراحات';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'اليوم مناسب أكثر لـ $top. قد يبدو $weak بطيئًا، لذا تجنب القرارات المهمة فيه. ماليًا يبدو اليوم $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'تتجمع طاقتك اليوم حول $top — ركّز عليه وتعامل بلطف مع باقي المجالات.';
  }

  @override
  String get gochToday => 'اليوم';

  @override
  String get gochOverallScore => 'درجة الانتقال العامة';

  @override
  String get gochNeutral => 'محايد';

  @override
  String get gochChallenging => 'صعب';

  @override
  String get gochTopPositive => 'أبرز إيجابي';

  @override
  String get gochTopChallenges => 'أبرز التحديات';

  @override
  String get gochFilterAll => 'الكل';

  @override
  String get gochFavorability => 'الملاءمة';

  @override
  String get gochAlerts => 'تنبيهات الانتقال';

  @override
  String get gochAlertCritical => 'حرج';

  @override
  String get gochAlertWarning => 'تحذير';

  @override
  String get gochAlertOpportunity => 'فرصة';

  @override
  String get gochAiFocus => 'تركيز الذكاء الاصطناعي اليوم';

  @override
  String get gochLifeScores => 'درجات مجالات الحياة';

  @override
  String get gochWhy => 'لماذا؟';

  @override
  String get gochCurrentTransits => 'الانتقالات النشطة';

  @override
  String get gochDailyPlan => 'خطتك اليومية';

  @override
  String get gochMorning => 'الصباح';

  @override
  String get gochAfternoon => 'بعد الظهر';

  @override
  String get gochEvening => 'المساء';

  @override
  String get gochNight => 'الليل';

  @override
  String get gochSmartReco => 'توصيات ذكية';

  @override
  String get gochExplain => 'اشرح انتقال اليوم';

  @override
  String get gochDo => 'افعل';

  @override
  String get gochDont => 'تجنّب';

  @override
  String get gochDoWork => 'تعامل مع الأعمال المهمة';

  @override
  String get gochDoMeditate => 'تأمل وتفكّر';

  @override
  String get gochDoStart => 'ابدأ خططًا جديدة';

  @override
  String get gochDoFinish => 'أنهِ المهام المعلقة';

  @override
  String get gochDontArgue => 'تجنّب الجدالات';

  @override
  String get gochDontImpulsive => 'تجنّب القرارات المتسرعة';

  @override
  String get gochDontOverspend => 'تجنّب الإنفاق الزائد';

  @override
  String gochThemeGrowth(Object area) {
    return 'يوم نمو في $area — انطلق فيه.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'تحلَّ بالصبر مع $area اليوم — تقدّم بثبات.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area مدعوم جيدًا الآن.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area يحتاج إلى عناية إضافية اليوم.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'ركّز طاقتك على $a1 اليوم، وتعامل بلطف مع $a2.';
  }

  @override
  String get divBeginner => 'مبتدئ';

  @override
  String get divSearchHint => 'ابحث: المسيرة المهنية، الزواج، التعليم…';

  @override
  String get divSummaryTitle => 'ملخص المخططات التقسيمية';

  @override
  String get divTotalCharts => 'إجمالي المخططات';

  @override
  String get divMostImportant => 'الأكثر أهمية';

  @override
  String get divRecommendedForYou => 'موصى به لك';

  @override
  String get divCatEssential => 'المخططات الأساسية';

  @override
  String get divCatPersonal => 'الحياة الشخصية';

  @override
  String get divCatKnowledge => 'مخططات المعرفة';

  @override
  String get divCatAdvanced => 'المخططات المتقدمة';

  @override
  String get divGoalProperty => 'الممتلكات';

  @override
  String get divGoalKarma => 'الكارما';

  @override
  String get divBadgeHighlyRec => 'موصى به بشدة';

  @override
  String get divBadgeRec => 'موصى به';

  @override
  String get divBadgeUseful => 'مفيد';

  @override
  String get divBadgeOptional => 'اختياري';

  @override
  String get divBadgeAdvOnly => 'للمتقدمين فقط';

  @override
  String get divRecommendBest => 'التوصية بأفضل المخططات';

  @override
  String get divNoMatch => 'لا توجد مخططات مطابقة لبحثك';

  @override
  String get divLifeAreas => 'مجالات الحياة';

  @override
  String divAiUse(Object purpose) {
    return 'استخدم هذا المخطط لتحليل $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'مخططا $c1 و$c2 مهمان بشكل خاص — ابدأ بهما للمجالات التي يغطيانها، ثم استكشف الباقي حسب الحاجة.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'يحتاج بيتك $house إلى دراسة أعمق — يوضح هذا المخطط ذلك بتفصيل.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet كوكب رئيسي لكنه معرض للاختبار — يكشف هذا المخطط حالته الأعمق.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'أنت حاليًا في مهاداشا $planet، لذا هذا المخطط مناسب التوقيت الآن بشكل خاص.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'بناءً على مخططك، يجب أن يكون $c1 أولويتك القصوى. المخططات أدناه مرتبة حسب أهميتها بالنسبة لك الآن.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'افتح هذا المخطط عندما تريد دراسة $purpose.';
  }

  @override
  String get yogaHelpful => 'مفيدة';

  @override
  String get yogaInactive => 'غير نشطة';

  @override
  String get yogaTabMoney => 'المال';

  @override
  String get yogaTabRare => 'نادرة';

  @override
  String get yogaSummaryTitle => 'ملخص اليوغات';

  @override
  String get yogaActiveYogas => 'اليوغات النشطة';

  @override
  String get yogaTotalYogas => 'إجمالي اليوغات';

  @override
  String get yogaMostPowerful => 'الأقوى';

  @override
  String get yogaFortuneRating => 'تقييم الحظ العام';

  @override
  String get yogaBenefits => 'الفوائد';

  @override
  String get yogaSupportingPlanets => 'الكواكب الداعمة';

  @override
  String get yogaRanking => 'أقوى 5 يوغات';

  @override
  String get yogaExplain => 'اشرح يوغاتي';

  @override
  String get yogaExplainSubtitle => 'كيف تدعمك يوغاتك';

  @override
  String get yogaNoneActive => 'لا توجد يوغات نشطة بعد';

  @override
  String get yogaNoneInCategory => 'لا توجد يوغات في هذه الفئة';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'يحمل مخططك $count يوغا نشطة — تركيبات كوكبية داعمة. التركيبات التي تشمل $planets تخلق تأثيرات مفيدة بشكل خاص للنمو والنجاح.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return 'يدعم $name $areas، وتزداد فوائده عندما تكون كواكبه نشطة في Dasha أو الانتقال.';
  }

  @override
  String get yogaAiGeneric =>
      'هذه اليوغا تركيبة داعمة في مخططك تعزز مجالات الحياة المرتبطة بها.';

  @override
  String get yogaExplainReassure =>
      'اليوغات هي النقاط المضيئة في مخططك — تركيبات كوكبية مفيدة تعمل لصالحك. تقدم اليوغات الأقوى فوائد دائمة، خصوصًا خلال فترات الكواكب التي تشكّلها.';

  @override
  String get doshSevere => 'شديد';

  @override
  String get doshVeryMild => 'خفيف جدًا';

  @override
  String get doshLow => 'منخفض';

  @override
  String get doshHigh => 'مرتفع';

  @override
  String get doshCritical => 'حرج';

  @override
  String get doshSummaryTitle => 'ملخص الدوشات';

  @override
  String get doshActiveDoshas => 'الدوشات النشطة';

  @override
  String get doshTotalChecked => 'إجمالي المفحوصة';

  @override
  String get doshOverallSeverity => 'الشدة العامة';

  @override
  String get doshNoneActive => 'لا توجد دوشات نشطة — مخطط نظيف!';

  @override
  String get doshCategory => 'الفئة';

  @override
  String get doshConfidence => 'درجة الثقة';

  @override
  String get doshWhyFormed => 'لماذا تكوّنت';

  @override
  String get doshAffectedAreas => 'المجالات المتأثرة';

  @override
  String get doshTimeline => 'الجدول الزمني';

  @override
  String get doshDefinition => 'التعريف';

  @override
  String get doshFormationRule => 'قاعدة التكوين';

  @override
  String get doshSupportingPlanets => 'الكوكب ذو الصلة';

  @override
  String get doshCancellation => 'يوغات الإلغاء';

  @override
  String get doshNoCancellation => 'لم يتم العثور على شيء';

  @override
  String get doshAreaChildren => 'الأطفال';

  @override
  String get doshAreaMind => 'العقل';

  @override
  String get remMantra => 'المانترا';

  @override
  String get remGemstone => 'حجر كريم';

  @override
  String get remDonation => 'التبرع';

  @override
  String get remTemple => 'المعبد';

  @override
  String get remFasting => 'الصيام';

  @override
  String get remLifestyle => 'نمط الحياة';

  @override
  String get remLifestyleGeneric =>
      'مارس الامتنان والانضباط والعطاء المرتبط بهذا الكوكب، وحافظ على السلوك الحسن.';

  @override
  String get doshExplain => 'اشرح دوشاتي';

  @override
  String get doshExplainSubtitle => 'نظرة هادئة وعملية على دوشاتك';

  @override
  String get doshExplainReassure =>
      'الدوشات شائعة — تقريبًا كل مخطط يحتوي على بعضها. إنها تصف ميولًا، لا قدرًا محتومًا. الوعي والسلوك الحسن والعلاجات البسيطة تقلل من أثرها العملي، فلا داعي للقلق.';

  @override
  String get doshAiGeneric =>
      'تصف هذه الدوشا ميلًا في مخططك. تأثيرها العملي عادة ما يكون خفيفًا ويمكن موازنته بالوعي والعلاجات البسيطة.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'يُظهر مخططك $active دوشا نشطة من أصل $total تم فحصها. معظمها خفيف ولا يحتاج سوى القليل منها إلى اهتمام. مع الفهم والعلاجات البسيطة، يمكن تخفيف أثرها العملي.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'تؤثر هذه الدوشا بشكل أساسي على $areas. خلال فترات $planet قد يبدو تأثيرها أقوى، وتساعد العلاجات على موازنته.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'يظهر تأثيرها بشكل أكبر خلال Mahadasha وAntardasha لكوكب $planet، وعندما يكون $planet نشطًا في الانتقال.';
  }

  @override
  String get sbLegendary => 'أسطوري';

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
  String get sbSummary => 'ملخص القوة الكوكبية';

  @override
  String get sbAverageStrength => 'متوسط القوة';

  @override
  String get sbHighestRupa => 'أعلى Rupa';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'ترتيب الكواكب';

  @override
  String get sbRequired => 'المطلوب';

  @override
  String get sbExcess => 'الفائض';

  @override
  String get sbDeficit => 'العجز';

  @override
  String get sbTotalShadbala => 'إجمالي Shadbala';

  @override
  String get sbExplain => 'اشرح قوتي الكوكبية';

  @override
  String get sbExplainSubtitle => 'ملخص بسيط لقوة كواكبك';

  @override
  String get sbInfoTitle => 'فهم Shadbala';

  @override
  String get sbQWhatIs => 'ما هو Shadbala؟';

  @override
  String get sbQRupas => 'ما هي Rupas؟';

  @override
  String get sbQHowCalc => 'كيف تُحسب القوة؟';

  @override
  String get sbQHowUse => 'كيف تستخدم هذا';

  @override
  String get sbWhyStrong => 'لماذا قوي';

  @override
  String get sbWhyWeak => 'لماذا ضعيف';

  @override
  String get sbDuringMahadasha => 'خلال Mahadasha';

  @override
  String get sbEffects => 'التأثيرات';

  @override
  String get sbLifeAreas => 'مجالات الحياة';

  @override
  String get sbPlanetDetails => 'تفاصيل الكوكب';

  @override
  String get sbBodyWhatIs =>
      'يقيس Shadbala (\'القوة السداسية\') مقدار قدرة كل كوكب على تحقيق نتائجه، بجمع ستة مصادر مستقلة للقوة.';

  @override
  String get sbBodyRupas =>
      'تُقاس القوة بوحدة Rupa (1 Rupa = 60 Virupa). يحتاج كل كوكب إلى حد أدنى من قوة Rupa ليُعتبر قويًا؛ زيادة عدد الـRupas تعني تحقيقًا أكمل لنتائجه.';

  @override
  String get sbBodyHowCalc =>
      'تُجمع ستة balas: Sthana (الموضعي)، Dig (الاتجاهي)، Kala (الزمني)، Chesta (الحركي)، Naisargika (الطبيعي) وDrik (الاتجاهي/الرؤية). يُقارن المجموع بالحد الأدنى المطلوب للكوكب للحصول على نسبة مئوية.';

  @override
  String get sbBodyHowUse =>
      'الكوكب الذي يتجاوز 100% يحقق دلالاته بارتياح؛ وما دون 100% يحتاج إلى دعم. فضّل كواكبك الأقوى في الأمور المهمة، وامنح الأضعف علاجات وصبرًا.';

  @override
  String get sbRemedyStrong =>
      'مدعوم جيدًا — لا حاجة لعلاج خاص؛ يمكنك الاعتماد بثقة على فترات هذا الكوكب.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP هو كوكبك الأقوى، ويمنح دعمًا ممتازًا لـ$strongTrait. $weakP هو الأضعف ويستفيد أكثر من العلاجات.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return 'يمتلك $planet Shadbala من فئة $category، لذا فإن $karakatva مدعومة وفقًا لذلك.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'الأقوى من خلال $bala ($rupa روبا).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'الأضعف في $bala، مما يخفض المجموع.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'خلال Mahadasha لكوكب $planet، تبرز $karak.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'مع Shadbala قوي، تكون $karak مدعومة بشكل طبيعي.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'مع Shadbala متواضع، قد تحتاج $karak إلى جهد واعٍ.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'قوِّ $planet من خلال المانترا أو الحجر الكريم أو الصدقة، وتصرف بصبر خلال فتراته.';
  }

  @override
  String get bhOverview => 'نظرة عامة';

  @override
  String get bhDetailed => 'تفصيلي';

  @override
  String get bhavaHouses => 'البيوت';

  @override
  String get bhStrengthOverview => 'نظرة عامة على قوة البيوت';

  @override
  String get bhOverallAverage => 'متوسط البيوت العام';

  @override
  String get bhStrongestHouse => 'أقوى بيت';

  @override
  String get bhWeakestHouse => 'أضعف بيت';

  @override
  String get bhBestArea => 'أفضل مجال حياة';

  @override
  String get bhNeedsAttention => 'يحتاج إلى اهتمام';

  @override
  String get bhSavContribution => 'مساهمة SAV';

  @override
  String get bhLordCondition => 'حالة سيد البيت';

  @override
  String get bhBenefic => 'تأثير نافع';

  @override
  String get bhMalefic => 'تأثير ضار';

  @override
  String get bhStrengthReasons => 'لماذا هذه الدرجة';

  @override
  String get bhGoodEffects => 'التأثيرات الجيدة';

  @override
  String get bhChallenges => 'التحديات';

  @override
  String get bhRemedies => 'العلاجات';

  @override
  String get bhRanking => 'ترتيب البيوت';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'اشرح بيوتي';

  @override
  String get bhExplainSubtitle => 'ملخص بسيط لبيوتك الـ12';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'أقوى بيوتك هي $s1 و$s2. $strongArea قوي بشكل طبيعي، بينما يحتاج $weakArea إلى مزيد من الجهد.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'يقع سيده $lord في وضع $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'يحمل هذا البيت $sav نقطة نافعة (SAV)؛ تشكّل شواغله وجوانبه بقية الدرجة.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'عندما يكون قويًا، يدعم $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'عندما يكون ضعيفًا، قد يحتاج $meaning إلى جهد وعناية إضافيين.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'قوِّ سيده $lord واعتنِ بشؤون هذا البيت لرفع مستواه.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'بيتك $house $strengthWord. يحكم $meaning.';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'موضع الكوكب';

  @override
  String get kunHousesTitle => 'تفاصيل البيوت';

  @override
  String get kunPlanet => 'الكوكب';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'السيد';

  @override
  String get kunExplain => 'اشرح مخططي';

  @override
  String get kunExplainSubtitle => 'ملخص بسيط لمخططك';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'يحكم البيت $ordinal $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets الموجودة هنا تشكّل نتائجه.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'طالعك هو $asc، وهو يشكّل نظرتك للحياة وكيف يراك الآخرون للوهلة الأولى.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'يتبع عقلك وعواطفك القمر في $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet هو كوكبك الأقوى — مجال طبيعي من السهولة والدعم.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet هو كوكبك الأكثر اختبارًا — الصبر والجهد يؤتيان ثمارهما هنا.';
  }

  @override
  String get plNature => 'الطبيعة';

  @override
  String get plElement => 'العنصر';

  @override
  String get plGender => 'الجنس';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'السيادة';

  @override
  String get plStrength => 'القوة';

  @override
  String get plAspectsGiven => 'الجوانب المُعطاة';

  @override
  String get plAspectsReceived => 'الجوانب المُستقبَلة';

  @override
  String get plConjunction => 'الاقتران';

  @override
  String get plHouseMeaning => 'معنى البيت';

  @override
  String get plNakshatraMeaning => 'معنى Nakshatra';

  @override
  String get plAiInterpretation => 'تفسير الذكاء الاصطناعي';

  @override
  String get plSearchHint => 'ابحث عن أي كوكب';

  @override
  String get plNoResults => 'لم يتم العثور على كواكب';

  @override
  String get plBenefic => 'نافع';

  @override
  String get plMalefic => 'ضار';

  @override
  String get plMale => 'ذكر';

  @override
  String get plFemale => 'أنثى';

  @override
  String get plNeutralGender => 'محايد';

  @override
  String get plOwnSign => 'برجه الخاص';

  @override
  String get plFriend => 'برج صديق';

  @override
  String get plEnemy => 'برج عدو';

  @override
  String get plNeutral => 'محايد';

  @override
  String get sumEther => 'الأثير';

  @override
  String plLordOfHouses(Object houses) {
    return 'سيد البيت (البيوت) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'يحكمه $nakLord، مما يجلب $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return 'يقع $planet في برج $sign، في البيت $house.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'دلالاته الأساسية — $karak — مدعومة جيدًا هنا.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'دلالاته الأساسية — $karak — قد تحتاج إلى جهد واعٍ هنا.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet في حالة شرف (exalted)، مما يمنحه أفضل نتائجه.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet في حالة وهن (debilitated) ويحتاج إلى دعم لتحقيق نتائجه.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet محترق (combust)، لذا يعمل بشكل أقل وضوحًا تحت وهج الشمس.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet في وضع Vargottama — موضع قوي متكرر في مخطط Navamsa.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet في حركة تراجعية (retrograde)، مما يوجّه طاقته نحو الداخل ويكثفها.';
  }

  @override
  String get plHouse1 => 'الذات والجسد والشخصية والحيوية';

  @override
  String get plHouse2 => 'الثروة والأسرة والكلام والطعام';

  @override
  String get plHouse3 => 'الشجاعة والإخوة والتواصل والرحلات القصيرة';

  @override
  String get plHouse4 => 'المنزل والأم والراحة والممتلكات والسلام الداخلي';

  @override
  String get plHouse5 =>
      'الأطفال والإبداع والذكاء والرومانسية والفضل من الحياة السابقة';

  @override
  String get plHouse6 => 'الصحة والأعداء والديون والخدمة والعمل اليومي';

  @override
  String get plHouse7 => 'الزواج والشراكات والعلاقات التجارية';

  @override
  String get plHouse8 => 'طول العمر والتحول والأسرار والميراث';

  @override
  String get plHouse9 => 'الحظ والدارما والتعليم العالي والمرشد والأب';

  @override
  String get plHouse10 => 'المسيرة المهنية والمكانة والسلطة والكارما العامة';

  @override
  String get plHouse11 => 'المكاسب والدخل والأصدقاء والشبكة والرغبات المتحققة';

  @override
  String get plHouse12 =>
      'الخسارة والمصروفات والأراضي الأجنبية والروحانية والتحرر';

  @override
  String get sumVeryStrong => 'قوي جدًا';

  @override
  String get sumStrong => 'قوي';

  @override
  String get sumAverage => 'متوسط';

  @override
  String get sumWeak => 'ضعيف';

  @override
  String get sumNeedsAttention => 'يحتاج إلى اهتمام';

  @override
  String get sumFire => 'النار';

  @override
  String get sumEarth => 'الأرض';

  @override
  String get sumAir => 'الهواء';

  @override
  String get sumWater => 'الماء';

  @override
  String get sumMovable => 'متحرك';

  @override
  String get sumFixed => 'ثابت';

  @override
  String get sumDual => 'مزدوج';

  @override
  String get sumDirEast => 'الشرق';

  @override
  String get sumDirWest => 'الغرب';

  @override
  String get sumDirNorth => 'الشمال';

  @override
  String get sumDirSouth => 'الجنوب';

  @override
  String get sumDirNE => 'الشمال الشرقي';

  @override
  String get sumDirNW => 'الشمال الغربي';

  @override
  String get sumDirSE => 'الجنوب الشرقي';

  @override
  String get sumDirSW => 'الجنوب الغربي';

  @override
  String get sumSnapshotTitle => 'لمحة عن تنجيمك';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'العنصر';

  @override
  String get sumModality => 'النمط';

  @override
  String get sumLuckyDirection => 'الاتجاه المحظوظ';

  @override
  String get sumHighlights => 'أبرز النقاط المهمة';

  @override
  String get sumStrongPlanet => 'أقوى كوكب';

  @override
  String get sumWeakPlanet => 'أضعف كوكب';

  @override
  String get sumYogas => 'اليوغات';

  @override
  String get sumDoshas => 'الدوشات';

  @override
  String get sumRetrograde => 'تراجعي';

  @override
  String get sumCombust => 'محترق';

  @override
  String get sumExalted => 'في شرف';

  @override
  String get sumDebilitated => 'في وهن';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'رؤى سريعة';

  @override
  String get sumSpirituality => 'الروحانية';

  @override
  String get sumTimezone => 'المنطقة الزمنية';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'التقويم';

  @override
  String get sumCopied => 'تم النسخ إلى الحافظة';

  @override
  String get sumNatureFire => 'لديك طبيعة جريئة ونشطة ورائدة تقود من الأمام.';

  @override
  String get sumNatureEarth =>
      'لديك طبيعة عملية وواقعية ومنضبطة تبني نتائج دائمة.';

  @override
  String get sumNatureAir =>
      'لديك طبيعة فضولية وتواصلية وفكرية تزدهر بالأفكار الجديدة.';

  @override
  String get sumNatureWater =>
      'لديك طبيعة حدسية وعاطفية ومتعاطفة بحساسية داخلية عميقة.';

  @override
  String get sumGradePhraseExcellent =>
      'مدعوم بقوة — النتائج المواتية محتملة مع جهد مستمر.';

  @override
  String get sumGradePhraseGood =>
      'مدعوم جيدًا — إيجابي عمومًا مع القليل من العناية.';

  @override
  String get sumGradePhraseAverage =>
      'دعم متباين — تعتمد النتائج على الجهد والتوقيت.';

  @override
  String get sumGradePhraseWeak =>
      'يحتاج إلى اهتمام — الصبر والعلاجات تساعد هنا.';

  @override
  String get kDefCombust =>
      'كوكب قريب جدًا من الشمس، مما \'يحرق\' طاقته ويضعفها.';

  @override
  String get kDefRetrograde =>
      'كوكب يبدو أنه يتحرك للخلف؛ تنقلب تأثيراته نحو الداخل وتشتد.';

  @override
  String get kDefNakshatra =>
      'أحد المنازل القمرية الـ27 التي يمر بها القمر والكواكب.';

  @override
  String get kDefVargottama =>
      'كوكب يقع في نفس البرج في كل من مخطط الميلاد (D1) ومخطط Navamsa (D9) — علامة قوة.';

  @override
  String get kDefOwnSign =>
      'كوكب يقع في برج يحكمه، حيث يشعر أنه في وطنه ويعطي نتائج ثابتة.';

  @override
  String get kDefExalted => 'كوكب في برج أقصى قوته، يمنح أفضل نتائجه.';

  @override
  String get kDefDebilitated => 'كوكب في أضعف بروجه، حيث يجاهد لتحقيق نتائجه.';

  @override
  String get kDefMooltrikona =>
      'جزء خاص من برج الكوكب الخاص حيث يكون قويًا بشكل خاص.';

  @override
  String get kDefAscendant =>
      'البرج الطالع من الأفق الشرقي عند الولادة — الـLagna، أساس المخطط.';

  @override
  String get kDefMahadasha =>
      'الفترة الكوكبية الرئيسية التي تلوّن جزءًا طويلًا من الحياة.';

  @override
  String get kDefAntardasha => 'فترة فرعية ضمن Mahadasha تضبط نتائجها بدقة.';

  @override
  String get kDefPada => 'أحد الأرباع الأربعة لـNakshatra التي يشغلها كوكب.';

  @override
  String get aspGivesAspectTo => 'يوجّه جانبًا إلى';

  @override
  String get aspReceivesAspectFrom => 'يستقبل جانبًا من';

  @override
  String get aspInfluences => 'يؤثر في';

  @override
  String get aspNoInfluence => 'لا تأثير';

  @override
  String get aspNoAspect => 'لا يوجد جانب';

  @override
  String get aspPresent => 'موجود';

  @override
  String get aspAbsent => 'غير موجود';

  @override
  String get aspNotPresent => 'غير موجود';

  @override
  String get aspSpecialAspect => 'جانب خاص';

  @override
  String get aspAspectWord => 'الجانب';

  @override
  String get aspTotalGiven => 'الجوانب المُعطاة';

  @override
  String get aspTotalReceived => 'الجوانب المُستقبَلة';

  @override
  String get aspStrongestInfluence => 'أقوى تأثير';

  @override
  String get aspMedium => 'متوسط';

  @override
  String get aspAspectPresent => 'الجانب موجود';

  @override
  String get aspReason => 'السبب';

  @override
  String get aspBoth => 'كلاهما';

  @override
  String get aspTargetHouse => 'البيت المستهدف';

  @override
  String get aspTargetSign => 'البرج المستهدف';

  @override
  String get aspLagnaReceives => 'يستقبل الطالع جانبًا من';

  @override
  String get aspNoAspectFrom => 'لا يوجد جانب من';

  @override
  String get aspPlanetToPlanet => 'من كوكب إلى كوكب';

  @override
  String get aspSignToSign => 'من برج إلى برج';

  @override
  String get aspCombinedAspect => 'جانب مركّب';

  @override
  String get aspGrahaAspect => 'جانب Graha';

  @override
  String get aspRashiAspect => 'جانب Rashi';

  @override
  String get aspInfoTitle => 'فهم الجوانب (Drishti)';

  @override
  String get aspQGraha => 'ما هو Graha Drishti؟';

  @override
  String get aspQRashi => 'ما هو Rashi Drishti؟';

  @override
  String get aspQDiff => 'الفرق بين الاثنين';

  @override
  String get aspQPredict => 'كيف تؤثر الجوانب على التوقع';

  @override
  String get aspGrahaBody =>
      'Graha Drishti هو الجانب الذي يوجّهه كوكب من موضعه. كل كوكب يوجّه جانبًا كاملًا للبيت/الكوكب السابع منه (تأثير مباشر ومواجه). بالإضافة إلى ذلك، يوجّه المريخ جانبًا للبيتين الرابع والثامن، والمشتري للخامس والتاسع، وزحل للثالث والعاشر. عادة ما يُمنح Rahu وKetu الجوانب الخامس والسابع والتاسع. يلوّن جانب الكوكب الكوكب أو البيت الذي يقع عليه بطبيعته الخاصة.';

  @override
  String get aspRashiBody =>
      'Rashi Drishti هو جانب من برج إلى برج من علم Jaimini التنجيمي، بغض النظر عن الكواكب الموجودة فيه. تُوجّه البروج المتحركة جوانب نحو البروج الثابتة (باستثناء المجاور)، وتُوجّه البروج الثابتة جوانب نحو البروج المتحركة (باستثناء المجاور)، وتُوجّه البروج المزدوجة جوانب نحو البروج المزدوجة الأخرى. يُستخدم بشكل أساسي في توقعات Jaimini ولتقييم العلاقات بين البيوت.';

  @override
  String get aspDiffBody =>
      'يوجّه Graha Drishti كوكب ويعتمد على مكان وجود ذلك الكوكب. أما Rashi Drishti فينتمي إلى البرج نفسه وينطبق على أي شيء موضوع فيه. Graha Drishti اتجاهي (الكوكب أ يرى الكوكب ب)، بينما Rashi Drishti عادة ما يكون متبادلًا بين البروج. عندما يشير كلاهما إلى نفس الهدف، يكون التأثير قويًا بشكل خاص.';

  @override
  String get aspPredictBody =>
      'يوضح الجانب أين يمد الكوكب تأثيره خارج بيته الخاص. الجانب النافع (المشتري، الزهرة، القمر/عطارد في وضع جيد) يدعم الهدف ويحميه؛ أما الجانب الضار (زحل، المريخ، الشمس، Rahu، Ketu) فقد يضغط عليه أو يؤخره أو يتحداه. قراءة الكواكب التي تُوجّه جانبًا نحو بيت أو كوكب يفسّر سبب ظهور النتائج على النحو الذي تظهر به.';

  @override
  String get aspTraitSun => 'السلطة والقيادة والحيوية';

  @override
  String get aspTraitMoon => 'العمق العاطفي والراحة والحدس';

  @override
  String get aspTraitMars => 'الطاقة والشجاعة والدافع';

  @override
  String get aspTraitMercury => 'التواصل والذكاء والقدرة على التكيف';

  @override
  String get aspTraitJupiter => 'الحكمة والنمو والحظ الجيد';

  @override
  String get aspTraitVenus => 'الحب والانسجام والرفاهية';

  @override
  String get aspTraitSaturn =>
      'الانضباط والمسؤولية والنجاح الصبور، وأحيانًا المتأخر';

  @override
  String get aspTraitRahu => 'الطموح والشدة والمنعطفات غير التقليدية';

  @override
  String get aspTraitKetu => 'الانفصال والروحانية والتغيير المفاجئ';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet يؤثر في $targets. قد يجلب هذا $trait إلى المجالات التي تمثلها هذه الكواكب.';
  }

  @override
  String aspAiNone(Object planet) {
    return 'لا يوجّه $planet جانبًا خاصًا إلى أي كوكب آخر هنا؛ يعمل تأثيره بشكل أساسي من خلال برجه وبيته الخاصين.';
  }

  @override
  String get avSummaryTitle => 'ملخص Ashtakavarga';

  @override
  String get avOverallScore => 'درجة SAV العامة';

  @override
  String get avOverallRating => 'التقييم العام';

  @override
  String get avStrongestSigns => 'أقوى البروج';

  @override
  String get avWeakestSigns => 'أضعف البروج';

  @override
  String get avScore => 'الدرجة';

  @override
  String get avMeaning => 'المعنى';

  @override
  String get avGrid => 'شبكة';

  @override
  String get avList => 'قائمة';

  @override
  String get avOverallScoreShort => 'الدرجة العامة';

  @override
  String get avNatalSignScore => 'درجة البرج الميلادي';

  @override
  String get avBestSigns => 'أفضل البروج';

  @override
  String get avWeakSigns => 'البروج الضعيفة';

  @override
  String get avAiInterpretation => 'تفسير الذكاء الاصطناعي';

  @override
  String get avVeryGood => 'جيد جدًا';

  @override
  String get avVeryWeak => 'ضعيف جدًا';

  @override
  String get avTotalSav => 'إجمالي SAV';

  @override
  String get avPlanetContributions => 'مساهمات الكواكب';

  @override
  String get avFinance => 'المال';

  @override
  String get avOverallStrength => 'القوة العامة';

  @override
  String get avWhatDoesThisMean => 'ماذا يعني هذا؟';

  @override
  String get avSimple => 'بسيط';

  @override
  String get avAdvanced => 'متقدم';

  @override
  String get avInfoTitle => 'فهم Ashtakavarga';

  @override
  String get avStrong => 'قوي';

  @override
  String get avModerate => 'متوسط';

  @override
  String get avQWhatIsAv => 'ما هو Ashtakavarga؟';

  @override
  String get avQWhatIsSav => 'ما هو SAV؟';

  @override
  String get avQWhatIsBav => 'ما هو BAV؟';

  @override
  String get avQHowToRead => 'كيف تقرأ هذه الدرجات';

  @override
  String get avQSavVsBav => 'SAV مقابل BAV';

  @override
  String get avABody =>
      'Ashtakavarga هو نظام قوة قائم على النقاط في التنجيم الفيدي. يمنح كل كوكب نقاطًا نافعة (bindus، تُسمى أيضًا rekhas) للبروج الاثني عشر بناءً على موضعه. زيادة النقاط في برج تعني دعمًا أكثر سلاسة لذلك المجال من الحياة خلال الفترات الكوكبية والانتقالات المرتبطة به.';

  @override
  String get avSavBody =>
      'يجمع SAV (Sarva Ashtakavarga) النقاط من جميع الكواكب السبعة لكل برج. يعطي درجة قوة واحدة لكل برج، بحيث يمكنك بسرعة معرفة أي البروج — والبيوت التي تقع فيها — الأكثر دعمًا في مخططك.';

  @override
  String get avBavBody =>
      'يُظهر BAV (Bhinna Ashtakavarga) النقاط من كوكب واحد عبر البروج الاثني عشر. يخبرك بأي البروج يدعمها كوكب معين أكثر، وهو أمر مهم عندما تكون Dasha أو انتقال ذلك الكوكب نشطًا.';

  @override
  String get avHowToReadBody =>
      'الأرقام الأعلى أفضل. بالنسبة لـSAV، يحصل البرج المتوسط على نحو 28 نقطة — وما فوق 30 يُعتبر قويًا وما دون 25 يحتاج إلى عناية. بالنسبة لـBAV، يتراوح كل برج من 0 إلى 8، حيث يُعتبر 4 متوسطًا. فضّل أقوى بروجك للأعمال المهمة، وتحلَّ بالصبر والانضباط مع أضعفها.';

  @override
  String get avSavVsBavBody =>
      'SAV هو المجموع الكلي لجميع الكواكب ويُظهر القوة العامة للبرج. BAV هو مساهمة كوكب واحد ويُظهر أي كوكب يدعم ذلك البرج. استخدم SAV للصورة الكبيرة، وBAV لفهم أي كوكب يقود قوة برج ما.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'مخططك الأقوى في $s1 و$s2 و$s3. تمنح هذه البروج دعمًا أفضل خلال الفترات الكوكبية والانتقالات. لدى $weak حاليًا أقل دعم، لذا يساعد الصبر والانضباط في الأمور المرتبطة به.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return 'يعمل $planet بأقوى شكل من خلال $s1 و$s2. تميل الأمور التي يحكمها $planet إلى التحسن عندما تُفعّل هذه البروج.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'أقوى بروجك هي $s1 و$s2 — فضّل البدايات المهمة عندما تعبر الكواكب من خلالها.';
  }

  @override
  String avInsightWeak(Object s1) {
    return 'لدى $s1 أقل دعم — تحرك بحذر وتجنب الالتزام الزائد في أموره.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return 'يحمل $planet أكبر عدد من النقاط، لذا فإن دلالاته مدعومة جيدًا في حياتك.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return 'يحمل $planet أقل عدد من النقاط ويستفيد أكثر من العلاجات والجهد الواعي.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'البروج التي تسجّل فوق متوسطك البالغ $avg نقطة تميل إلى إعطاء نتائج أكثر سلاسة وموثوقية.';
  }

  @override
  String get fcKey => 'المفتاح';

  @override
  String get fcActions => 'الإجراءات';

  @override
  String get fcCautions => 'التحذيرات';

  @override
  String get fc12House => 'البيوت الـ12';

  @override
  String get fcProbabilities => 'الاحتمالات';

  @override
  String get fcHousesCaps => 'البيوت';

  @override
  String get fcCritical => 'حرج';

  @override
  String get fcFlags => 'إشارات';

  @override
  String get fcAnalysis => 'التحليل';

  @override
  String get fcConfidence => 'درجة الثقة';

  @override
  String get fcQualityCaps => 'الجودة';

  @override
  String get fcIncomeVs => 'الدخل مقابل';

  @override
  String get fcExpense => 'المصروفات';

  @override
  String get fcFinance => 'المال';

  @override
  String get fcNetBalance => 'الرصيد الصافي';

  @override
  String get fcSignature => 'البصمة';

  @override
  String get fcBestTimeForIncome => 'أفضل وقت للدخل';

  @override
  String get fcExpenseCaution => 'تحذير من المصروفات';

  @override
  String get fcIncomeCaps => 'الدخل';

  @override
  String get fcExpenseCaps => 'المصروفات';

  @override
  String get fcRelationships => 'العلاقات';

  @override
  String get fcAreasCaps => 'المجالات';

  @override
  String get fcBestForMeetings => 'الأفضل للاجتماعات';

  @override
  String get fcOpportunitiesVs => 'الفرص مقابل';

  @override
  String get fcRisks => 'المخاطر';

  @override
  String get fcOutlook => 'التوقعات';

  @override
  String get fcAction => 'الإجراء';

  @override
  String get fcProtect => 'الحماية';

  @override
  String get fcOpportunityCaps => 'الفرصة';

  @override
  String get fcRiskCaps => 'الخطر';

  @override
  String get fcTopOpportunities => 'أبرز الفرص';

  @override
  String get fcTopRisks => 'أبرز المخاطر';

  @override
  String get fcTiming => 'التوقيت';

  @override
  String get fcWindows => 'النوافذ';

  @override
  String get fcSlotsCaps => 'الفترات';

  @override
  String get fcBestWindows => 'أفضل النوافذ';

  @override
  String get fcWorstWindows => 'أسوأ النوافذ';

  @override
  String get fcAvoid => 'تجنّب';

  @override
  String get fcHouse => 'البيت';

  @override
  String get fcFailed => 'فشل';

  @override
  String get lifeCareer => 'المسيرة المهنية';

  @override
  String get lifeHealth => 'الصحة';

  @override
  String get lifeWealth => 'الثروة';

  @override
  String get lifeFamily => 'الأسرة';

  @override
  String get lifeMind => 'العقل';

  @override
  String get lifeEgo => 'الأنا';

  @override
  String get lifeAggression => 'العدوانية';

  @override
  String get lifeConflict => 'النزاع';

  @override
  String get rashiElement => 'العنصر';

  @override
  String get rashiQuality => 'الصفة';

  @override
  String get rashiLuckyColor => 'اللون المحظوظ';

  @override
  String get rashiLuckyDay => 'اليوم المحظوظ';

  @override
  String get rashiLuckyNumber => 'الرقم المحظوظ';

  @override
  String get rashiGemstone => 'الحجر الكريم';

  @override
  String get rashiBody => 'الجسد';

  @override
  String get gocharTodaysTransitChart => 'مخطط انتقال اليوم';

  @override
  String get gocharTransit => 'الانتقال';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get best => 'الأفضل';

  @override
  String get worst => 'الأسوأ';

  @override
  String get avg => 'المتوسط';

  @override
  String get favorableLoveWindowsLabel => 'نوافذ الحب المواتية';

  @override
  String get lordLabel => 'السيد';

  @override
  String get lordPlacementLabel => 'موضع السيد';

  @override
  String get lordDignityLabel => 'منزلة السيد';

  @override
  String get categoriesSuffix => 'الفئات';

  @override
  String get coreBlockerLabel => 'العائق الجوهري';

  @override
  String get coreGiftLabel => '✦ الهبة الجوهرية';

  @override
  String get coreThemeLabel => '● الموضوع الجوهري';

  @override
  String dominantLabel(Object value) {
    return 'السائد: $value';
  }

  @override
  String get karakasSuffix => 'الكاراكات';

  @override
  String get protectiveLabel => 'الحماية';

  @override
  String secondaryLabel(Object value) {
    return ' · الثانوي: $value';
  }

  @override
  String get tagCore => 'جوهري';

  @override
  String get debtScoresHeader => '📉 درجات الديون';

  @override
  String get debtCurrentLoadStat => 'عبء الديون\nالحالي';

  @override
  String get debtRecoveryCapacityStat => 'قدرة\nالتعافي';

  @override
  String get debtIntensityStat => 'الشدة';

  @override
  String get debtDefaultRiskStat => 'خطر التعثر';

  @override
  String get debtProfileTitle => 'ملف الديون';

  @override
  String get debtKarmaLabel => 'الكارما';

  @override
  String get debtPersonalityLabel => 'الشخصية';

  @override
  String get debtPhaseLabel => 'المرحلة';

  @override
  String get debtPrimaryCategoryLabel => 'الفئة الأساسية';

  @override
  String get debtWord => 'الدين';

  @override
  String get debtYogasTitle => 'يوغات الديون';

  @override
  String get debtCreatingLabel => 'مسببة للديون';

  @override
  String get debtClearingLabel => 'مصفّية للديون';

  @override
  String get yearlyDebtTitle => 'الديون السنوية';

  @override
  String get debtRepaymentTitle => 'السداد';

  @override
  String get debtDangerPeriodsTitle => 'فترات الخطر';

  @override
  String get debtDefaultPctStat => 'نسبة التعثر';

  @override
  String get debtBankruptcyPctStat => 'نسبة الإفلاس';

  @override
  String get debtChronicPctStat => 'نسبة المزمن';

  @override
  String get debtResilienceStat => 'المرونة';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'التعافي: $pct% · الجدول الزمني: $years سنوات';
  }

  @override
  String get debtFreeWindowLabel => '🎯 نافذة التحرر من الديون';

  @override
  String debtFreeYear(Object year) {
    return 'السنة $year';
  }

  @override
  String get legalScoresHeader => '⚖️ الدرجات القانونية';

  @override
  String get legalVulnerabilityStat => 'الضعف\nالقانوني';

  @override
  String get legalVictoryPotentialStat => 'إمكانية\nالفوز';

  @override
  String get legalConflictStat => 'النزاع';

  @override
  String get legalResolutionStat => 'التسوية';

  @override
  String get legalProfileTitle => 'الملف القانوني';

  @override
  String get legalKarmaTypeLabel => 'نوع الكارما';

  @override
  String get legalConflictStyleLabel => 'أسلوب النزاع';

  @override
  String get legalStrategyLabel => 'الاستراتيجية';

  @override
  String get legalCaseDurationLabel => 'مدة القضية';

  @override
  String get legalCurrentStatusLabel => 'الحالة الراهنة';

  @override
  String get legalWord => 'قانوني';

  @override
  String get legalYogasTitle => 'اليوغات القانونية';

  @override
  String get legalDisputePressureLabel => 'ضغط النزاع';

  @override
  String get legalProtectionLabel => 'الحماية القانونية';

  @override
  String get legalStressTrendTitle => 'التوتر القانوني';

  @override
  String get legalVisibleEnemiesStat => 'الأعداء الظاهرون';

  @override
  String get legalHiddenEnemiesStat => 'الأعداء الخفيون';

  @override
  String get legalCriminalRiskStat => 'الخطر الجنائي';

  @override
  String get legalFalseAccusationStat => 'الاتهام الباطل';

  @override
  String get legalContractKarmaTitle => 'كارما العقود';

  @override
  String get legalDocumentationLabel => 'التوثيق';

  @override
  String get legalFinePrintAwareLabel => 'الوعي بالشروط الدقيقة';

  @override
  String get legalNegotiationSkillLabel => 'مهارة التفاوض';

  @override
  String get legalSignatureCautionLabel => 'الحذر عند التوقيع';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'المرونة: $pct/100';
  }

  @override
  String get legalVictoryWord => 'الفوز';

  @override
  String get legalAnalysisSuffix => 'تحليل';

  @override
  String get legalAsPlaintiff => 'بصفة المدّعي';

  @override
  String get legalAsDefendant => 'بصفة المدّعى عليه';

  @override
  String get legalWinProbability => 'احتمالية الفوز';

  @override
  String get legalDisputeWord => 'النزاع';

  @override
  String get lifepathScoresHeader => '🌟 درجات مسار الحياة';

  @override
  String get lifepathDharmaClarityStat => 'وضوح\nالدارما';

  @override
  String get lifepathFortuneBaselineStat => 'خط أساس\nالحظ';

  @override
  String get lifepathCoherenceStat => 'تماسك\nمسار الحياة';

  @override
  String get lifepathKarmaStat => 'الكارما';

  @override
  String get lifepathSpiritualStat => 'الروحاني';

  @override
  String get lifepathFameStat => 'الشهرة';

  @override
  String get lifepathSoulContractTitle => 'عقد الروح';

  @override
  String get lifepathAtmakarakaLabel => 'Atmakaraka';

  @override
  String get lifepathAkFocusLabel => 'تركيز AK';

  @override
  String get lifepathSoulPurposeLabel => 'هدف الروح';

  @override
  String get lifepathLifeChapterLabel => 'فصل الحياة';

  @override
  String get lifepathPrimaryDomainLabel => 'المجال الأساسي';

  @override
  String get lifepathLeadershipStat => 'القيادة';

  @override
  String get lifepathWisdomTeachStat => 'الحكمة/التعليم';

  @override
  String get lifepathServiceStat => 'الخدمة';

  @override
  String get lifepathHealingStat => 'الشفاء';

  @override
  String get lifepathFortuneYogasTitle => 'يوغات الحظ';

  @override
  String get lifepathLuckBlocksLabel => 'عوائق الحظ';

  @override
  String get lifepathFortuneBoostersLabel => 'معززات الحظ';

  @override
  String get lifepathFortuneTrendTitle => 'اتجاه الحظ';

  @override
  String get lifepathGoldenWindowsTitle => 'النوافذ الذهبية ★';

  @override
  String get lifepathTransformationTitle => 'التحول';

  @override
  String get lifepathMilestonesTitle => 'محطات الحياة';

  @override
  String get lifepathKarmicLessonsTitle => 'الدروس الكرمية';

  @override
  String get lifepathRahuGrowthLabel => 'نمو Rahu';

  @override
  String get lifepathKetuSurrenderLabel => 'استسلام Ketu';

  @override
  String get lifepathSaturnLessonLabel => 'درس زحل';

  @override
  String get lifepathLifeDifficultyLabel => 'صعوبة الحياة';

  @override
  String get lifepathSoulExperienceTitle => '★ ما جاءت الروح لتختبره';

  @override
  String get lifepathBlessingsTitle => '● البركات';

  @override
  String get lifepathLifeWord => 'الحياة';

  @override
  String get lifepathArchetypeSuffix => 'النموذج';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'التحقق: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'القدر مقابل';

  @override
  String get lifepathFreeWillSuffix => 'الإرادة الحرة';

  @override
  String get lifepathDestinyStat => 'القدر';

  @override
  String get lifepathFreeWillStat => 'الإرادة الحرة';

  @override
  String get pastlifeScoresHeader => '🔮 درجات الحياة السابقة';

  @override
  String get pastlifeSignatureStrengthStat => 'قوة\nالبصمة';

  @override
  String get pastlifeCarryForwardStat => 'المحمول\nإلى الحاضر';

  @override
  String get pastlifeMasteryPreservedStat => 'الإتقان\nالمحفوظ';

  @override
  String get pastlifeUnfinishedStat => 'غير المكتمل';

  @override
  String get pastlifeKarmicDebtStat => 'الدين الكرمي';

  @override
  String get pastlifeProfileTitle => 'ملف الحياة السابقة';

  @override
  String get pastlifeThemeLabel => 'الموضوع';

  @override
  String get pastlifeProfessionLabel => 'المهنة';

  @override
  String get pastlifeSocialStandingLabel => 'المكانة الاجتماعية';

  @override
  String get pastlifeRegionLabel => 'المنطقة';

  @override
  String get pastlifeSpiritualLevelLabel => 'المستوى الروحي';

  @override
  String get pastlifeGenderLabel => 'الجنس';

  @override
  String get pastlifeWealthLevelLabel => 'مستوى الثروة';

  @override
  String get pastlifeFamilyRoleLabel => 'الدور الأسري';

  @override
  String get pastlifeSkillsCarriedTitle => '★ المهارات المحمولة إلى الحاضر';

  @override
  String get pastlifeNaturalAttractionsTitle => '● الانجذابات الطبيعية';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ المخاوف غير المبررة';

  @override
  String get pastlifeMagneticPullsTitle => '→ الجواذب المغناطيسية';

  @override
  String get pastlifeRelationshipStat => 'العلاقات';

  @override
  String get pastlifeFinancialStat => 'المالي';

  @override
  String get pastlifeServiceStat => 'الخدمة';

  @override
  String get pastlifeDharmicStat => 'الدارمي';

  @override
  String get pastlifeOnRelationsStat => 'على العلاقات';

  @override
  String get pastlifeOnCareerStat => 'على المسيرة المهنية';

  @override
  String get pastlifeOnHealthStat => 'على الصحة';

  @override
  String get pastlifeOnSpiritualStat => 'على الروحانية';

  @override
  String get pastlifeKarmicResolutionTitle => 'التسوية الكرمية';

  @override
  String get pastlifePrimaryPathLabel => 'المسار الأساسي';

  @override
  String get pastlifeSecondaryPathLabel => 'المسار الثانوي';

  @override
  String get pastlifeClearingProgressLabel => 'تقدم التصفية';

  @override
  String get pastlifeRemainingWorkLabel => 'العمل المتبقي';

  @override
  String get pastlifeDebtTimelineLabel => 'الجدول الزمني للدين';

  @override
  String get pastlifeMemoryAccessStat => 'الوصول إلى الذاكرة';

  @override
  String get pastlifeDreamVisitsStat => 'الزيارات في الأحلام';

  @override
  String get pastlifeDejaVuStat => 'الشعور بالحدوث المسبق';

  @override
  String get pastlifeRegressionFitStat => 'ملاءمة الرجوع للحياة السابقة';

  @override
  String get pastlifeActivationTitle => 'تفعيل الحياة السابقة';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'النضج: $maturity · الحالة: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'الإتقان السابق';

  @override
  String get pastlifeKetuMasteredLabel => 'Ketu · ما أتقنته';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'النمو المستقبلي';

  @override
  String get pastlifeRahuPullsLabel => 'Rahu · ما يدفعك إلى الأمام';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ الجانب الخفي: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 الدرجات النفسية';

  @override
  String get mentalStabilityStat => 'الاستقرار\nالنفسي';

  @override
  String get mentalEmotionalBaselineStat => 'خط الأساس\nالعاطفي';

  @override
  String get mentalResilienceStat => 'المرونة';

  @override
  String get mentalAnxietyStat => 'القلق';

  @override
  String get mentalDepressionStat => 'الاكتئاب';

  @override
  String get mentalRegulationStat => 'التنظيم';

  @override
  String get mentalProfileTitle => 'الملف النفسي';

  @override
  String get mentalConstitutionLabel => 'البنية';

  @override
  String get mentalStressDriverLabel => 'محفز التوتر';

  @override
  String get mentalStabilityAnchorLabel => 'مرساة الاستقرار';

  @override
  String get mentalStressResponseLabel => 'الاستجابة للتوتر';

  @override
  String get mentalAttachmentStyleLabel => 'أسلوب التعلق';

  @override
  String get mentalBurnoutStageLabel => 'مرحلة الإرهاق';

  @override
  String get mentalWord => 'نفسي';

  @override
  String get mentalYogasTitle => 'اليوغات النفسية';

  @override
  String get mentalStressPressureLabel => 'ضغط التوتر';

  @override
  String get mentalWellnessTrendTitle => 'اتجاه العافية';

  @override
  String get mentalHealthyCopingTitle => '✓ التأقلم الصحي';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ مخاطر غير صحية';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ بدائل موصى بها';

  @override
  String get mentalSleepQualityStat => 'جودة النوم';

  @override
  String get mentalSocialSupportStat => 'الدعم الاجتماعي';

  @override
  String get mentalBurnoutVulnStat => 'قابلية الإرهاق';

  @override
  String get mentalSelfAwarenessStat => 'الوعي الذاتي';

  @override
  String get mentalAnxietyWord => 'القلق';

  @override
  String get mentalTypesSuffix => 'الأنواع';

  @override
  String get mentalTherapyWord => 'العلاج';

  @override
  String get mentalModalityFitSuffix => 'ملاءمة الأسلوب';

  @override
  String get characterScoresHeader => '🔍 درجات الشخصية';

  @override
  String get characterStrengthStat => 'قوة\nالشخصية';

  @override
  String get characterIntegrityStat => 'النزاهة';

  @override
  String get characterResilienceStat => 'المرونة';

  @override
  String get characterAwarenessStat => 'الوعي';

  @override
  String get characterStabilityStat => 'الاستقرار';

  @override
  String get characterEthicsStat => 'الأخلاق';

  @override
  String get characterSurfacePersonalityTitle => 'الشخصية الظاهرية';

  @override
  String get characterLagnaLabel => 'Lagna';

  @override
  String get characterConstitutionLabel => 'البنية';

  @override
  String get characterNakshatraLabel => 'Nakshatra';

  @override
  String get characterDeityLabel => 'الإله الحارس';

  @override
  String get characterMoonManasTitle => 'عقل القمر (Manas)';

  @override
  String get characterSignLabel => 'البرج';

  @override
  String get characterHouseLabel => 'البيت';

  @override
  String get characterWarmthStat => 'الدفء';

  @override
  String get characterEmpathyStat => 'التعاطف';

  @override
  String get characterLoyaltyStat => 'الوفاء';

  @override
  String get characterBoundariesStat => 'الحدود';

  @override
  String get characterDharmaStat => 'الدارما';

  @override
  String get characterTruthStat => 'الصدق';

  @override
  String get characterCompassionStat => 'الرحمة';

  @override
  String get characterGenerosityStat => 'الكرم';

  @override
  String get characterSignatureVirtuesTitle => '★ الفضائل المميزة';

  @override
  String get characterNaturalTalentsTitle => '● المواهب الطبيعية';

  @override
  String get characterShadowPatternsTitle => '⚠ الأنماط الخفية';

  @override
  String get characterYogasTitle => 'يوغات الشخصية';

  @override
  String get characterTestsLabel => 'الاختبارات';

  @override
  String get characterGiftsLabel => 'الهبات';

  @override
  String get characterSelfAwareEiStat => 'الوعي الذاتي (ذكاء عاطفي)';

  @override
  String get characterSelfRegulateStat => 'ضبط الذات';

  @override
  String get characterEmpathyEiStat => 'التعاطف (ذكاء عاطفي)';

  @override
  String get characterSocialSkillsStat => 'المهارات الاجتماعية';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'التحقق: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'بصمة الروح';

  @override
  String get characterAtmakarakaLabel => 'Atmakaraka';

  @override
  String get characterGunaWord => 'Guna';

  @override
  String get characterProfileSuffix => 'الملف';

  @override
  String get characterSattvaLabel => 'Sattva';

  @override
  String get characterRajasLabel => 'Rajas';

  @override
  String get characterTamasLabel => 'Tamas';

  @override
  String get healthScoresHeader => '🏥 الدرجات الصحية';

  @override
  String get healthVitalityStat => 'الحيوية';

  @override
  String get healthImmunityStat => 'المناعة';

  @override
  String get healthRecoveryStat => 'التعافي';

  @override
  String get healthMentalStat => 'النفسي';

  @override
  String get healthStressTolStat => 'تحمّل التوتر';

  @override
  String get healthYogasTitle => 'اليوغات الصحية';

  @override
  String get healthDiseasePressureLabel => 'ضغط المرض';

  @override
  String get healthTrendTitle => 'الاتجاه الصحي';

  @override
  String get healthRecoveryWindowsTitle => 'نوافذ التعافي';

  @override
  String get healthCautionPeriodsTitle => 'فترات الحذر';

  @override
  String get healthFertilityStat => 'الخصوبة';

  @override
  String get healthBurnoutRiskStat => 'خطر الإرهاق';

  @override
  String get healthAddictionVulnStat => 'قابلية الإدمان';

  @override
  String get healthWorkLifeBalStat => 'توازن العمل والحياة';

  @override
  String get healthAyurvedicWord => 'أيورفيدي';

  @override
  String get healthConstitutionSuffix => 'البنية';

  @override
  String get healthBodyWord => 'الجسد';

  @override
  String get healthSystemMapSuffix => 'خريطة الأجهزة';

  @override
  String get healthBodyZoneWord => 'منطقة الجسد';

  @override
  String get healthVulnerabilitySuffix => 'القابلية للتأثر';

  @override
  String get healthDiseaseWord => 'المرض';

  @override
  String get healthSusceptibilitySuffix => 'القابلية للإصابة';

  @override
  String get healthLifestyleFactorsTitle => 'عوامل نمط الحياة';

  @override
  String get healthSleepDisciplineLabel => 'انضباط النوم';

  @override
  String get healthDietDisciplineLabel => 'انضباط الحمية';

  @override
  String get healthExerciseNeedLabel => 'الحاجة إلى الرياضة';

  @override
  String get healthSunlightNeedLabel => 'الحاجة إلى ضوء الشمس';

  @override
  String get healthSocialTypeLabel => 'النمط الاجتماعي';

  @override
  String get healthHealingSpeedLabel => 'سرعة الشفاء';

  @override
  String get wealthScoresHeader => '💰 درجات الثروة';

  @override
  String get wealthStrengthStat => 'قوة\nالثروة';

  @override
  String get wealthAccumulationStat => 'التراكم';

  @override
  String get wealthIncomeFlowStat => 'تدفق\nالدخل';

  @override
  String get wealthSustainStat => 'الاستدامة';

  @override
  String get wealthMultiStreamStat => 'مصادر متعددة';

  @override
  String get wealthRetentionStat => 'الاحتفاظ';

  @override
  String get wealthWord => 'الثروة';

  @override
  String get wealthYogasTitle => 'يوغات الثروة';

  @override
  String get wealthDrainsLabel => 'الاستنزافات';

  @override
  String get wealthBoostersLabel => 'المعززات';

  @override
  String get wealthYearlyTrendTitle => 'الاتجاه السنوي';

  @override
  String get wealthGrowthTitle => 'نمو الثروة';

  @override
  String get wealthCashPressureTitle => 'ضغط السيولة';

  @override
  String get wealthMoneyPersonalityTitle => 'شخصية التعامل مع المال';

  @override
  String get wealthTypeLabel => 'نوع الثروة';

  @override
  String get wealthRiskAppetiteLabel => 'الرغبة في المخاطرة';

  @override
  String get wealthInvestmentStyleLabel => 'أسلوب الاستثمار';

  @override
  String get wealthMoneyPersonalityLabel => 'شخصية المال';

  @override
  String get wealthSpendingLabel => 'الإنفاق';

  @override
  String get wealthDebtProbStat => 'احتمالية الديون %';

  @override
  String get wealthInheritanceStat => 'الميراث %';

  @override
  String get wealthSuddenGainsStat => 'المكاسب المفاجئة %';

  @override
  String get wealthSpouseBoostStat => 'دعم الزوج/الزوجة %';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'احتمالية النجاح: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'فئة الثروة مدى الحياة';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'أساسي: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'الذروة: $value';
  }

  @override
  String get wealthIncomeWord => 'الدخل';

  @override
  String get wealthSourcesSuffix => 'المصادر';

  @override
  String get wealthInvestmentWord => 'الاستثمار';

  @override
  String get wealthMixSuffix => 'المزيج';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'مدفوع بواسطة $planet';
  }

  @override
  String get marriageScoresHeader => '💒 درجات الزواج';

  @override
  String get marriageOverallStat => 'الزواج\nالعام';

  @override
  String get marriageHarmonyStat => 'الانسجام\nالزوجي';

  @override
  String get marriageDomesticStabilityStat => 'الاستقرار\nالمنزلي';

  @override
  String get marriageLongevityStat => 'الديمومة';

  @override
  String get marriageSatisfactionStat => 'الرضا';

  @override
  String get marriageClarityStat => 'الوضوح';

  @override
  String get marriageWindowsTitle => 'نوافذ الزواج';

  @override
  String get marriagePhasesTitle => 'مراحل الزواج';

  @override
  String get marriageInLawRelationsStat => 'علاقات الأصهار';

  @override
  String get marriageFamilyHarmonyStat => 'الانسجام الأسري';

  @override
  String get marriageFertilityStat => 'الخصوبة';

  @override
  String get marriageHomeOwnershipStat => 'ملكية المنزل';

  @override
  String get marriageDivorceRiskStat => 'خطر الطلاق';

  @override
  String get marriageInfidelityStat => 'الخيانة الزوجية';

  @override
  String get marriageConflictStat => 'النزاع';

  @override
  String get marriageDistanceStat => 'المسافة';

  @override
  String get marriageSeekInPartnerTitle => '★ ابحث عنه في الشريك';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ تجنّبه في الشريك';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'التحقق: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'كاراكا الزوج/الزوجة';

  @override
  String get marriageDarakarakaDkLabel => 'Darakaraka (DK)';

  @override
  String get marriage7thWord => 'السابع';

  @override
  String get marriageSignLabel => 'البرج';

  @override
  String get marriageLordInLabel => 'السيد في';

  @override
  String get marriageStrengthLabel => 'القوة';

  @override
  String get marriageSpouseWord => 'الزوج/الزوجة';

  @override
  String get marriageProfileSuffix => 'الملف';

  @override
  String get marriageSpouseTraitsTitle => '★ سمات الزوج/الزوجة';

  @override
  String get marriageLikelyProfessionsTitle => '● المهن المحتملة';

  @override
  String get marriageHarmonyWord => 'الانسجام';

  @override
  String get marriageRadarSuffix => 'الرادار';

  @override
  String get marriagePhysicalLabel => 'الجسدي';

  @override
  String get marriageSharedValuesLabel => 'القيم المشتركة';

  @override
  String get marriageConflictResolutionLabel => 'حل الخلافات';

  @override
  String get marriageMangalDoshLabel => '⚠ Mangal Dosh';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'الشدة: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'الإلغاء: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'الطفل';

  @override
  String get multiChartTitleLove => 'الحب';

  @override
  String get multiChartTitleKarma => 'الكارما';

  @override
  String get multiChartTitleDefault => 'مخطط متعدد';

  @override
  String get multiChartSuffixProbability => 'الاحتمالية';

  @override
  String get multiChartSuffixCompatibility => 'التوافق';

  @override
  String get multiChartSuffixLinkage => 'الارتباط';

  @override
  String get multiChartSuffixReport => 'التقرير';

  @override
  String get multiChartParticipantsLabel => 'المشاركون';

  @override
  String get multiChartAnalysisWord => 'التحليل';

  @override
  String get multiChartConfidenceSuffix => 'درجة الثقة';

  @override
  String get multiChartQualityBadge => 'الجودة';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'حلّل تقرير التنجيم الفيدي هذا وقدّم رؤى مفصّلة:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'هذا تقرير متخصص في التنجيم الفيدي. يرجى تحليله بدقة وتقديم رؤى قابلة للتنفيذ:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'راجع تحليل التنجيم الفيدي هذا واشرح النتائج الرئيسية بلغة بسيطة:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'تم النسخ لـ $label!';
  }

  @override
  String get childProbTitle1 => 'احتمالية';

  @override
  String get childProbTitle2 => 'الإنجاب';

  @override
  String get childNumberOfChildrenHeader1 => 'عدد';

  @override
  String get childNumberOfChildrenHeader2 => 'الأطفال';

  @override
  String get childTimingHeader1 => 'التوقيت';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => 'البيت الخامس';

  @override
  String get analysisWord => 'التحليل';

  @override
  String get jupiterWord => 'المشتري';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja و Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'الدوشا';

  @override
  String get childVedicHeader1 => 'العلاجات';

  @override
  String get childVedicHeader2 => 'الفيدية';

  @override
  String get progenyProbabilityLabel => 'احتمالية الإنجاب';

  @override
  String get favorableWindowsLabel => 'النوافذ المواتية';

  @override
  String get partnerOneLabel => 'الشريك 1';

  @override
  String get partnerTwoLabel => 'الشريك 2';

  @override
  String get moonSignLabel => 'برج القمر';

  @override
  String get lordInDusthana => 'السيد في Dusthana';

  @override
  String get lordStrengthLabel => 'قوة السيد';

  @override
  String get houseStrengthLabel => 'قوة البيت';

  @override
  String get dignityLabel => 'المنزلة';

  @override
  String get directBadge => 'مستقيم';

  @override
  String get notCombustBadge => 'غير محترق';

  @override
  String get in5thHouseBadge => 'في البيت الخامس';

  @override
  String get aspects5thBadge => 'يوجّه جانبًا للخامس';

  @override
  String get no5thConnectionBadge => 'لا ارتباط بالخامس';

  @override
  String jupiterInSignHeading(String sign) {
    return 'المشتري في $sign';
  }

  @override
  String get d7LagnaLabel => 'طالع D7';

  @override
  String get d7FifthSignLabel => 'برج D7 الخامس';

  @override
  String get d7FifthLordLabel => 'سيد D7 الخامس';

  @override
  String get jupiterInD7Label => 'المشتري في D7';

  @override
  String get jupiterDignityLabel => 'منزلة المشتري';

  @override
  String get d7StrengthLabel => 'قوة D7';

  @override
  String get yesWord => 'نعم';

  @override
  String get noWord => 'لا';

  @override
  String get beejaSphutaTitle => 'BEEJA SPHUTA';

  @override
  String get kshetraSphutaTitle => 'KSHETRA SPHUTA';

  @override
  String get degreeLabel => 'الدرجة';

  @override
  String get signLordLabel => 'سيد البرج';

  @override
  String get presentInLabel => 'موجود في';

  @override
  String get netPenaltyLabel => 'صافي العقوبة';

  @override
  String get remedyGemstone => 'علاجات الأحجار الكريمة';

  @override
  String get remedyMantra => 'علاجات المانترا';

  @override
  String get remedyRitual => 'علاجات الطقوس';

  @override
  String get remedyLifestyle => 'علاجات نمط الحياة';

  @override
  String get remedyCharitable => 'علاجات العطاء الخيري';

  @override
  String copiedForName(String name) {
    return 'تم النسخ لـ $name!';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'فترة MD';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'فترة AD';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'الملاءمة';

  @override
  String factorPrefix(String factor) {
    return 'العامل: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'ينطبق على: $value';
  }

  @override
  String get qualityTag => 'الجودة';

  @override
  String get reliabilityVeryHigh => 'موثوقية عالية جدًا';

  @override
  String get reliabilityGuidanceLevel => 'قراءة إرشادية';

  @override
  String get karmaLinkTitle1 => 'الارتباط';

  @override
  String get karmaLinkTitle2 => 'الكرمي';

  @override
  String get karmaFoundationHeader1 => 'الأساس';

  @override
  String get karmaFoundationHeader2 => 'الكرمي';

  @override
  String get karmaPairwiseHeader1 => 'الارتباطات';

  @override
  String get karmaPairwiseHeader2 => 'الثنائية';

  @override
  String get karmaGroupHeader1 => 'النمط';

  @override
  String get karmaGroupHeader2 => 'الجماعي';

  @override
  String get karmaPastLifeHeader1 => 'أهداف';

  @override
  String get karmaPastLifeHeader2 => 'الحياة السابقة';

  @override
  String get karmaCurrentLifeHeader1 => 'تعلّم';

  @override
  String get karmaCurrentLifeHeader2 => 'الحياة الحالية';

  @override
  String get karmaDebtsHeader2 => 'الديون';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'التوقيت';

  @override
  String get karmaDeepAuditHeader1 => 'جدول';

  @override
  String get karmaDeepAuditHeader2 => 'التدقيق العميق';

  @override
  String get karmaHeroLabel => 'الارتباط الكرمي من حياة سابقة';

  @override
  String get karmaKetuMastery => 'إتقان Ketu';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'الإله الحارس';

  @override
  String get masteryScoreLabel => 'درجة الإتقان';

  @override
  String get karmaRahuGrowth => 'نمو Rahu';

  @override
  String get growthScoreLabel => 'درجة النمو';

  @override
  String get karmaAtmakaraka => 'Atmakaraka';

  @override
  String get karmaSaturnKarma => 'كارما زحل';

  @override
  String get karma12thHouse => 'البيت الثاني عشر';

  @override
  String get karma9thHousePunya => 'بونيا البيت التاسع';

  @override
  String get bhavaScoreLabel => 'درجة Bhava';

  @override
  String get karmaD60Signature => 'بصمة D60';

  @override
  String get depthScoreLabel => 'درجة العمق';

  @override
  String get linkageStrengthLabel => 'قوة الارتباط';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'عوامل الارتباط ($count نشطة)';
  }

  @override
  String get factorColumnLabel => 'العامل';

  @override
  String get weightColumnLabel => 'الوزن';

  @override
  String get meaningColumnLabel => 'المعنى';

  @override
  String get statusColumnLabel => 'الحالة';

  @override
  String get karmaPastLifeConnection => 'الارتباط من الحياة السابقة';

  @override
  String get karmaCurrentLifeDynamic => 'الديناميكية في الحياة الحالية';

  @override
  String get karmaWhatTheyTeach => 'ما يعلّمانه لبعضهما البعض';

  @override
  String get karmaGroupThemeHeader => 'الموضوع الكرمي للمجموعة';

  @override
  String get karmaSharedSettingHeader => 'إطار الحياة السابقة المشترك';

  @override
  String get karmaCollectiveKetuHeader => 'نمط Ketu الجماعي';

  @override
  String get karmaCollectiveRahuHeader => 'نمط Rahu الجماعي';

  @override
  String get housesPrefixLabel => 'البيوت: ';

  @override
  String get signsPrefixLabel => 'البروج: ';

  @override
  String get karmicCohesionLabel => 'التماسك الكرمي';

  @override
  String get karmaGroupSoulContractHeader => 'عقد الروح الجماعي';

  @override
  String get goalLabel => 'الهدف';

  @override
  String get karmaSharedGoalHeader => 'هدف الحياة السابقة المشترك';

  @override
  String get howToGrowHeader => 'كيف تنمو';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'الدرس الجماعي المشترك';

  @override
  String get karmaMutualTeachingHeader => 'خريطة التعليم المتبادل';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'ستظهر ديناميكيات التعليم مع تعمّق الروابط الكرمية.';

  @override
  String get typeFieldLabel => 'النوع';

  @override
  String get basisFieldLabel => 'الأساس';

  @override
  String get resolutionPathHeader => 'مسار التسوية';

  @override
  String dashaTimingPrefix(String value) {
    return 'توقيت Dasha: $value';
  }

  @override
  String get mutualDebtsHeader => 'الديون المتبادلة';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'التواريخ';

  @override
  String get groupKarmicWindowHeader => 'النافذة الكرمية للمجموعة';

  @override
  String parametersAuditedHeading(int count) {
    return '$count معيار تم فحصه';
  }

  @override
  String get valuePrefixLabel => 'القيمة: ';

  @override
  String weightPrefix(String value) {
    return 'الوزن: $value';
  }

  @override
  String get loveCompatTitle1 => 'التوافق';

  @override
  String get loveCompatTitle2 => 'العاطفي';

  @override
  String get loveAttractionHeader1 => 'الانجذاب';

  @override
  String get loveAttractionHeader2 => 'والكيمياء';

  @override
  String get loveEmotionalHeader1 => 'الانسجام';

  @override
  String get loveEmotionalHeader2 => 'العاطفي';

  @override
  String get loveMentalHeader1 => 'التناغم';

  @override
  String get loveMentalHeader2 => 'الفكري';

  @override
  String get lovePassionHeader1 => 'الشغف';

  @override
  String get lovePassionHeader2 => 'والجانب الجسدي';

  @override
  String get loveLongtermHeader1 => 'طويل الأمد';

  @override
  String get loveKarmicHeader1 => 'الرابطة العاطفية';

  @override
  String get loveKarmicHeader2 => 'الكرمية';

  @override
  String get loveChallengesHeader1 => 'التحديات';

  @override
  String get loveChallengesHeader2 => 'والاحتكاك';

  @override
  String get loveTimingHeader1 => 'توقيت الحب';

  @override
  String get loveRelationshipHeader1 => 'ديناميكيات';

  @override
  String get loveRelationshipHeader2 => 'العلاقة';

  @override
  String get loveRemediesHeader1 => 'العلاجات';

  @override
  String get loveRemediesHeader2 => 'والإرشاد';

  @override
  String get loveCompatHeroLabel => 'التوافق العاطفي';

  @override
  String get loveChipAttraction => 'الانجذاب';

  @override
  String get loveChipPassion => 'الشغف';

  @override
  String get loveChipChallenge => 'التحدي';

  @override
  String get venusSignLabel => 'برج الزهرة';

  @override
  String get attractionScoreLabel => 'درجة الانجذاب';

  @override
  String get activeContactsLabel => 'الاتصالات النشطة';

  @override
  String get magneticPullLabel => 'الجاذبية المغناطيسية';

  @override
  String get initialAttractionLabel => 'الانجذاب الأولي';

  @override
  String get emotionalScoreLabel => 'الدرجة العاطفية';

  @override
  String get elementMatchLabel => 'توافق العنصر';

  @override
  String get harmonyLabel => 'الانسجام';

  @override
  String get kootaYoni => 'YONI';

  @override
  String get kootaGana => 'GANA';

  @override
  String get kootaTara => 'TARA';

  @override
  String get doshaPresentBadge => 'توجد دوشا';

  @override
  String get noDoshaBadge => 'لا توجد دوشا';

  @override
  String get axisLabel => 'المحور';

  @override
  String get mentalScoreLabel => 'الدرجة الفكرية';

  @override
  String get mercuryDynamicsLabel => 'ديناميكيات عطارد';

  @override
  String get communicationStyleLabel => 'توافق أسلوب التواصل';

  @override
  String get intellectualConnectionLabel => 'الاتصال الفكري';

  @override
  String get passionScoreLabel => 'درجة الشغف';

  @override
  String get marsVenusLabel => 'تفاعل المريخ والزهرة';

  @override
  String get physicalChemistryLabel => 'الكيمياء الجسدية';

  @override
  String get yoniCompatLabel => 'توافق YONI';

  @override
  String get longtermScoreLabel => 'الدرجة طويلة الأمد';

  @override
  String get seventhHouseSynastryLabel => 'توافق البيت السابع';

  @override
  String get commitmentPotentialLabel => 'إمكانية الالتزام';

  @override
  String get jupiterBlessingLabel => 'بركة المشتري';

  @override
  String get d9NavamsaResonanceLabel => 'توافق D9 Navamsa';

  @override
  String get saturnLongevityLabel => 'طول أمد زحل';

  @override
  String get karmicScoreLabel => 'الدرجة الكرمية';

  @override
  String get darakarakaLinkLabel => 'رابط Darakaraka';

  @override
  String get sourceLabel => 'المصدر';

  @override
  String get emotionalGiverReceiverLabel => 'المانح/المتلقي العاطفي';

  @override
  String get powerBalanceLabel => 'توازن القوة';

  @override
  String get growthDynamicLabel => 'ديناميكية النمو';

  @override
  String get addressesLabel => 'يعالج';

  @override
  String get loveScoresLabel => 'درجات الحب';

  @override
  String get loveCapacityLabel => 'قدرة\nالحب';

  @override
  String get emotionalAvailabilityLabel => 'التوفر\nالعاطفي';

  @override
  String get romanticAttractionLabel => 'الانجذاب\nالرومانسي';

  @override
  String get commitmentWord => 'الالتزام';

  @override
  String get intimacyWord => 'الحميمية';

  @override
  String get fidelityWord => 'الوفاء';

  @override
  String get loveProfileTitle => 'ملف الحب';

  @override
  String get loveStyleLabel => 'أسلوب الحب';

  @override
  String get attractionStyleLabel => 'أسلوب الانجذاب';

  @override
  String get lovePathLabel => 'مسار الحب';

  @override
  String get currentPhaseLabel => 'المرحلة الحالية';

  @override
  String get commitmentStyleLabel => 'أسلوب الالتزام';

  @override
  String get loveWord => 'الحب';

  @override
  String get karakasWord => 'الكاراكات';

  @override
  String get attractedToLabel => 'ينجذب إلى';

  @override
  String get whatPartnerSeesLabel => 'ما يراه الشريك';

  @override
  String get romancePatternTitle => 'نمط الرومانسية';

  @override
  String get firstLoveAgeLabel => 'عمر الحب الأول';

  @override
  String get relationshipCountLabel => 'عدد العلاقات';

  @override
  String get avgDurationLabel => 'متوسط المدة';

  @override
  String get breakupTriggerLabel => 'محفز الانفصال';

  @override
  String get heartbreakRecoveryLabel => 'التعافي من خيبة القلب';

  @override
  String get loveTrendTitle => 'اتجاه الحب';

  @override
  String get newLoveWindowsTitle => 'نوافذ الحب الجديد';

  @override
  String get loveBlocksTitle => 'عوائق الحب';

  @override
  String get activeBlocksLabel => 'العوائق النشطة';

  @override
  String get loveMarriagePctLabel => 'نسبة زواج الحب %';

  @override
  String get heartbreakVulnLabel => 'قابلية خيبة القلب';

  @override
  String get selfSabotageLabel => 'تخريب الذات';

  @override
  String get emotionalIqLabel => 'معدل الذكاء العاطفي';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'التحقق: $pct%';
  }

  @override
  String get languagesWord => 'اللغات';

  @override
  String get givesLabel => 'يعطي';

  @override
  String get receivesLabel => 'يستقبل';

  @override
  String get idealWord => 'المثالي';

  @override
  String get partnerWord => 'الشريك';

  @override
  String get seekTheseTraitsLabel => 'ابحث عن هذه السمات';

  @override
  String get dealbreakersLabel => 'أسباب القطيعة';

  @override
  String get propertyScoresLabel => 'درجات الممتلكات';

  @override
  String get acquisitionCapacityLabel => 'القدرة على\nالاقتناء';

  @override
  String get homeOwnershipPctLabel => 'ملكية\nالمنزل %';

  @override
  String get reWealthPotentialLabel => 'إمكانية الثروة\nالعقارية';

  @override
  String get rentalWord => 'الإيجار';

  @override
  String get vehiclesWord => 'المركبات';

  @override
  String get landPctLabel => 'الأرض %';

  @override
  String get propertyProfileTitle => 'ملف الممتلكات';

  @override
  String get karmaTypeLabel => 'نوع الكارما';

  @override
  String get environmentLabel => 'البيئة';

  @override
  String get styleLabel => 'الأسلوب';

  @override
  String get sizeLabel => 'الحجم';

  @override
  String get locationLabel => 'الموقع';

  @override
  String get actionNext12mLabel => 'الإجراء خلال 12 شهرًا القادمة';

  @override
  String get propertyWord => 'الممتلكات';

  @override
  String get propertyYogasTitle => 'يوغات الممتلكات';

  @override
  String get drainsLabel => 'الاستنزافات';

  @override
  String get boostersLabel => 'المعززات';

  @override
  String get propertyTrendTitle => 'اتجاه الممتلكات';

  @override
  String get buyingWindowsTitle => 'نوافذ الشراء';

  @override
  String get constructionWindowsTitle => 'نوافذ البناء';

  @override
  String get maternalInherPctLabel => 'الميراث من الأم %';

  @override
  String get paternalInherPctLabel => 'الميراث من الأب %';

  @override
  String get multiHomePctLabel => 'منازل متعددة %';

  @override
  String get investmentPctLabel => 'الاستثمار %';

  @override
  String get vehicleProfileTitle => 'ملف المركبات';

  @override
  String get countLabel => 'العدد';

  @override
  String get firstAgeLabel => 'العمر الأول';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get luxuryLabel => 'الفخامة';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'العدد مدى الحياة: $count · التحقق: $pct%';
  }

  @override
  String get pressureWord => 'الضغط';

  @override
  String get protectionWord => 'الحماية';

  @override
  String get astrologicalWord => 'تنجيمي';

  @override
  String get keyRisksHeader1 => 'أبرز';

  @override
  String get keyRisksHeader2 => 'المخاطر';

  @override
  String get reportCopiedShort => 'تم نسخ التقرير!';

  @override
  String get keyScoresLabel => 'الدرجات الرئيسية';

  @override
  String allScoresCountLabel(int count) {
    return 'جميع الدرجات ($count)';
  }

  @override
  String get windowsWord => 'النوافذ';

  @override
  String get genericFailedMsg => 'فشل';

  @override
  String get unknownWord => 'غير معروف';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'اختر 2-$max مخططات';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'اختر $max مخططات';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'جارٍ تشغيل تحليل $label...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'اختر من 2 إلى $max مخططات لتحليل الروابط الكرمية';
  }

  @override
  String get pickMaleFemaleHint => 'اختر مخططًا لذكر وأنثى';

  @override
  String get personOneLabel => 'الشخص 1';

  @override
  String get personTwoLabel => 'الشخص 2';

  @override
  String get analysisFailedMsg => 'فشل التحليل';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'حلّل $count مخططات';
  }

  @override
  String get contextGeneralLabel => 'عام';

  @override
  String get contextLoveLabel => 'الحب';

  @override
  String get contextBusinessLabel => 'الأعمال';

  @override
  String get contextFamilyLabel => 'الأسرة';

  @override
  String get contextTeamLabel => 'الفريق';

  @override
  String get contextFriendshipLabel => 'الصداقة';

  @override
  String get relationshipIntelTitle => 'ذكاء العلاقات';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'جارٍ تحليل $count مخططات...';
  }

  @override
  String get relationshipContextLabel => 'سياق العلاقة';

  @override
  String get kundliMilanReportTitle => 'تقرير Kundli Milan';

  @override
  String get runningMilanAnalysisLabel => 'جارٍ تشغيل تحليل Milan...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return 'تم اختيار $count/2';
  }

  @override
  String get runMilanAnalysisBtn => 'تشغيل تحليل Milan';

  @override
  String get noChartsCreateFirst => 'لا توجد مخططات. أنشئ مخطط ميلاد أولاً.';

  @override
  String get selectBirthChartAnalyze => 'اختر مخطط ميلاد للتحليل';

  @override
  String get doshAnalysis => 'تحليل الدوشا';

  @override
  String doshActiveCount(Object active, Object total) {
    return '$active نشطة / $total تم فحصها';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return '$active نشطة / $total يوغا تم فحصها';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'اليوغات النشطة ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'إخفاء اليوغات غير النشطة ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'عرض اليوغات غير النشطة ($count)';
  }

  @override
  String get loadFailed => 'فشل';

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
    return 'الفترات الفرعية لـ $planet';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'سيد الميلاد: $lord • الرصيد: $balance سنوات';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • الرصيد: $balance سنوات';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years سنوات';
  }

  @override
  String get dashaCurrentPeriod => 'فترة Dasha الحالية';

  @override
  String dashaAsOf(Object date) {
    return 'اعتبارًا من: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'اليوغات النشطة في الفترة الحالية ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'الدوشات النشطة في الفترة الحالية ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'لم يتم تفعيل أي يوغا';

  @override
  String get dashaNoDoshasTriggered => 'لم يتم تفعيل أي دوشا';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'الوجود المادي، كل الأمور';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'الثروة والمال';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'الإخوة والشجاعة';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'الممتلكات والسكن والحظ';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'الشهرة والسلطة والقوة';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'المشاكل الصحية';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'الأطفال والأحفاد';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'المشاكل المفاجئة والتقاضي';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'الزواج والزوج/الزوجة والدارما';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'المسيرة المهنية والمهنة';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'الموت والدمار';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'الوالدان وأقارب الدم';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'المركبات والراحة والمتع';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'الأمور الروحية والدينية';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'التعلم والمعرفة والتعليم';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'نقاط القوة والضعف والطبيعة';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'الشرور، اللاوعي، العقاب';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'الميمون وغير الميمون (من جهة الأم)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'جميع الأمور (من جهة الأب)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'كارما الحياة السابقة — الأكثر أهمية';

  @override
  String get lifeAreaCareer => 'المسيرة المهنية';

  @override
  String get lifeAreaWealth => 'الثروة';

  @override
  String get lifeAreaMarriage => 'الزواج';

  @override
  String get lifeAreaHealth => 'الصحة';

  @override
  String get lifeAreaSpirituality => 'الروحانية';

  @override
  String lifeAreaGrade(Object grade) {
    return 'الدرجة: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'العوامل:';

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
    return 'خط الطول: $value°';
  }

  @override
  String get chakraOverallHealth => 'الصحة العامة';

  @override
  String get careerWord => 'المسيرة المهنية';

  @override
  String get failedToLoad => 'فشل التحميل';

  @override
  String get kundliAscendantLagna => 'الطالع (Lagna)';

  @override
  String get kundliMoonSignRashi => 'برج القمر (Rashi)';

  @override
  String get kundliSunSign => 'برج الشمس';

  @override
  String kundliEngineLabel(Object engine) {
    return 'المحرك: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'الدرجة: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'سيد Nakshatra: $lord  •  المنزلة: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'مخطط $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'مخطط $base';
  }

  @override
  String get careerSummary => 'ملخص المسيرة المهنية';

  @override
  String get phase => 'المرحلة';

  @override
  String get confidenceLabel => 'درجة الثقة';

  @override
  String get careerScores => 'درجات المسيرة المهنية';

  @override
  String get stabilityLabel => 'الاستقرار';

  @override
  String get growthLabel => 'النمو';

  @override
  String get gradeExcellent => 'ممتاز';

  @override
  String get gradeGood => 'جيد';

  @override
  String get gradeAverage => 'متوسط';

  @override
  String get gradeBelowAvg => 'دون المتوسط';

  @override
  String get gradeWeak => 'ضعيف';

  @override
  String get careerTypeDomain => 'المسيرة المهنية والمجال';

  @override
  String get careerTimeline => 'الجدول الزمني للمسيرة المهنية';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'اقتراحات التحسين';

  @override
  String get chartDetails => 'تفاصيل المخطط';

  @override
  String get keyHousesCareer => 'البيوت الرئيسية (المسيرة المهنية)';

  @override
  String get keyCareerPlanets => 'الكواكب الرئيسية للمسيرة المهنية';

  @override
  String get empty => 'فارغ';

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
  String get charGroupCorePersonality => 'الشخصية الجوهرية';

  @override
  String get charGroupTrustHonesty => 'الثقة والصدق';

  @override
  String get charGroupLoyaltyCommitment => 'الوفاء والالتزام';

  @override
  String get charGroupStrategicPrivacy => 'الاستراتيجية والخصوصية';

  @override
  String get charGroupFinancial => 'المالي';

  @override
  String get charGroupAngerConflict => 'الغضب والنزاع';

  @override
  String get charGroupMoralDharmic => 'الأخلاقي والدارمي';

  @override
  String get charGroupIntellectCommunication => 'الذكاء والتواصل';

  @override
  String get charGroupEmotionalProfile => 'الملف العاطفي';

  @override
  String get charGroupMentalHealth => 'الصحة النفسية';

  @override
  String get charGroupRomantic => 'الرومانسي';

  @override
  String get charGroupMarriageFamily => 'الزواج والأسرة';

  @override
  String get charGroupOverallLife => 'الحياة العامة';

  @override
  String get grahaDrishti => 'Graha Drishti (جوانب الكواكب)';

  @override
  String get grahaDrishtiSubtitle => 'من يوجّه جانبًا لمن (%)';

  @override
  String get lagnaAspectsReceived => 'الجوانب المستقبلة في الطالع';

  @override
  String get rashiDrishti => 'Rashi Drishti (جوانب البروج)';

  @override
  String get shadbalaRupas => 'روبا';

  @override
  String get bhavaHouse1 => 'الذات / الجسد';

  @override
  String get bhavaHouse2 => 'الثروة / الأسرة';

  @override
  String get bhavaHouse3 => 'الإخوة / الشجاعة';

  @override
  String get bhavaHouse4 => 'المنزل / الأم';

  @override
  String get bhavaHouse5 => 'الأطفال / الذكاء';

  @override
  String get bhavaHouse6 => 'الأعداء / الصحة';

  @override
  String get bhavaHouse7 => 'الزواج / الشريك';

  @override
  String get bhavaHouse8 => 'طول العمر';

  @override
  String get bhavaHouse9 => 'الحظ / المرشد';

  @override
  String get bhavaHouse10 => 'المسيرة المهنية / الأب';

  @override
  String get bhavaHouse11 => 'المكاسب / الأصدقاء';

  @override
  String get bhavaHouse12 => 'الخسارة / التحرر';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • السيد: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'الإجمالي: $total rekhas (متوسط البرج = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'الإجمالي: $total rekhas • في البرج الميلادي: $score';
  }

  @override
  String get today => 'اليوم';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (درجات الانتقال) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'قمر الميلاد: $sign';
  }

  @override
  String get gocharBest => 'الأفضل';

  @override
  String get gocharWorst => 'الأسوأ';

  @override
  String copiedOpening(Object ai) {
    return 'تم النسخ! جارٍ فتح $ai...';
  }

  @override
  String get openLink => 'فتح ↗';

  @override
  String get discussReportWithAI => 'ناقش هذا التقرير مع الذكاء الاصطناعي';

  @override
  String get reliabilityHigh => 'موثوقية عالية';

  @override
  String get reliabilityModerate => 'موثوقية متوسطة';

  @override
  String get reliabilityLow => 'أقل — إرشادي فقط';

  @override
  String get reliabilityGoodEdu => 'موثوقية جيدة · تم التحقق عبر D-24';

  @override
  String get relationshipWord => 'العلاقة';

  @override
  String get intelligenceWord => 'الذكاء';

  @override
  String get relationshipIntelligence => 'ذكاء العلاقات';

  @override
  String get typeLabel => 'النوع';

  @override
  String get trustLabel => 'الثقة';

  @override
  String get dhokaRisk => 'خطر الخيانة';

  @override
  String get powerLabel => 'القوة';

  @override
  String get integrity => 'النزاهة';

  @override
  String get warmth => 'الدفء';

  @override
  String get trustWord => 'الثقة';

  @override
  String get assertLabel => 'الحزم';

  @override
  String get character => 'الشخصية';

  @override
  String get love => 'الحب';

  @override
  String get businessWord => 'الأعمال';

  @override
  String get karmic => 'كرمي';

  @override
  String get enmityRisk => 'خطر العداوة';

  @override
  String get hdrChartProfiles => 'ملفات المخططات';

  @override
  String get hdrPairwiseAnalysis => 'التحليل الثنائي';

  @override
  String get hdrCriticalPatterns => 'الأنماط الحرجة';

  @override
  String get hdrGroupRecommendations => 'توصيات المجموعة';

  @override
  String get sharedPractices => 'الممارسات المشتركة';

  @override
  String get hdrIndividualGuidance => 'إرشادات فردية';

  @override
  String get growthAreas => 'مجالات النمو';

  @override
  String get hdrCoreTheme => 'الموضوع الجوهري';

  @override
  String get growthOriented => 'موجّه نحو النمو';

  @override
  String get groupTheme => 'موضوع المجموعة';

  @override
  String get compatibility => 'التوافق';

  @override
  String get unifiedScoreLabel => 'الدرجة الموحدة';

  @override
  String get ashtakoot => 'ASHTAKOOT';

  @override
  String get probability => 'الاحتمالية';

  @override
  String get hdrAshtakootSummary => 'ملخص Ashtakoot';

  @override
  String get hdrGunBreakdown => 'تفصيل الـ8 Gun';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'تقاطع المخططات D-9';

  @override
  String get d9Compatibility => 'توافق D-9';

  @override
  String get hdrDomainCompatibility => 'التوافق حسب المجال';

  @override
  String get emotional => 'العاطفي';

  @override
  String get intellectual => 'الفكري';

  @override
  String get spiritual => 'الروحي';

  @override
  String get financial => 'المالي';

  @override
  String get domestic => 'المنزلي';

  @override
  String get communicationWord => 'التواصل';

  @override
  String get sharedDharma => 'الدارما المشتركة';

  @override
  String get familyCreation => 'تكوين الأسرة';

  @override
  String get hdrMarriageTiming => 'توقيت الزواج';

  @override
  String get jointMarriageWindows => 'نوافذ الزواج المشتركة';

  @override
  String get engagementWindows => 'نوافذ الخطوبة';

  @override
  String get recommendedLabel => 'موصى به';

  @override
  String get hdrKeyRisks => 'أبرز المخاطر';

  @override
  String get hdrFinalVerdict => 'الحكم النهائي';

  @override
  String get marriageVerdict => 'حكم الزواج';

  @override
  String get educationWord => 'التعليم';

  @override
  String get learningSuffix => 'والتعلم';

  @override
  String get coreEducationScores => 'درجات التعليم الأساسية';

  @override
  String get academicSuccess => 'النجاح الأكاديمي';

  @override
  String get learningCapacity => 'القدرة على التعلم';

  @override
  String get memory => 'الذاكرة';

  @override
  String get intelligence => 'الذكاء';

  @override
  String get research => 'البحث';

  @override
  String get hdrIntellectualProfile => 'الملف الفكري';

  @override
  String get learningSignature => 'بصمة التعلم';

  @override
  String get hdrSubjectKaraka => 'كاراكا المواد الدراسية';

  @override
  String get hdrHouseFoundations => 'أسس البيوت';

  @override
  String get hdrMercuryJupiter => 'عطارد والمشتري';

  @override
  String get hdrEducationYogas => 'يوغات التعليم';

  @override
  String get hdrDivisionalValidation => 'التحقق التقسيمي';

  @override
  String get standing => 'المكانة';

  @override
  String get hdrSubjectRanking => 'ترتيب المواد الدراسية';

  @override
  String get hdrDegreeLikelihood => 'احتمالية الدرجة العلمية';

  @override
  String get hdrStudyPeriods => 'فترات الدراسة';

  @override
  String get earlySchooling => 'التعليم المبكر';

  @override
  String get higherEducation => 'التعليم العالي';

  @override
  String get postgradResearch => 'الدراسات العليا · البحث';

  @override
  String get hdrLearningPreferences => 'تفضيلات التعلم';

  @override
  String get hdrChallengesGifts => 'التحديات والمواهب';

  @override
  String get challenges => 'التحديات';

  @override
  String get cognitiveGifts => 'المواهب المعرفية';

  @override
  String get naturalAbilities => 'القدرات الطبيعية';

  @override
  String get hdrSaraswatiRemedies => 'علاجات Saraswati';

  @override
  String get studentVerdict => 'حكم الطالب';

  @override
  String get educationCareerLinkage => 'الرابط بين التعليم والمسيرة المهنية';

  @override
  String get startupSuffix => 'والمشاريع الناشئة';

  @override
  String get coreBusinessScores => 'درجات الأعمال الأساسية';

  @override
  String get overallBusiness => 'الأعمال العامة';

  @override
  String get ventureSuccess => 'نجاح المشروع';

  @override
  String get eleventhHouse => 'البيت الحادي عشر';

  @override
  String get gains => 'المكاسب';

  @override
  String get investor => 'المستثمر';

  @override
  String get hdrFounderArchetype => 'نموذج المؤسس';

  @override
  String get hdrTenthEleventhHouses => 'البيتان العاشر والحادي عشر';

  @override
  String get hdrBusinessYogas => 'يوغات الأعمال';

  @override
  String get hdrRecommendedDomains => 'المجالات الموصى بها';

  @override
  String get hdrBusinessStyle => 'أسلوب العمل';

  @override
  String get hdrFounderSkills => 'مهارات المؤسس';

  @override
  String get hdrFundingProfile => 'ملف التمويل';

  @override
  String get recommendedPath => 'المسار الموصى به';

  @override
  String get investorAttract => 'جاذبية المستثمرين';

  @override
  String get familyBacking => 'دعم الأسرة';

  @override
  String get hybridViability => 'جدوى المزيج';

  @override
  String get launchWindow => 'نافذة الإطلاق';

  @override
  String get scaleWindow => 'نافذة التوسع';

  @override
  String get hdrBusinessRisks => 'مخاطر الأعمال';

  @override
  String get recoveryCapacity => 'قدرة التعافي';

  @override
  String get hdrRemediesSolutions => 'العلاجات والحلول';

  @override
  String get aiConnectionLost => 'انقطع الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get aiSomethingWrong => 'حدث خطأ ما';

  @override
  String get aiNoResponse => 'لا توجد استجابة';

  @override
  String get aiConnectionError => 'خطأ في الاتصال. يرجى المحاولة مرة أخرى.';

  @override
  String get aiAutoDetect => 'كشف تلقائي';

  @override
  String aiAutoArrow(String lang) {
    return 'تلقائي ← $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'اللغة: $lang';
  }

  @override
  String get aiNoBirthCharts => 'لم يتم العثور على مخططات ميلاد';

  @override
  String get aiCreateChartFirst =>
      'أنشئ مخطط ميلاد أولاً للمحادثة مع الذكاء الاصطناعي';

  @override
  String get aiSelectChartBegin => 'اختر مخطط ميلاد لبدء التحليل';

  @override
  String aiAnalyzingName(String name) {
    return 'جارٍ تحليل: $name';
  }

  @override
  String get aiChange => 'تغيير';

  @override
  String get aiAnalyzingChart => 'جارٍ تحليل مخططك...';

  @override
  String get aiAskStarsHint => 'اسأل النجوم عن أي شيء...';

  @override
  String get aiSuggestedFollowups => 'أسئلة متابعة مقترحة';

  @override
  String get aiThinking => 'جارٍ التفكير...';

  @override
  String get aiThanks => 'شكرًا!';

  @override
  String get aiFeedbackNoted => 'تم تسجيل ملاحظتك';

  @override
  String get svcAll => 'الكل';

  @override
  String get svcNoServices => 'لا توجد خدمات متاحة';

  @override
  String get svcFree => 'مجاني';

  @override
  String get astroFailedStartCall => 'فشل بدء المكالمة';

  @override
  String get astroFailedStartChat => 'فشل بدء المحادثة';

  @override
  String astroErrorDetail(String error) {
    return 'خطأ: $error';
  }

  @override
  String get astroExperience => 'الخبرة';

  @override
  String get astroSessions => 'الجلسات';

  @override
  String get astroMinutes => 'الدقائق';

  @override
  String get astroAbout => 'نبذة';

  @override
  String get astroLanguages => 'اللغات';

  @override
  String get astroRateCard => 'بطاقة الأسعار';

  @override
  String get astroVoice => 'الصوت';

  @override
  String astroReviews(int count) {
    return 'التقييمات ($count)';
  }

  @override
  String get astroNoReviews => 'لا توجد تقييمات بعد';

  @override
  String get astroAnonymous => 'مجهول';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك\nرابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'إعادة إرسال الرابط';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'رحلتك الكونية تنتظرك';

  @override
  String get home => 'الرئيسية';

  @override
  String get astrologers => 'المنجمون';

  @override
  String get services => 'الخدمات';

  @override
  String get wallet => 'المحفظة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get live => 'بث مباشر';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'محادثة';

  @override
  String get call => 'مكالمة';

  @override
  String get video => 'فيديو';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get phone => 'الهاتف';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get backToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get continueGoogle => 'المتابعة باستخدام Google';

  @override
  String get required => 'مطلوب';

  @override
  String get minSixChars => '6 أحرف على الأقل';

  @override
  String get passwordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get validEmailRequired => 'يلزم بريد إلكتروني صالح';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get signupFailed => 'فشل إنشاء الحساب';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get todaysHoroscope => 'توقعات اليوم';

  @override
  String get todaysRashi => 'برج اليوم';

  @override
  String get tapDetails => 'اضغط للتفاصيل';

  @override
  String get allServices => 'جميع الخدمات';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get topAstrologers => 'أفضل المنجمين';

  @override
  String get onlineExperts => 'خبراء متصلون جاهزون للاستشارة';

  @override
  String get searchAstrologers => 'ابحث عن منجمين...';

  @override
  String get noAstrologersFound => 'لم يتم العثور على منجمين';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get busy => 'مشغول';

  @override
  String get perMin => '/دقيقة';

  @override
  String get noCharts => 'لا توجد مخططات ميلاد بعد';

  @override
  String get createFirst => 'أنشئ Janam Kundli الأول الخاص بك';

  @override
  String get createChart => 'إنشاء مخطط';

  @override
  String get newBirthChart => 'مخطط ميلاد جديد';

  @override
  String get clientName => 'اسم العميل';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get other => 'آخر';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get timeOfBirth => 'وقت الميلاد';

  @override
  String get birthPlace => 'مكان الميلاد';

  @override
  String get birthPlaceHint => 'اكتب اسم المدينة للبحث...';

  @override
  String get generateKundli => 'إنشاء Kundli';

  @override
  String get birthChartCreated => 'تم إنشاء مخطط الميلاد!';

  @override
  String get deleteChart => 'حذف المخطط؟';

  @override
  String get cannotUndo => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get primary => 'أساسي';

  @override
  String get viewKundli => 'عرض Kundli';

  @override
  String get completeBirthChart => 'مخطط الميلاد الكامل';

  @override
  String get birthDetails => 'تفاصيل الميلاد';

  @override
  String get name => 'الاسم';

  @override
  String get dob => 'تاريخ الميلاد';

  @override
  String get tob => 'وقت الميلاد';

  @override
  String get place => 'المكان';

  @override
  String get summary => 'الملخص';

  @override
  String get planets => 'الكواكب';

  @override
  String get divisions => 'الأقسام';

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
  String get aspects => 'الجوانب';

  @override
  String get lifeAreas => 'مجالات الحياة';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'الشاكرات';

  @override
  String get dashaActive => 'Dasha النشطة';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'القمر';

  @override
  String get sun => 'الشمس';

  @override
  String get premiumSection => 'القسم المميز';

  @override
  String get unlockReading => 'افتح هذه القراءة لعرض التحليل التفصيلي.';

  @override
  String get unlock => 'فتح';

  @override
  String get retrograde => 'تراجعي';

  @override
  String get combust => 'محترق';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'في شرف';

  @override
  String get debilitated => 'في وهن';

  @override
  String get addBalance => 'إضافة رصيد';

  @override
  String get amount => 'المبلغ';

  @override
  String get walletBalance => 'رصيد المحفظة';

  @override
  String get recharge => 'إعادة الشحن';

  @override
  String get bonus => 'مكافأة';

  @override
  String get serviceLabel => 'الخدمة';

  @override
  String get refund => 'استرداد';

  @override
  String get noTransactions => 'لا توجد معاملات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get savedAstrologers => 'المنجمون المحفوظون';

  @override
  String get noSavedAstrologers => 'لا يوجد منجمون محفوظون بعد';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get communicationHistory => 'سجل التواصل';

  @override
  String get chatHistory => 'سجل المحادثات';

  @override
  String get callHistory => 'سجل المكالمات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get chatMessages => 'رسائل المحادثة';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get sessionEnded => 'انتهت الجلسة';

  @override
  String get endChat => 'إنهاء المحادثة؟';

  @override
  String get endChatConfirm => 'هل أنت متأكد أنك تريد إنهاء جلسة المحادثة هذه؟';

  @override
  String get sendPhoto => 'إرسال صورة';

  @override
  String get sendPDF => 'إرسال ملف PDF';

  @override
  String get upload => 'رفع';

  @override
  String get fileNotFound => 'الملف غير موجود';

  @override
  String get voiceCall => 'مكالمة صوتية';

  @override
  String get videoCall => 'مكالمة فيديو';

  @override
  String get ringing => 'جارٍ الاتصال...';

  @override
  String get connected => 'متصل';

  @override
  String get endCall => 'إنهاء المكالمة';

  @override
  String get mute => 'كتم الصوت';

  @override
  String get unmute => 'إلغاء كتم الصوت';

  @override
  String get speaker => 'مكبر الصوت';

  @override
  String get camera => 'الكاميرا';

  @override
  String get flip => 'قلب الكاميرا';

  @override
  String get liveStreams => 'البث المباشر';

  @override
  String get noLiveStreams => 'لا يوجد بث مباشر حاليًا';

  @override
  String get astrologerUnavailable => 'المنجم غير متاح. جارٍ إنهاء البث.';

  @override
  String get streamEnded => 'انتهى البث';

  @override
  String get superChat => 'محادثة مميزة';

  @override
  String get sendGift => 'إرسال هدية';

  @override
  String get goBack => 'رجوع';

  @override
  String get appPermissions => 'أذونات التطبيق';

  @override
  String get grantPermissions => 'منح الأذونات';

  @override
  String get skipForNow => 'تخطَّ الآن';

  @override
  String get microphone => 'الميكروفون';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get storage => 'التخزين';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get send => 'إرسال';

  @override
  String get refresh => 'تحديث';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get myDetails => 'بياناتي';

  @override
  String get myKundlis => 'مخططاتي (Kundlis)';

  @override
  String get walletRecharge => 'المحفظة والشحن';

  @override
  String get consultationHistory => 'سجل الاستشارات';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get biometricLogin => 'تسجيل الدخول البيومتري';

  @override
  String get pastVoiceConsultations => 'الاستشارات الصوتية السابقة';

  @override
  String get pastTextConversations => 'المحادثات النصية السابقة';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get totalCredit => 'إجمالي الإضافات';

  @override
  String get totalDebit => 'إجمالي الخصومات';

  @override
  String get statement => 'كشف الحساب';

  @override
  String get allTypes => 'جميع الأنواع';

  @override
  String get prev => 'السابق';

  @override
  String get next => 'التالي';

  @override
  String get allInsights => 'جميع الرؤى';

  @override
  String get yourCompleteReading => 'قراءتك الكاملة';

  @override
  String get expertEngines => 'محركات متخصصة';

  @override
  String get eachInsightConsultation => 'كل رؤية هي استشارة كاملة';

  @override
  String get engines => 'المحركات';

  @override
  String get dataPoints => 'نقاط البيانات';

  @override
  String get singleChart => 'مفرد';

  @override
  String get careerPurpose => 'المسيرة المهنية والهدف';

  @override
  String get wealthAssets => 'الثروة والأصول';

  @override
  String get loveRelationships => 'الحب والعلاقات';

  @override
  String get healthWellness => 'الصحة والعافية';

  @override
  String get soulKarma => 'الروح والكارما';

  @override
  String get specialistReports => 'التقارير المتخصصة';

  @override
  String get searchByNameSpeciality => 'ابحث بالاسم أو التخصص...';

  @override
  String get sortedByRating => 'مرتب حسب التقييم';

  @override
  String get initiatingChat => 'جارٍ بدء المحادثة...';

  @override
  String get startingCall => 'جارٍ بدء المكالمة...';

  @override
  String get yrs => 'سنوات';

  @override
  String get chatWithAISpecialist => 'تحدث مع أخصائي الذكاء الاصطناعي';

  @override
  String get tapToStart => 'اضغط للبدء';

  @override
  String get astrologer => 'المنجم';

  @override
  String get reports => 'التقارير';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'التوقعات';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'المشتري يفضل التحركات الجريئة';

  @override
  String get careerIlluminated => 'قطاع مسيرتك المهنية مضيء — ثق بحدسك.';

  @override
  String get todaysForecast => 'توقعات اليوم';

  @override
  String get engCareer => 'المسيرة المهنية والوظيفة';

  @override
  String get engBusiness => 'الأعمال والمشاريع الناشئة';

  @override
  String get engEducation => 'التعليم والتعلم';

  @override
  String get engLifePath => 'مسار الحياة والحظ';

  @override
  String get engWealth => 'الثروة والمال';

  @override
  String get engDebt => 'الديون والتعافي المالي';

  @override
  String get engProperty => 'الممتلكات والأصول';

  @override
  String get engLegal => 'الشؤون القانونية والنزاعات';

  @override
  String get engLove => 'الحب والرومانسية';

  @override
  String get engMarriage => 'الزواج والأسرة';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'ذكاء العلاقات';

  @override
  String get engLoveCompat => 'التوافق العاطفي';

  @override
  String get engChildProb => 'احتمالية الإنجاب';

  @override
  String get engHealth => 'الصحة والعافية';

  @override
  String get engMental => 'الحالة النفسية والتوتر';

  @override
  String get engCharacter => 'تحليل الشخصية';

  @override
  String get engPastLife => 'الحياة السابقة والكارما';

  @override
  String get engKarmaLink => 'الارتباط الكرمي';

  @override
  String get noChatSessions => 'لا توجد محادثات بعد';

  @override
  String get chatAppearHere => 'ستظهر محادثاتك مع المنجمين هنا.';

  @override
  String get noCallsYet => 'لا توجد مكالمات بعد';

  @override
  String get callAppearHere => 'سيظهر سجل مكالماتك مع المنجمين هنا.';

  @override
  String get chatWith => 'محادثة مع';

  @override
  String get msgs => 'رسالة';

  @override
  String get voiceCallLabel => 'مكالمة صوتية';

  @override
  String get videoCallLabel => 'مكالمة فيديو';

  @override
  String get pullToRefresh => 'اسحب للأسفل للتحديث';

  @override
  String get sessionExpired => 'انتهت صلاحية الجلسة';

  @override
  String get connectionFailed => 'فشل الاتصال';

  @override
  String get callActive => 'المكالمة نشطة';

  @override
  String get lessThanOneMin => 'أقل من دقيقة واحدة متبقية';

  @override
  String get noMessages => 'لا توجد رسائل في هذه الجلسة';

  @override
  String get gocharForAllSigns => 'Gochar اليوم لجميع الأبراج الاثني عشر';

  @override
  String get selectChart => 'اختر مخططًا للتحليل';

  @override
  String get selectTwoCharts => 'اختر مخططين';

  @override
  String get analyzing => 'جارٍ التحليل...';

  @override
  String get browseAstrologers => 'تصفح المنجمين';

  @override
  String get probableNumber => 'العدد المحتمل';

  @override
  String get genderTendency => 'الميل الجنسي';

  @override
  String get son => 'ابن';

  @override
  String get daughter => 'ابنة';

  @override
  String get occupants => 'الشاغلون';

  @override
  String get beneficAspects => 'الجوانب النافعة';

  @override
  String get maleficAspects => 'الجوانب الضارة';

  @override
  String get nextFavorableWindow => 'النافذة المواتية القادمة';

  @override
  String get totalDoshaPenalty => 'إجمالي عقوبة الدوشا';

  @override
  String get cancellationFactors => 'عوامل الإلغاء';

  @override
  String get combinedFertility => 'مؤشر الخصوبة المشترك';

  @override
  String get planetPositions => 'مواضع الكواكب';

  @override
  String get bestWindows => 'أفضل النوافذ';

  @override
  String get worstWindows => 'أسوأ النوافذ';

  @override
  String get scoreComponents => 'مكونات الدرجة';

  @override
  String get topOpportunities => 'أبرز الفرص';

  @override
  String get topRisks => 'أبرز المخاطر';

  @override
  String get remedies => 'العلاجات';

  @override
  String get keyInsights => 'أبرز الرؤى';

  @override
  String get overallVerdict => 'الحكم العام';

  @override
  String get venusContacts => 'اتصالات الزهرة المتقاطعة';

  @override
  String get contact => 'الاتصال';

  @override
  String get effect => 'التأثير';

  @override
  String get moonSignCompat => 'توافق برج القمر';

  @override
  String get hisMoon => 'قمره';

  @override
  String get herMoon => 'قمرها';

  @override
  String get nakshatraCompat => 'توافق Nakshatra';

  @override
  String get ketuContacts => 'اتصالات Ketu';

  @override
  String get rahuContacts => 'اتصالات Rahu';

  @override
  String get pastLifeIndication => 'مؤشر الحياة السابقة';

  @override
  String get totalChallengePenalty => 'إجمالي عقوبة التحديات';

  @override
  String get manifestation => 'التجلي';

  @override
  String get cancellation => 'الإلغاء';

  @override
  String get navigation => 'التوجيه';

  @override
  String get potentialStrengths => 'نقاط القوة المحتملة';

  @override
  String get areasToNurture => 'مجالات تحتاج إلى رعاية';

  @override
  String get relationshipGuidance => 'إرشادات العلاقة';

  @override
  String get detailedSummary => 'الملخص التفصيلي';

  @override
  String get discussWithAI => 'ناقش مع الذكاء الاصطناعي';

  @override
  String get planet => 'الكوكب';

  @override
  String get sign => 'البرج';

  @override
  String get house => 'البيت';

  @override
  String get strength => 'القوة';

  @override
  String get copy => 'نسخ';

  @override
  String get confidence => 'درجة الثقة';

  @override
  String get d7Saptamsa => 'D7 Saptamsa';

  @override
  String get numberExplanation => 'شرح العدد';

  @override
  String get genderExplanation => 'شرح الجنس';

  @override
  String get inFifth => 'في الخامس؟';

  @override
  String get primaryArchetype => 'النموذج الأساسي';

  @override
  String get mitigation => 'التخفيف';

  @override
  String get soulCareerAlign => 'توافق الروح والمسيرة المهنية';

  @override
  String get favorablePeriods => 'الفترات المواتية';

  @override
  String get challengingPeriods => 'الفترات الصعبة';

  @override
  String get keyHouses => 'البيوت الرئيسية';

  @override
  String get keyPlanets => 'الكواكب الرئيسية';

  @override
  String get characterOverview => 'نظرة عامة على الشخصية';

  @override
  String get noYogasActive => 'لا توجد يوغات نشطة حاليًا في هذا المخطط.';

  @override
  String get basedOnPlanetStrengths => 'بناءً على قوة الكواكب ومواضع البيوت';

  @override
  String get basedOnTransits => 'بناءً على الانتقالات الكوكبية الحالية';

  @override
  String get currentPlanetPositions => 'مواضع الكواكب الحالية مع برجك كبيت أول';

  @override
  String get favorablePeriodAdvice =>
      'فترة مواتية — ركّز على نمو المسيرة المهنية والعلاقات.';

  @override
  String get noClassicalYogas =>
      'من دون يوغات التعلم الكلاسيكية، يأتي النجاح من الجهد المستمر.';

  @override
  String get walletDeduction => 'سيتم خصم المبلغ من محفظتك';

  @override
  String get bhakootAxis => 'محور Bhakoot';

  @override
  String get basis => 'الأساس';

  @override
  String get selectChartsForMilan => 'اختر مخططين لتحليل Milan';

  @override
  String get selectMultiCharts => 'اختر 2–5 مخططات';

  @override
  String get running => 'جارٍ';

  @override
  String get past => 'سابق';

  @override
  String get topActiveDoshas => 'أبرز الدوشات النشطة';

  @override
  String get allDoshas => 'جميع الدوشات';

  @override
  String get activeYogas => 'اليوغات النشطة';

  @override
  String get activeDoshas => 'الدوشات النشطة';

  @override
  String get yogaAnalysis => 'تحليل اليوغا';

  @override
  String get factors => 'العوامل';

  @override
  String get dominantPlanet => 'الكوكب المهيمن';

  @override
  String get startSession => 'بدء الجلسة';

  @override
  String get notesSaved => 'تم حفظ الملاحظات';

  @override
  String get unlocked => 'تم الفتح! استمتع بقراءتك.';

  @override
  String get todaysGochar => 'Gochar اليوم';

  @override
  String get todaysTransitChart => 'مخطط انتقال اليوم';

  @override
  String get lifeAreaPredictions => 'توقعات مجالات الحياة';

  @override
  String get strengths => 'نقاط القوة';

  @override
  String get weaknesses => 'نقاط الضعف';

  @override
  String get ruledBy => 'يحكمه';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'بدء Kundli Milan';

  @override
  String get recommendations => 'التوصيات';

  @override
  String get cancellations => 'الإلغاءات';

  @override
  String get dashaSync => 'تزامن Dasha';

  @override
  String get transitMarriageWindows => 'نوافذ الزواج الانتقالية';

  @override
  String get overlappingWindows => 'نوافذ الزواج المتداخلة';

  @override
  String get overallStrength => 'القوة العامة';

  @override
  String get stability => 'الاستقرار';

  @override
  String get growth => 'النمو';

  @override
  String get clarity => 'الوضوح';

  @override
  String get recognition => 'التقدير';

  @override
  String get satisfaction => 'الرضا';

  @override
  String get verdict => 'الحكم';

  @override
  String get topRoles => 'أبرز الأدوار';

  @override
  String get areasForGrowth => 'مجالات النمو';

  @override
  String get bestIndustries => 'أفضل الصناعات';

  @override
  String get employment => 'التوظيف';

  @override
  String get entrepreneurship => 'ريادة الأعمال';

  @override
  String get freelance => 'العمل الحر';

  @override
  String get portfolio => 'المحفظة المختلطة';

  @override
  String get burnoutRisk => 'خطر الإرهاق';

  @override
  String get careerStagnation => 'الركود المهني';

  @override
  String get workplaceConflict => 'نزاع مكان العمل';

  @override
  String get positioning => 'التموضع';

  @override
  String get skillDevelopment => 'تطوير المهارات';

  @override
  String get network => 'الشبكة';

  @override
  String get visibility => 'الظهور';

  @override
  String get lagnaLord => 'سيد Lagna';

  @override
  String get tenthLord => 'سيد البيت العاشر';

  @override
  String get lord => 'السيد';

  @override
  String get lordPlacedIn => 'السيد موضوع في';

  @override
  String get lordDignity => 'منزلة السيد';

  @override
  String get d9Dignity => 'منزلة D9';

  @override
  String get careerAnalysis => 'تحليل المسيرة المهنية';

  @override
  String get launchWindows => 'نوافذ الانطلاق';

  @override
  String get peakWindows => 'نوافذ الذروة';

  @override
  String get promotionWindows => 'نوافذ الترقية';

  @override
  String get riskWindows => 'نوافذ الخطر';

  @override
  String get timingWindows => 'نوافذ التوقيت';

  @override
  String get careerRisks => 'مخاطر المسيرة المهنية';

  @override
  String get astrologicalRemedies => 'العلاجات التنجيمية';

  @override
  String get practicalSolutions => 'الحلول العملية';

  @override
  String get analysisConfidence => 'درجة الثقة في التحليل';

  @override
  String get careerArchetype => 'نموذج المسيرة المهنية';

  @override
  String get workStructure => 'هيكل العمل';

  @override
  String get teamLeadership => 'قيادة الفريق';

  @override
  String get idealEnvironment => 'البيئة المثالية';

  @override
  String get idealOrgSize => 'حجم المؤسسة المثالي';

  @override
  String get fitScore => 'درجة الملاءمة';

  @override
  String get recommended => 'موصى به';

  @override
  String get divisionalValidation => 'التحقق التقسيمي';

  @override
  String get houseAnalysis => 'تحليل البيت';

  @override
  String get jaiminiKarakas => 'كاراكات Jaimini';

  @override
  String get copyFullReport => 'نسخ بيانات التقرير الكاملة';

  @override
  String get reportCopied => 'تم نسخ بيانات التقرير!';

  @override
  String get biometricNotAvailable =>
      'البصمة الحيوية غير متوفرة على هذا الجهاز';

  @override
  String biometricErrorMsg(Object error) {
    return 'خطأ في البصمة الحيوية: $error';
  }

  @override
  String get biometricVerifyReason =>
      'تحقق لتفعيل تسجيل الدخول بالبصمة الحيوية';

  @override
  String get dobFormatLabel => 'تاريخ الميلاد (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'وقت الميلاد (HH:MM)';

  @override
  String get phoneLabel => 'الهاتف';

  @override
  String get activeBadge => 'نشط';

  @override
  String get chartCategoryLabel => 'الفئة';

  @override
  String get freePrimaryDescription =>
      'الأساسي المجاني — يُستخدم للأبراج اليومية وخدمات الرسم البياني المفرد المجانية';

  @override
  String get searchChartsHint => 'البحث بالاسم أو تاريخ الميلاد...';

  @override
  String unlockPriceLabel(Object price) {
    return 'فتح مقابل $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'افتح هذا الخبير الذكي مقابل $price (مرة واحدة)، يتم الشراء بأمان عبر متجر التطبيقات.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'افتح هذا الخبير الذكي مقابل $price (مرة واحدة). سيتم خصم المبلغ من محفظتك.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'هذا الخبير غير متاح للشراء حاليًا.';

  @override
  String get couldNotCompletePurchase =>
      'تعذر إتمام الشراء. يرجى المحاولة مرة أخرى.';

  @override
  String get couldNotUnlockWalletBalance =>
      'تعذر فتح القفل (تحقق من رصيد المحفظة)';

  @override
  String get freeBadge => 'مجاني';

  @override
  String activeSessionInProgress(Object kind) {
    return 'لديك $kind نشط قيد التنفيذ';
  }

  @override
  String get returnLabel => 'عودة';

  @override
  String get enableNotificationsForAlerts =>
      'فعّل الإشعارات للحصول على تنبيهات الاستشارة والعروض';

  @override
  String get enableLabel => 'تفعيل';

  @override
  String get notificationsEnabled => 'تم تفعيل الإشعارات';

  @override
  String get couldNotEnableNotifications =>
      'تعذر التفعيل — يرجى السماح بالإشعارات في متصفحك';

  @override
  String get amountInrLabel => 'المبلغ (₹)';

  @override
  String get noteOptionalLabel => 'ملاحظة (اختياري)';

  @override
  String get txnDate => 'التاريخ';

  @override
  String get txnDescription => 'الوصف';

  @override
  String get txnType => 'النوع';

  @override
  String get txnAmount => 'المبلغ';

  @override
  String get txnBalance => 'الرصيد';

  @override
  String get credit => 'إيداع';

  @override
  String get debit => 'خصم';

  @override
  String get razorpayStripeNote =>
      '💳 في الإنتاج، سيتم التوجيه إلى Razorpay/Stripe.';

  @override
  String get downloadPdf => 'تنزيل PDF';

  @override
  String get chatWithAiCta => 'تحدث مع الذكاء الاصطناعي';

  @override
  String get pdfServiceUnavailable =>
      'خدمة PDF غير متوفرة مؤقتًا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get pleaseUnlockFirst => 'يرجى فتح هذا أولاً.';

  @override
  String get couldNotGeneratePdf =>
      'تعذر إنشاء ملف PDF. يرجى المحاولة مرة أخرى.';

  @override
  String get statConsults => 'الاستشارات';

  @override
  String get statCharts => 'الرسوم البيانية';

  @override
  String get statWallet => 'المحفظة';

  @override
  String get firstChartPrimaryInfo =>
      'مخططك الأول هو الأساسي المجاني. المخططات الإضافية تفتح الخدمات بشكل فردي.';

  @override
  String get tryDifferentFilter => 'جرّب مرشحًا مختلفًا';

  @override
  String get defaultChartName => 'مخطط';

  @override
  String get balAbbr => 'الرصيد';

  @override
  String get aiTimePassTitle => 'اختر وقت الدردشة';

  @override
  String get aiTimePassHint => 'الدفع من محفظتك. يبدأ الوقت الآن — الشراء مرة أخرى يضيف إلى الوقت المتبقي.';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes دقيقة';
  }

  @override
  String aiTimePassPay(Object price) {
    return 'ادفع $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return 'متبقٍ $minutes دقيقة';
  }
}
