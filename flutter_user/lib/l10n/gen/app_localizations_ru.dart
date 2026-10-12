// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get awChooseLanguage => 'Выберите язык';

  @override
  String get awGoogleFailed =>
      'Не удалось войти через Google. Повторите попытку.';

  @override
  String get awCompleteProfileTitle => 'Заполните профиль';

  @override
  String awWelcomeName(String name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'Несколько деталей, чтобы персонализировать Nakshatralogy для вас.';

  @override
  String get awRegionLabel => 'Регион';

  @override
  String get awRegionIndia => 'Индия';

  @override
  String get awRegionInternational => 'Международный';

  @override
  String get awPreferredLanguage => 'Предпочитаемый язык';

  @override
  String get awFinishSetup => 'Завершить настройку';

  @override
  String get awChatFileWebUnsupported =>
      'Обмен файлами пока недоступен в веб-версии. Используйте мобильное приложение.';

  @override
  String get awVideoUnsupported =>
      'Видеозвонки не поддерживаются в этом браузере. Используйте наше мобильное приложение или поддерживаемый настольный браузер.';

  @override
  String get awClose => 'Закрыть';

  @override
  String get pwPremiumTitle => 'Премиум-отчёт';

  @override
  String get pwLockedSubtitle => 'Откройте полный анализ для этой карты';

  @override
  String pwUnlockFull(Object name) {
    return 'Открыть полностью $name';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'Открыть · $price';
  }

  @override
  String get pwOneTime => 'Разовая покупка — навсегда ваша для этой карты';

  @override
  String get pwWhatYouGet => 'Что вы получите';

  @override
  String get pwYourBalance => 'Баланс вашего кошелька';

  @override
  String get pwInsufficient => 'Недостаточно средств';

  @override
  String get pwRechargeToUnlock => 'Пополнить, чтобы открыть';

  @override
  String get pwRechargeAmount => 'Сумма пополнения (₹)';

  @override
  String get pwAddMoney => 'Пополнить счёт';

  @override
  String get pwRechargeDone => 'Кошелёк пополнен';

  @override
  String get pwRechargeFailed => 'Не удалось пополнить. Попробуйте ещё раз.';

  @override
  String get pwUnlockFailed => 'Не удалось открыть. Попробуйте ещё раз.';

  @override
  String get pwUnlockedNow => 'Открыто! Загружаем ваш отчёт…';

  @override
  String get pwProcessing => 'Обработка…';

  @override
  String get pwPrimaryNoDelete =>
      'Ваша основная Кундли не может быть удалена — она бесплатна навсегда.';

  @override
  String get pwPrimaryNoEdit => 'Вашу основную Кундли нельзя редактировать.';

  @override
  String get pwLoadingAccess => 'Проверка доступа…';

  @override
  String get pwMaybeLater => 'Может быть позже';

  @override
  String get updatePhoto => 'Обновить фото';

  @override
  String get takePhoto => 'Камера';

  @override
  String get chooseFromGallery => 'Галерея';

  @override
  String get removePhoto => 'Удалить фото';

  @override
  String get photoUpdated => 'Фото обновлено';

  @override
  String get photoUploadFailed =>
      'Не удалось загрузить фото. Попробуйте ещё раз.';

  @override
  String get tapToChangePhoto => 'Нажмите, чтобы изменить фото';

  @override
  String get klSubtitle =>
      'Отчёт о кармической связи прошлых жизней на основе ИИ и ведической астрологии';

  @override
  String get klTitle => 'Кармическая связь прошлых жизней';

  @override
  String get klSnapshotHeader => 'Снимок кармической связи';

  @override
  String get klGaugePairwise => 'Средняя парная связь';

  @override
  String get klGaugeCohesion => 'Групповая сплочённость';

  @override
  String get klGaugeRahuKetu => 'Резонанс Раху-Кету';

  @override
  String get klGaugeAtmakaraka => 'Резонанс души';

  @override
  String get klGaugeD60 => 'Резонанс D60';

  @override
  String get klChipSoulResonance => 'Сильный резонанс сигнатуры души';

  @override
  String get klChipD60Resonance => 'Сильный резонанс прошлых жизней по D60';

  @override
  String get klChipCohesiveGroup => 'Сплочённая группа';

  @override
  String get klChipNoDebts => 'Кармические долги не обнаружены';

  @override
  String get klProfilesTitle => 'Профили карт';

  @override
  String get klKetuAt => 'Кету в';

  @override
  String get klRahuAt => 'Раху в';

  @override
  String get klFoundationTitle => 'Кармическая основа каждой карты';

  @override
  String get klFoundationSubtitle =>
      'Мастерство прошлой жизни и направление текущей жизни каждой души';

  @override
  String get klKetuMastery => 'Мастерство Кету';

  @override
  String get klRahuGrowth => 'Рост Раху';

  @override
  String get klNinthHousePunya => 'Пунья 9-го дома';

  @override
  String get klD60Depth => 'Кармическая глубина D60';

  @override
  String get klAtmakarakaAgenda => 'Задача души';

  @override
  String get klSaturnKarma => 'Карма Сатурна';

  @override
  String get klPairwiseTitle => 'Парные кармические связи';

  @override
  String get klActiveFactors => 'Активные факторы связи';

  @override
  String get klGroupPatternTitle => 'Групповая кармическая модель';

  @override
  String get klSharedSetting => 'Общая обстановка прошлой жизни';

  @override
  String get klCohesionScore => 'Кармическая сплочённость';

  @override
  String get klPastGoalsTitle => 'Цели прошлой жизни';

  @override
  String get klLearningTitle => 'Уроки текущей жизни';

  @override
  String get klTeachingMap => 'Карта взаимного обучения';

  @override
  String get klDebtsTitle => 'Кармические долги и их разрешение';

  @override
  String get klNoDebtsDetected =>
      'Кармические долги в этой группе не обнаружены';

  @override
  String get klTimingTitle => 'Кармическое время по Мула-даше';

  @override
  String get klAuditTitle => 'Таблица глубокого анализа';

  @override
  String klAuditSubtitle(Object count) {
    return 'Изучено параметров: $count';
  }

  @override
  String get klTopicLinkage => 'Наша общая кармическая связь';

  @override
  String get klTopicPairwise => 'Кармическая связь конкретной пары';

  @override
  String get klTopicDebts => 'Кармические долги, которые нужно разрешить';

  @override
  String get klTopicLessons => 'Чему мы здесь учимся';

  @override
  String get klTopicTiming => 'Лучшее время для нашей группы';

  @override
  String get klTopicGroup => 'Наша общая история прошлой жизни';

  @override
  String get lcSubtitle =>
      'Отчёт о любовной совместимости на основе ИИ и ведической астрологии';

  @override
  String get lcTitle => 'Любовная совместимость';

  @override
  String get lcSnapshotHeader => 'Снимок любовной совместимости';

  @override
  String get lcGaugeAttraction => 'Притяжение';

  @override
  String get lcGaugeEmotional => 'Эмоциональная гармония';

  @override
  String get lcGaugeMental => 'Ментальное взаимопонимание';

  @override
  String get lcGaugePassion => 'Страсть';

  @override
  String get lcGaugeLongterm => 'Долгосрочная гармония';

  @override
  String get lcChipStrongMental => 'Сильная ментальная связь';

  @override
  String get lcChipStrongLongterm => 'Сильный долгосрочный потенциал';

  @override
  String get lcChipStrongPassion => 'Сильная физическая химия';

  @override
  String get lcChipLowFriction => 'Низкий уровень трений в целом';

  @override
  String get lcChipKarmicPull => 'Сильное кармическое притяжение';

  @override
  String get lcPartnersTitle => 'Снимок партнёра';

  @override
  String get lcVenusSuffix => 'Знак Венеры';

  @override
  String get lcAttractionTitle => 'Притяжение и химия';

  @override
  String get lcAttractionScore => 'Оценка притяжения';

  @override
  String get lcActiveContacts => 'Активные контакты Венеры';

  @override
  String get lcEmotionalTitle => 'Эмоциональная гармония';

  @override
  String get lcEmotionalScore => 'Оценка эмоциональной гармонии';

  @override
  String get lcNakshatraCompat => 'Совместимость накшатр';

  @override
  String get lcYoniKoota => 'Йони Кута';

  @override
  String get lcGanaKoota => 'Гана Кута';

  @override
  String get lcTaraKoota => 'Тара Кута';

  @override
  String get lcBhakootAxis => 'Ось Бхакут';

  @override
  String get lcMentalTitle => 'Ментальное взаимопонимание';

  @override
  String get lcMentalScore => 'Оценка ментального взаимопонимания';

  @override
  String get lcPassionTitle => 'Страсть и физическая близость';

  @override
  String get lcPassionScore => 'Оценка страсти';

  @override
  String get lcLongtermTitle => 'Долгосрочная гармония';

  @override
  String get lcLongtermScore => 'Оценка долгосрочной гармонии';

  @override
  String get lcCommitmentPotential => 'Потенциал обязательств';

  @override
  String get lc7thHouseSynastry => 'Синастрия 7-го дома';

  @override
  String get lcJupiterBlessing => 'Благословение Юпитера';

  @override
  String get lcD9Resonance => 'Резонанс Навамши D9';

  @override
  String get lcSaturnLongevity => 'Долголетие по Сатурну';

  @override
  String get lcKarmicTitle => 'Кармическая любовная связь';

  @override
  String get lcKarmicScore => 'Оценка кармической связи';

  @override
  String get lcKetuContacts => 'Контакты Кету';

  @override
  String get lcRahuContacts => 'Контакты Раху';

  @override
  String get lcChallengesTitle => 'Сложности и трения';

  @override
  String get lcNoChallenges =>
      'Существенных точек трения ни в одной из карт не обнаружено';

  @override
  String get lcTotalPenalty => 'Общий штраф за сложности';

  @override
  String get lcTimingTitle => 'Время любви — Мула-даша';

  @override
  String get lcDynamicsTitle => 'Динамика отношений';

  @override
  String get lcPowerBalance => 'Баланс сил';

  @override
  String get lcGiverReceiver => 'Эмоциональный даритель/получатель';

  @override
  String get lcGrowthDynamic => 'Динамика роста';

  @override
  String get lcAreasToNurture => 'Области для развития';

  @override
  String get lcTopicTiming => 'Лучшее время для наших отношений';

  @override
  String get lcTopicChallenges => 'Сложности, которые предстоит преодолеть';

  @override
  String get lcTopicKarmic => 'Наша кармическая связь';

  @override
  String get lcTopicRemedies => 'Рекомендуемые средства';

  @override
  String get lcTopicLongterm => 'Наш долгосрочный потенциал';

  @override
  String get lcTopicDynamics => 'Динамика наших отношений';

  @override
  String get cpSubtitle =>
      'Отчёт о вероятности рождения детей на основе ИИ и ведической астрологии';

  @override
  String get cpTitle => 'Вероятность рождения детей';

  @override
  String get cpSnapshotHeader => 'Снимок вероятности потомства';

  @override
  String get cpGauge5thHouse => '5-й дом';

  @override
  String get cpGaugeJupiter => 'Юпитер/Путракарака';

  @override
  String get cpGaugeD7 => 'Саптамша D7';

  @override
  String get cpGaugeSphuta => 'Биджа-Кшетра';

  @override
  String get cpGaugeTiming => 'Время по даше';

  @override
  String get cpChipStrongPutrakaraka => 'Сильная Путракарака (Юпитер)';

  @override
  String get cpChipLowDoshaPenalty => 'Низкий штраф за дошу';

  @override
  String get cpChipFavorableTiming => 'Благоприятное время по даше';

  @override
  String get cpChipNoDoshas => 'Доши, влияющие на потомство, не обнаружены';

  @override
  String get cpPartnersTitle => 'Снимок партнёра';

  @override
  String get cpLagnaSuffix => 'Лагна';

  @override
  String get cpMoonSuffix => 'Знак Луны';

  @override
  String get cpNumberTitle => 'Число детей и склонность к полу';

  @override
  String get cpProbableNumber => 'Вероятное число';

  @override
  String get cpFirstChildTendency => 'Склонность в отношении первого ребёнка';

  @override
  String get cpSpacing => 'Заметка об интервалах';

  @override
  String get cpTimingTitle => 'Время — Мула-даша';

  @override
  String get cpCombinedTiming => 'Совмещённое время';

  @override
  String get cpNextWindow => 'Следующее благоприятное окно';

  @override
  String get cp5thHouseTitle => 'Анализ 5-го дома';

  @override
  String get cp5thHouseSubtitle =>
      'Дом детей (Путра Бхава) для каждого человека';

  @override
  String get cpJupiterTitle => 'Анализ Юпитера — Путракараки';

  @override
  String get cpJupiterSubtitle =>
      'Естественный сигнификатор детей для каждого человека';

  @override
  String get cpD7Title => 'Анализ Саптамши D7';

  @override
  String get cpD7Subtitle => 'Дробная карта, посвящённая именно детям';

  @override
  String get cpD7Strength => 'Сила D7';

  @override
  String get cpSphutaTitle => 'Биджа- и Кшетра-Спхута';

  @override
  String get cpBeejaSphuta => 'Биджа-Спхута (семя)';

  @override
  String get cpKshetraSphuta => 'Кшетра-Спхута (поле)';

  @override
  String get cpDoshaTitle => 'Анализ дош';

  @override
  String get cpNoDoshasDetected =>
      'Дош, влияющих на потомство, ни в одной из карт не обнаружено';

  @override
  String get cpRemediesTitle => 'Рекомендуемые средства';

  @override
  String get cpAddresses => 'Затрагивает';

  @override
  String get cpTopicTiming => 'Лучшее время для зачатия';

  @override
  String get cpTopicNumber => 'Сколько детей у нас может быть';

  @override
  String get cpTopicDosha => 'Доши, которые нужно устранить';

  @override
  String get cpTopicRemedies => 'Рекомендуемые средства';

  @override
  String get cpTopicFifthHouse => 'Сила нашего 5-го дома';

  @override
  String get cpTopicJupiter => 'Роль Юпитера в этом вопросе';

  @override
  String get riSubtitle =>
      'Отчёт об интеллекте отношений на основе ИИ и ведической астрологии';

  @override
  String get riTitle => 'Интеллект отношений';

  @override
  String get riSnapshotHeader => 'Снимок группы';

  @override
  String get riGaugeCohesion => 'Групповая сплочённость';

  @override
  String get riGaugeTrust => 'Климат доверия';

  @override
  String get riGaugeProductivity => 'Продуктивность';

  @override
  String get riGaugeCreativity => 'Креативность';

  @override
  String get riChipNoAlerts => 'Критических предупреждений нет';

  @override
  String get riChipStrongCohesion => 'Сильная сплочённость группы';

  @override
  String get riChipHighTrust => 'Высокий уровень доверия';

  @override
  String get riChipNoHiddenEnemy => 'Сигналов скрытого врага не обнаружено';

  @override
  String get riChipHealthyGroup => 'В целом здоровая группа';

  @override
  String get riProfilesTitle => 'Профили карт';

  @override
  String riProfilesSubtitle(Object count) {
    return 'Людей в этой группе: $count';
  }

  @override
  String get riLagnaSuffix => 'Лагна';

  @override
  String get riIntegrity => 'Честность';

  @override
  String get riWarmth => 'Теплота';

  @override
  String get riTrustworthiness => 'Надёжность';

  @override
  String get riAssertiveness => 'Напористость';

  @override
  String get riGroupDynamicsTitle => 'Обзор групповой динамики';

  @override
  String get riMostSupportive => 'Наиболее поддерживающий';

  @override
  String get riMostChallenged => 'Наиболее сложный';

  @override
  String get riHiddenEnemyAlert => 'Обнаружен сигнал скрытого врага';

  @override
  String get riBestWorstTitle => 'Лучшие и самые сложные пары';

  @override
  String get riBestPair => 'САМАЯ ПРОЧНАЯ СВЯЗЬ';

  @override
  String get riWorstPair => 'ТРЕБУЕТ ВНИМАНИЯ';

  @override
  String get riAlliances => 'Вероятные союзы';

  @override
  String get riConflicts => 'Вероятные точки трения';

  @override
  String get riPairwiseTitle => 'Парный анализ';

  @override
  String riPairwiseSubtitle(Object count) {
    return 'Проанализировано пар: $count';
  }

  @override
  String get riDynamic => 'Динамика';

  @override
  String get riKarmicLink => 'Кармическая связь';

  @override
  String get riMutualTrust => 'Взаимное доверие';

  @override
  String get riBetrayalRisk => 'Риск предательства';

  @override
  String get riPowerDistribution => 'Распределение власти';

  @override
  String get riPowerHealth => 'Здоровье баланса власти';

  @override
  String get riCriticalPatternsTitle => 'Критические паттерны';

  @override
  String get riGroupRecsTitle => 'Рекомендации для группы';

  @override
  String get riSharedPractices => 'Общие практики';

  @override
  String get riCommStyle => 'Рекомендуемый стиль общения';

  @override
  String get riGrowthFocus => 'Рекомендуемый фокус развития';

  @override
  String get riIndividualTitle => 'Индивидуальные рекомендации';

  @override
  String get riBestAllies => 'Лучшие союзники';

  @override
  String get riHandleWithCare => 'Требует деликатного обращения';

  @override
  String get riCoreThemeTitle => 'Основная тема группы';

  @override
  String get riLayerPairwise => 'Полнота парного анализа';

  @override
  String get riLayerD1 => 'Натальная карта (D1)';

  @override
  String get riLayerD9 => 'Навамша (D9)';

  @override
  String get riLayerD10 => 'Дашамша (D10)';

  @override
  String get riLayerD30 => 'Тримшамша (D30)';

  @override
  String get riLayerJaimini => 'Сигнал по Джаймини';

  @override
  String get riLayerBehavior => 'Ясность поведения';

  @override
  String get riLayerCoherence => 'Согласованность группы';

  @override
  String get riTopicDynamics => 'Динамика нашей группы';

  @override
  String get riTopicPairwise => 'Совместимость конкретной пары';

  @override
  String get riTopicAlerts => 'Наличие критических предупреждений';

  @override
  String get riTopicGrowth => 'Как нам расти вместе';

  @override
  String get riTopicRecs => 'Рекомендуемые практики';

  @override
  String get riTopicTheme => 'Основная тема нашей группы';

  @override
  String get kmSubtitle =>
      'Отчёт Кундли-Милан на основе ИИ и ведической астрологии';

  @override
  String get kmTitle => 'Кундли-Милан';

  @override
  String get kmSnapshotHeader => 'Снимок совместимости';

  @override
  String kmAshtakootScore(Object score) {
    return 'Аштакута: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Аштакута, %';

  @override
  String get kmGaugeD9 => 'Карма брака по D9';

  @override
  String get kmGaugeMangal => 'Баланс Мангал Доша';

  @override
  String get kmGaugePapa => 'Кармический баланс';

  @override
  String get kmGaugeAk => 'Резонанс души';

  @override
  String get kmChipNoNadi => 'Нади-доша отсутствует';

  @override
  String get kmChipNoBhakoot => 'Бхакут-доша отсутствует';

  @override
  String get kmChipMangalCancelled => 'Мангал-доша аннулирована';

  @override
  String get kmChipPapaBalanced => 'Сбалансированная кармическая нагрузка';

  @override
  String get kmChipStrongChemistry => 'Сильная физическая химия';

  @override
  String get kmChipStrongD9 => 'Сильная брачная карма по D9';

  @override
  String get kmChipLongevity => 'Сильное совпадение по долголетию';

  @override
  String get kmAshtakootTitle => 'Аштакута Гуна Милан';

  @override
  String get kmAshtakootSubtitle =>
      'Классическая система сопоставления по 8 пунктам, из 36';

  @override
  String get kmNadiSeverity => 'Тяжесть Нади-доши';

  @override
  String get kmBhakootSeverity => 'Тяжесть Бхакут-доши';

  @override
  String get kmGanaSignature => 'Сигнатура Ганы';

  @override
  String get kmMangalTitle => 'Проверка Мангал-доши';

  @override
  String get kmD9Title => 'Навамша D9 — карма брака';

  @override
  String get kmD9Subtitle =>
      'Карта брака на уровне души, классически считается наиболее важной';

  @override
  String get kmD9Score => 'Совместимость по D9';

  @override
  String get kmLagnaRelation => 'Отношение Лагны';

  @override
  String get km7thLordRelation => 'Отношение управителя 7-го дома';

  @override
  String get kmKarakasTitle => 'Караки души и супруга';

  @override
  String get kmAtmakaraka => 'Планета души';

  @override
  String get kmAkCompatibility => 'Резонанс сигнатуры души';

  @override
  String get kmUlCompatibility => 'Согласованность Караки супруга';

  @override
  String get kmUlSigns => 'Управители Упапады';

  @override
  String get kmChemistryTitle => 'Химия Венеры и Марса';

  @override
  String get kmPhysicalChemistry => 'Физическая химия';

  @override
  String get kmEmotionalWarmth => 'Эмоциональная теплота';

  @override
  String get kmAestheticAlignment => 'Эстетическое соответствие';

  @override
  String get kmElementalSynthesis => 'Синтез стихий';

  @override
  String get kmHouseCrossTitle => 'Перекрёстный анализ 7-го и 8-го домов';

  @override
  String get km78Compatibility => 'Совместимость 7-го и 8-го домов';

  @override
  String get km8thHouseSignature => 'Совместная сигнатура долголетия';

  @override
  String get kmLongevityAlignment => 'Совпадение по долголетию';

  @override
  String get km7thLordFriendship => 'Дружба управителей 7-го дома';

  @override
  String get kmDomainsTitle => 'Совместимость по областям жизни';

  @override
  String get kmConflictEngagement => 'Стиль поведения в конфликте';

  @override
  String get kmDashaTitle => 'Синхронизация даш и транзитов';

  @override
  String get kmDashaSync => 'Синхронизация даш';

  @override
  String get kmTransitAlignment => 'Согласованность транзитов';

  @override
  String get kmTimingTitle => 'Время для брака';

  @override
  String get kmMarriageWindow => 'Окно для брака';

  @override
  String get kmEngagementWindow => 'Окно для помолвки';

  @override
  String get kmRecommendedRange => 'Рекомендуемые сроки';

  @override
  String get kmMuhurtaNotes => 'Заметки по мухурте';

  @override
  String get kmRisksTitle => 'Риски, требующие внимания';

  @override
  String get kmConflictRisk => 'Риск конфликта';

  @override
  String get kmCommunicationRisk => 'Риск в общении';

  @override
  String get kmFinanceRisk => 'Риск финансовых конфликтов';

  @override
  String get kmFamilyDynamicsRisk => 'Риск в семейной динамике';

  @override
  String get kmMentalHealthRisk => 'Риск в психологическом соответствии';

  @override
  String get kmStrengthsTitle => 'Главные сильные стороны совместимости';

  @override
  String get kmSharedGrowth => 'Общий потенциал роста';

  @override
  String get kmSharedCreative => 'Общий творческий потенциал';

  @override
  String get kmJourneyTitle => 'Путь и развитие отношений';

  @override
  String get kmCurrentPhase => 'Текущий этап';

  @override
  String get kmEarlyArc => 'Ранний период брака';

  @override
  String get kmMiddleArc => 'Средний период брака';

  @override
  String get kmMatureArc => 'Зрелый период брака';

  @override
  String get kmElderArc => 'Преклонные годы';

  @override
  String get kmPeakPhase => 'Пик товарищества';

  @override
  String get kmGrowthAreas => 'Области для роста';

  @override
  String get kmCommProtocols => 'Протоколы общения';

  @override
  String get kmSharedPractices => 'Общие практики';

  @override
  String get kmImprovementTitle => 'Основная тема и план улучшений';

  @override
  String get kmVerdictTitle => 'Итоговый вердикт';

  @override
  String get kmRealizationPotential => 'Потенциал реализации отношений';

  @override
  String get kmLayerAshtakoot => 'Аштакута';

  @override
  String get kmLayerD9 => 'Навамша D9';

  @override
  String get kmLayerMangalPapa => 'Мангал и Папасамья';

  @override
  String get kmLayerVenusMars => 'Венера-Марс';

  @override
  String get kmLayerDashaSync => 'Синхронизация даш';

  @override
  String get kmLayerH7H8 => 'Пересечение 7-го и 8-го домов';

  @override
  String get kmLayerAkResonance => 'Резонанс Атмакараки';

  @override
  String get kmLayerDomains => 'Измерения по областям жизни';

  @override
  String get kmTopicAshtakoot => 'Наш балл по Аштакуте';

  @override
  String get kmTopicMangal => 'Опасения по Мангал-доше';

  @override
  String get kmTopicD9 => 'Наша брачная карма (D9)';

  @override
  String get kmTopicTiming => 'Лучшее время для брака';

  @override
  String get kmTopicRisks => 'Риски, к которым нужно подготовиться';

  @override
  String get kmTopicGrowth => 'Как нам расти вместе';

  @override
  String get kmTopicRemedies => 'Рекомендуемые средства';

  @override
  String get kmTopicVerdict => 'Стоит ли нам вступать в брак';

  @override
  String get pkSubtitle =>
      'Отчёт о прошлых жизнях и карме на основе ИИ и ведической астрологии';

  @override
  String get pkTitle => 'Прошлые жизни и карма';

  @override
  String get pkSnapshotHeader => 'Снимок прошлой жизни';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'Ваша карта показывает сигнатуру прошлой жизни «$theme», которая сейчас $relation в эту жизнь. Рекомендуемый путь: $strategy.';
  }

  @override
  String get pkGaugeSignature => 'Сила сигнатуры';

  @override
  String get pkGaugeMasteryPreserved => 'Сохранённое мастерство';

  @override
  String get pkGaugeClearingProgress => 'Проработка кармы';

  @override
  String get pkGaugeMaturity => 'Зрелость прошлой жизни';

  @override
  String get pkGaugeMemoryAccess => 'Доступ к памяти';

  @override
  String get pkChipGoodProgress => 'Хороший прогресс в проработке кармы';

  @override
  String get pkChipLowDebt => 'Низкий кармический долг';

  @override
  String get pkChipMatureSoul => 'Зрелая сигнатура души';

  @override
  String get pkChipGiftedPast => 'Карта несёт дар прошлой жизни';

  @override
  String get pkChipAccomplished => 'Успешная прошлая жизнь';

  @override
  String get pkChipMasteryPreserved => 'Перенесено сильное мастерство';

  @override
  String get pkKetuTitle => 'Кету — ваше прошлое мастерство';

  @override
  String get pkKetuSubtitle => 'Навыки, которыми ваша душа уже овладела';

  @override
  String get pkMasteryStrength => 'Сила мастерства';

  @override
  String get pkSkillsCarried => 'Перенесённые навыки';

  @override
  String get pkInstincts => 'Инстинктивные способности';

  @override
  String get pkKetuDignity => 'Достоинство Кету';

  @override
  String get pkRahuTitle => 'Раху — грань роста вашей души';

  @override
  String get pkRahuSubtitle => 'То, что ваша душа должна завершить';

  @override
  String get pkUnmetDesires => 'Неудовлетворённые желания';

  @override
  String get pkProfileTitle => 'Ваш профиль прошлой жизни';

  @override
  String get pkProfession => 'Вероятная профессия';

  @override
  String get pkSocialStanding => 'Социальное положение';

  @override
  String get pkRegion => 'Вероятный регион';

  @override
  String get pkCulturalArchetype => 'Культурный архетип';

  @override
  String get pkAccomplishment => 'Уровень достижений';

  @override
  String get pkAuthority => 'Уровень власти';

  @override
  String get pkFamilyRole => 'Роль в семье';

  @override
  String get pkSecondaryProfession => 'Дополнительная профессия';

  @override
  String get pkClimateAffinity => 'Климатическая близость';

  @override
  String get pkForeignResidence => 'Карма проживания за рубежом';

  @override
  String get pkRelationshipsTitle =>
      'Прошлые отношения, перенесённые в эту жизнь';

  @override
  String get pkSpouseConnection => 'Воссоединение с супругом';

  @override
  String get pkChildrenConnection => 'Воссоединение с детьми';

  @override
  String get pkCarriedRelationTypes => 'Модели отношений';

  @override
  String get pkPartnerArchetype => 'Архетип партнёра из прошлой жизни';

  @override
  String get pkDarakaraka => 'Карака супруга';

  @override
  String get pkParentsKarma => 'Модель кармы с родителями';

  @override
  String get pkSiblingKarma => 'Модель кармы с братьями и сёстрами';

  @override
  String get pkSpiritualTitle => 'Ваша духовная жизнь тогда';

  @override
  String get pkSpiritualLevel => 'Духовный уровень';

  @override
  String get pkPracticeSignature => 'Стиль практики';

  @override
  String get pkMeditativeCapacity => 'Способность к медитации';

  @override
  String get pkDevotionalPractice => 'Практика поклонения (бхакти)';

  @override
  String get pkYogicAttainment => 'Йогические достижения';

  @override
  String get pkMokshaProximity => 'Близость к мокше';

  @override
  String get pkKarmicDebtsTitle => 'Кармические долги и богатство тогда';

  @override
  String get pkTotalKarmicDebt => 'Общий кармический долг';

  @override
  String get pkPrimaryDebtType => 'Основной тип долга';

  @override
  String get pkRelationshipDebt => 'Долг в отношениях';

  @override
  String get pkFinancialDebt => 'Финансовый долг';

  @override
  String get pkServiceDebt => 'Долг служения';

  @override
  String get pkDharmicDebt => 'Дхармический долг';

  @override
  String get pkPitruKarma => 'Карма Питру (предков)';

  @override
  String get pkMatruKarma => 'Карма Матру (материнская)';

  @override
  String get pkWealthLevel => 'Уровень богатства тогда';

  @override
  String get pkWealthKarmaCarried => 'Перенесённая карма богатства';

  @override
  String get pkResourcePattern => 'Управление ресурсами';

  @override
  String get pkGainSource => 'Источник дохода';

  @override
  String get pkEchoesTitle => 'Отголоски в этой жизни';

  @override
  String get pkOnRelationships => 'На отношения';

  @override
  String get pkOnCareer => 'На карьеру';

  @override
  String get pkOnHealth => 'На здоровье';

  @override
  String get pkOnSpirituality => 'На духовность';

  @override
  String get pkDominantArea => 'Сильнейшее наследие';

  @override
  String get pkAttractions => 'Естественные притяжения';

  @override
  String get pkAversions => 'Естественные отторжения';

  @override
  String get pkUnexplainedFears => 'Необъяснимые страхи';

  @override
  String get pkMagneticPulls => 'Магнетическое притяжение';

  @override
  String get pkResolutionTitle => 'Кармическое разрешение и завершение';

  @override
  String get pkPrimaryPathway => 'Основной путь';

  @override
  String get pkSecondaryPathway => 'Дополнительный путь';

  @override
  String get pkClearingProgress => 'Прогресс проработки';

  @override
  String get pkRemainingWork => 'Оставшаяся работа';

  @override
  String get pkSettlementTimeline => 'Сроки разрешения';

  @override
  String get pkAccelerationPractices => 'Практики, ускоряющие разрешение';

  @override
  String get pkPriorityAreas => 'Приоритетные области';

  @override
  String get pkVerificationTitle => 'Подтверждено по картам (D60)';

  @override
  String get pkD60Label => 'Эпоха прошлой жизни по D60';

  @override
  String get pkD60Ketu => 'Положение Кету в D60';

  @override
  String get pkD60Standing => 'Общее положение';

  @override
  String get pkMemoryTitle => 'Память и интуиция';

  @override
  String get pkMemoryAccess => 'Доступ к памяти';

  @override
  String get pkRegressionFit => 'Пригодность для регрессивной терапии';

  @override
  String get pkDreamVisits => 'Визиты во снах';

  @override
  String get pkDejaVuFrequency => 'Частота дежавю';

  @override
  String get pkSpontaneousRemembrance => 'Спонтанные воспоминания';

  @override
  String get pkRemembrancePractices => 'Практики для воспоминаний';

  @override
  String get pkTimelineTitle => 'Сроки активации';

  @override
  String get pkGiftsActivation => 'Активация даров прошлой жизни';

  @override
  String get pkSurfaceWindow => 'Окно проявления';

  @override
  String get pkRisksTitle => 'Риски и хронические паттерны';

  @override
  String get pkTraumaResidue => 'Остаточная травма';

  @override
  String get pkSpiritualBypass => 'Риск духовного обхода';

  @override
  String get pkMajorRisks => 'Основные риски';

  @override
  String get pkChronicImprints => 'Хронические отпечатки';

  @override
  String get pkKarmicLoops => 'Кармические петли';

  @override
  String get pkImprovementTitle => 'План улучшений';

  @override
  String get pkRoadmapTitle => 'Дорожная карта вашей прошлой жизни';

  @override
  String get pkMaturity => 'Зрелость прошлой жизни';

  @override
  String get pkLayerD1 => 'Натальная карта (D1)';

  @override
  String get pkLayerD9 => 'Навамша (D9)';

  @override
  String get pkLayerD60 => 'Шаштьямша (D60)';

  @override
  String get pkLayerKetuDepth => 'Глубина Кету';

  @override
  String get pkLayerAtmakaraka => 'Планета души (Атмакарака)';

  @override
  String get pkTopicMastery => 'Моё мастерство прошлой жизни';

  @override
  String get pkTopicUnfinished => 'Моя незавершённая карма';

  @override
  String get pkTopicRelationships => 'Мои отношения в прошлой жизни';

  @override
  String get pkTopicDebts => 'Мои кармические долги';

  @override
  String get pkTopicResolution => 'Как разрешить мою карму';

  @override
  String get pkTopicMemory => 'Доступ к памяти прошлой жизни';

  @override
  String get pkTopicTiming => 'Лучшие временные окна';

  @override
  String get pkTopicProfile => 'Кем я был в прошлой жизни';

  @override
  String get chSubtitle =>
      'Отчёт об анализе характера на основе ИИ и ведической астрологии';

  @override
  String get chTitle => 'Анализ характера';

  @override
  String get chSnapshotHeader => 'Снимок характера';

  @override
  String get chGaugeIntegrity => 'Честность';

  @override
  String get chGaugeResilience => 'Стойкость';

  @override
  String get chGaugeSelfAwareness => 'Самосознание';

  @override
  String get chGaugeStability => 'Эмоциональная устойчивость';

  @override
  String get chGaugeMoralFabric => 'Нравственный стержень';

  @override
  String get chChipRajaYoga => 'Присутствует Раджа-йога';

  @override
  String get chChipHighIntegrity => 'Высокая честность';

  @override
  String get chChipResilient => 'Стойкая натура';

  @override
  String get chChipDharmic => 'Сильная ориентация на дхарму';

  @override
  String get chChipEmpathetic => 'Естественная эмпатия';

  @override
  String get chChipLoyal => 'Глубокая преданность';

  @override
  String get chChipGiftedCharacter => 'Карта несёт дар характера';

  @override
  String get chSoulTitle => 'Сигнатура вашей души';

  @override
  String get chSoulIntegration => 'Интеграция души и характера';

  @override
  String get chAmatyakarakaTheme => 'Поддерживающий голос характера';

  @override
  String get chAtmakarakaDignity => 'Достоинство планеты души';

  @override
  String get chAtmakarakaHouse => 'Положение в доме';

  @override
  String get chSurfaceTitle => 'Внешняя личность и конституция';

  @override
  String get chLagnaSign => 'Знак Асцендента';

  @override
  String get chConstitution => 'Конституция';

  @override
  String get chSurfaceSignature => 'Как вас воспринимают';

  @override
  String get chPhysicalConstitution => 'Физическая конституция';

  @override
  String get chLagnaLord => 'Управитель Асцендента';

  @override
  String get chLagnaOccupants => 'Планеты в Асценденте';

  @override
  String get chMindEmotionsTitle => 'Разум, эмоции и эго';

  @override
  String get chEmotionalNature => 'Ваша эмоциональная природа';

  @override
  String get chMentalStability => 'Психическая устойчивость';

  @override
  String get chSelfConfidence => 'Здоровая уверенность в себе';

  @override
  String get chEgoNature => 'Ваше эго и самовосприятие';

  @override
  String get chAuthorityRelationship => 'Отношение к власти';

  @override
  String get chPrideTendency => 'Склонность к гордыне';

  @override
  String get chMoodPatterns => 'Модели настроения';

  @override
  String get chKemadrumaPresent =>
      'Присутствует Кемадрума-йога — полезна дополнительная забота об эмоциональном состоянии.';

  @override
  String get chFatherImprint => 'Качество отцовского отпечатка';

  @override
  String get chCommunicationTitle => 'Стиль общения и интеллекта';

  @override
  String get chIntellectStyle => 'Стиль интеллекта';

  @override
  String get chCommStyle => 'Стиль общения';

  @override
  String get chDecisionStyle => 'Стиль принятия решений';

  @override
  String get chDiscrimination => 'Способность к различению';

  @override
  String get chPersonaTitle => 'Публичный образ против истинного «я»';

  @override
  String get chAuthenticityGap => 'Разрыв в подлинности';

  @override
  String get chGunaTitle => 'Профиль Гун и Дош';

  @override
  String get chGunaSubtitle =>
      'Ваша внутренняя природа и конституция в классическом ведическом стиле';

  @override
  String get chSattva => 'Саттва';

  @override
  String get chRajas => 'Раджас';

  @override
  String get chTamas => 'Тамас';

  @override
  String get chDominantGuna => 'Доминирующая Гуна';

  @override
  String get chPitta => 'Питта';

  @override
  String get chKapha => 'Капха';

  @override
  String get chVata => 'Вата';

  @override
  String get chDominantDosha => 'Доминирующая Доша';

  @override
  String get chRahuRestlessness => 'Беспокойство от Раху';

  @override
  String get chKetuDetachment => 'Отрешённость Кету';

  @override
  String get chYogasTitle => 'Йоги характера';

  @override
  String get chRajaYogaStrength => 'Сила Раджа-йоги';

  @override
  String get chGiftYogas => 'Йоги-дары';

  @override
  String get chTestYogas => 'Йоги-испытания';

  @override
  String get chStrengthsTitle => 'Сильные стороны и таланты';

  @override
  String get chSignatureVirtues => 'Характерные достоинства';

  @override
  String get chNaturalTalents => 'Природные таланты';

  @override
  String get chSoftSkills => 'Гибкие навыки';

  @override
  String get chHiddenStrengths => 'Скрытые сильные стороны для развития';

  @override
  String get chShadowTitle => 'Теневые стороны и области роста';

  @override
  String get chShadowSubtitle =>
      'Бережное осознание паттернов, над которыми стоит поработать';

  @override
  String get chShadowPatterns => 'Теневые паттерны';

  @override
  String get chBlindSpots => 'Слепые зоны';

  @override
  String get chEmotionalWounds => 'Эмоциональные раны';

  @override
  String get chShadowWorkPriorities => 'Приоритеты работы с тенью';

  @override
  String get chMoralTests => 'Нравственные испытания';

  @override
  String get chRelationshipsTitle => 'Отношения и социальный стиль';

  @override
  String get chWarmth => 'Межличностная теплота';

  @override
  String get chEmpathy => 'Способность к эмпатии';

  @override
  String get chLoyalty => 'Способность к преданности';

  @override
  String get chBoundaries => 'Установление границ';

  @override
  String get chSocialConfidence => 'Социальная уверенность';

  @override
  String get chTrustGiving => 'Базовый уровень доверия к людям';

  @override
  String get chConflictStyle => 'Стиль поведения в конфликте';

  @override
  String get chEthicsTitle => 'Этика и нравственный компас';

  @override
  String get chDharmaOrientation => 'Ориентация на дхарму';

  @override
  String get chTruthfulness => 'Правдивость';

  @override
  String get chCompassion => 'Сострадание';

  @override
  String get chGenerosity => 'Щедрость';

  @override
  String get chEthicalConsistency => 'Этическая последовательность';

  @override
  String get chIntegrityPressure => 'Честность под давлением';

  @override
  String get chJusticeFairness => 'Справедливость и беспристрастность';

  @override
  String get chMoralTrajectory => 'Нравственное развитие';

  @override
  String get chEiTitle => 'Эмоциональный интеллект';

  @override
  String get chEiSelfAwareness => 'Самосознание';

  @override
  String get chEiSelfRegulation => 'Саморегуляция';

  @override
  String get chEiEmpathy => 'Эмпатия';

  @override
  String get chEiSocialSkills => 'Социальные навыки';

  @override
  String get chMotivation => 'Внутренняя мотивация';

  @override
  String get chVulnerabilityComfort => 'Комфорт с уязвимостью';

  @override
  String get chEmotionalExpression => 'Комфорт с выражением эмоций';

  @override
  String get chEmotionalReceptivity => 'Эмоциональная восприимчивость';

  @override
  String get chVerificationTitle => 'Подтверждено по картам (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'Дхарма-характер по D9';

  @override
  String get chD12Label => 'Родовое наследие по D12';

  @override
  String get chD30Label => 'Теневой профиль по D30';

  @override
  String get chD60Label => 'Характер прошлой жизни по D60';

  @override
  String get chD30Standing => 'Теневое положение';

  @override
  String get chMaternalInheritance => 'Материнское наследие';

  @override
  String get chAncestralKarmaWeight => 'Тяжесть родовой кармы';

  @override
  String get chTimelineTitle => 'Хронология характера';

  @override
  String get chFormationWindow => 'Окно формирования';

  @override
  String get chMaturationWindow => 'Окно созревания';

  @override
  String get chLegacyWindow => 'Окно наследия';

  @override
  String get chPeakMaturationAge => 'Возраст пика созревания';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'Возраст $ageRange';
  }

  @override
  String get chImprovementTitle => 'План улучшений';

  @override
  String get chRoadmapTitle => 'Дорожная карта вашего характера';

  @override
  String get chAuthenticExpression => 'Подлинное самовыражение';

  @override
  String get chRealizationPotential => 'Потенциал реализации характера';

  @override
  String get chLayerAtmakaraka => 'Планета души (Атмакарака)';

  @override
  String get chLayerD1 => 'Натальная карта (D1)';

  @override
  String get chLayerD9 => 'Навамша (D9)';

  @override
  String get chLayerD30 => 'Тримшамша (D30)';

  @override
  String get chLayerLagnaMoon => 'Асцендент и Луна';

  @override
  String get chLayerArudha => 'Арудха-лагна';

  @override
  String get chTopicStrengths => 'Мои сильные стороны характера';

  @override
  String get chTopicShadow => 'Мои теневые паттерны';

  @override
  String get chTopicSoul => 'Сигнатура моей души';

  @override
  String get chTopicRelationships => 'Мой стиль отношений';

  @override
  String get chTopicEthics => 'Моя этика и ценности';

  @override
  String get chTopicGuna => 'Мой профиль Гун и Дош';

  @override
  String get chTopicGrowth => 'Как развивать мой характер';

  @override
  String get chTopicTiming => 'Лучшее время для работы над характером';

  @override
  String get lpSubtitle =>
      'Отчёт о жизненном пути и удаче на основе ИИ и ведической астрологии';

  @override
  String get lpTitle => 'Жизненный путь и удача';

  @override
  String get lpSnapshotHeader => 'Снимок жизненного пути';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'Вы — $archetype с главной целью в области $domain. Наш анализ показывает общий потенциал реализации жизни на уровне $probability%.';
  }

  @override
  String get lpGaugeDharma => 'Ясность дхармы';

  @override
  String get lpGaugeFortune => 'Базовая удача';

  @override
  String get lpGaugeCoherence => 'Согласованность пути';

  @override
  String get lpGaugeFulfillment => 'Реализованность';

  @override
  String get lpGaugeMomentum => 'Кармический импульс';

  @override
  String get lpChipRareGift => 'Редкий дар судьбы';

  @override
  String get lpChipFreeWillStrong => 'Сильная свободная воля';

  @override
  String get lpChipGraceSupported => 'Поддержка милостью';

  @override
  String get lpChipLightKarma => 'Лёгкая кармическая нагрузка';

  @override
  String get lpChipRecognitionPotential => 'Потенциал признания';

  @override
  String get lpChipSpiritualPath => 'Сильное духовное влечение';

  @override
  String get lpChipBlessed => 'Карта несёт благословения';

  @override
  String get lpSoulPathTitle => 'Путь вашей души';

  @override
  String get lpSoulPlanet => 'Планета души';

  @override
  String get lpCareerPlanet => 'Планета цели';

  @override
  String get lpSoulClarity => 'Ясность цели';

  @override
  String get lpLifeChapter => 'Текущая глава жизни';

  @override
  String get lpPrimaryDomain => 'Основная область цели';

  @override
  String get lpKarakaTitle => 'Ваши планеты дхармы';

  @override
  String get lpKarakaSubtitle =>
      'Насколько сильно каждая планета поддерживает цель вашей жизни';

  @override
  String get lpVerificationTitle => 'Подтверждено по картам (D9 / D60)';

  @override
  String get lpD9Label => 'Согласованность души по D9';

  @override
  String lpD9Explain(Object stage) {
    return 'Стадия эволюции вашей души — «$stage» в карте Навамши.';
  }

  @override
  String get lpD9JupiterDignity => 'Достоинство Юпитера';

  @override
  String get lpD9DharmaMultiplier => 'Множитель дхармы';

  @override
  String get lpD60Label => 'Сигнатура прошлой жизни по D60';

  @override
  String get lpKarmaType => 'Тип кармы прошлой жизни';

  @override
  String get lpKetuMastery => 'Мастерство прошлой жизни по Кету';

  @override
  String get lpRahuGrowthDir => 'Направление роста по Раху';

  @override
  String get lpYogasTitle => 'Йоги удачи и блоки удачи';

  @override
  String get lpFortuneBoost => 'Усиление удачи';

  @override
  String get lpLuckDrain => 'Утечка удачи';

  @override
  String get lpFortuneBoosters => 'Усилители удачи';

  @override
  String get lpLuckBlocks => 'Блоки удачи';

  @override
  String get lpPurposeTitle => 'Области цели и слава';

  @override
  String get lpDomainLeadership => 'Лидерство';

  @override
  String get lpDomainWisdom => 'Мудрость и обучение';

  @override
  String get lpDomainService => 'Служение';

  @override
  String get lpDomainHealing => 'Целительство';

  @override
  String get lpDomainCreative => 'Творческое самовыражение';

  @override
  String get lpPrimaryDomainBadge => 'Основное';

  @override
  String get lpFameRecognition => 'Слава и признание';

  @override
  String get lpSocialInfluence => 'Социальное влияние';

  @override
  String get lpRecognitionDomain => 'Поле признания';

  @override
  String get lpPublicImage => 'Публичный образ';

  @override
  String get lpHistoricalImpact => 'Потенциал исторического влияния';

  @override
  String get lpTimelineTitle => 'Хронология удачи и жизни';

  @override
  String get lpCurrentPhase => 'Текущая фаза удачи';

  @override
  String get lpJupiterReturn => 'Возвращение Юпитера';

  @override
  String get lpSaturnReturn => 'Возвращение Сатурна';

  @override
  String get lpSadeSati => 'Саде Сати';

  @override
  String get lpGoldenWindow => 'Золотое окно';

  @override
  String get lpTransformationWindow => 'Окно трансформации';

  @override
  String get lpPeakYears => 'Годы пика удачи';

  @override
  String get lpChallengingYears => 'Сложные годы';

  @override
  String get lpMilestonesTitle => 'Главные вехи и поворотные моменты';

  @override
  String get lpFirstTurningPoint => 'Первый крупный поворотный момент';

  @override
  String get lpMidlifeTransform => 'Трансформация середины жизни';

  @override
  String get lpLateLifeFulfillment => 'Реализация в поздние годы';

  @override
  String lpDharmicMilestone(Object age) {
    return 'Дхармическая веха (возраст $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'Возраст $age';
  }

  @override
  String get lpDestinyTitle => 'Судьба против свободной воли';

  @override
  String get lpDestinyStat => 'Вес судьбы';

  @override
  String get lpFreeWillStat => 'Влияние свободной воли';

  @override
  String get lpFateStrength => 'Сила сигнатуры судьбы';

  @override
  String get lpSelfCreation => 'Способность к самосозиданию';

  @override
  String get lpEffortGrace => 'Усилие против милости';

  @override
  String get lpKarmicTitle => 'Кармические уроки';

  @override
  String get lpRahuGrowthLabel => 'Раху — вызов роста';

  @override
  String get lpKetuSurrenderLabel => 'Кету — тема смирения';

  @override
  String get lpSaturnLessonLabel => 'Сатурн — урок дисциплины';

  @override
  String get lpTestDifficulty => 'Сложность жизненных испытаний';

  @override
  String get lpLessonsInProgress => 'Уроки в процессе';

  @override
  String get lpSoulContract => 'Области договора души';

  @override
  String get lpSoulExperience => 'Что ваша душа пришла испытать';

  @override
  String get lpSoulMastery => 'Что ваша душа пришла освоить';

  @override
  String get lpSpiritualTitle => 'Духовный путь';

  @override
  String get lpSpiritualInclination => 'Духовная склонность';

  @override
  String get lpMeditationReceptivity => 'Восприимчивость к медитации';

  @override
  String get lpTeacherKarma => 'Карма учителя/гуру';

  @override
  String get lpPilgrimageBenefit => 'Польза паломничества';

  @override
  String get lpSelfRealization => 'Потенциал самореализации';

  @override
  String get lpDivineConnection => 'Связь с божественным';

  @override
  String get lpTraditionAffinity => 'Близость к традиции';

  @override
  String get lpIntuitionStrength => 'Сила интуиции';

  @override
  String get lpMantraEfficacy => 'Эффективность молитвы/мантры';

  @override
  String get lpInnerGuidance => 'Доверие внутреннему руководству';

  @override
  String get lpPropheticDreams => 'Чувствительность к пророческим снам';

  @override
  String get lpDifficultyTitle => 'Сложность жизни и испытания';

  @override
  String get lpEarlyLife => 'Ранняя жизнь';

  @override
  String get lpMidlife => 'Средний возраст';

  @override
  String get lpLateLife => 'Поздняя жизнь';

  @override
  String get lpStruggleToSuccess => 'Карма пути от борьбы к успеху';

  @override
  String get lpUnlivedLifeRisk => 'Риск непрожитой жизни';

  @override
  String get lpChallenges => 'Жизненные испытания';

  @override
  String get lpFortuneDrains => 'Хронические утечки удачи';

  @override
  String get lpRegretAreas => 'Области уязвимости к сожалениям';

  @override
  String get lpRedFlags => 'Тревожные сигналы направления';

  @override
  String get lpBlessingsTitle => 'Благословения и основная тема жизни';

  @override
  String get lpKarmicRoot => 'Кармический корень';

  @override
  String get lpBlessingsList => 'Ваши благословения';

  @override
  String get lpFulfillmentPriorities => 'Приоритеты реализации';

  @override
  String get lpImprovementTitle => 'План улучшений';

  @override
  String get lpDharmaPriorities => 'Приоритеты дхармы';

  @override
  String get lpRoadmapTitle => 'Дорожная карта вашей судьбы';

  @override
  String get lpStrategy => 'Стратегия';

  @override
  String get lpFulfillmentPotential => 'Потенциал реализации';

  @override
  String get lpNext12Focus => 'Фокус на ближайшие 12 месяцев';

  @override
  String get lpLayerD1 => 'Натальная карта (D1)';

  @override
  String get lpLayerD9 => 'Навамша (D9)';

  @override
  String get lpLayerD60 => 'Шаштьямша (D60)';

  @override
  String get lpLayerDasha => 'Время по даше';

  @override
  String get lpLayerTransit => 'Текущие транзиты';

  @override
  String get lpTopicPurpose => 'Моя жизненная цель';

  @override
  String get lpTopicFortune => 'Мои йоги удачи';

  @override
  String get lpTopicKarma => 'Мои кармические уроки';

  @override
  String get lpTopicMilestones => 'Предстоящие вехи';

  @override
  String get lpTopicDestiny => 'Судьба против свободной воли';

  @override
  String get lpTopicSpiritual => 'Мой духовный путь';

  @override
  String get lpTopicChallenges => 'Мои жизненные испытания';

  @override
  String get lpTopicTiming => 'Лучшие временные окна';

  @override
  String get dbSubtitle =>
      'Отчёт о долгах и восстановлении на основе ИИ и ведической астрологии';

  @override
  String get dbTitle => 'Долги и восстановление';

  @override
  String get dbSnapshotHeader => 'Снимок восстановления после долгов';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'Сейчас вы находитесь в фазе «$phase» с подходом к деньгам типа «$personality». Наш анализ показывает вероятность $probability% полностью избавиться от долгов примерно за $years лет.';
  }

  @override
  String get dbGaugeCapacity => 'Способность к восстановлению';

  @override
  String get dbGaugeProbability => 'Шанс на восстановление';

  @override
  String get dbGaugeFreedomNow => 'Свобода от долгов сейчас';

  @override
  String get dbGaugeDti => 'Здоровье дохода';

  @override
  String get dbGaugeResilience => 'Стойкость';

  @override
  String get dbChipCleanKarma => 'Чистая долговая карма';

  @override
  String get dbChipStrongRecovery => 'Сильная способность к восстановлению';

  @override
  String get dbChipHealthyDti => 'Здоровое соотношение долга к доходу';

  @override
  String get dbChipResilient => 'Высокая психологическая устойчивость';

  @override
  String get dbChipCycleBreakable => 'Долговой цикл можно разорвать';

  @override
  String get dbChipLowReindebt => 'Низкий риск повторной задолженности';

  @override
  String get dbChipGoodNegotiator => 'Хорошие шансы на переговоры';

  @override
  String get dbProfileTitle => 'Ваш долговой профиль';

  @override
  String get dbPhaseLabel => 'Текущий этап';

  @override
  String get dbPrimaryCategoryLabel => 'Основная категория';

  @override
  String get dbKarakaLabel => 'Карака долга';

  @override
  String get dbProtectorLabel => 'Защита от кредиторов';

  @override
  String get dbSecondaryCategories => 'Дополнительные категории';

  @override
  String get dbUnsecuredRatio => 'Доля необеспеченного долга';

  @override
  String get dbKarakaTitle => 'Ваши планеты долга';

  @override
  String get dbKarakaSubtitle =>
      'Насколько сильно каждая планета поддерживает восстановление после долгов';

  @override
  String get dbVerificationTitle => 'Подтверждено по картам (D6)';

  @override
  String get dbD6Label => 'Карта долгов и врагов D6';

  @override
  String get dbD6LordDignity => 'Сила управителя 6-го дома';

  @override
  String get dbD6Severity => 'Тяжесть долговой кармы';

  @override
  String get dbD6Multiplier => 'Множитель долга по D6';

  @override
  String get dbYogasTitle => 'Йоги долгов и защиты';

  @override
  String get dbPressureNow => 'Текущее долговое давление';

  @override
  String get dbRecoveryBoost => 'Усиление восстановления';

  @override
  String get dbClearingLabel => 'Йоги, устраняющие долги';

  @override
  String get dbCreatingLabel => 'Йоги, создающие долги';

  @override
  String get dbCategoriesTitle => 'Категории долгов, требующие внимания';

  @override
  String get dbCategoriesSubtitle =>
      'Какие виды долгов требуют наибольшего внимания';

  @override
  String get dbTimelineTitle => 'Хронология освобождения от долгов';

  @override
  String get dbFreeWindowLabel => 'ОКНО ОСВОБОЖДЕНИЯ ОТ ДОЛГОВ';

  @override
  String get dbClearanceEstimate => 'Оценка полного погашения';

  @override
  String get dbPeakYears => 'Годы пика долгов';

  @override
  String get dbClearanceYears => 'Годы погашения';

  @override
  String get dbBorrowTitle => 'Разумное руководство по займам';

  @override
  String get dbLoanSuitability => 'Пригодность для кредита';

  @override
  String get dbBestLoanType => 'Лучший тип кредита';

  @override
  String get dbLeverageCeiling => 'Потолок кредитного плеча';

  @override
  String get dbNegotiationSuccess => 'Успех переговоров';

  @override
  String get dbCreditorAggression => 'Риск давления кредиторов';

  @override
  String get dbLegalEscalation => 'Риск судебного разбирательства';

  @override
  String get dbNegotiationApproach => 'Рекомендуемый подход';

  @override
  String get dbAvoidLoanTypes => 'Типы кредитов, которых стоит избегать';

  @override
  String get dbRiskTitle => 'Наблюдение за рисками и уязвимостями';

  @override
  String get dbRiskDefault => 'Риск дефолта';

  @override
  String get dbRiskDefaultExp =>
      'Вероятность пропустить плановый платёж настолько сильно, чтобы получить статус дефолта у кредитора.';

  @override
  String get dbRiskDefaultFix =>
      'Настройте автоплатежи по минимальным суммам и держите буфер на 1 месяц, чтобы один пропущенный цикл дохода не привёл к цепной реакции.';

  @override
  String get dbRiskBankruptcy => 'Риск банкротства';

  @override
  String get dbRiskBankruptcyExp =>
      'Вероятность того, что долговая нагрузка вырастет больше, чем реально могут покрыть доход и активы.';

  @override
  String get dbRiskBankruptcyFix =>
      'Пройдите профессиональную проверку долгов перед оформлением нового кредита или кредитной линии.';

  @override
  String get dbRiskAssetSeizure => 'Риск изъятия имущества';

  @override
  String get dbRiskAssetSeizureExp =>
      'Вероятность того, что дефолт по обеспеченному кредиту приведёт к изъятию залога или имущества кредитором.';

  @override
  String get dbRiskAssetSeizureFix =>
      'В первую очередь отдавайте приоритет платежам по обеспеченным кредитам и рефинансируйте заранее, если возможен разрыв в платежах.';

  @override
  String get dbRiskChronic => 'Риск хронического возврата долгов';

  @override
  String get dbRiskChronicExp =>
      'Склонность снова попадать в долги даже после погашения текущей нагрузки.';

  @override
  String get dbRiskChronicFix =>
      'Создайте отдельный резервный фонд, прежде чем увеличивать расходы на образ жизни после погашения долгов.';

  @override
  String get dbReindebtTrigger => 'Триггер повторной задолженности';

  @override
  String get dbCycleBreakFeasibility => 'Возможность разорвать цикл';

  @override
  String get dbMajorRisks => 'Основные риски';

  @override
  String get dbHiddenSignals => 'Сигналы скрытых долгов';

  @override
  String get dbCrisisTitle => 'Готовность к кризису';

  @override
  String get dbCrisisSubtitle =>
      'Как рано заметить проблему и спокойно на неё отреагировать';

  @override
  String get dbWarningSigns => 'Ранние предупреждающие признаки';

  @override
  String get dbMitigationActions => 'Что с этим делать';

  @override
  String get dbFamilyTitle => 'Семейные и родовые долги';

  @override
  String get dbInheritedDebtProb => 'Вероятность унаследованного долга';

  @override
  String get dbFamilyDrag => 'Тяжесть семейного долга';

  @override
  String get dbInheritedSource => 'Вероятный источник';

  @override
  String get dbCoreBlockerLabel => 'ОСНОВНОЙ БЛОКЕР';

  @override
  String get dbPsychologyTitle => 'Ваша денежная психология';

  @override
  String get dbResilience => 'Стойкость';

  @override
  String get dbDiscipline => 'Дисциплина под давлением';

  @override
  String get dbSocialSupport => 'Социальная поддержка';

  @override
  String get dbDepressionRisk => 'Уязвимость к финансовому стрессу';

  @override
  String get dbStressTolerance => 'Устойчивость к стрессу';

  @override
  String get dbRootCause => 'Поведенческая коренная причина';

  @override
  String get dbImprovementTitle => 'План улучшений';

  @override
  String get dbRoadmapTitle => 'Ваша дорожная карта к свободе от долгов';

  @override
  String get dbRecoveryProbability => 'Вероятность восстановления';

  @override
  String get dbClearanceTimeline => 'Сроки погашения';

  @override
  String get dbYears => 'лет';

  @override
  String get dbDtiHealth => 'Здоровье соотношения долга к доходу';

  @override
  String get dbDtiCategory => 'Категория DTI';

  @override
  String get dbBreakEvenMonths => 'Месяцев до точки безубыточности';

  @override
  String get dbIncomeAcceleration => 'Необходимый рост дохода';

  @override
  String get dbLayerD1 => 'Натальная карта (D1)';

  @override
  String get dbLayerD6 => 'Долги и враги (D6)';

  @override
  String get dbLayerD9 => 'Навамша (D9)';

  @override
  String get dbLayerDasha => 'Время по даше';

  @override
  String get dbLayerTransit => 'Текущие транзиты';

  @override
  String get dbTopicRecovery => 'Мои сроки восстановления';

  @override
  String get dbTopicNegotiate => 'Переговоры с кредиторами';

  @override
  String get dbTopicBorrowing => 'Безопасно ли занимать сейчас';

  @override
  String get dbTopicCrisis => 'Подготовка к кризису';

  @override
  String get dbTopicAncestral => 'Родовая долговая карма';

  @override
  String get dbTopicTimeline => 'Лучшие годы для погашения долгов';

  @override
  String get dbTopicPsychology => 'Моя денежная психология';

  @override
  String get dbTopicCategories => 'Какие долги приоритетнее';

  @override
  String get mnSubtitle =>
      'Отчёт о психологическом благополучии на основе ИИ и ведической астрологии';

  @override
  String get mnTitle => 'Психика и стресс';

  @override
  String get mnSnapshotHeader => 'Снимок благополучия';

  @override
  String get mnResilience => 'Стойкость';

  @override
  String get mnStability => 'Стабильность';

  @override
  String get mnEmotionalBalance => 'Эмоциональный баланс';

  @override
  String get mnInnerCalm => 'Внутреннее спокойствие';

  @override
  String get mnSelfAwareness => 'Самосознание';

  @override
  String get mnStatusThriving => 'Процветание';

  @override
  String get mnStatusSteady => 'Стабильно и устойчиво';

  @override
  String get mnStatusBuildingStrength => 'Наращивание сил';

  @override
  String get mnStatusNeedsGentleCare => 'Требует бережной заботы';

  @override
  String get mnStatusReachOut => 'Время обратиться за поддержкой';

  @override
  String get mnChipStable => 'Эмоционально стабильно';

  @override
  String get mnChipSupported => 'Хорошо поддержаны';

  @override
  String get mnChipSelfAware => 'Высокая самоосознанность';

  @override
  String get mnChipResilient => 'Хорошо восстанавливается';

  @override
  String get mnChipSecureAttachment => 'Надёжная привязанность';

  @override
  String get mnChipHealingReady => 'Готовность к исцелению';

  @override
  String get mnChipMindBodyBalance => 'Баланс тела и разума';

  @override
  String get mnSupportBannerTitle => 'Бережная заметка';

  @override
  String get mnSupportBannerBody =>
      'Ваша карта показывает, что сейчас может быть хорошее время опереться на дополнительную поддержку — доверенного друга, члена семьи или специалиста. Обращение за помощью — признак силы, а не слабости.';

  @override
  String get mnProfileTitle => 'Ваш эмоциональный план';

  @override
  String get mnStressDriver => 'Источник стресса';

  @override
  String get mnStabilityAnchor => 'Опора устойчивости';

  @override
  String get mnSoulLevelKarma => 'Паттерн на уровне души';

  @override
  String get mnSubtleSignature => 'Тонкая эмоциональная сигнатура';

  @override
  String get mnKarakaTitle => 'Ваш разум и планеты';

  @override
  String get mnKarakaSubtitle => 'Какие планеты формируют ваш внутренний мир';

  @override
  String get mnYogasTitle => 'Сильные стороны и области роста';

  @override
  String get mnCurrentPhase => 'Текущая фаза';

  @override
  String get mnCurrentStressLevel => 'Текущий уровень стресса';

  @override
  String get mnRecentStrain => 'Недавнее эмоциональное напряжение';

  @override
  String get mnStrengths => 'Сильные стороны';

  @override
  String get mnGrowthAreas => 'Области для роста';

  @override
  String get mnSadeSatiStatus => 'Статус Саде Сати';

  @override
  String get mnVerificationTitle => 'Подтверждено по картам';

  @override
  String get mnD9Confirmation => 'Подтверждение по D9';

  @override
  String get mnD30Confirmation => 'Подтверждение по D30';

  @override
  String get mnMoodPatternsTitle => 'Паттерны настроения и тревожности';

  @override
  String get mnMoodPatternsSubtitle => 'Бережное осознание, а не диагноз';

  @override
  String get mnAnxietyPatterns => 'Паттерны тревожности';

  @override
  String get mnMoodPatterns => 'Паттерны пониженного настроения';

  @override
  String get mnPrimaryPattern => 'Основной паттерн';

  @override
  String get mnRumination => 'Склонность к чрезмерным раздумьям';

  @override
  String get mnHypervigilance => 'Повышенная настороженность';

  @override
  String get mnHopelessnessVuln => 'Чувствительность к снижению настроения';

  @override
  String get mnEnergyDepletion => 'Склонность к истощению энергии';

  @override
  String get mnMotivationBaseline => 'Базовый уровень мотивации';

  @override
  String get mnRegulationTitle => 'Эмоциональная регуляция и совладание';

  @override
  String get mnEmotionalRegulation => 'Эмоциональная регуляция';

  @override
  String get mnSelfSoothing => 'Способность к самоуспокоению';

  @override
  String get mnExpressionStyle => 'Стиль выражения';

  @override
  String get mnRecoveryTime => 'Время восстановления';

  @override
  String get mnTriggerIntensity => 'Интенсивность триггеров';

  @override
  String get mnHealthyCoping => 'Здоровые привычки совладания';

  @override
  String get mnWatchFor => 'На что обратить внимание';

  @override
  String get mnSleepTitle => 'Сон и отдых';

  @override
  String get mnSleepQuality => 'Качество сна';

  @override
  String get mnSleepAsRegulator => 'Сон как эмоциональный регулятор';

  @override
  String get mnInsomniaTendency => 'Склонность к беспокойным ночам';

  @override
  String get mnNightmareTendency => 'Склонность к ярким снам';

  @override
  String get mnSleepHygienePriority => 'Приоритет гигиены сна';

  @override
  String get mnBurnoutTitle => 'Выгорание и энергия';

  @override
  String get mnBurnoutVulnerability => 'Чувствительность к выгоранию';

  @override
  String get mnBurnoutRecovery =>
      'Способность к восстановлению после выгорания';

  @override
  String get mnBurnoutStage => 'Текущая стадия выгорания';

  @override
  String get mnSelfDrivingTendency => 'Склонность к самопринуждению';

  @override
  String get mnBurnoutTriggers => 'Триггеры выгорания';

  @override
  String get mnConnectionTitle => 'Связь и поддержка';

  @override
  String get mnSocialSupport => 'Качество социальной поддержки';

  @override
  String get mnLonelinessVuln => 'Чувствительность к одиночеству';

  @override
  String get mnSolitudeNeed => 'Потребность в уединении';

  @override
  String get mnSocialComfort => 'Комфорт в общении';

  @override
  String get mnTraumaSensitivity => 'Чувствительность к травме';

  @override
  String get mnHealingReadiness => 'Готовность к исцелению';

  @override
  String get mnProcessingStyle => 'Стиль переработки';

  @override
  String get mnMindBodyIntegration => 'Интеграция тела и разума';

  @override
  String get mnPtsdVuln => 'Чувствительность к травматическим реакциям';

  @override
  String get mnSelfAwarenessTitle => 'Самоосознание и рост';

  @override
  String get mnSelfAwarenessScore => 'Самосознание';

  @override
  String get mnEmotionalVocabulary => 'Эмоциональный словарь';

  @override
  String get mnTherapyReadiness => 'Готовность к терапии';

  @override
  String get mnJournalingBenefit => 'Польза ведения дневника';

  @override
  String get mnInnerDialogue => 'Качество внутреннего диалога';

  @override
  String get mnAwarenessOfPatterns => 'Осознание паттернов';

  @override
  String get mnEscapePatternVuln => 'Чувствительность к паттернам избегания';

  @override
  String get mnEscapeChannels => 'На что обратить внимание';

  @override
  String get mnHealthyAlternatives => 'Здоровые альтернативы';

  @override
  String get mnTherapyFitTitle => 'Соответствие терапии и поддержки';

  @override
  String get mnCrisisSupportRec => 'Рекомендация по поддержке';

  @override
  String get mnSupportNetwork => 'Активируйте свою сеть поддержки';

  @override
  String get mnSelfAdvocacy => 'Готовность отстаивать себя';

  @override
  String get mnMedicationReceptivity =>
      'Восприимчивость к медикаментозному лечению';

  @override
  String get mnTimelineTitle => 'Хронология благополучия';

  @override
  String get mnPeakWellnessYears => 'Годы пика благополучия';

  @override
  String get mnExtraCareYears => 'Годы для дополнительной заботы о себе';

  @override
  String get mnTransformationWindows => 'Окна позитивной трансформации';

  @override
  String get mnTherapyWindow => 'Рекомендуемое окно для терапии';

  @override
  String get mnPracticesTitle => 'Ежедневные практики благополучия';

  @override
  String get mnMorningPractices => 'Утренние практики';

  @override
  String get mnEveningPractices => 'Вечерние практики';

  @override
  String get mnBreathwork => 'Дыхательные практики';

  @override
  String get mnMovement => 'Движение';

  @override
  String get mnNutrition => 'Питание';

  @override
  String get mnNatureExposure => 'Потребность в контакте с природой';

  @override
  String get mnDigitalDetox => 'Потребность в цифровом детоксе';

  @override
  String get mnImprovementTitle => 'План улучшений';

  @override
  String get mnReliabilityTitle => 'Надёжность';

  @override
  String get mnLayerD1 => 'Натальная карта (D1)';

  @override
  String get mnLayerD9 => 'Карта души (D9)';

  @override
  String get mnLayerD30 => 'Карта D30';

  @override
  String get mnLayerDasha => 'Время по даше';

  @override
  String get mnLayerTransit => 'Транзиты';

  @override
  String get mnTopicResilience => 'Насколько я устойчив эмоционально?';

  @override
  String get mnTopicCoping =>
      'Какие стратегии совладания подходят мне лучше всего?';

  @override
  String get mnTopicSleep => 'Как улучшить мой сон?';

  @override
  String get mnTopicBurnout => 'Есть ли у меня риск выгорания?';

  @override
  String get mnTopicTherapy => 'Какой стиль терапии мне подходит?';

  @override
  String get mnTopicPractices =>
      'Какие ежедневные практики помогают мне больше всего?';

  @override
  String get mnTopicTiming => 'Когда мои лучшие годы для благополучия?';

  @override
  String get mnTopicSupport => 'Как построить крепкую сеть поддержки?';

  @override
  String get lgSubtitle =>
      'Отчёт по юридическим вопросам на основе ИИ и ведической астрологии';

  @override
  String get lgTitle => 'Право и споры';

  @override
  String get lgSnapshotHeader => 'Правовой снимок';

  @override
  String get lgResilience => 'Правовая устойчивость';

  @override
  String get lgResolutionCapacity => 'Способность к разрешению';

  @override
  String get lgVictoryPotential => 'Потенциал победы';

  @override
  String get lgLegalSafety => 'Правовая безопасность';

  @override
  String get lgNegotiationSkill => 'Навык переговоров';

  @override
  String get lgStatusExcellent => 'Отлично';

  @override
  String get lgStatusStrong => 'Сильно';

  @override
  String get lgStatusModerate => 'Умеренно';

  @override
  String get lgStatusDeveloping => 'В развитии';

  @override
  String get lgStatusChallenging => 'Сложно';

  @override
  String get lgChipResolver => 'Умелый переговорщик';

  @override
  String get lgChipWinner => 'Побеждает в сильных делах';

  @override
  String get lgChipNegotiator => 'Прирождённый переговорщик';

  @override
  String get lgChipDocumented => 'Хорошо задокументировано';

  @override
  String get lgChipLowRisk => 'Низкий правовой риск';

  @override
  String get lgChipMoralAuthority => 'Моральный авторитет';

  @override
  String get lgChipLegalAptitude => 'Правовые способности';

  @override
  String get lgProfileTitle => 'Ваш правовой профиль и карма';

  @override
  String get lgPrimaryDriver => 'Основной двигатель';

  @override
  String get lgDharmaAnchor => 'Опора дхармы';

  @override
  String get lgAggressionMarker => 'Маркер агрессии';

  @override
  String get lgDocumentationKaraka => 'Качество документации';

  @override
  String get lgKarakaTitle => 'Ваши правовые планеты';

  @override
  String get lgKarakaSubtitle => 'Какие планеты формируют вашу правовую удачу';

  @override
  String get lgYogasTitle => 'Правовые йоги и защиты';

  @override
  String get lgCurrentPhase => 'Текущая фаза';

  @override
  String get lgProtections => 'Защиты';

  @override
  String get lgDisputePressures => 'Давление споров';

  @override
  String get lgVerificationTitle => 'Подтверждено по картам';

  @override
  String get lgD6Litigation => 'Карта тяжб D6';

  @override
  String get lgD9Dharma => 'Карта дхармы D9';

  @override
  String get lgMoralAuthority => 'Моральный авторитет';

  @override
  String get lgVictoryTitle => 'Анализ побед';

  @override
  String get lgAsPlaintiff => 'В роли истца';

  @override
  String get lgAsDefendant => 'В роли ответчика';

  @override
  String get lgSettlementPreference => 'Предпочтение мирового соглашения';

  @override
  String get lgDisputeCategoriesTitle => 'Категории споров, требующие внимания';

  @override
  String get lgLowRiskCategories => 'Категории низкого риска';

  @override
  String get lgConflictStyleTitle => 'Стиль конфликта и враги';

  @override
  String get lgConfrontationComfort => 'Комфорт в конфронтации';

  @override
  String get lgArgumentPersuasiveness => 'Убедительность аргументов';

  @override
  String get lgEmotionalRegulation => 'Эмоциональная регуляция';

  @override
  String get lgGrudgeHolding => 'Склонность держать обиду';

  @override
  String get lgEnemyAnalysisLabel => 'Анализ врагов';

  @override
  String get lgVisibleEnemies => 'Явные враги';

  @override
  String get lgHiddenEnemies => 'Скрытые враги';

  @override
  String get lgWorkplaceEnemies => 'Враги на работе';

  @override
  String get lgFamilyEnemies => 'Враги в семье';

  @override
  String get lgLegalEnemies => 'Враги в правовой сфере';

  @override
  String get lgEnemyDefeatCapacity => 'Способность одолеть врагов';

  @override
  String get lgCriminalFinancialTitle =>
      'Наблюдение за уголовными и финансовыми рисками';

  @override
  String get lgCriminalRisk => 'Риск причастности к преступлению';

  @override
  String get lgVictimOfCrime => 'Вероятность стать жертвой преступления';

  @override
  String get lgFalseAccusation => 'Риск ложного обвинения';

  @override
  String get lgImprisonmentRisk => 'Риск лишения свободы';

  @override
  String get lgTaxDisputeRisk => 'Риск налогового спора';

  @override
  String get lgFinancialFraudRisk => 'Риск финансового мошенничества';

  @override
  String get lgBusinessLitigationRisk => 'Риск деловых тяжб';

  @override
  String get lgBankruptcyRisk => 'Риск банкротства';

  @override
  String get lgAuditVulnerability => 'Уязвимость к проверкам';

  @override
  String get lgProtectionPriority => 'Приоритет защиты';

  @override
  String get lgContractsTitle => 'Контракты и переговоры';

  @override
  String get lgContractClarity => 'Ясность контракта';

  @override
  String get lgDocumentationDiscipline => 'Дисциплина документации';

  @override
  String get lgFinePrintAwareness => 'Внимание к мелкому шрифту';

  @override
  String get lgSignatureCaution => 'Осторожность при подписании';

  @override
  String get lgMediationReceptivity => 'Восприимчивость к медиации';

  @override
  String get lgNegotiationSkillFull => 'Навык переговоров';

  @override
  String get lgCompromiseWillingness => 'Готовность к компромиссу';

  @override
  String get lgFaceSavingNeeds => 'Потребность сохранить лицо';

  @override
  String get lgMediatorHireRecommendation => 'Рекомендация нанять медиатора';

  @override
  String get lgTypicalContractIssues => 'Типичные проблемы с контрактами';

  @override
  String get lgCareerFitTitle => 'Соответствие юридической карьере';

  @override
  String get lgProfessionAffinity => 'Склонность к профессии';

  @override
  String get lgRoleFit => 'Наилучшая роль';

  @override
  String get lgLawStudentSuccess => 'Успех в изучении права';

  @override
  String get lgBarExamSuccess => 'Успех на экзамене на адвоката';

  @override
  String get lgTimelineTitle => 'Правовая хронология';

  @override
  String get lgNewMatterChance => 'Вероятность нового дела (следующие 12 мес.)';

  @override
  String get lgOngoingCaseOutcome => 'Исход текущего дела';

  @override
  String get lgRecommendedAction => 'Рекомендуемое действие';

  @override
  String get lgPeakDisputeYears => 'Годы пика споров';

  @override
  String get lgClarityYears => 'Годы правовой ясности';

  @override
  String get lgAvoidancePeriods =>
      'Критические периоды, которых стоит избегать';

  @override
  String get lgFavorableWindows => 'Благоприятные окна для разрешения';

  @override
  String get lgRisksTitle => 'Риски и уязвимости';

  @override
  String get lgChronicVulnerabilities => 'Хронические уязвимости';

  @override
  String get lgAvoidDashaPeriods => 'Периоды даш, требующие внимания';

  @override
  String get lgPreventivePriorities => 'Приоритеты профилактики';

  @override
  String get lgRedFlags => 'Тревожные ситуации';

  @override
  String get lgImprovementTitle => 'План улучшений';

  @override
  String get lgReliabilityTitle => 'Надёжность';

  @override
  String get lgLayerD1 => 'Натальная карта (D1)';

  @override
  String get lgLayerD6 => 'Карта тяжб (D6)';

  @override
  String get lgLayerD9 => 'Карта дхармы (D9)';

  @override
  String get lgLayerDasha => 'Время по даше';

  @override
  String get lgLayerTransit => 'Транзиты';

  @override
  String get lgTopicWinChance => 'Каковы мои шансы на победу?';

  @override
  String get lgTopicStrategy => 'Какая юридическая стратегия мне подходит?';

  @override
  String get lgTopicContract => 'На какие риски контрактов обратить внимание?';

  @override
  String get lgTopicTiming => 'Лучшее время для разрешения споров?';

  @override
  String get lgTopicSettlement => 'Мне уладить дело миром или бороться?';

  @override
  String get lgTopicEnemies => 'Кто мои скрытые враги?';

  @override
  String get lgTopicProtection => 'Как защитить себя юридически?';

  @override
  String get lgTopicCareer => 'Подхожу ли я для юридической карьеры?';

  @override
  String get prSubtitle =>
      'Отчёт о собственности на основе ИИ и ведической астрологии';

  @override
  String get prTitle => 'Собственность и активы';

  @override
  String get prSnapshotHeader => 'Снимок собственности';

  @override
  String get prAcquisitionCapacity => 'Способность к приобретению';

  @override
  String get prHomeOwnership => 'Владение жильём';

  @override
  String get prWealthPotential => 'Потенциал богатства';

  @override
  String get prRentalIncome => 'Доход от аренды';

  @override
  String get prLandOwnership => 'Владение землёй';

  @override
  String get prStatusExcellent => 'Отлично';

  @override
  String get prStatusStrong => 'Сильно';

  @override
  String get prStatusModerate => 'Умеренно';

  @override
  String get prStatusDeveloping => 'В развитии';

  @override
  String get prStatusChallenging => 'Сложно';

  @override
  String get prChipHomeOwner => 'Владелец жилья';

  @override
  String get prChipWealthBuilder => 'Строитель богатства';

  @override
  String get prChipLandOwner => 'Владелец земли';

  @override
  String get prChipInvestor => 'Инвестор в недвижимость';

  @override
  String get prChipInheritance => 'Вероятно наследство';

  @override
  String get prChipVehicle => 'Владелец транспортного средства';

  @override
  String get prChipGlobalAsset => 'Склонность к зарубежным активам';

  @override
  String get prProfileTitle => 'Ваш стиль в отношении собственности';

  @override
  String get prHomeAesthetics => 'Эстетика дома';

  @override
  String get prHomeSanctuary => 'Дом как убежище';

  @override
  String get prComfortInvestment => 'Инвестиции в комфорт';

  @override
  String get prVastuPriority => 'Приоритет Васту';

  @override
  String get prNaturalElements => 'Природные элементы';

  @override
  String get prNextActionLabel => 'Следующий шаг';

  @override
  String get prKarakaTitle => 'Ваши планеты собственности';

  @override
  String get prKarakaSubtitle =>
      'Какие планеты формируют вашу удачу в собственности';

  @override
  String get prPrimaryKaraka => 'Основная Карака';

  @override
  String get prDurableAsset => 'Карака долговечных активов';

  @override
  String get prYogasTitle => 'Йоги и доши собственности';

  @override
  String get prCurrentPhase => 'Текущая фаза';

  @override
  String get prBoosters => 'Усилители';

  @override
  String get prDrains => 'Утечки';

  @override
  String get prVerificationTitle => 'Подтверждено по картам';

  @override
  String get prD4Property => 'Карта собственности D4';

  @override
  String get prD16Vehicle => 'Карта транспорта D16';

  @override
  String get prVehicleFit => 'Соответствие транспорту';

  @override
  String get prJourneyTitle => 'Путь владения и хронология';

  @override
  String get prFirstHomeAge => 'Возраст первого дома';

  @override
  String get prFirstHomeType => 'Тип первого дома';

  @override
  String get prMultipleHomes => 'Несколько домов';

  @override
  String get prNewPropertySoon => 'Новая собственность скоро';

  @override
  String get prFirstMajorWindow => 'Первое крупное окно';

  @override
  String get prBuyingWindow => 'Окно покупки';

  @override
  String get prConstructionWindow => 'Окно строительства';

  @override
  String get prNextOpportunity => 'Следующая возможность';

  @override
  String get prLifetimePropertyCount =>
      'Количество объектов собственности за жизнь';

  @override
  String get prInheritanceTitle => 'Наследство и семейная собственность';

  @override
  String get prMaternalInheritance => 'Наследство по материнской линии';

  @override
  String get prPaternalInheritance => 'Наследство по отцовской линии';

  @override
  String get prAncestralProperty => 'Родовая собственность';

  @override
  String get prFamilyDisputeRisk => 'Риск семейного спора';

  @override
  String get prInheritanceTiming => 'Время наследования';

  @override
  String get prInheritanceType => 'Тип наследства';

  @override
  String get prLandInvestTitle =>
      'Земля, инвестиции и зарубежная собственность';

  @override
  String get prPropertyInvestor => 'Балл инвестора в недвижимость';

  @override
  String get prAppreciationLuck => 'Удача в росте стоимости';

  @override
  String get prInvestorMindset => 'Мышление инвестора';

  @override
  String get prLandType => 'Тип земли';

  @override
  String get prRentalCount => 'Количество арендуемых объектов';

  @override
  String get prMultipleLand => 'Несколько земельных участков';

  @override
  String get prFarmEstate => 'Вероятность фермы/поместья';

  @override
  String get prGlobalPropertyLabel => 'Зарубежная собственность';

  @override
  String get prForeignProperty => 'Иностранная собственность';

  @override
  String get prNriAffinity => 'Склонность к активам NRI';

  @override
  String get prVehiclesTitle => 'Транспортные средства';

  @override
  String get prVehicleCount => 'Количество транспортных средств';

  @override
  String get prVehicleFirstAge => 'Возраст первого транспортного средства';

  @override
  String get prVehicleCategory => 'Категория транспортного средства';

  @override
  String get prVehicleQuality => 'Качество транспортного средства';

  @override
  String get prLuxuryAffinity => 'Склонность к роскоши';

  @override
  String get prVehicleLossRisk =>
      'Риск потери/повреждения транспортного средства';

  @override
  String get prLegalRiskTitle => 'Наблюдение за юридическими и прочими рисками';

  @override
  String get prBoundaryDisputes => 'Споры о границах';

  @override
  String get prPartitionDisputes => 'Споры о разделе';

  @override
  String get prTitleIssues => 'Проблемы с правом собственности/документами';

  @override
  String get prTenantConflict => 'Конфликт арендатор-арендодатель';

  @override
  String get prForcedSale => 'Риск принудительной продажи';

  @override
  String get prPropertyDamage => 'Риск повреждения имущества';

  @override
  String get prInsurancePriority => 'Приоритет страхования';

  @override
  String get prProtectionUrgency => 'Срочность защиты';

  @override
  String get prProtectiveFactors => 'Защитные факторы';

  @override
  String get prChronicVulnerabilities => 'Хронические уязвимости';

  @override
  String get prDueDiligenceTitle => 'Чек-лист due diligence';

  @override
  String get prPreventiveMeasures => 'Профилактические меры';

  @override
  String get prImprovementTitle => 'План улучшений';

  @override
  String get prReliabilityTitle => 'Надёжность';

  @override
  String get prLayerD1 => 'Натальная карта (D1)';

  @override
  String get prLayerD4 => 'Карта собственности (D4)';

  @override
  String get prLayerD16 => 'Карта транспорта (D16)';

  @override
  String get prLayerDasha => 'Время по даше';

  @override
  String get prLayerTransit => 'Транзиты';

  @override
  String get prTopicBuying => 'Лучшее время для покупки?';

  @override
  String get prTopicInherit => 'Получу ли я наследство?';

  @override
  String get prTopicVehicle => 'Когда я получу транспортное средство?';

  @override
  String get prTopicRental => 'Потенциал дохода от аренды?';

  @override
  String get prTopicLand => 'Шансы на владение землёй?';

  @override
  String get prTopicLegal => 'На какие юридические риски обратить внимание?';

  @override
  String get prTopicForeign => 'Шансы на зарубежную собственность?';

  @override
  String get prTopicTiming => 'Лучшие временные окна для собственности?';

  @override
  String get edTitle => 'Анализ образования и обучения';

  @override
  String get edSubtitle =>
      'Отчёт об образовании на основе ИИ и ведической астрологии';

  @override
  String get edSnapshotHeader => 'Снимок вашего образования';

  @override
  String get edOverallStrength => 'Общая сила';

  @override
  String get edAcademicSuccess => 'Академический успех';

  @override
  String get edLearningCapacity => 'Способность к обучению';

  @override
  String get edIntellect => 'Интеллект';

  @override
  String get edMemory => 'Память';

  @override
  String get edStatusExcellent => 'Отличный потенциал';

  @override
  String get edStatusStrong => 'Сильный потенциал';

  @override
  String get edStatusModerate => 'Умеренный потенциал';

  @override
  String get edStatusDeveloping => 'Развивающийся потенциал';

  @override
  String get edStatusChallenging => 'Сложный период';

  @override
  String get edChipSaraswati => 'Йога Сарасвати';

  @override
  String get edChipGajaKesari => 'Йога Гаджа-Кесари';

  @override
  String get edChipBudhaAditya => 'Йога Будха-Адитья';

  @override
  String get edChipResearch => 'Сильные исследовательские способности';

  @override
  String get edChipScholarship => 'Потенциал получения стипендии';

  @override
  String get edChipDoctorate => 'Потенциал докторской степени';

  @override
  String get edChipForeign => 'Поддержка обучения за рубежом';

  @override
  String get edChipLifelong => 'Пожизненный ученик';

  @override
  String get edLearningStyleTitle => 'Ваш стиль обучения';

  @override
  String get edSoulPlanet => 'Планета души';

  @override
  String get edSoulHint =>
      'Ваше глубочайшее внутреннее стремление и цель жизни';

  @override
  String get edSubjectPlanet => 'Планета предмета';

  @override
  String get edTechAtmakaraka => 'Атмакарака (техническое)';

  @override
  String get edTechAmatyakaraka => 'Аматьякарака (техническое)';

  @override
  String get edSubjectKarakaStrength => 'Сила Караки предмета';

  @override
  String get edFoundationTitle => 'Основа образования';

  @override
  String get edHouse4 => 'Раннее школьное обучение';

  @override
  String get edHouse5 => 'Интеллект';

  @override
  String get edHouse9 => 'Высшее образование';

  @override
  String get edPurvaPunya => 'Заслуги прошлой жизни';

  @override
  String get edStudyPlanetsTitle => 'Ваши планеты обучения';

  @override
  String get edYogasTitle => 'Йоги образования в вашей карте';

  @override
  String get edYogaBudhaAditya => 'Будха-Адитья';

  @override
  String get edYogaGajaKesari => 'Гаджа-Кесари';

  @override
  String get edYogaSaraswati => 'Сарасвати';

  @override
  String get edYogaPresent => 'Присутствует';

  @override
  String get edYogaAbsent => 'Отсутствует';

  @override
  String get edYogaNoneNote =>
      'Классических йог образования нет — успех приходит через постоянные усилия и дисциплину.';

  @override
  String get edVerificationTitle => 'Подтверждение по картам';

  @override
  String get edD24Learning => 'D24 — карта глубокого обучения';

  @override
  String get edD4Formal => 'D4 — карта формального образования';

  @override
  String get edD9Dharma => 'D9 — карта дхармы обучения';

  @override
  String get edD60Karma => 'D60 — карма обучения прошлой жизни';

  @override
  String get edSubjectsTitle => 'Лучшие предметы для вас';

  @override
  String get edSubjectsSubtitle => 'Ранжировано по близости к карте';

  @override
  String get edLowAffinity => 'Предметы с меньшей склонностью';

  @override
  String get edDegreesTitle => 'Вероятность степени и уровня';

  @override
  String get edExpectedLevel => 'Ожидаемый уровень';

  @override
  String get edDegreeFormal => 'Формальная степень';

  @override
  String get edDegreePostgrad => 'Магистратура';

  @override
  String get edDegreeDoctorate => 'Докторантура';

  @override
  String get edDegreeForeign => 'Образование за рубежом';

  @override
  String get edTimelineTitle => 'Хронология обучения';

  @override
  String get edEarlySchooling => 'Окно раннего школьного обучения';

  @override
  String get edHigherEducation => 'Окно высшего образования';

  @override
  String get edPostgradResearch => 'Окно аспирантуры/исследований';

  @override
  String get edPeakLearningAge => 'Пик возраста обучения';

  @override
  String get edPreferencesTitle => 'Предпочтения в обучении и поддержка';

  @override
  String get edPrefStudyMode => 'Режим обучения';

  @override
  String get edPrefTiming => 'Лучшее время';

  @override
  String get edPrefEnvironment => 'Окружение';

  @override
  String get edPrefLocation => 'Местоположение';

  @override
  String get edPrefForeign => 'Обучение за рубежом';

  @override
  String get edGuruRelationship => 'Связь с учителем/гуру';

  @override
  String get edMentorAvailability => 'Доступность наставника';

  @override
  String get edPeerLearning => 'Обучение со сверстниками';

  @override
  String get edAuthorityDeference => 'Уважение к авторитету';

  @override
  String get edStrengthsTitle => 'Сильные стороны и трудности';

  @override
  String get edCognitiveGifts => 'Когнитивные дары';

  @override
  String get edNaturalAbilities => 'Природные способности к обучению';

  @override
  String get edHiddenCapacities => 'Скрытые способности';

  @override
  String get edConcentration => 'Трудности с концентрацией';

  @override
  String get edBreakRisk => 'Риск перерыва в образовании';

  @override
  String get edDisciplineConsistency => 'Последовательность дисциплины';

  @override
  String get edScholarshipLikelihood => 'Вероятность получения стипендии';

  @override
  String get edCareerLinkTitle => 'Путь от образования к карьере';

  @override
  String get edDirectionRec => 'Рекомендуемое направление';

  @override
  String get edIntegrationStrategy => 'Стратегия интеграции';

  @override
  String get edCareerLinkage => 'Связь с карьерой';

  @override
  String get edAlignedSubjects => 'Предметы, связанные с карьерой';

  @override
  String get edDegreeUtility => 'Полезность степени для карьеры';

  @override
  String get edImprovementTitle => 'Ваш план развития';

  @override
  String get edReliabilityTitle => 'Надёжность прогноза';

  @override
  String get edLayerD1 => 'Натальная карта (D1)';

  @override
  String get edLayerD4 => 'Формальное образование (D4)';

  @override
  String get edLayerD9 => 'Навамша (D9)';

  @override
  String get edLayerD24 => 'Глубокое обучение (D24)';

  @override
  String get edLayerD60 => 'Обучение прошлой жизни (D60)';

  @override
  String get edLayerAmk => 'Карака предмета';

  @override
  String get edLayerMj => 'Меркурий-Юпитер';

  @override
  String get edLayerDasha => 'Планетарное время';

  @override
  String get edTopicSubjects => 'Лучшие предметы для меня';

  @override
  String get edTopicDegree => 'Шансы на степень';

  @override
  String get edTopicAbroad => 'Учёба за рубежом';

  @override
  String get edTopicExam => 'Успеваемость на экзаменах';

  @override
  String get edTopicHabits => 'Учебные привычки';

  @override
  String get edTopicCareerLink => 'Связь образования с карьерой';

  @override
  String get edTopicTiming => 'Временные окна для обучения';

  @override
  String get edTopicScholarship => 'Шансы на стипендию';

  @override
  String get hwTitle => 'Анализ здоровья и благополучия';

  @override
  String get hwSubtitle =>
      'Отчёт о здоровье и благополучии на основе ИИ и ведической астрологии';

  @override
  String get hwSnapshotHeader => 'Снимок вашего здоровья';

  @override
  String get hwOverallVitality => 'Жизненная сила';

  @override
  String get hwImmunity => 'Иммунитет';

  @override
  String get hwRecovery => 'Восстановление';

  @override
  String get hwMentalWellness => 'Психическое благополучие';

  @override
  String get hwStressTolerance => 'Устойчивость к стрессу';

  @override
  String get hwStatusThriving => 'Процветание';

  @override
  String get hwStatusGood => 'Хорошая жизненная сила';

  @override
  String get hwStatusBalanced => 'Сбалансировано';

  @override
  String get hwStatusNeedsCare => 'Требует заботы';

  @override
  String get hwStatusNeedsAttention => 'Требует внимания';

  @override
  String get hwChipImmunity => 'Сильный иммунитет';

  @override
  String get hwChipRecovery => 'Быстрое восстановление';

  @override
  String get hwChipMentalBalance => 'Сбалансированный разум';

  @override
  String get hwChipStressResilience => 'Устойчив к стрессу';

  @override
  String get hwChipFertility => 'Поддержка фертильности';

  @override
  String get hwChipWorkLife => 'Хороший баланс работы и жизни';

  @override
  String get hwChipLowAddiction => 'Низкий риск зависимостей';

  @override
  String get hwConstitutionTitle => 'Ваш тип телосложения';

  @override
  String get hwConstitutionSubtitle =>
      'Аюрведическая конституция по вашей карте';

  @override
  String get hwDominantDosha => 'Доминирующий';

  @override
  String get hwSecondaryDosha => 'Вторичный';

  @override
  String get hwPrimaryKaraka => 'Основной показатель здоровья';

  @override
  String get hwStrongestSystem => 'Самая сильная система';

  @override
  String get hwWeakestSystem => 'Система, требующая поддержки';

  @override
  String get hwBodyMapTitle => 'Планетарная карта вашего тела';

  @override
  String get hwBodyMapSubtitle => '9 планет, 9 систем организма';

  @override
  String get hwYogaTitle => 'Паттерны здоровья в вашей карте';

  @override
  String get hwYogaSubtitle => 'Защитные йоги против йог давления болезни';

  @override
  String get hwDiseasePressureLabel => 'ДАВЛЕНИЕ БОЛЕЗНИ';

  @override
  String get hwAreasTitle => 'Зоны тела, требующие внимания';

  @override
  String get hwAreasSubtitle => 'Уязвимость по зонам тела';

  @override
  String get hwProtectedAreas => 'Хорошо защищённые зоны';

  @override
  String get hwCategoriesTitle => 'Наблюдение по категориям заболеваний';

  @override
  String get hwCategoriesSubtitle =>
      'Восприимчивость по основным категориям здоровья';

  @override
  String get hwLowRiskCategories => 'Категории низкого риска';

  @override
  String get hwMentalTitle => 'Психическое и эмоциональное благополучие';

  @override
  String get hwMentalSubtitle =>
      'Эмоциональная устойчивость и потребности в поддержке';

  @override
  String get hwMentalVulnerability => 'Эмоциональная чувствительность';

  @override
  String get hwEmotionalRegulation => 'Эмоциональная регуляция';

  @override
  String get hwSupportRec => 'Рекомендация по поддержке';

  @override
  String get hwTendencies => 'Психические склонности';

  @override
  String get hwTimelineTitle => 'Хронология здоровья';

  @override
  String get hwTimelineSubtitle =>
      'Годы пика, годы осторожности и окна восстановления';

  @override
  String get hwPeakYears => 'Годы пика благополучия';

  @override
  String get hwCautionYears => 'Годы осторожности';

  @override
  String get hwRecoveryWindow => 'Окно восстановления';

  @override
  String get hwCheckupYears => 'Рекомендуемые годы для обследований';

  @override
  String get hwCurrentPhase => 'Текущая фаза';

  @override
  String get hwLifestyleTitle => 'Ваш гид по образу жизни';

  @override
  String get hwLifestyleSubtitle =>
      'Что ваша карта говорит о ежедневных привычках';

  @override
  String get hwSleepDiscipline => 'Влияние дисциплины сна';

  @override
  String get hwDietDiscipline => 'Влияние дисциплины питания';

  @override
  String get hwExerciseNeed => 'Потребность в физической активности';

  @override
  String get hwSunlightNeed => 'Потребность в солнечном свете';

  @override
  String get hwStressSusceptibility => 'Восприимчивость к стрессу';

  @override
  String get hwHydrationSensitivity => 'Чувствительность к гидратации';

  @override
  String get hwSocialType => 'Тип социальной энергии';

  @override
  String get hwHealingSpeed => 'Скорость исцеления';

  @override
  String get hwTreatmentResponse => 'Реакция на лечение';

  @override
  String get hwAltHealing => 'Склонность к альтернативному лечению';

  @override
  String get hwSpecialTitle => 'Жизненные этапы и особые темы';

  @override
  String get hwSpecialSubtitle =>
      'Фертильность, здоровье в детстве, привычки и выгорание';

  @override
  String get hwFertility => 'Показатель фертильности';

  @override
  String get hwHormonalBalance => 'Гормональный баланс';

  @override
  String get hwReproductiveStrength => 'Сила репродуктивной системы';

  @override
  String get hwChildhoodVuln => 'Уязвимость здоровья в детстве';

  @override
  String get hwChildhoodStatus => 'Здоровье в детстве';

  @override
  String get hwAddictionVuln => 'Уязвимость к зависимостям';

  @override
  String get hwAddictionRecovery => 'Способность к восстановлению';

  @override
  String get hwBurnoutVuln => 'Уязвимость к выгоранию';

  @override
  String get hwWorkLifeBalance => 'Баланс работы и жизни';

  @override
  String get hwStressTriggers => 'Триггеры стресса';

  @override
  String get hwProtectiveFactors => 'Защитные факторы';

  @override
  String get hwChallengesTitle =>
      'Трудности, на которые стоит обратить внимание';

  @override
  String get hwChallengesSubtitle => 'На чём сосредоточить профилактику';

  @override
  String get hwMitigation => 'Как справляться';

  @override
  String get hwChronicAreas => 'Области хронической уязвимости';

  @override
  String get hwPreventivePriorities => 'Приоритеты профилактики';

  @override
  String get hwImprovementTitle => 'Ваш план благополучия';

  @override
  String get hwImprovementSubtitle =>
      'Практические шаги + традиционные средства';

  @override
  String get hwReliabilityTitle => 'Надёжность прогноза';

  @override
  String get hwLayerD1 => 'Натальная карта (D1)';

  @override
  String get hwLayerD6 => 'Карта здоровья (D6)';

  @override
  String get hwLayerD30 => 'Микрокарта здоровья (D30)';

  @override
  String get hwLayerDasha => 'Планетарное время';

  @override
  String get hwLayerTransit => 'Текущие транзиты';

  @override
  String get hwDisclaimerLabel => 'Медицинский отказ от ответственности';

  @override
  String get hwTopicImmunity => 'Укрепление иммунитета';

  @override
  String get hwTopicSleep => 'Сон и отдых';

  @override
  String get hwTopicStress => 'Управление стрессом';

  @override
  String get hwTopicFertility => 'Время для зачатия';

  @override
  String get hwTopicDiet => 'Диета и питание';

  @override
  String get hwTopicTiming => 'Временные окна для здоровья';

  @override
  String get hwTopicMental => 'Психическое благополучие';

  @override
  String get hwTopicPrevention => 'План профилактической заботы';

  @override
  String get lvSubtitle => 'Отчёт о любви на основе ИИ и ведической астрологии';

  @override
  String get lvTitle => 'Любовь и отношения';

  @override
  String get lvLovePotential => 'Потенциал в любви';

  @override
  String get lvEmotionalAvail => 'Эмоционально открыт(а)';

  @override
  String get lvAttraction => 'Притяжение';

  @override
  String get lvCommitment => 'Обязательства';

  @override
  String get lvCommunication => 'Общение';

  @override
  String get lvFidelity => 'Преданность';

  @override
  String get lvChipLoyal => 'Преданное сердце';

  @override
  String get lvChipOpenHeart => 'Открытое сердце';

  @override
  String get lvChipCommunicator => 'Отличный собеседник';

  @override
  String get lvChipMature => 'Хорошо справляется с конфликтами';

  @override
  String get lvChipEmotionallyWise => 'Эмоционально мудр(а)';

  @override
  String get lvLoveStyle => 'Ваш стиль любви';

  @override
  String get lvAttractionStyle => 'Стиль притяжения';

  @override
  String get lvLangGiven => 'Вы выражаете любовь через';

  @override
  String get lvLangReceived => 'Вы чувствуете себя любимым(ой), когда';

  @override
  String get lvLovePlanets => 'Ваши планеты любви';

  @override
  String get lvLoveKaraka => 'Любовь';

  @override
  String get lvEmotionKaraka => 'Эмоции';

  @override
  String get lvPassionKaraka => 'Страсть';

  @override
  String get lvPathToLove => 'Ваш путь к любви';

  @override
  String get lvPathSub => 'Любовь или брак по договорённости';

  @override
  String get lvLoveMarriage => 'Брак по любви';

  @override
  String get lvArrangedMarriage => 'Брак по договорённости';

  @override
  String get lvParentalAccept => 'Одобрение родителей';

  @override
  String get lvInterCaste => 'Межкастовые/межрелигиозные отношения';

  @override
  String get lvIdealPartner => 'Ваш идеальный партнёр';

  @override
  String get lvPersonality => 'Личность';

  @override
  String get lvAppearance => 'Внешность';

  @override
  String get lvIdealTraits => 'Идеальные черты';

  @override
  String get lvWhatMatters => 'Что важнее всего';

  @override
  String get lvDrawnTo => 'Вас привлекает';

  @override
  String get lvDealbreakers => 'Неприемлемые качества';

  @override
  String get lvYourAppeal => 'Ваша притягательность';

  @override
  String get lvLoveStory => 'Ваша история любви';

  @override
  String get lvLoveStorySub => 'Модели отношений';

  @override
  String get lvFirstLove => 'Первая любовь';

  @override
  String get lvRelationCount => 'Значимые связи';

  @override
  String get lvDuration => 'Типичная продолжительность';

  @override
  String get lvDepth => 'Эмоциональная глубина';

  @override
  String get lvDatingPattern => 'Модель свиданий';

  @override
  String get lvCommitIntimacy => 'Обязательства и близость';

  @override
  String get lvCommitReady => 'Готовность к обязательствам';

  @override
  String get lvIntimacyDrive => 'Стремление к близости';

  @override
  String get lvSensuality => 'Чувственность';

  @override
  String get lvEmpathy => 'Эмпатия';

  @override
  String get lvCommitStyle => 'Стиль обязательств';

  @override
  String get lvChemistry => 'Стиль химии';

  @override
  String get lvMakesCommit => 'Что заставляет вас взять на себя обязательства';

  @override
  String get lvMakesFlee => 'Что вас отталкивает';

  @override
  String get lvEmotional => 'Эмоциональный интеллект';

  @override
  String get lvEmotionalIQ => 'Эмоциональный IQ';

  @override
  String get lvConflictStyle => 'Стиль поведения в конфликте';

  @override
  String get lvTiming => 'Время для любви';

  @override
  String get lvNewLove12 => 'Новая любовь в течение 12 месяцев';

  @override
  String get lvEnergyNow => 'Энергия сейчас';

  @override
  String get lvPhaseNow => 'Текущая фаза';

  @override
  String get lvPeakRomance => 'Годы пика романтики';

  @override
  String get lvNewLoveWindow => 'Окно новой любви';

  @override
  String get lvChallenges => 'Трудности, на которые стоит обратить внимание';

  @override
  String get lvRiskHeartbreak => 'Уязвимость к разбитому сердцу';

  @override
  String get lvRiskSabotage => 'Самосаботаж';

  @override
  String get lvRiskCommitFear => 'Страх обязательств';

  @override
  String get lvRiskRepeat => 'Повторяющиеся паттерны';

  @override
  String get lvRiskWorkaholic => 'Работа вместо любви';

  @override
  String get lvRedFlags =>
      'Тревожные сигналы, на которые стоит обратить внимание';

  @override
  String get lvHealing => 'Что нужно исцелить';

  @override
  String get lvFocusArea => 'Область фокуса';

  @override
  String get lvHealDir => 'Направление исцеления';

  @override
  String get lvImprovementPlan => 'План улучшений';

  @override
  String get lvReliability => 'Надёжность прогноза';

  @override
  String get lvLayerBirth => 'Натальная карта (D1)';

  @override
  String get lvLayerNavamsa => 'Навамша (D9)';

  @override
  String get lvLayerSaptamsa => 'Саптамша (D7)';

  @override
  String get lvLayerDasha => 'Время по даше';

  @override
  String get lvLayerTransit => 'Текущие транзиты';

  @override
  String get lvTopicWhen => 'Когда я найду любовь?';

  @override
  String get lvTopicSoulmate => 'О моей второй половинке';

  @override
  String get lvTopicCurrent => 'Мои текущие отношения';

  @override
  String get lvTopicHeal => 'Исцеление от прошлого';

  @override
  String get lvTopicCommit => 'Помощь с обязательствами';

  @override
  String get lvTopicLoveVsArranged => 'Любовь или брак по договорённости';

  @override
  String get lvTopicHeartbreak => 'Как избежать разбитого сердца';

  @override
  String get lvTopicConfidence => 'Уверенность в любви';

  @override
  String get mrSubtitle => 'Отчёт о браке на основе ИИ и ведической астрологии';

  @override
  String get mrTitle => 'Брак и семья';

  @override
  String get mrMarriagePotential => 'Потенциал брака';

  @override
  String get mrHarmony => 'Гармония';

  @override
  String get mrLongevity => 'Долговечность';

  @override
  String get mrSatisfaction => 'Удовлетворённость';

  @override
  String get mrStability => 'Стабильность дома';

  @override
  String get mrClarity => 'Ясность';

  @override
  String get mrChipHarmony => 'Гармоничная связь';

  @override
  String get mrChipNoMangal => 'Нет Мангал-доши';

  @override
  String get mrChipLongLasting => 'Долговечный брак';

  @override
  String get mrChipHome => 'Вероятно собственное жильё';

  @override
  String get mrChipInLaws => 'Хорошие отношения со свёкрами/тестями';

  @override
  String get mrChipChildren => 'Благословлены детьми';

  @override
  String get mrSpouse => 'Ваш будущий супруг';

  @override
  String get mrSpouseSub => 'Что предполагает карта';

  @override
  String get mrSpouseTraits => 'Вероятная личность';

  @override
  String get mrSpouseWork => 'Вероятная профессия';

  @override
  String get mrAgeDiff => 'Разница в возрасте';

  @override
  String get mrCulture => 'Культурное соответствие';

  @override
  String get mrEducation => 'Образование';

  @override
  String get mrFamilyBg => 'Семейное происхождение';

  @override
  String get mrSoulPartnership => 'Душа и партнёрство';

  @override
  String get mrSelfPlanet => 'Вы в отношениях';

  @override
  String get mrSpousePlanet => 'Ваша планета супруга';

  @override
  String get mrSoulAlignment => 'Согласованность душ';

  @override
  String get mrAlignStrong =>
      'Ваша душа и идеальный партнёр сильно согласованы — глубоко удовлетворяющая связь хорошо поддержана.';

  @override
  String get mrAlignModerate =>
      'Ваша душа и идеальный партнёр умеренно согласованы — удовлетворяющая связь растёт при осознанных усилиях.';

  @override
  String get mrAlignLow =>
      'Вашей душе и партнёрству нужна осознанная интеграция — выбирайте партнёра, который действительно соответствует вашим внутренним ценностям.';

  @override
  String get mrTechDarakaraka => 'Планета супруга (Даракарака)';

  @override
  String get mrUpapada => 'Точка брака (Упапада)';

  @override
  String get mrUpapadaLord => 'Управитель Упапады';

  @override
  String get mrFoundation => 'Основа брака';

  @override
  String get mrMarriageSign => 'Знак брака';

  @override
  String get mrMarriageLord => 'Управитель брака';

  @override
  String get mrHouseStrength => 'Сила дома';

  @override
  String get mrPartnerHint => 'Подсказка о партнёре по вашей карте';

  @override
  String get mrHarmonyHdr => 'Гармония совместимости';

  @override
  String get mrHarmonySub => 'Как вы будете общаться';

  @override
  String get mrEmotional => 'Эмоциональная';

  @override
  String get mrIntellectual => 'Интеллектуальная';

  @override
  String get mrPhysical => 'Физическая близость';

  @override
  String get mrFinancial => 'Финансовая';

  @override
  String get mrCommunication => 'Общение';

  @override
  String get mrSharedValues => 'Общие ценности';

  @override
  String get mrSpiritual => 'Духовная';

  @override
  String get mrConflictRes => 'Разрешение конфликтов';

  @override
  String get mrTiming => 'Время для брака';

  @override
  String get mrFirstMarriageAge => 'Вероятный возраст вступления в брак';

  @override
  String get mrDelayChance => 'Вероятность задержки';

  @override
  String get mrMarriageWindow => 'Окно для брака';

  @override
  String get mrSecondaryWindow => 'Альтернативное окно';

  @override
  String get mrCurrentReadiness => 'Прямо сейчас';

  @override
  String get mrJourney => 'Путь брака';

  @override
  String get mrJourneySub => 'Как развивается связь';

  @override
  String get mrPhaseEarly => 'Ранние годы';

  @override
  String get mrPhaseMid => 'Средние годы';

  @override
  String get mrPhaseMature => 'Зрелые годы';

  @override
  String get mrPhaseLate => 'Поздние годы';

  @override
  String get mrTip => 'Совет';

  @override
  String get mrFamilyHome => 'Семья и дом';

  @override
  String get mrInLaws => 'Отношения со свёкрами/тестями';

  @override
  String get mrFamilyHarmony => 'Семейная гармония';

  @override
  String get mrHomeOwnership => 'Владение жильём';

  @override
  String get mrDomesticPeace => 'Домашний покой';

  @override
  String get mrFertility => 'Фертильность';

  @override
  String get mrParenting => 'Гармония в воспитании детей';

  @override
  String get mrChildren => 'Дети';

  @override
  String get mrLikelyCount => 'Вероятное количество';

  @override
  String get mrVerification => 'Перекрёстная проверка по картам';

  @override
  String get mrD9 => 'Карта брака (D9)';

  @override
  String get mrD10 => 'Карта карьеры-супруга (D10)';

  @override
  String get mrD60 => 'Карта кармы (D60)';

  @override
  String get mrChallenges => 'Трудности, на которые стоит обратить внимание';

  @override
  String get mrMangalPresent =>
      'В карте присутствует Мангал-доша — внимательно изучите средства и подбор партнёра.';

  @override
  String get mrMangalAbsent =>
      'Мангал-доша не обнаружена — благоприятный показатель для брака.';

  @override
  String get mrRiskConflict => 'Конфликт';

  @override
  String get mrRiskSeparation => 'Разлука';

  @override
  String get mrRiskDistance => 'Эмоциональная дистанция';

  @override
  String get mrRiskInfidelity => 'Измена';

  @override
  String get mrRiskFinance => 'Разногласия по деньгам';

  @override
  String get mrPartnerGuide => 'Гид по выбору партнёра';

  @override
  String get mrPartnerGuideSub => 'На что обратить внимание';

  @override
  String get mrSeek => 'Ищите';

  @override
  String get mrMatchingPriorities => 'Приоритеты подбора';

  @override
  String get mrImprovementPlan => 'План улучшений';

  @override
  String get mrReliability => 'Надёжность прогноза';

  @override
  String get mrLayerBirth => 'Натальная карта (D1)';

  @override
  String get mrLayerNavamsa => 'Навамша (D9)';

  @override
  String get mrLayerDashamsa => 'Дашамша (D10)';

  @override
  String get mrLayerShashtiamsa => 'Карма (D60)';

  @override
  String get mrLayerDarakaraka => 'Планета супруга';

  @override
  String get mrTopicWhen => 'Когда я вступлю в брак?';

  @override
  String get mrTopicSpouse => 'О моём супруге';

  @override
  String get mrTopicCompat => 'Советы по совместимости';

  @override
  String get mrTopicDelay => 'Задержка брака';

  @override
  String get mrTopicMangal => 'Мангал-доша';

  @override
  String get mrTopicChildren => 'Время рождения детей';

  @override
  String get mrTopicInLaws => 'Отношения со свёкрами/тестями';

  @override
  String get mrTopicHarmony => 'Построение гармонии';

  @override
  String get wlSubtitle =>
      'Отчёт о богатстве на основе ИИ и ведической астрологии';

  @override
  String get wlTitle => 'Богатство и финансы';

  @override
  String get wlWealthPotential => 'Потенциал богатства';

  @override
  String get wlAccumulation => 'Накопление';

  @override
  String get wlIncomeFlow => 'Денежный поток';

  @override
  String get wlRetention => 'Сохранение';

  @override
  String get wlSustainability => 'Устойчивость';

  @override
  String get wlSavings => 'Дисциплина сбережений';

  @override
  String get wlChipSaver => 'Прирождённый накопитель';

  @override
  String get wlChipMultiIncome => 'Несколько источников дохода';

  @override
  String get wlChipStrongYogas => 'Йоги богатства';

  @override
  String get wlChipLowDebt => 'Низкий долг';

  @override
  String get wlChipInheritance => 'Вероятно наследство';

  @override
  String get wlChipInvestor => 'Разумный инвестор';

  @override
  String get wlWealthClass => 'Класс богатства';

  @override
  String get wlWealthType => 'Основной тип богатства';

  @override
  String get wlPrimarySource => 'Основной доход';

  @override
  String get wlPeakAge => 'Возраст пика богатства';

  @override
  String get wlBoosters => 'Что усиливает ваше богатство';

  @override
  String get wlBoostersSub => 'Мощные денежные комбинации';

  @override
  String get wlWealthImpact => 'усиление';

  @override
  String get wlDrains => 'Утечки богатства';

  @override
  String get wlIncomeSources => 'Источники дохода';

  @override
  String get wlIncomeSourcesSub => 'Откуда приходят ваши деньги';

  @override
  String get wlPrimary => 'Основное';

  @override
  String get wlInvestment => 'Инвестиционный план';

  @override
  String get wlInvestmentSub => 'Идеальное сочетание активов';

  @override
  String get wlRiskAppetite => 'Аппетит к риску';

  @override
  String get wlInvestStyle => 'Инвестиционный стиль';

  @override
  String get wlDrivenBy => 'Движим';

  @override
  String get wlMoneyPersonality => 'Денежная личность';

  @override
  String get wlMoneyType => 'Денежный тип';

  @override
  String get wlSpending => 'Траты';

  @override
  String get wlSavingsDiscipline => 'Дисциплина сбережений';

  @override
  String get wlCharity => 'Склонность к благотворительности';

  @override
  String get wlLuxury => 'Траты на роскошь';

  @override
  String get wlWindfalls => 'Внезапные доходы и шансы';

  @override
  String get wlWindfallsSub => 'Деньги на основе удачи';

  @override
  String get wlInheritanceChance => 'Наследство';

  @override
  String get wlSuddenGains => 'Внезапные доходы';

  @override
  String get wlLottery => 'Лотерея/спекуляции';

  @override
  String get wlInsurance => 'Страховые выплаты';

  @override
  String get wlWindfallSource => 'Вероятный источник внезапного дохода';

  @override
  String get wlMoneyPlanets => 'Ваши денежные планеты';

  @override
  String get wlPrimaryKaraka => 'Основная денежная планета';

  @override
  String get wlSecondaryKaraka => 'Вторичная денежная планета';

  @override
  String get wlTimeline => 'Хронология богатства';

  @override
  String get wlPeakYears => 'Годы пика';

  @override
  String get wlGoodPeriod => 'Период процветания';

  @override
  String get wlSuddenGainWindow => 'Окно внезапного дохода';

  @override
  String get wlToughPeriod => 'Осторожный период';

  @override
  String get wlDebtRisks => 'Долги и денежные риски';

  @override
  String get wlDebtChance => 'Вероятность долга';

  @override
  String get wlLoanBurden => 'Бремя кредита';

  @override
  String get wlDrainSources => 'Остерегайтесь';

  @override
  String get wlStrengthen => 'Что укрепить';

  @override
  String get wlWeakestDriver => 'Самый слабый денежный фактор';

  @override
  String get wlHowToFix => 'Как укрепить';

  @override
  String get wlImprovementPlan => 'План улучшений';

  @override
  String get wlReliability => 'Надёжность прогноза';

  @override
  String get wlLayerBirth => 'Дома богатства (D1)';

  @override
  String get wlLayerHora => 'Хора-карта (D2)';

  @override
  String get wlLayerNavamsa => 'Навамша (D9)';

  @override
  String get wlLayerDasha => 'Время по даше';

  @override
  String get wlLayerTransit => 'Текущие транзиты';

  @override
  String get wlTopicGrow => 'Как приумножить богатство';

  @override
  String get wlTopicInvest => 'Куда инвестировать';

  @override
  String get wlTopicDebt => 'Управление долгами';

  @override
  String get wlTopicProperty => 'Покупка недвижимости';

  @override
  String get wlTopicRetire => 'Планирование пенсии';

  @override
  String get wlTopicPassive => 'Пассивный доход';

  @override
  String get wlTopicWindfall => 'Внезапные доходы';

  @override
  String get wlTopicTiming => 'Лучшее время для денег';

  @override
  String get bzSubtitle =>
      'Отчёт о бизнесе на основе ИИ и ведической астрологии';

  @override
  String get bzTitle => 'Бизнес и стартапы';

  @override
  String get bzBusinessPotential => 'Потенциал бизнеса';

  @override
  String get bzEntrepreneurship => 'Предприниматель';

  @override
  String get bzVenture => 'Успех предприятия';

  @override
  String get bzWealth => 'Богатство через бизнес';

  @override
  String get bzRiskAppetite => 'Аппетит к риску';

  @override
  String get bzLongevity => 'Долговечность';

  @override
  String get bzChipWealthMagnet => 'Магнит богатства';

  @override
  String get bzChipMoneyYoga => 'Денежная йога';

  @override
  String get bzChipLeadership => 'Лидерство';

  @override
  String get bzChipPartnerFit => 'Отлично подходит в партнёры';

  @override
  String get bzChipGains => 'Сильная прибыль';

  @override
  String get bzChipInvestor => 'Привлекательность для инвесторов';

  @override
  String get bzChipFounder => 'Мышление основателя';

  @override
  String get bzWhatsWorking => 'Что работает в вашу пользу';

  @override
  String get bzWhatsWorkingSub => 'Ваши бизнес-дары';

  @override
  String get bzClassicYogas => 'Классические комбинации богатства';

  @override
  String get bzFounderType => 'Ваш тип основателя';

  @override
  String get bzSoulBusiness => 'Душа и цель бизнеса';

  @override
  String get bzSoulPlanet => 'Двигатель вашей души';

  @override
  String get bzBusinessPlanet => 'Ваш деловой ум';

  @override
  String get bzDirectionStrength => 'Ясность направления';

  @override
  String get bzAlignStrong =>
      'Цель вашей души и направление бизнеса сильно согласованы — построение предприятия ощущается естественным и полноценным.';

  @override
  String get bzAlignModerate =>
      'Цель вашей души и направление бизнеса умеренно согласованы — предприятие работает лучше всего, когда отражает ваши глубинные ценности.';

  @override
  String get bzAlignLow =>
      'Цели вашей души и направлению бизнеса требуется осознанное согласование — выбирайте предприятие, которое действительно соответствует вашей сути.';

  @override
  String get bzTechAtmakaraka => 'Планета души (Атмакарака)';

  @override
  String get bzTechAmatyakaraka => 'Бизнес-планета (Аматьякарака)';

  @override
  String get bzTechDarakaraka => 'Планета партнёра (Даракарака)';

  @override
  String get bzFoundation => 'Основа бизнеса';

  @override
  String get bzCareerHouse => 'Дом карьеры';

  @override
  String get bzGainsHouse => 'Дом доходов';

  @override
  String get bzLord => 'Управитель';

  @override
  String get bzGainsPotential => 'Потенциал доходов';

  @override
  String get bzNetwork => 'Сила связей';

  @override
  String get bzRecovery => 'Сила восстановления';

  @override
  String get bzVerification => 'Перекрёстная проверка по картам';

  @override
  String get bzD10 => 'Карта карьеры (D10)';

  @override
  String get bzD11 => 'Карта доходов (D11)';

  @override
  String get bzD9 => 'Карта цели (D9)';

  @override
  String get bzD60 => 'Карта кармы (D60)';

  @override
  String get bzFounderSkills => 'Навыки основателя';

  @override
  String get bzSkillStrategy => 'Стратегическое мышление';

  @override
  String get bzSkillExecution => 'Исполнение';

  @override
  String get bzSkillPeople => 'Управление людьми';

  @override
  String get bzSkillSales => 'Продажи и убеждение';

  @override
  String get bzSkillFinance => 'Финансовая хватка';

  @override
  String get bzSkillOps => 'Операционная дисциплина';

  @override
  String get bzTopSkill => 'Главный навык';

  @override
  String get bzDomains => 'Лучшие сферы бизнеса';

  @override
  String get bzDomainsSub => 'Ранжировано по естественной склонности';

  @override
  String get bzFit => 'СООТВЕТСТВИЕ';

  @override
  String get bzBusinessStyleHdr => 'Стиль бизнеса';

  @override
  String get bzStyleService => 'Продукт против услуги';

  @override
  String get bzStyleMarket => 'Фокус на рынке';

  @override
  String get bzStyleTech => 'Технологический подход';

  @override
  String get bzStyleLeadership => 'Стиль лидерства';

  @override
  String get bzStylePartnership => 'Соло или партнёрство';

  @override
  String get bzWhereBuild => 'Охват';

  @override
  String get bzExpansion => 'Экспансия';

  @override
  String get bzSetup => 'Организация';

  @override
  String get bzPartnership => 'Партнёрство и команда';

  @override
  String get bzIdealCofounder => 'Идеальный сооснователь';

  @override
  String get bzPartnerViability => 'Соответствие партнёрству';

  @override
  String get bzTeamBuilding => 'Формирование команды';

  @override
  String get bzCofounderFit => 'Соответствие сооснователя';

  @override
  String get bzAdvisorNetwork => 'Сеть советников';

  @override
  String get bzFunding => 'Финансирование и деньги';

  @override
  String get bzRecommendedPath => 'Рекомендуемый путь финансирования';

  @override
  String get bzInvestorAttract => 'Привлекательность для инвесторов';

  @override
  String get bzFamilyBacking => 'Поддержка семьи';

  @override
  String get bzHybridViability => 'Сочетание работы и бизнеса';

  @override
  String get bzFallback => 'Работа как подстраховка';

  @override
  String get bzDebtStyle => 'Стиль работы с долгом';

  @override
  String get bzTimeline => 'Хронология бизнеса';

  @override
  String get bzCurrentPhase => 'Прямо сейчас';

  @override
  String get bzLaunchWindow => 'Окно запуска';

  @override
  String get bzScaleWindow => 'Окно роста';

  @override
  String get bzPeakAge => 'Годы пика';

  @override
  String get bzChallenges => 'Трудности, на которые стоит обратить внимание';

  @override
  String get bzRiskFinancial => 'Финансовые потери';

  @override
  String get bzRiskBurnout => 'Выгорание';

  @override
  String get bzRiskTeam => 'Конфликт в команде';

  @override
  String get bzRiskLegal => 'Юридические/нормативные вопросы';

  @override
  String get bzFinancialExp =>
      'Риск потери денег из-за чрезмерных инвестиций или неудачного времени денежного потока во время предприятия.';

  @override
  String get bzFinancialFix =>
      'Держите денежный резерв, начинайте экономно и проверяйте спрос, прежде чем наращивать расходы.';

  @override
  String get bzBurnoutExp =>
      'Слишком долгое чрезмерное напряжение может истощить вашу энергию и внимание.';

  @override
  String get bzBurnoutFix =>
      'Берегите отдых, делегируйте заранее и распределяйте большие рывки по благоприятным периодам.';

  @override
  String get bzTeamExp =>
      'Трения с сооснователями или сотрудниками могут замедлить бизнес.';

  @override
  String get bzTeamFix =>
      'Чётко закрепляйте роли и ожидания письменно и общайтесь часто.';

  @override
  String get bzLegalExp =>
      'Проблемы с соответствием, контрактами или регулированием могут создать препятствия.';

  @override
  String get bzLegalFix =>
      'Проверяйте контракты, ведите документацию в порядке и заранее консультируйтесь со специалистами.';

  @override
  String get bzImprovementPlan => 'План улучшений';

  @override
  String get bzBestDirection => 'Лучшее направление';

  @override
  String get bzStrategy => 'Стратегия развития';

  @override
  String get bzTopFields => 'Лучшие сферы';

  @override
  String get bzEmploymentPath => 'Работа против бизнеса';

  @override
  String get bzRoadmap => 'Дорожная карта роста';

  @override
  String get bzRoadmapSub => 'Ваш план предприятия';

  @override
  String get bzReliability => 'Надёжность прогноза';

  @override
  String get bzLayerBirth => 'Натальная карта (D1)';

  @override
  String get bzLayerNavamsa => 'Навамша (D9)';

  @override
  String get bzLayerDashamsa => 'Карьера (D10)';

  @override
  String get bzLayerLabhamsa => 'Доходы (D11)';

  @override
  String get bzLayerShashtiamsa => 'Карма (D60)';

  @override
  String get bzTopicStart => 'Стоит ли начинать сейчас?';

  @override
  String get bzTopicIdea => 'Лучшая бизнес-идея';

  @override
  String get bzTopicPartner => 'Поиск сооснователя';

  @override
  String get bzTopicFunding => 'Как это финансировать';

  @override
  String get bzTopicScale => 'Когда масштабироваться';

  @override
  String get bzTopicRisk => 'Управление рисками';

  @override
  String get bzTopicJob => 'Работа против бизнеса';

  @override
  String get bzTopicTiming => 'Лучшее время';

  @override
  String get crTitle => 'Анализ карьеры и работы';

  @override
  String get crSubtitle =>
      'Отчёт о карьере на основе ИИ и ведической астрологии';

  @override
  String get crCrumbHome => 'Главная';

  @override
  String get crCrumbReports => 'Отчёты';

  @override
  String get crCareerPotential => 'Потенциал карьеры';

  @override
  String get crStatusStrong => 'Сильный потенциал';

  @override
  String get crStatusGood => 'Хороший потенциал';

  @override
  String get crStatusModerate => 'Умеренный потенциал';

  @override
  String get crStatusDeveloping => 'Развивающийся потенциал';

  @override
  String get crStatusChallenging => 'Сложный период';

  @override
  String get crOverallCareer => 'Карьера в целом';

  @override
  String get crStability => 'Стабильность карьеры';

  @override
  String get crGrowth => 'Потенциал роста';

  @override
  String get crRecognition => 'Признание';

  @override
  String get crSatisfaction => 'Удовлетворённость';

  @override
  String get crChipLeadership => 'Лидерство';

  @override
  String get crChipCreativity => 'Креативность';

  @override
  String get crChipBusiness => 'Бизнес';

  @override
  String get crChipStableIncome => 'Стабильный доход';

  @override
  String get crChipLearning => 'Обучение';

  @override
  String get crChipGrowth => 'Долгосрочный рост';

  @override
  String get crChipTechnical => 'Технические навыки';

  @override
  String get crChipRecognition => 'Признание';

  @override
  String get crTopInsights => 'Главные выводы';

  @override
  String get crWhatDefines => 'Что определяет вашу карьеру?';

  @override
  String get crSoulCareer => 'Душа и цель карьеры';

  @override
  String get crSoulPlanet => 'Планета цели души';

  @override
  String get crCareerPlanet => 'Планета карьеры';

  @override
  String get crMeaning => 'Значение';

  @override
  String get crAlignment => 'Согласованность души и карьеры';

  @override
  String get crAlignStrong =>
      'Ваши природные интересы и карьерный путь сильно согласованы.';

  @override
  String get crAlignModerate =>
      'Ваши природные интересы и карьерный путь умеренно согласованы.';

  @override
  String get crAlignLow =>
      'Вашим природным интересам и карьерному пути требуется осознанное согласование.';

  @override
  String get crTechAtmakaraka => 'Атмакарака (указатель души)';

  @override
  String get crTechAmatyakaraka => 'Аматьякарака (указатель карьеры)';

  @override
  String get crDegrees => 'Градусы';

  @override
  String get crDignity => 'Достоинство';

  @override
  String get crFoundation => 'Основа карьеры';

  @override
  String get crCareerSign => 'Знак карьеры';

  @override
  String get crCareerLord => 'Управитель карьеры';

  @override
  String get crLordPosition => 'Положение управителя';

  @override
  String get crCareerStrength => 'Сила карьеры';

  @override
  String get crProfStyle => 'Профессиональный стиль';

  @override
  String get crBestFields => 'Лучшие сферы';

  @override
  String get crTechnicalDetails => 'Технические детали';

  @override
  String get crHouseLabel => 'Дом';

  @override
  String get crVerification => 'Проверка карьеры по картам';

  @override
  String get crD10Career => 'D10 · Карьера';

  @override
  String get crD9Purpose => 'D9 · Цель';

  @override
  String get crD60Karma => 'D60 · Карма';

  @override
  String get crStatusNeedsImprovement => 'Требует улучшения';

  @override
  String get crStatusWellAligned => 'Хорошо согласовано';

  @override
  String get crStatusStrongSupport => 'Сильная поддержка';

  @override
  String get crStatusModerateSupport => 'Умеренная поддержка';

  @override
  String get crChartDetails => 'Технические детали карты';

  @override
  String get crPersonality => 'Ваша карьерная личность';

  @override
  String get crGrowthAreas => 'Области для роста';

  @override
  String get crBestRoles => 'Лучшие роли';

  @override
  String get crBestIndustries => 'Лучшие отрасли';

  @override
  String get crEnvironment => 'Рабочая среда';

  @override
  String get crWorkStyle => 'Лучший стиль работы';

  @override
  String get crEmployment => 'Наёмная работа';

  @override
  String get crBusiness => 'Бизнес';

  @override
  String get crFreelance => 'Фриланс/консалтинг';

  @override
  String get crPortfolio => 'Смешанный портфель';

  @override
  String get crLeadership => 'Лидерство';

  @override
  String get crFit => 'Соответствие';

  @override
  String get crBestFit => 'Наилучшее соответствие';

  @override
  String get crTimeline => 'Хронология карьеры';

  @override
  String get crPastPeak => 'Прошлый пик';

  @override
  String get crPresentPhase => 'Текущая фаза';

  @override
  String get crUpcoming => 'Предстоящая возможность';

  @override
  String get crFutureExpansion => 'Будущая экспансия';

  @override
  String get crRiskPeriod => 'Период риска';

  @override
  String get crViewDasha => 'Планетарный период (техническое)';

  @override
  String get crChallenges => 'Трудности, на которые стоит обратить внимание';

  @override
  String get crRiskBurnout => 'Выгорание';

  @override
  String get crRiskRecognition => 'Задержка признания';

  @override
  String get crRiskConflict => 'Конфликт на работе';

  @override
  String get crRiskFinancial => 'Финансовая нестабильность';

  @override
  String get crRiskOverqual => 'Недоиспользование потенциала';

  @override
  String get crPrevention => 'Профилактика';

  @override
  String get crBurnoutExp =>
      'Долгие, требовательные фазы со временем могут истощить вашу энергию.';

  @override
  String get crBurnoutFix =>
      'Берегите отдых, устанавливайте границы и распределяйте большие усилия.';

  @override
  String get crRecognitionExp =>
      'Награды и признание могут приходить медленнее, чем ваши усилия.';

  @override
  String get crRecognitionFix =>
      'Документируйте успехи и делайте свой вклад заметным для руководства.';

  @override
  String get crConflictExp =>
      'Порой могут возникать трения с коллегами или руководством.';

  @override
  String get crConflictFix =>
      'Общайтесь спокойно и разумно выбирайте, за что стоит бороться.';

  @override
  String get crFinancialExp =>
      'Доход может ощущаться неравномерным в определённые периоды.';

  @override
  String get crFinancialFix =>
      'Держите резерв и избегайте чрезмерных финансовых обязательств.';

  @override
  String get crOverqualExp =>
      'Иногда вы можете чувствовать себя недоиспользованным или недостаточно задействованным.';

  @override
  String get crOverqualFix =>
      'Ищите вызовы на вырост и продолжайте учиться, чтобы оставаться вовлечённым.';

  @override
  String get crImprovementPlan => 'План развития карьеры';

  @override
  String get crCatPlanetary => 'Планетарное и духовное';

  @override
  String get crCatPractical => 'Практические шаги';

  @override
  String get crTraditionalExplain =>
      'Объяснение с точки зрения традиционной астрологии';

  @override
  String get crActionPlan => '30-дневный план карьерных действий';

  @override
  String get crWeek1 => 'Неделя 1 · Оптимизация профиля';

  @override
  String get crWeek2 => 'Неделя 2 · Развитие навыков';

  @override
  String get crWeek3 => 'Неделя 3 · Нетворкинг';

  @override
  String get crWeek4 => 'Неделя 4 · Карьерная видимость';

  @override
  String get crWeek1Tip =>
      'Обновите резюме и LinkedIn вокруг вашей самой сильной карьерной темы.';

  @override
  String get crWeek2Tip =>
      'Выберите один ценный навык в вашей лучшей области и практикуйте его ежедневно.';

  @override
  String get crWeek3Tip =>
      'Восстановите связь с наставниками и обратитесь к двум новым контактам в отрасли.';

  @override
  String get crWeek4Tip =>
      'Делитесь своей работой публично и вызовитесь на заметный проект.';

  @override
  String get crPriority => 'Приоритет';

  @override
  String get crTimeRequired => 'Время';

  @override
  String get crExpectedBenefit => 'Польза';

  @override
  String get crPriorityHigh => 'Высокий';

  @override
  String get crPriorityMedium => 'Средний';

  @override
  String get crRoadmap => 'Дорожная карта карьеры от ИИ';

  @override
  String get crNext12 => 'Ближайшие 12 месяцев';

  @override
  String get crBestFocus => 'Лучший фокус';

  @override
  String get crSkillsLearn => 'Навыки для изучения';

  @override
  String get crIndustriesTarget => 'Отрасли для нацеливания';

  @override
  String get crExpectedOutcome => 'Ожидаемый результат';

  @override
  String get crReliability => 'Надёжность прогноза';

  @override
  String get crReliabilityHigh => 'Высокая надёжность';

  @override
  String get crReliabilityGood => 'Хорошая надёжность';

  @override
  String get crReliabilityModerate => 'Умеренная надёжность';

  @override
  String get crReliabilityExplain =>
      'Этот отчёт объединяет вашу натальную карту, дробные карты и показатели Джаймини. Оценка отражает, насколько сильно эти слои карты согласуются друг с другом.';

  @override
  String get crChartLayers => 'Слои карты и их вес';

  @override
  String get crBirthChart => 'Натальная карта (D1)';

  @override
  String get crNavamsa => 'Навамша (D9)';

  @override
  String get crDashamsa => 'Дашамша (D10)';

  @override
  String get crShashtiamsa => 'Шаштьямша (D60)';

  @override
  String get crDiscussAi => 'Обсудить с ИИ';

  @override
  String get crAskAbout => 'Спросить о';

  @override
  String get crTopicChange => 'Смена карьеры';

  @override
  String get crTopicGovt => 'Государственная работа';

  @override
  String get crTopicBusiness => 'Бизнес';

  @override
  String get crTopicPromotion => 'Повышение';

  @override
  String get crTopicMarriage => 'Брак против карьеры';

  @override
  String get crTopicAbroad => 'За границей';

  @override
  String get crTopicIncome => 'Доход';

  @override
  String get crTopicPurpose => 'Цель';

  @override
  String get crTopicResume => 'Резюме';

  @override
  String get crTopicCopied => 'Вопрос скопирован — вставьте его в чат с ИИ.';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul направляет ваше внутреннее призвание, а $career формирует вашу внешнюю профессию.';
  }

  @override
  String get rzTodayOutlook => 'Сегодняшний гороскоп';

  @override
  String get rzPlanetaryEnergy => 'Сегодняшняя планетарная энергия';

  @override
  String get rzBestSign => 'Лучший знак';

  @override
  String get rzChallengingSign => 'Самый сложный';

  @override
  String get rzDominantPlanet => 'Доминирующая планета';

  @override
  String get rzOverallMood => 'Общее настроение';

  @override
  String get rzMoodBright => 'Яркое и активное';

  @override
  String get rzMoodCalm => 'Спокойное и устойчивое';

  @override
  String get rzMoodMixed => 'Смешанная энергия';

  @override
  String get rzMoodTense => 'Напряжённое и осторожное';

  @override
  String get rzTodayEnergy => 'Сегодняшняя энергия';

  @override
  String get rzCaution => 'Осторожность';

  @override
  String get rzWeak => 'Слабая';

  @override
  String get rzAllSigns => 'Все знаки зодиака';

  @override
  String get rzAiSummary => 'Резюме от ИИ';

  @override
  String get rzPlanetaryInfluence => 'Сегодняшнее планетарное влияние';

  @override
  String get rzStrongInfluences => 'Сильные влияния';

  @override
  String get rzShowTechnical => 'Показать технические детали';

  @override
  String get rzOpportunities => 'Сегодняшние возможности';

  @override
  String get rzAvoidTitle => 'Чего избегать сегодня';

  @override
  String get rzTechnicalReason => 'Техническая причина';

  @override
  String get rzAvoidDecisions => 'Поспешность в важных решениях';

  @override
  String get rzAvoidArguments => 'Горячие споры';

  @override
  String get rzAvoidInvestments => 'Крупные инвестиции';

  @override
  String get rzAvoidOverthink => 'Чрезмерное обдумывание мелочей';

  @override
  String get rzAvoidOverspend => 'Ненужные траты';

  @override
  String get rzAvoidStress => 'Стресс и переработка';

  @override
  String get rzPlanetaryChart => 'Сегодняшняя планетарная карта';

  @override
  String get rzWhatChartMeans => 'Что означает эта карта';

  @override
  String get rzChartExplain =>
      'Этот ромб показывает, где сегодня находится каждая планета на небе относительно вашего знака. Планеты в благоприятных домах поднимают день; в сложных домах — требуют осторожности.';

  @override
  String get rzDoNetworking => 'Нетворкинг и общение';

  @override
  String get rzDoLearning => 'Изучение чего-то нового';

  @override
  String get rzDoMeditation => 'Медитация и спокойствие';

  @override
  String get rzDoFamily => 'Время с семьёй';

  @override
  String get rzDoCreative => 'Творческая работа';

  @override
  String get rzDoRest => 'Отдых и забота о себе';

  @override
  String get rzAiRecommendations => 'Сегодняшние рекомендации ИИ';

  @override
  String get rzTechnical => 'Техническая астрология';

  @override
  String get rzTransitScore => 'Балл транзита';

  @override
  String get rzVedha => 'Ведха (препятствия)';

  @override
  String get rzGocharDetails => 'Детали транзита (гочара)';

  @override
  String get rzAdvancedOnly => 'Для продвинутых пользователей';

  @override
  String get rzTomorrow => 'Превью на завтра';

  @override
  String get rzTomorrowEnergy => 'Завтрашняя энергия';

  @override
  String get rzImproving => 'Улучшается';

  @override
  String get rzWeaker => 'Немного слабее';

  @override
  String get rzSteady => 'Стабильно';

  @override
  String get rzTomorrowUpLine =>
      'Ожидается, что завтра энергия возрастёт — планируйте важные дела заранее.';

  @override
  String get rzTomorrowDownLine =>
      'Завтра энергия может немного снизиться — сделайте день лёгким и размеренным.';

  @override
  String get rzTomorrowFlatLine =>
      'Завтра энергия остаётся стабильной — впереди спокойный, сбалансированный день.';

  @override
  String get rzWeeklyTrend => 'Недельная тенденция';

  @override
  String get rzMonthlyTrend => 'Месячная тенденция';

  @override
  String get rzBestDayWeek => 'Лучший день';

  @override
  String get rzHardestDay => 'Самый сложный день';

  @override
  String get rzLuckyToday => 'Удача сегодня';

  @override
  String get rzKarakaSun => 'уверенность и жизненная сила';

  @override
  String get rzKarakaMoon => 'эмоции и душевный покой';

  @override
  String get rzKarakaMars => 'энергия и напор';

  @override
  String get rzKarakaMercury => 'общение и обучение';

  @override
  String get rzKarakaJupiter => 'мудрость и рост';

  @override
  String get rzKarakaVenus => 'отношения и комфорт';

  @override
  String get rzKarakaSaturn => 'дисциплина и терпение';

  @override
  String get rzKarakaRahu => 'амбиции и перемены';

  @override
  String get rzKarakaKetu => 'духовность и отпускание';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom задаёт тон дня, а $chal требует терпения и заботы.';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'Хороший день для $karaka.';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'Сегодня действуйте не спеша в отношении $karaka.';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka сегодня хорошо поддерживается.';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka сегодня может столкнуться с задержками.';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'Сегодня поддерживается $strong, а $weak требует терпения и заботы.';
  }

  @override
  String get fdEnergyScore => 'Сегодняшний балл энергии';

  @override
  String get fdStatusAverage => 'Средне';

  @override
  String get fdStatusMixed => 'Смешанно';

  @override
  String get fdStatusChallenging => 'Сложно';

  @override
  String get fdTheme => 'Тема дня';

  @override
  String get fdExplainToday => 'Объяснить сегодняшний день';

  @override
  String get fdTodaysFocus => 'Фокус дня';

  @override
  String get fdTopRecommendation => 'Главная рекомендация';

  @override
  String get fdTopCaution => 'Главная предосторожность';

  @override
  String get fdReadingTime => 'Время чтения';

  @override
  String get fdSeconds30 => '30 сек';

  @override
  String get fdCareer => 'Карьера';

  @override
  String get fdMoney => 'Деньги';

  @override
  String get fdLove => 'Любовь';

  @override
  String get fdHealth => 'Здоровье';

  @override
  String get fdTravel => 'Путешествия';

  @override
  String get fdFamily => 'Семья';

  @override
  String get fdBestToDo => 'Лучшие дела на сегодня';

  @override
  String get fdAvoidToday => 'Избегать сегодня';

  @override
  String get fdConfidenceLabel => 'Уверенность';

  @override
  String get fdBestTime => 'Лучшее время';

  @override
  String get fdRecommended => 'Рекомендовано';

  @override
  String get fdReason => 'Причина';

  @override
  String get fdRisk => 'Риск';

  @override
  String get fdRecommendation => 'Рекомендация';

  @override
  String get fdNoActions =>
      'Сегодня нет ничего важного, что стоило бы форсировать — придерживайтесь спокойного, стабильного распорядка.';

  @override
  String get fdNoCautions =>
      'Сегодня нет серьёзных предостережений — действуйте с обычной осторожностью.';

  @override
  String get fdHighlights => 'Главное сегодня';

  @override
  String get fdProbVeryHigh => 'Очень высокий';

  @override
  String get fdProbHigh => 'Высокий';

  @override
  String get fdProbElevated => 'Повышенный';

  @override
  String get fdProbCaution => 'Осторожность';

  @override
  String get fdWhatToDo => 'Что делать';

  @override
  String get fdLifeAreas => 'Сферы жизни';

  @override
  String get fdTapDetails => 'Нажмите для деталей';

  @override
  String get fdArea1 => 'Личность и здоровье';

  @override
  String get fdArea2 => 'Богатство и семья';

  @override
  String get fdArea3 => 'Общение';

  @override
  String get fdArea4 => 'Дом и комфорт';

  @override
  String get fdArea5 => 'Творчество и романтика';

  @override
  String get fdArea6 => 'Работа и обязанности';

  @override
  String get fdArea7 => 'Отношения';

  @override
  String get fdArea8 => 'Перемены и глубина';

  @override
  String get fdArea9 => 'Удача и путешествия';

  @override
  String get fdArea10 => 'Карьера и статус';

  @override
  String get fdArea11 => 'Доходы и связи';

  @override
  String get fdArea12 => 'Отдых и духовность';

  @override
  String get fdTodaysMeaning => 'Значение сегодняшнего дня';

  @override
  String get fdGoodFor => 'Благоприятно для';

  @override
  String get fdAvoid => 'Избегать';

  @override
  String get fdPlanetSupport => 'Поддержка планет';

  @override
  String get fdWhyPrediction => 'Почему такой прогноз?';

  @override
  String get fdAdvancedDetails => 'Расширенные детали';

  @override
  String get fdAiRecommendation => 'Рекомендация ИИ';

  @override
  String get fdOverallStatus => 'Общий статус';

  @override
  String get fdNoPlanetTransit =>
      'Ни одна крупная планета сегодня не проходит через эту область.';

  @override
  String get fdFinancialOutlook => 'Финансовый прогноз';

  @override
  String get fdIncomeProbability => 'Вероятность дохода';

  @override
  String get fdExpenseProbability => 'Вероятность расходов';

  @override
  String get fdNetBalance => 'Чистый финансовый баланс';

  @override
  String get fdAvoidSpending => 'Избегайте трат';

  @override
  String get fdRelationshipOutlook => 'Прогноз отношений';

  @override
  String get fdOverallScore => 'Общий балл';

  @override
  String get fdPartner => 'Партнёр';

  @override
  String get fdRomance => 'Романтика';

  @override
  String get fdWorkplace => 'Работа';

  @override
  String get fdPublicImage => 'Публичный образ';

  @override
  String get fdBestActivity => 'Лучшая активность';

  @override
  String get fdWeakArea => 'Слабая область';

  @override
  String get fdBiggestOpportunity => 'Главная возможность';

  @override
  String get fdBiggestRisk => 'Главный риск';

  @override
  String get fdProbability => 'Вероятность';

  @override
  String get fdProtection => 'Совет по защите';

  @override
  String get fdDescription => 'Описание';

  @override
  String get fdBestTimeToday => 'Лучшее время сегодня';

  @override
  String get fdAvoidDuring => 'Избегать во время';

  @override
  String get fdPredictionConfidence => 'Уверенность прогноза';

  @override
  String get fdConfBasis => 'Сегодняшний прогноз объединяет';

  @override
  String get fdConfNatal => 'Натальную карту';

  @override
  String get fdConfTransit => 'Текущий транзит';

  @override
  String get fdConfDasha => 'Планетарные периоды';

  @override
  String get fdConfStrength => 'Силу планет';

  @override
  String get fdConfHouse => 'Активацию домов';

  @override
  String get fdAskAi => 'Спросить ИИ';

  @override
  String get fdAskAiSub =>
      'Нажмите на вопрос, чтобы получить сегодняшний ответ';

  @override
  String get fdQ1 => 'Почему карьера сегодня идёт медленно?';

  @override
  String get fdQ2 => 'Какое сегодня лучшее время?';

  @override
  String get fdQ3 => 'Хорош ли сегодняшний день для денежных вопросов?';

  @override
  String get fdQ4 => 'Хорош ли сегодняшний день для путешествий?';

  @override
  String get fdQ5 => 'Чего мне избегать сегодня?';

  @override
  String get fdMoreSuggestions => 'Больше предложений';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'Сегодня лучше всего подходит для $top. $weak может ощущаться медленно, поэтому избегайте там важных решений. В финансовом плане день выглядит $fin.';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'Сегодня ваша энергия сосредоточена вокруг $top — опирайтесь на неё, а в остальном действуйте мягче.';
  }

  @override
  String get gochToday => 'Сегодня';

  @override
  String get gochOverallScore => 'Общий балл транзита';

  @override
  String get gochNeutral => 'Нейтрально';

  @override
  String get gochChallenging => 'Сложно';

  @override
  String get gochTopPositive => 'Главный позитив';

  @override
  String get gochTopChallenges => 'Главные сложности';

  @override
  String get gochFilterAll => 'Все';

  @override
  String get gochFavorability => 'Благоприятность';

  @override
  String get gochAlerts => 'Оповещения о транзитах';

  @override
  String get gochAlertCritical => 'Критично';

  @override
  String get gochAlertWarning => 'Осторожность';

  @override
  String get gochAlertOpportunity => 'Возможность';

  @override
  String get gochAiFocus => 'Фокус ИИ на сегодня';

  @override
  String get gochLifeScores => 'Баллы по сферам жизни';

  @override
  String get gochWhy => 'Почему?';

  @override
  String get gochCurrentTransits => 'Активные транзиты';

  @override
  String get gochDailyPlan => 'Ваш ежедневный план';

  @override
  String get gochMorning => 'Утро';

  @override
  String get gochAfternoon => 'День';

  @override
  String get gochEvening => 'Вечер';

  @override
  String get gochNight => 'Ночь';

  @override
  String get gochSmartReco => 'Умные рекомендации';

  @override
  String get gochExplain => 'Объяснить сегодняшний транзит';

  @override
  String get gochDo => 'Делать';

  @override
  String get gochDont => 'Избегать';

  @override
  String get gochDoWork => 'Заняться важной работой';

  @override
  String get gochDoMeditate => 'Медитировать и размышлять';

  @override
  String get gochDoStart => 'Начать новые планы';

  @override
  String get gochDoFinish => 'Завершить незаконченные дела';

  @override
  String get gochDontArgue => 'Избегать споров';

  @override
  String get gochDontImpulsive => 'Избегать импульсивных решений';

  @override
  String get gochDontOverspend => 'Избегать перерасхода';

  @override
  String gochThemeGrowth(Object area) {
    return 'День роста в области $area — используйте его.';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'Сохраняйте терпение в области $area сегодня — двигайтесь размеренно.';
  }

  @override
  String gochPosLine(Object area) {
    return '$area сейчас хорошо поддерживается.';
  }

  @override
  String gochChalLine(Object area) {
    return '$area сегодня требует особой заботы.';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'Направьте свою энергию на $a1 сегодня и будьте мягче с $a2.';
  }

  @override
  String get divBeginner => 'Начинающий';

  @override
  String get divSearchHint => 'Поиск: карьера, брак, образование…';

  @override
  String get divSummaryTitle => 'Сводка дробных карт';

  @override
  String get divTotalCharts => 'Всего карт';

  @override
  String get divMostImportant => 'Наиболее важные';

  @override
  String get divRecommendedForYou => 'Рекомендовано для вас';

  @override
  String get divCatEssential => 'Основные карты';

  @override
  String get divCatPersonal => 'Личная жизнь';

  @override
  String get divCatKnowledge => 'Карты знаний';

  @override
  String get divCatAdvanced => 'Продвинутые карты';

  @override
  String get divGoalProperty => 'Собственность';

  @override
  String get divGoalKarma => 'Карма';

  @override
  String get divBadgeHighlyRec => 'Настоятельно рекомендуется';

  @override
  String get divBadgeRec => 'Рекомендовано';

  @override
  String get divBadgeUseful => 'Полезно';

  @override
  String get divBadgeOptional => 'Опционально';

  @override
  String get divBadgeAdvOnly => 'Только для продвинутых';

  @override
  String get divRecommendBest => 'Рекомендовать лучшие карты';

  @override
  String get divNoMatch => 'Нет карт, соответствующих поиску';

  @override
  String get divLifeAreas => 'Сферы жизни';

  @override
  String divAiUse(Object purpose) {
    return 'Используйте эту карту для анализа $purpose.';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'Ваши карты $c1 и $c2 особенно важны — начните с них для соответствующих областей, а затем изучите остальные по мере необходимости.';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'Ваш $house дом требует более пристального внимания — эта карта показывает его подробно.';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet — ключевая, но испытываемая планета — эта карта раскрывает её более глубокое состояние.';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'Вы находитесь в Махадаше $planet, поэтому эта карта сейчас особенно актуальна.';
  }

  @override
  String divRecSummary(Object c1) {
    return 'На основе вашей карты $c1 должна быть вашим наивысшим приоритетом. Карты ниже упорядочены по актуальности для вас прямо сейчас.';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'Открывайте эту карту, когда хотите изучить $purpose.';
  }

  @override
  String get yogaHelpful => 'Полезно';

  @override
  String get yogaInactive => 'Неактивно';

  @override
  String get yogaTabMoney => 'Деньги';

  @override
  String get yogaTabRare => 'Редко';

  @override
  String get yogaSummaryTitle => 'Сводка йог';

  @override
  String get yogaActiveYogas => 'Активные йоги';

  @override
  String get yogaTotalYogas => 'Всего йог';

  @override
  String get yogaMostPowerful => 'Самая мощная';

  @override
  String get yogaFortuneRating => 'Общая удача';

  @override
  String get yogaBenefits => 'Преимущества';

  @override
  String get yogaSupportingPlanets => 'Поддерживающие планеты';

  @override
  String get yogaRanking => 'Топ-5 сильнейших йог';

  @override
  String get yogaExplain => 'Объяснить мои йоги';

  @override
  String get yogaExplainSubtitle => 'Как ваши йоги поддерживают вас';

  @override
  String get yogaNoneActive => 'Активных йог пока нет';

  @override
  String get yogaNoneInCategory => 'В этой категории нет йог';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'Ваша карта содержит $count активных йог — благоприятных планетарных сочетаний. Сочетания с участием $planets создают особенно полезные влияния для роста и успеха.';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name поддерживает $areas, и её преимущества растут, когда её планеты активны в даше или транзите.';
  }

  @override
  String get yogaAiGeneric =>
      'Эта йога — благоприятное сочетание в вашей карте, которое усиливает связанные с ней сферы жизни.';

  @override
  String get yogaExplainReassure =>
      'Йоги — это яркие стороны вашей карты, благоприятные планетарные сочетания, работающие в вашу пользу. Более сильные из них приносят долгосрочные преимущества, особенно в периоды формирующих их планет.';

  @override
  String get doshSevere => 'Тяжёлая';

  @override
  String get doshVeryMild => 'Очень лёгкая';

  @override
  String get doshLow => 'Низкая';

  @override
  String get doshHigh => 'Высокий';

  @override
  String get doshCritical => 'Критично';

  @override
  String get doshSummaryTitle => 'Сводка дош';

  @override
  String get doshActiveDoshas => 'Активные доши';

  @override
  String get doshTotalChecked => 'Всего проверено';

  @override
  String get doshOverallSeverity => 'Общая тяжесть';

  @override
  String get doshNoneActive => 'Активных дош нет — чистая карта!';

  @override
  String get doshCategory => 'Категория';

  @override
  String get doshConfidence => 'Уверенность';

  @override
  String get doshWhyFormed => 'Почему это сформировалось';

  @override
  String get doshAffectedAreas => 'Затронутые области';

  @override
  String get doshTimeline => 'Хронология';

  @override
  String get doshDefinition => 'Определение';

  @override
  String get doshFormationRule => 'Правило формирования';

  @override
  String get doshSupportingPlanets => 'Связанная планета';

  @override
  String get doshCancellation => 'Йоги отмены';

  @override
  String get doshNoCancellation => 'Не найдено';

  @override
  String get doshAreaChildren => 'Дети';

  @override
  String get doshAreaMind => 'Разум';

  @override
  String get remMantra => 'Мантра';

  @override
  String get remGemstone => 'Драгоценный камень';

  @override
  String get remDonation => 'Пожертвование';

  @override
  String get remTemple => 'Храм';

  @override
  String get remFasting => 'Пост';

  @override
  String get remLifestyle => 'Образ жизни';

  @override
  String get remLifestyleGeneric =>
      'Практикуйте благодарность, дисциплину и благотворительность, связанные с этой планетой, и поддерживайте хорошее поведение.';

  @override
  String get doshExplain => 'Объяснить мои доши';

  @override
  String get doshExplainSubtitle => 'Спокойный, практичный взгляд на ваши доши';

  @override
  String get doshExplainReassure =>
      'Доши распространены — почти в каждой карте есть какие-то. Они описывают склонности, а не предопределённую судьбу. Осознанность, хорошее поведение и простые средства снижают их практическое влияние, так что беспокоиться не о чем.';

  @override
  String get doshAiGeneric =>
      'Эта доша описывает склонность в вашей карте. Её практическое влияние обычно мягкое и может быть сбалансировано осознанностью и простыми средствами.';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'Ваша карта показывает $active активных дош из $total проверенных. Большинство из них мягкие, и лишь немногие требуют внимания. При понимании и простых средствах их практическое влияние можно смягчить.';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Эта доша в основном влияет на $areas. В периоды $planet её эффект может ощущаться сильнее, а средства помогают его сбалансировать.';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'Её эффект ощущается сильнее всего во время Махадаши и Антардаши $planet, а также когда $planet активна в транзите.';
  }

  @override
  String get sbLegendary => 'Легендарная';

  @override
  String get sbSthana => 'Стхана-бала';

  @override
  String get sbDig => 'Диг-бала';

  @override
  String get sbKala => 'Кала-бала';

  @override
  String get sbChesta => 'Чешта-бала';

  @override
  String get sbNaisargika => 'Наисаргика-бала';

  @override
  String get sbDrik => 'Дрик-бала';

  @override
  String get sbSummary => 'Сводка планетарной силы';

  @override
  String get sbAverageStrength => 'Средняя сила';

  @override
  String get sbHighestRupa => 'Наивысшая Рупа';

  @override
  String get sbRupa => 'Рупа';

  @override
  String get sbRanking => 'Ранжирование планет';

  @override
  String get sbRequired => 'Требуется';

  @override
  String get sbExcess => 'Избыток';

  @override
  String get sbDeficit => 'Дефицит';

  @override
  String get sbTotalShadbala => 'Общая Шадбала';

  @override
  String get sbExplain => 'Объяснить мою планетарную силу';

  @override
  String get sbExplainSubtitle => 'Простая сводка силы ваших планет';

  @override
  String get sbInfoTitle => 'Понимание Шадбалы';

  @override
  String get sbQWhatIs => 'Что такое Шадбала?';

  @override
  String get sbQRupas => 'Что такое Рупы?';

  @override
  String get sbQHowCalc => 'Как рассчитывается сила?';

  @override
  String get sbQHowUse => 'Как это использовать';

  @override
  String get sbWhyStrong => 'Почему сильная';

  @override
  String get sbWhyWeak => 'Почему слабая';

  @override
  String get sbDuringMahadasha => 'Во время Махадаши';

  @override
  String get sbEffects => 'Эффекты';

  @override
  String get sbLifeAreas => 'Сферы жизни';

  @override
  String get sbPlanetDetails => 'Детали планеты';

  @override
  String get sbBodyWhatIs =>
      'Шадбала («шестикратная сила») измеряет, сколько силы имеет каждая планета для проявления своих результатов, суммируя шесть независимых источников силы.';

  @override
  String get sbBodyRupas =>
      'Сила измеряется в Рупах (1 Рупа = 60 Вирупа). Каждой планете нужна минимальная сила в Рупах, чтобы считаться сильной; больше Рупа означает более полное проявление её результатов.';

  @override
  String get sbBodyHowCalc =>
      'Складываются шесть бал: Стхана (позиционная), Диг (направленная), Кала (временная), Чешта (движения), Наисаргика (естественная) и Дрик (аспектная). Итог сравнивается с требуемым минимумом планеты для получения процента.';

  @override
  String get sbBodyHowUse =>
      'Планета выше 100% уверенно проявляет свои значения; ниже 100% ей требуется поддержка. Отдавайте предпочтение самым сильным планетам для важных дел, а самым слабым уделяйте внимание через средства и терпение.';

  @override
  String get sbRemedyStrong =>
      'Хорошо поддержана — особые средства не нужны; вы можете уверенно использовать периоды этой планеты.';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP — ваша самая сильная планета, обеспечивающая отличную поддержку для $strongTrait. $weakP — самая слабая и больше всего выигрывает от средств.';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return 'У планеты $planet $category Шадбала, поэтому её $karakatva поддерживаются соответствующим образом.';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'Сильнее всего через $bala ($rupa рупа).';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'Слабее всего в $bala, что снижает общий показатель.';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'Во время Махадаши $planet на первый план выходят её $karak.';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'При сильной Шадбале $karak поддерживаются естественным образом.';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'При умеренной Шадбале $karak может потребоваться осознанное усилие.';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'Усильте $planet через её мантру, драгоценный камень или благотворительность и действуйте терпеливо в её периоды.';
  }

  @override
  String get bhOverview => 'Обзор';

  @override
  String get bhDetailed => 'Подробно';

  @override
  String get bhavaHouses => 'Дома';

  @override
  String get bhStrengthOverview => 'Обзор силы домов';

  @override
  String get bhOverallAverage => 'Общее среднее по домам';

  @override
  String get bhStrongestHouse => 'Самый сильный дом';

  @override
  String get bhWeakestHouse => 'Самый слабый дом';

  @override
  String get bhBestArea => 'Лучшая сфера жизни';

  @override
  String get bhNeedsAttention => 'Требует внимания';

  @override
  String get bhSavContribution => 'Вклад SAV';

  @override
  String get bhLordCondition => 'Состояние управителя дома';

  @override
  String get bhBenefic => 'Благоприятное влияние';

  @override
  String get bhMalefic => 'Влияние вредоносных планет';

  @override
  String get bhStrengthReasons => 'Почему такой балл';

  @override
  String get bhGoodEffects => 'Благоприятные эффекты';

  @override
  String get bhChallenges => 'Сложности';

  @override
  String get bhRemedies => 'Средства';

  @override
  String get bhRanking => 'Ранжирование домов';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'Объяснить мои дома';

  @override
  String get bhExplainSubtitle => 'Простая сводка по вашим 12 домам';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'Ваши самые сильные дома — $s1 и $s2. $strongArea естественно сильна, а $weakArea требует больше усилий.';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'Её управитель $lord расположен как $relation.';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'Этот дом несёт $sav благоприятных баллов (SAV); его обитатели и аспекты формируют остальную часть оценки.';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'Когда он силён, поддерживает $meaning.';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'Когда он слаб, $meaning может потребовать дополнительных усилий и заботы.';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'Усильте его управителя $lord и уважайте темы этого дома, чтобы поднять его.';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return 'Ваш $house $strengthWord. Он управляет $meaning.';
  }

  @override
  String get kunNavamsa => 'Навамша (D9)';

  @override
  String get kunD10 => 'Дашамша (D10)';

  @override
  String get kunPlacement => 'Расположение планет';

  @override
  String get kunHousesTitle => 'Детали дома';

  @override
  String get kunPlanet => 'Планета';

  @override
  String get kunNakshatra => 'Накшатра';

  @override
  String get kunPada => 'Пада';

  @override
  String get kunLord => 'Управитель';

  @override
  String get kunExplain => 'Объяснить мою карту';

  @override
  String get kunExplainSubtitle => 'Простая сводка по вашей карте';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return '$ordinal дом управляет $meaning.';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets, расположенные здесь, формируют его результаты.';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'Ваш асцендент — $asc, формирующий ваше мировоззрение и то, как вас воспринимают окружающие с первого взгляда.';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'Ваш разум и эмоции следуют за Луной в знаке $moon.';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet — ваша самая сильная планета, естественная область лёгкости и поддержки.';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet — ваша самая испытываемая планета, здесь окупаются терпение и усилия.';
  }

  @override
  String get plNature => 'Природа';

  @override
  String get plElement => 'Стихия';

  @override
  String get plGender => 'Пол';

  @override
  String get plKarakatva => 'Каракатва';

  @override
  String get plLordship => 'Управление';

  @override
  String get plStrength => 'Сила';

  @override
  String get plAspectsGiven => 'Отдаваемые аспекты';

  @override
  String get plAspectsReceived => 'Получаемые аспекты';

  @override
  String get plConjunction => 'Соединение';

  @override
  String get plHouseMeaning => 'Значение дома';

  @override
  String get plNakshatraMeaning => 'Значение накшатры';

  @override
  String get plAiInterpretation => 'Толкование ИИ';

  @override
  String get plSearchHint => 'Поиск любой планеты';

  @override
  String get plNoResults => 'Планеты не найдены';

  @override
  String get plBenefic => 'Благоприятная';

  @override
  String get plMalefic => 'Вредоносная';

  @override
  String get plMale => 'Мужской';

  @override
  String get plFemale => 'Женский';

  @override
  String get plNeutralGender => 'Нейтрально';

  @override
  String get plOwnSign => 'Собственный знак';

  @override
  String get plFriend => 'Знак друга';

  @override
  String get plEnemy => 'Знак врага';

  @override
  String get plNeutral => 'Нейтрально';

  @override
  String get sumEther => 'Эфир';

  @override
  String plLordOfHouses(Object houses) {
    return 'Управитель дома(ов) $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'Под управлением $nakLord, привносит $trait.';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet находится в знаке $sign, в $house доме.';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'Её ключевые значения — $karak — здесь хорошо поддерживаются.';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'Её ключевые значения — $karak — здесь могут потребовать осознанного усилия.';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet в экзальтации, дающей наилучшие результаты.';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet в падении и нуждается в поддержке, чтобы проявить свои результаты.';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet в соединении с Солнцем (комбустирована), поэтому действует менее открыто под его сиянием.';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet в варготтаме — сильное положение, повторяющееся в навамше.';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet ретроградна, обращая свою энергию внутрь и усиливая её.';
  }

  @override
  String get plHouse1 => 'личность, тело, характер и жизненная сила';

  @override
  String get plHouse2 => 'богатство, семья, речь и пища';

  @override
  String get plHouse3 =>
      'смелость, братья и сёстры, общение и короткие поездки';

  @override
  String get plHouse4 => 'дом, мать, комфорт, собственность и внутренний покой';

  @override
  String get plHouse5 =>
      'дети, творчество, интеллект, романтика и заслуги прошлого';

  @override
  String get plHouse6 =>
      'здоровье, враги, долги, служение и повседневная работа';

  @override
  String get plHouse7 => 'брак, партнёрство и деловые отношения';

  @override
  String get plHouse8 => 'долголетие, трансформация, тайны и наследство';

  @override
  String get plHouse9 => 'удача, дхарма, высшее образование, гуру и отец';

  @override
  String get plHouse10 => 'карьера, статус, власть и публичная карма';

  @override
  String get plHouse11 =>
      'доходы, заработок, друзья, связи и исполненные желания';

  @override
  String get plHouse12 =>
      'потери, расходы, зарубежные земли, духовность и освобождение';

  @override
  String get sumVeryStrong => 'Очень сильно';

  @override
  String get sumStrong => 'Сильно';

  @override
  String get sumAverage => 'Средне';

  @override
  String get sumWeak => 'Слабая';

  @override
  String get sumNeedsAttention => 'Требует внимания';

  @override
  String get sumFire => 'Огонь';

  @override
  String get sumEarth => 'Земля';

  @override
  String get sumAir => 'Воздух';

  @override
  String get sumWater => 'Вода';

  @override
  String get sumMovable => 'Подвижный';

  @override
  String get sumFixed => 'Фиксированный';

  @override
  String get sumDual => 'Двойственный';

  @override
  String get sumDirEast => 'Восток';

  @override
  String get sumDirWest => 'Запад';

  @override
  String get sumDirNorth => 'Север';

  @override
  String get sumDirSouth => 'Юг';

  @override
  String get sumDirNE => 'Северо-Восток';

  @override
  String get sumDirNW => 'Северо-Запад';

  @override
  String get sumDirSE => 'Юго-Восток';

  @override
  String get sumDirSW => 'Юго-Запад';

  @override
  String get sumSnapshotTitle => 'Снимок вашей астрологии';

  @override
  String get sumMahadasha => 'Махадаша';

  @override
  String get sumAntardasha => 'Антардаша';

  @override
  String get sumNakshatra => 'Джанма-накшатра';

  @override
  String get sumElement => 'Стихия';

  @override
  String get sumModality => 'Модальность';

  @override
  String get sumLuckyDirection => 'Счастливое направление';

  @override
  String get sumHighlights => 'Важные моменты';

  @override
  String get sumStrongPlanet => 'Самая сильная планета';

  @override
  String get sumWeakPlanet => 'Самая слабая планета';

  @override
  String get sumYogas => 'Йоги';

  @override
  String get sumDoshas => 'Доши';

  @override
  String get sumRetrograde => 'Ретроградная';

  @override
  String get sumCombust => 'Комбустированная';

  @override
  String get sumExalted => 'В экзальтации';

  @override
  String get sumDebilitated => 'В падении';

  @override
  String get sumVargottama => 'Варготтама';

  @override
  String get sumQuickInsights => 'Быстрые выводы';

  @override
  String get sumSpirituality => 'Духовность';

  @override
  String get sumTimezone => 'Часовой пояс';

  @override
  String get sumAyanamsa => 'Айанамша';

  @override
  String get sumCalendarType => 'Календарь';

  @override
  String get sumCopied => 'Скопировано в буфер обмена';

  @override
  String get sumNatureFire =>
      'У вас смелая, энергичная и первопроходческая натура, которая ведёт за собой.';

  @override
  String get sumNatureEarth =>
      'У вас практичная, приземлённая и дисциплинированная натура, которая создаёт долговечные результаты.';

  @override
  String get sumNatureAir =>
      'У вас любознательная, общительная и интеллектуальная натура, которая процветает на новых идеях.';

  @override
  String get sumNatureWater =>
      'У вас интуитивная, эмоциональная и чуткая натура с глубокой внутренней чувствительностью.';

  @override
  String get sumGradePhraseExcellent =>
      'Сильно поддержана — благоприятные результаты вероятны при постоянных усилиях.';

  @override
  String get sumGradePhraseGood =>
      'Хорошо поддержана — в целом позитивно при небольшой заботе.';

  @override
  String get sumGradePhraseAverage =>
      'Смешанная поддержка — результаты зависят от усилий и времени.';

  @override
  String get sumGradePhraseWeak =>
      'Требует внимания — здесь помогают терпение и средства.';

  @override
  String get kDefCombust =>
      'Планета, слишком близкая к Солнцу, поэтому её энергия «сгорает» и ослабевает.';

  @override
  String get kDefRetrograde =>
      'Планета, которая кажется движущейся назад; её эффекты обращаются внутрь и усиливаются.';

  @override
  String get kDefNakshatra =>
      'Один из 27 лунных домов, через которые проходят Луна и планеты.';

  @override
  String get kDefVargottama =>
      'Планета в одном и том же знаке как в натальной карте (D1), так и в навамше (D9) — признак силы.';

  @override
  String get kDefOwnSign =>
      'Планета, находящаяся в знаке, которым она управляет, где она чувствует себя как дома и даёт стабильные результаты.';

  @override
  String get kDefExalted =>
      'Планета в знаке своей наивысшей силы, дающая наилучшие результаты.';

  @override
  String get kDefDebilitated =>
      'Планета в знаке своей наименьшей силы, где ей трудно проявить результаты.';

  @override
  String get kDefMooltrikona =>
      'Особая часть собственного знака планеты, где она особенно сильна.';

  @override
  String get kDefAscendant =>
      'Знак, восходящий на восточном горизонте при рождении — Лагна, основа карты.';

  @override
  String get kDefMahadasha =>
      'Главный планетарный период, окрашивающий длительный отрезок жизни.';

  @override
  String get kDefAntardasha =>
      'Подпериод внутри Махадаши, который уточняет её результаты.';

  @override
  String get kDefPada =>
      'Одна из четырёх четвертей накшатры, которую занимает планета.';

  @override
  String get aspGivesAspectTo => 'Даёт аспект на';

  @override
  String get aspReceivesAspectFrom => 'Получает аспект от';

  @override
  String get aspInfluences => 'Влияет';

  @override
  String get aspNoInfluence => 'Нет влияния';

  @override
  String get aspNoAspect => 'Нет аспекта';

  @override
  String get aspPresent => 'Присутствует';

  @override
  String get aspAbsent => 'Отсутствует';

  @override
  String get aspNotPresent => 'Отсутствует';

  @override
  String get aspSpecialAspect => 'Особый аспект';

  @override
  String get aspAspectWord => 'Аспект';

  @override
  String get aspTotalGiven => 'Отдаваемые аспекты';

  @override
  String get aspTotalReceived => 'Получаемые аспекты';

  @override
  String get aspStrongestInfluence => 'Сильнейшее влияние';

  @override
  String get aspMedium => 'Средний';

  @override
  String get aspAspectPresent => 'Аспект присутствует';

  @override
  String get aspReason => 'Причина';

  @override
  String get aspBoth => 'Оба';

  @override
  String get aspTargetHouse => 'Целевой дом';

  @override
  String get aspTargetSign => 'Целевой знак';

  @override
  String get aspLagnaReceives => 'Лагна получает аспект от';

  @override
  String get aspNoAspectFrom => 'Нет аспекта от';

  @override
  String get aspPlanetToPlanet => 'Планета к планете';

  @override
  String get aspSignToSign => 'Знак к знаку';

  @override
  String get aspCombinedAspect => 'Совмещённый аспект';

  @override
  String get aspGrahaAspect => 'Аспект Грахи';

  @override
  String get aspRashiAspect => 'Аспект Раши';

  @override
  String get aspInfoTitle => 'Понимание аспектов (Дришти)';

  @override
  String get aspQGraha => 'Что такое Граха-Дришти?';

  @override
  String get aspQRashi => 'Что такое Раши-Дришти?';

  @override
  String get aspQDiff => 'Разница между ними';

  @override
  String get aspQPredict => 'Как аспекты влияют на прогноз';

  @override
  String get aspGrahaBody =>
      'Граха-Дришти — это аспект, который планета отбрасывает из своего положения. Каждая планета полностью аспектирует 7-й дом/планету от себя (прямое влияние «лицом к лицу»). Кроме того, Марс аспектирует 4-й и 8-й дома, Юпитер — 5-й и 9-й, а Сатурн — 3-й и 10-й. Раху и Кету обычно наделяют аспектами 5-й, 7-й и 9-й дома. Аспект планеты окрашивает планету или дом, на который он падает, своей собственной природой.';

  @override
  String get aspRashiBody =>
      'Раши-Дришти — это аспект знака на знак из астрологии Джаймини, независимо от того, какие планеты там находятся. Подвижные знаки аспектируют фиксированные знаки (кроме соседнего), фиксированные знаки аспектируют подвижные знаки (кроме соседнего), а двойственные знаки аспектируют другие двойственные знаки. Используется в основном в прогнозировании по Джаймини и для оценки отношений между домами.';

  @override
  String get aspDiffBody =>
      'Граха-Дришти отбрасывается планетой и зависит от того, где эта планета находится. Раши-Дришти принадлежит самому знаку и применяется ко всему, что в нём расположено. Граха-Дришти направлена (планета А видит планету Б), а Раши-Дришти обычно взаимна между знаками. Когда обе указывают на одну и ту же цель, влияние особенно сильно.';

  @override
  String get aspPredictBody =>
      'Аспект показывает, где планета распространяет своё влияние за пределы своего дома. Благоприятный аспект (Юпитер, Венера, хорошо расположенные Луна/Меркурий) поддерживает и защищает цель; неблагоприятный аспект (Сатурн, Марс, Солнце, Раху, Кету) может создавать давление, задержки или испытания. Чтение того, какие планеты аспектируют дом или планету, объясняет, почему результаты проявляются именно так.';

  @override
  String get aspTraitSun => 'власть, лидерство и жизненную силу';

  @override
  String get aspTraitMoon => 'эмоциональную глубину, комфорт и интуицию';

  @override
  String get aspTraitMars => 'энергию, смелость и напор';

  @override
  String get aspTraitMercury => 'общение, интеллект и адаптивность';

  @override
  String get aspTraitJupiter => 'мудрость, рост и удачу';

  @override
  String get aspTraitVenus => 'любовь, гармонию и комфорт';

  @override
  String get aspTraitSaturn =>
      'дисциплину, ответственность и терпеливый, порой отсроченный, успех';

  @override
  String get aspTraitRahu => 'амбиции, интенсивность и нестандартные повороты';

  @override
  String get aspTraitKetu => 'отрешённость, духовность и внезапные перемены';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet влияет на $targets. Это может привнести $trait в области, представленные этими планетами.';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet не отбрасывает особый аспект ни на одну другую планету здесь; её влияние работает в основном через собственный знак и дом.';
  }

  @override
  String get avSummaryTitle => 'Сводка Аштакаварги';

  @override
  String get avOverallScore => 'Общий балл SAV';

  @override
  String get avOverallRating => 'Общая оценка';

  @override
  String get avStrongestSigns => 'Самые сильные знаки';

  @override
  String get avWeakestSigns => 'Самые слабые знаки';

  @override
  String get avScore => 'Балл';

  @override
  String get avMeaning => 'Значение';

  @override
  String get avGrid => 'Сетка';

  @override
  String get avList => 'Список';

  @override
  String get avOverallScoreShort => 'Общий балл';

  @override
  String get avNatalSignScore => 'Балл натального знака';

  @override
  String get avBestSigns => 'Лучшие знаки';

  @override
  String get avWeakSigns => 'Слабые знаки';

  @override
  String get avAiInterpretation => 'Толкование ИИ';

  @override
  String get avVeryGood => 'Очень хорошо';

  @override
  String get avVeryWeak => 'Очень слабо';

  @override
  String get avTotalSav => 'Итого SAV';

  @override
  String get avPlanetContributions => 'Вклад планет';

  @override
  String get avFinance => 'Финансы';

  @override
  String get avOverallStrength => 'Общая сила';

  @override
  String get avWhatDoesThisMean => 'Что это значит?';

  @override
  String get avSimple => 'Просто';

  @override
  String get avAdvanced => 'Расширенно';

  @override
  String get avInfoTitle => 'Понимание Аштакаварги';

  @override
  String get avStrong => 'Сильно';

  @override
  String get avModerate => 'Умеренно';

  @override
  String get avQWhatIsAv => 'Что такое Аштакаварга?';

  @override
  String get avQWhatIsSav => 'Что такое SAV?';

  @override
  String get avQWhatIsBav => 'Что такое BAV?';

  @override
  String get avQHowToRead => 'Как читать эти баллы';

  @override
  String get avQSavVsBav => 'SAV против BAV';

  @override
  String get avABody =>
      'Аштакаварга — это система оценки силы в ведической астрологии, основанная на баллах. Каждая планета присваивает благоприятные баллы (бинду, также называемые рекха) двенадцати знакам в зависимости от своего положения. Больше баллов в знаке означает, что эта сфера жизни получает более плавную поддержку в соответствующие планетарные периоды и транзиты.';

  @override
  String get avSavBody =>
      'SAV (Сарва Аштакаварга) суммирует баллы всех семи планет для каждого знака. Она даёт единый показатель силы на знак, чтобы вы могли быстро увидеть, какие знаки — и попадающие в них дома — лучше всего поддержаны в вашей карте.';

  @override
  String get avBavBody =>
      'BAV (Бхинна Аштакаварга) показывает баллы одной планеты по всем двенадцати знакам. Он говорит, какие знаки конкретная планета поддерживает больше всего, что важно, когда активна её даша или транзит.';

  @override
  String get avHowToReadBody =>
      'Чем выше число, тем лучше. Для SAV средний знак набирает около 28 баллов — выше 30 считается сильным, ниже 25 требует внимания. Для BAV каждый знак от 0 до 8, где 4 — среднее. Отдавайте предпочтение самым сильным знакам для важных действий и сохраняйте терпение и дисциплину в отношении самых слабых.';

  @override
  String get avSavVsBavBody =>
      'SAV — это суммарный итог всех планет, показывающий общую силу знака. BAV — вклад одной планеты, показывающий, какая планета поддерживает этот знак. Используйте SAV для общей картины, а BAV — чтобы понять, какая планета обеспечивает силу знака.';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'Ваша карта сильнее всего в знаках $s1, $s2 и $s3. Эти знаки дают лучшую поддержку во время планетарных периодов и транзитов. $weak сейчас имеет наименьшую поддержку, поэтому в связанных с ним делах помогают терпение и дисциплина.';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet проявляется сильнее всего через $s1 и $s2. Дела, которыми управляет $planet, обычно улучшаются, когда активируются эти знаки.';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'Ваши самые сильные знаки — $s1 и $s2 — отдавайте предпочтение важным начинаниям, когда планеты проходят через них транзитом.';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 имеет наименьшую поддержку — действуйте осторожно и избегайте чрезмерных обязательств в связанных с ним делах.';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet несёт больше всего баллов, поэтому её значения хорошо поддержаны в вашей жизни.';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet несёт меньше всего баллов и больше всего выигрывает от средств и осознанных усилий.';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'Знаки, набравшие выше вашего среднего показателя $avg баллов, как правило, дают более плавные и надёжные результаты.';
  }

  @override
  String get fcKey => 'Ключ';

  @override
  String get fcActions => 'Действия';

  @override
  String get fcCautions => 'Предостережения';

  @override
  String get fc12House => '12 домов';

  @override
  String get fcProbabilities => 'Вероятности';

  @override
  String get fcHousesCaps => 'ДОМА';

  @override
  String get fcCritical => 'Критично';

  @override
  String get fcFlags => 'Флаги';

  @override
  String get fcAnalysis => 'Анализ';

  @override
  String get fcConfidence => 'Уверенность';

  @override
  String get fcQualityCaps => 'КАЧЕСТВО';

  @override
  String get fcIncomeVs => 'Доход против';

  @override
  String get fcExpense => 'Расход';

  @override
  String get fcFinance => 'ФИНАНСЫ';

  @override
  String get fcNetBalance => 'Чистый баланс';

  @override
  String get fcSignature => 'Сигнатура';

  @override
  String get fcBestTimeForIncome => 'Лучшее время для дохода';

  @override
  String get fcExpenseCaution => 'Осторожность с расходами';

  @override
  String get fcIncomeCaps => 'ДОХОД';

  @override
  String get fcExpenseCaps => 'РАСХОД';

  @override
  String get fcRelationships => 'Отношения';

  @override
  String get fcAreasCaps => 'ОБЛАСТИ';

  @override
  String get fcBestForMeetings => 'Лучше всего для встреч';

  @override
  String get fcOpportunitiesVs => 'Возможности против';

  @override
  String get fcRisks => 'Риски';

  @override
  String get fcOutlook => 'ПРОГНОЗ';

  @override
  String get fcAction => 'Действие';

  @override
  String get fcProtect => 'Защитить';

  @override
  String get fcOpportunityCaps => 'ВОЗМОЖНОСТЬ';

  @override
  String get fcRiskCaps => 'РИСК';

  @override
  String get fcTopOpportunities => 'ГЛАВНЫЕ ВОЗМОЖНОСТИ';

  @override
  String get fcTopRisks => 'ГЛАВНЫЕ РИСКИ';

  @override
  String get fcTiming => 'Время';

  @override
  String get fcWindows => 'Окна';

  @override
  String get fcSlotsCaps => 'СЛОТЫ';

  @override
  String get fcBestWindows => 'ЛУЧШИЕ ОКНА';

  @override
  String get fcWorstWindows => 'ХУДШИЕ ОКНА';

  @override
  String get fcAvoid => 'Избегать';

  @override
  String get fcHouse => 'Дом';

  @override
  String get fcFailed => 'Неудача';

  @override
  String get lifeCareer => 'Карьера';

  @override
  String get lifeHealth => 'Здоровье';

  @override
  String get lifeWealth => 'Богатство';

  @override
  String get lifeFamily => 'Семья';

  @override
  String get lifeMind => 'Разум';

  @override
  String get lifeEgo => 'Эго';

  @override
  String get lifeAggression => 'Агрессия';

  @override
  String get lifeConflict => 'Конфликт';

  @override
  String get rashiElement => 'Стихия';

  @override
  String get rashiQuality => 'Качество';

  @override
  String get rashiLuckyColor => 'Счастливый цвет';

  @override
  String get rashiLuckyDay => 'Счастливый день';

  @override
  String get rashiLuckyNumber => 'Счастливое число';

  @override
  String get rashiGemstone => 'Драгоценный камень';

  @override
  String get rashiBody => 'Тело';

  @override
  String get gocharTodaysTransitChart => 'Сегодняшняя транзитная карта';

  @override
  String get gocharTransit => 'Транзит';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get best => 'Лучший';

  @override
  String get worst => 'Худший';

  @override
  String get avg => 'средн.';

  @override
  String get favorableLoveWindowsLabel => 'Благоприятные окна для любви';

  @override
  String get lordLabel => 'Управитель';

  @override
  String get lordPlacementLabel => 'Расположение управителя';

  @override
  String get lordDignityLabel => 'Достоинство управителя';

  @override
  String get categoriesSuffix => 'Категории';

  @override
  String get coreBlockerLabel => 'ОСНОВНОЙ БЛОКЕР';

  @override
  String get coreGiftLabel => '✦ ОСНОВНОЙ ДАР';

  @override
  String get coreThemeLabel => '● ОСНОВНАЯ ТЕМА';

  @override
  String dominantLabel(Object value) {
    return 'Доминирующий: $value';
  }

  @override
  String get karakasSuffix => 'Караки';

  @override
  String get protectiveLabel => 'ЗАЩИТНОЕ';

  @override
  String secondaryLabel(Object value) {
    return ' · Вторичный: $value';
  }

  @override
  String get tagCore => 'ОСНОВНОЕ';

  @override
  String get debtScoresHeader => '📉 БАЛЛЫ ДОЛГОВ';

  @override
  String get debtCurrentLoadStat => 'ТЕКУЩАЯ\nДОЛГОВАЯ НАГРУЗКА';

  @override
  String get debtRecoveryCapacityStat => 'СПОСОБНОСТЬ\nК ВОССТАНОВЛЕНИЮ';

  @override
  String get debtIntensityStat => 'ИНТЕНСИВНОСТЬ';

  @override
  String get debtDefaultRiskStat => 'РИСК ДЕФОЛТА';

  @override
  String get debtProfileTitle => 'Долговой профиль';

  @override
  String get debtKarmaLabel => 'КАРМА';

  @override
  String get debtPersonalityLabel => 'ЛИЧНОСТЬ';

  @override
  String get debtPhaseLabel => 'ФАЗА';

  @override
  String get debtPrimaryCategoryLabel => 'ОСНОВНАЯ КАТЕГОРИЯ';

  @override
  String get debtWord => 'Долг';

  @override
  String get debtYogasTitle => 'Йоги долгов';

  @override
  String get debtCreatingLabel => 'СОЗДАЮЩИЕ ДОЛГИ';

  @override
  String get debtClearingLabel => 'УСТРАНЯЮЩИЕ ДОЛГИ';

  @override
  String get yearlyDebtTitle => 'Годовой долг';

  @override
  String get debtRepaymentTitle => 'Погашение';

  @override
  String get debtDangerPeriodsTitle => 'Опасные периоды';

  @override
  String get debtDefaultPctStat => '% ДЕФОЛТА';

  @override
  String get debtBankruptcyPctStat => '% БАНКРОТСТВА';

  @override
  String get debtChronicPctStat => '% ХРОНИЧЕСКОГО';

  @override
  String get debtResilienceStat => 'УСТОЙЧИВОСТЬ';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'Восстановление: $pct% · Сроки: $years лет';
  }

  @override
  String get debtFreeWindowLabel => '🎯 ОКНО ОСВОБОЖДЕНИЯ ОТ ДОЛГОВ';

  @override
  String debtFreeYear(Object year) {
    return 'Год $year';
  }

  @override
  String get legalScoresHeader => '⚖️ ПРАВОВЫЕ БАЛЛЫ';

  @override
  String get legalVulnerabilityStat => 'ПРАВОВАЯ\nУЯЗВИМОСТЬ';

  @override
  String get legalVictoryPotentialStat => 'ПОТЕНЦИАЛ\nПОБЕДЫ';

  @override
  String get legalConflictStat => 'КОНФЛИКТ';

  @override
  String get legalResolutionStat => 'РАЗРЕШЕНИЕ';

  @override
  String get legalProfileTitle => 'Правовой профиль';

  @override
  String get legalKarmaTypeLabel => 'ТИП КАРМЫ';

  @override
  String get legalConflictStyleLabel => 'СТИЛЬ КОНФЛИКТА';

  @override
  String get legalStrategyLabel => 'СТРАТЕГИЯ';

  @override
  String get legalCaseDurationLabel => 'ДЛИТЕЛЬНОСТЬ ДЕЛА';

  @override
  String get legalCurrentStatusLabel => 'ТЕКУЩИЙ СТАТУС';

  @override
  String get legalWord => 'Право';

  @override
  String get legalYogasTitle => 'Правовые йоги';

  @override
  String get legalDisputePressureLabel => 'ДАВЛЕНИЕ СПОРОВ';

  @override
  String get legalProtectionLabel => 'ПРАВОВАЯ ЗАЩИТА';

  @override
  String get legalStressTrendTitle => 'Правовой стресс';

  @override
  String get legalVisibleEnemiesStat => 'ЯВНЫЕ ВРАГИ';

  @override
  String get legalHiddenEnemiesStat => 'СКРЫТЫЕ ВРАГИ';

  @override
  String get legalCriminalRiskStat => 'УГОЛОВНЫЙ РИСК';

  @override
  String get legalFalseAccusationStat => 'ЛОЖНОЕ ОБВИНЕНИЕ';

  @override
  String get legalContractKarmaTitle => 'Карма контрактов';

  @override
  String get legalDocumentationLabel => 'ДОКУМЕНТАЦИЯ';

  @override
  String get legalFinePrintAwareLabel => 'ВНИМАНИЕ К МЕЛКОМУ ШРИФТУ';

  @override
  String get legalNegotiationSkillLabel => 'НАВЫК ПЕРЕГОВОРОВ';

  @override
  String get legalSignatureCautionLabel => 'ОСТОРОЖНОСТЬ ПРИ ПОДПИСАНИИ';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'Устойчивость: $pct/100';
  }

  @override
  String get legalVictoryWord => 'Победа';

  @override
  String get legalAnalysisSuffix => 'Анализ';

  @override
  String get legalAsPlaintiff => 'В РОЛИ ИСТЦА';

  @override
  String get legalAsDefendant => 'В РОЛИ ОТВЕТЧИКА';

  @override
  String get legalWinProbability => 'ВЕРОЯТНОСТЬ ПОБЕДЫ';

  @override
  String get legalDisputeWord => 'Спор';

  @override
  String get lifepathScoresHeader => '🌟 БАЛЛЫ ЖИЗНЕННОГО ПУТИ';

  @override
  String get lifepathDharmaClarityStat => 'ЯСНОСТЬ\nДХАРМЫ';

  @override
  String get lifepathFortuneBaselineStat => 'БАЗОВАЯ\nУДАЧА';

  @override
  String get lifepathCoherenceStat => 'СОГЛАСОВАННОСТЬ\nЖИЗНЕННОГО ПУТИ';

  @override
  String get lifepathKarmaStat => 'КАРМА';

  @override
  String get lifepathSpiritualStat => 'ДУХОВНОЕ';

  @override
  String get lifepathFameStat => 'СЛАВА';

  @override
  String get lifepathSoulContractTitle => 'Договор души';

  @override
  String get lifepathAtmakarakaLabel => 'АТМАКАРАКА';

  @override
  String get lifepathAkFocusLabel => 'ФОКУС AK';

  @override
  String get lifepathSoulPurposeLabel => 'ЦЕЛЬ ДУШИ';

  @override
  String get lifepathLifeChapterLabel => 'ГЛАВА ЖИЗНИ';

  @override
  String get lifepathPrimaryDomainLabel => 'ОСНОВНАЯ ОБЛАСТЬ';

  @override
  String get lifepathLeadershipStat => 'ЛИДЕРСТВО';

  @override
  String get lifepathWisdomTeachStat => 'МУДРОСТЬ/ОБУЧЕНИЕ';

  @override
  String get lifepathServiceStat => 'СЛУЖЕНИЕ';

  @override
  String get lifepathHealingStat => 'ЦЕЛИТЕЛЬСТВО';

  @override
  String get lifepathFortuneYogasTitle => 'Йоги удачи';

  @override
  String get lifepathLuckBlocksLabel => 'БЛОКИ УДАЧИ';

  @override
  String get lifepathFortuneBoostersLabel => 'УСИЛИТЕЛИ УДАЧИ';

  @override
  String get lifepathFortuneTrendTitle => 'Тенденция удачи';

  @override
  String get lifepathGoldenWindowsTitle => 'Золотые окна ★';

  @override
  String get lifepathTransformationTitle => 'Трансформация';

  @override
  String get lifepathMilestonesTitle => 'Вехи жизни';

  @override
  String get lifepathKarmicLessonsTitle => 'Кармические уроки';

  @override
  String get lifepathRahuGrowthLabel => 'РОСТ ПО РАХУ';

  @override
  String get lifepathKetuSurrenderLabel => 'СМИРЕНИЕ ПО КЕТУ';

  @override
  String get lifepathSaturnLessonLabel => 'УРОК САТУРНА';

  @override
  String get lifepathLifeDifficultyLabel => 'СЛОЖНОСТЬ ЖИЗНИ';

  @override
  String get lifepathSoulExperienceTitle => '★ ДУША ПРИШЛА ИСПЫТАТЬ';

  @override
  String get lifepathBlessingsTitle => '● БЛАГОСЛОВЕНИЯ';

  @override
  String get lifepathLifeWord => 'Жизнь';

  @override
  String get lifepathArchetypeSuffix => 'Архетип';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'Реализация: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'Судьба против';

  @override
  String get lifepathFreeWillSuffix => 'Свободная воля';

  @override
  String get lifepathDestinyStat => 'СУДЬБА';

  @override
  String get lifepathFreeWillStat => 'СВОБОДНАЯ ВОЛЯ';

  @override
  String get pastlifeScoresHeader => '🔮 БАЛЛЫ ПРОШЛОЙ ЖИЗНИ';

  @override
  String get pastlifeSignatureStrengthStat => 'СИЛА\nСИГНАТУРЫ';

  @override
  String get pastlifeCarryForwardStat => 'ПЕРЕНОС\nВ ЭТУ ЖИЗНЬ';

  @override
  String get pastlifeMasteryPreservedStat => 'СОХРАНЁННОЕ\nМАСТЕРСТВО';

  @override
  String get pastlifeUnfinishedStat => 'НЕЗАВЕРШЁННОЕ';

  @override
  String get pastlifeKarmicDebtStat => 'КАРМИЧЕСКИЙ ДОЛГ';

  @override
  String get pastlifeProfileTitle => 'Профиль прошлой жизни';

  @override
  String get pastlifeThemeLabel => 'ТЕМА';

  @override
  String get pastlifeProfessionLabel => 'ПРОФЕССИЯ';

  @override
  String get pastlifeSocialStandingLabel => 'СОЦИАЛЬНОЕ ПОЛОЖЕНИЕ';

  @override
  String get pastlifeRegionLabel => 'РЕГИОН';

  @override
  String get pastlifeSpiritualLevelLabel => 'ДУХОВНЫЙ УРОВЕНЬ';

  @override
  String get pastlifeGenderLabel => 'ПОЛ';

  @override
  String get pastlifeWealthLevelLabel => 'УРОВЕНЬ БОГАТСТВА';

  @override
  String get pastlifeFamilyRoleLabel => 'РОЛЬ В СЕМЬЕ';

  @override
  String get pastlifeSkillsCarriedTitle => '★ ПЕРЕНЕСЁННЫЕ НАВЫКИ';

  @override
  String get pastlifeNaturalAttractionsTitle => '● ЕСТЕСТВЕННЫЕ ПРИТЯЖЕНИЯ';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ НЕОБЪЯСНИМЫЕ СТРАХИ';

  @override
  String get pastlifeMagneticPullsTitle => '→ МАГНЕТИЧЕСКОЕ ПРИТЯЖЕНИЕ';

  @override
  String get pastlifeRelationshipStat => 'ОТНОШЕНИЯ';

  @override
  String get pastlifeFinancialStat => 'ФИНАНСОВОЕ';

  @override
  String get pastlifeServiceStat => 'СЛУЖЕНИЕ';

  @override
  String get pastlifeDharmicStat => 'ДХАРМИЧЕСКОЕ';

  @override
  String get pastlifeOnRelationsStat => 'НА ОТНОШЕНИЯ';

  @override
  String get pastlifeOnCareerStat => 'НА КАРЬЕРУ';

  @override
  String get pastlifeOnHealthStat => 'НА ЗДОРОВЬЕ';

  @override
  String get pastlifeOnSpiritualStat => 'НА ДУХОВНОСТЬ';

  @override
  String get pastlifeKarmicResolutionTitle => 'Кармическое разрешение';

  @override
  String get pastlifePrimaryPathLabel => 'ОСНОВНОЙ ПУТЬ';

  @override
  String get pastlifeSecondaryPathLabel => 'ДОПОЛНИТЕЛЬНЫЙ ПУТЬ';

  @override
  String get pastlifeClearingProgressLabel => 'ПРОГРЕСС ПРОРАБОТКИ';

  @override
  String get pastlifeRemainingWorkLabel => 'ОСТАВШАЯСЯ РАБОТА';

  @override
  String get pastlifeDebtTimelineLabel => 'ХРОНОЛОГИЯ ДОЛГА';

  @override
  String get pastlifeMemoryAccessStat => 'ДОСТУП К ПАМЯТИ';

  @override
  String get pastlifeDreamVisitsStat => 'ВИЗИТЫ ВО СНАХ';

  @override
  String get pastlifeDejaVuStat => 'ДЕЖАВЮ';

  @override
  String get pastlifeRegressionFitStat => 'ПРИГОДНОСТЬ ДЛЯ РЕГРЕССИИ';

  @override
  String get pastlifeActivationTitle => 'Активация прошлой жизни';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'Зрелость: $maturity · Статус: $status';
  }

  @override
  String get pastlifeKetuWord => 'Кету';

  @override
  String get pastlifePastMasterySuffix => 'Прошлое мастерство';

  @override
  String get pastlifeKetuMasteredLabel => 'КЕТУ · ЧТО ВЫ ОСВОИЛИ';

  @override
  String get pastlifeRahuWord => 'Раху';

  @override
  String get pastlifeFutureGrowthSuffix => 'Будущий рост';

  @override
  String get pastlifeRahuPullsLabel => 'РАХУ · ЧТО ТЯНЕТ ВАС ВПЕРЁД';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ Тень: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 ПСИХОЛОГИЧЕСКИЕ БАЛЛЫ';

  @override
  String get mentalStabilityStat => 'ПСИХИЧЕСКАЯ\nУСТОЙЧИВОСТЬ';

  @override
  String get mentalEmotionalBaselineStat => 'ЭМОЦИОНАЛЬНЫЙ\nБАЗОВЫЙ УРОВЕНЬ';

  @override
  String get mentalResilienceStat => 'УСТОЙЧИВОСТЬ';

  @override
  String get mentalAnxietyStat => 'ТРЕВОЖНОСТЬ';

  @override
  String get mentalDepressionStat => 'ДЕПРЕССИЯ';

  @override
  String get mentalRegulationStat => 'РЕГУЛЯЦИЯ';

  @override
  String get mentalProfileTitle => 'Психологический профиль';

  @override
  String get mentalConstitutionLabel => 'КОНСТИТУЦИЯ';

  @override
  String get mentalStressDriverLabel => 'ИСТОЧНИК СТРЕССА';

  @override
  String get mentalStabilityAnchorLabel => 'ОПОРА УСТОЙЧИВОСТИ';

  @override
  String get mentalStressResponseLabel => 'РЕАКЦИЯ НА СТРЕСС';

  @override
  String get mentalAttachmentStyleLabel => 'СТИЛЬ ПРИВЯЗАННОСТИ';

  @override
  String get mentalBurnoutStageLabel => 'СТАДИЯ ВЫГОРАНИЯ';

  @override
  String get mentalWord => 'Психика';

  @override
  String get mentalYogasTitle => 'Психологические йоги';

  @override
  String get mentalStressPressureLabel => 'ДАВЛЕНИЕ СТРЕССА';

  @override
  String get mentalWellnessTrendTitle => 'Тенденция благополучия';

  @override
  String get mentalHealthyCopingTitle => '✓ ЗДОРОВОЕ СОВЛАДАНИЕ';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ НЕЗДОРОВЫЕ РИСКИ';

  @override
  String get mentalRecommendedAlternativesTitle =>
      '✦ РЕКОМЕНДУЕМЫЕ АЛЬТЕРНАТИВЫ';

  @override
  String get mentalSleepQualityStat => 'КАЧЕСТВО СНА';

  @override
  String get mentalSocialSupportStat => 'СОЦИАЛЬНАЯ ПОДДЕРЖКА';

  @override
  String get mentalBurnoutVulnStat => 'УЯЗВИМОСТЬ К ВЫГОРАНИЮ';

  @override
  String get mentalSelfAwarenessStat => 'САМООСОЗНАНИЕ';

  @override
  String get mentalAnxietyWord => 'Тревожность';

  @override
  String get mentalTypesSuffix => 'Типы';

  @override
  String get mentalTherapyWord => 'Терапия';

  @override
  String get mentalModalityFitSuffix => 'Соответствие модальности';

  @override
  String get characterScoresHeader => '🔍 БАЛЛЫ ХАРАКТЕРА';

  @override
  String get characterStrengthStat => 'СИЛА\nХАРАКТЕРА';

  @override
  String get characterIntegrityStat => 'ЧЕСТНОСТЬ';

  @override
  String get characterResilienceStat => 'УСТОЙЧИВОСТЬ';

  @override
  String get characterAwarenessStat => 'ОСОЗНАННОСТЬ';

  @override
  String get characterStabilityStat => 'УСТОЙЧИВОСТЬ';

  @override
  String get characterEthicsStat => 'ЭТИКА';

  @override
  String get characterSurfacePersonalityTitle => 'Внешняя личность';

  @override
  String get characterLagnaLabel => 'ЛАГНА';

  @override
  String get characterConstitutionLabel => 'КОНСТИТУЦИЯ';

  @override
  String get characterNakshatraLabel => 'НАКШАТРА';

  @override
  String get characterDeityLabel => 'БОЖЕСТВО';

  @override
  String get characterMoonManasTitle => 'Манас Луны';

  @override
  String get characterSignLabel => 'ЗНАК';

  @override
  String get characterHouseLabel => 'ДОМ';

  @override
  String get characterWarmthStat => 'ТЕПЛОТА';

  @override
  String get characterEmpathyStat => 'ЭМПАТИЯ';

  @override
  String get characterLoyaltyStat => 'ПРЕДАННОСТЬ';

  @override
  String get characterBoundariesStat => 'ГРАНИЦЫ';

  @override
  String get characterDharmaStat => 'ДХАРМА';

  @override
  String get characterTruthStat => 'ПРАВДА';

  @override
  String get characterCompassionStat => 'СОСТРАДАНИЕ';

  @override
  String get characterGenerosityStat => 'ЩЕДРОСТЬ';

  @override
  String get characterSignatureVirtuesTitle => '★ ХАРАКТЕРНЫЕ ДОСТОИНСТВА';

  @override
  String get characterNaturalTalentsTitle => '● ПРИРОДНЫЕ ТАЛАНТЫ';

  @override
  String get characterShadowPatternsTitle => '⚠ ТЕНЕВЫЕ ПАТТЕРНЫ';

  @override
  String get characterYogasTitle => 'Йоги характера';

  @override
  String get characterTestsLabel => 'ИСПЫТАНИЯ';

  @override
  String get characterGiftsLabel => 'ДАРЫ';

  @override
  String get characterSelfAwareEiStat => 'САМООСОЗНАННОСТЬ (EI)';

  @override
  String get characterSelfRegulateStat => 'САМОРЕГУЛЯЦИЯ';

  @override
  String get characterEmpathyEiStat => 'ЭМПАТИЯ (EI)';

  @override
  String get characterSocialSkillsStat => 'СОЦИАЛЬНЫЕ НАВЫКИ';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'Реализация: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Атмакарака';

  @override
  String get characterSoulSignatureSuffix => 'Сигнатура души';

  @override
  String get characterAtmakarakaLabel => 'АТМАКАРАКА';

  @override
  String get characterGunaWord => 'Гуна';

  @override
  String get characterProfileSuffix => 'Профиль';

  @override
  String get characterSattvaLabel => 'Саттва';

  @override
  String get characterRajasLabel => 'Раджас';

  @override
  String get characterTamasLabel => 'Тамас';

  @override
  String get healthScoresHeader => '🏥 БАЛЛЫ ЗДОРОВЬЯ';

  @override
  String get healthVitalityStat => 'ЖИЗНЕННАЯ СИЛА';

  @override
  String get healthImmunityStat => 'ИММУНИТЕТ';

  @override
  String get healthRecoveryStat => 'ВОССТАНОВЛЕНИЕ';

  @override
  String get healthMentalStat => 'ПСИХИКА';

  @override
  String get healthStressTolStat => 'ТОЛЕРАНТНОСТЬ К СТРЕССУ';

  @override
  String get healthYogasTitle => 'Йоги здоровья';

  @override
  String get healthDiseasePressureLabel => 'ДАВЛЕНИЕ БОЛЕЗНИ';

  @override
  String get healthTrendTitle => 'Тенденция здоровья';

  @override
  String get healthRecoveryWindowsTitle => 'Окна восстановления';

  @override
  String get healthCautionPeriodsTitle => 'Периоды осторожности';

  @override
  String get healthFertilityStat => 'ФЕРТИЛЬНОСТЬ';

  @override
  String get healthBurnoutRiskStat => 'РИСК ВЫГОРАНИЯ';

  @override
  String get healthAddictionVulnStat => 'УЯЗВИМОСТЬ К ЗАВИСИМОСТЯМ';

  @override
  String get healthWorkLifeBalStat => 'БАЛАНС РАБОТЫ И ЖИЗНИ';

  @override
  String get healthAyurvedicWord => 'Аюрведическое';

  @override
  String get healthConstitutionSuffix => 'Конституция';

  @override
  String get healthBodyWord => 'Тело';

  @override
  String get healthSystemMapSuffix => 'Карта систем';

  @override
  String get healthBodyZoneWord => 'Зона тела';

  @override
  String get healthVulnerabilitySuffix => 'Уязвимость';

  @override
  String get healthDiseaseWord => 'Заболевание';

  @override
  String get healthSusceptibilitySuffix => 'Восприимчивость';

  @override
  String get healthLifestyleFactorsTitle => 'Факторы образа жизни';

  @override
  String get healthSleepDisciplineLabel => 'ДИСЦИПЛИНА СНА';

  @override
  String get healthDietDisciplineLabel => 'ДИСЦИПЛИНА ПИТАНИЯ';

  @override
  String get healthExerciseNeedLabel => 'ПОТРЕБНОСТЬ В НАГРУЗКЕ';

  @override
  String get healthSunlightNeedLabel => 'ПОТРЕБНОСТЬ В СОЛНЦЕ';

  @override
  String get healthSocialTypeLabel => 'СОЦИАЛЬНЫЙ ТИП';

  @override
  String get healthHealingSpeedLabel => 'СКОРОСТЬ ИСЦЕЛЕНИЯ';

  @override
  String get wealthScoresHeader => '💰 БАЛЛЫ БОГАТСТВА';

  @override
  String get wealthStrengthStat => 'СИЛА\nБОГАТСТВА';

  @override
  String get wealthAccumulationStat => 'НАКОП-\nЛЕНИЕ';

  @override
  String get wealthIncomeFlowStat => 'ПОТОК\nДОХОДА';

  @override
  String get wealthSustainStat => 'УСТОЙЧИВОСТЬ';

  @override
  String get wealthMultiStreamStat => 'НЕСКОЛЬКО ПОТОКОВ';

  @override
  String get wealthRetentionStat => 'СОХРАНЕНИЕ';

  @override
  String get wealthWord => 'Богатство';

  @override
  String get wealthYogasTitle => 'Йоги богатства';

  @override
  String get wealthDrainsLabel => 'УТЕЧКИ';

  @override
  String get wealthBoostersLabel => 'УСИЛИТЕЛИ';

  @override
  String get wealthYearlyTrendTitle => 'Годовая тенденция';

  @override
  String get wealthGrowthTitle => 'Рост богатства';

  @override
  String get wealthCashPressureTitle => 'Денежное давление';

  @override
  String get wealthMoneyPersonalityTitle => 'Денежная личность';

  @override
  String get wealthTypeLabel => 'ТИП БОГАТСТВА';

  @override
  String get wealthRiskAppetiteLabel => 'АППЕТИТ К РИСКУ';

  @override
  String get wealthInvestmentStyleLabel => 'ИНВЕСТИЦИОННЫЙ СТИЛЬ';

  @override
  String get wealthMoneyPersonalityLabel => 'ДЕНЕЖНАЯ ЛИЧНОСТЬ';

  @override
  String get wealthSpendingLabel => 'ТРАТЫ';

  @override
  String get wealthDebtProbStat => '% ВЕРОЯТНОСТИ ДОЛГА';

  @override
  String get wealthInheritanceStat => '% НАСЛЕДСТВА';

  @override
  String get wealthSuddenGainsStat => '% ВНЕЗАПНЫХ ДОХОДОВ';

  @override
  String get wealthSpouseBoostStat => '% УСИЛЕНИЯ СУПРУГОМ';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'Вероятность успеха: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'КЛАСС БОГАТСТВА ЗА ЖИЗНЬ';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'Основное: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'Пик: $value';
  }

  @override
  String get wealthIncomeWord => 'Доход';

  @override
  String get wealthSourcesSuffix => 'Источники';

  @override
  String get wealthInvestmentWord => 'Инвестиции';

  @override
  String get wealthMixSuffix => 'Сочетание';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'Движимо планетой $planet';
  }

  @override
  String get marriageScoresHeader => '💒 БАЛЛЫ БРАКА';

  @override
  String get marriageOverallStat => 'ОБЩИЙ\nБРАК';

  @override
  String get marriageHarmonyStat => 'СЕМЕЙНАЯ\nГАРМОНИЯ';

  @override
  String get marriageDomesticStabilityStat => 'ДОМАШНЯЯ\nСТАБИЛЬНОСТЬ';

  @override
  String get marriageLongevityStat => 'ДОЛГОВЕЧНОСТЬ';

  @override
  String get marriageSatisfactionStat => 'УДОВЛЕТВОРЁННОСТЬ';

  @override
  String get marriageClarityStat => 'ЯСНОСТЬ';

  @override
  String get marriageWindowsTitle => 'Окна брака';

  @override
  String get marriagePhasesTitle => 'Фазы брака';

  @override
  String get marriageInLawRelationsStat => 'ОТНОШЕНИЯ СО СВЁКРАМИ/ТЕСТЯМИ';

  @override
  String get marriageFamilyHarmonyStat => 'СЕМЕЙНАЯ ГАРМОНИЯ';

  @override
  String get marriageFertilityStat => 'ФЕРТИЛЬНОСТЬ';

  @override
  String get marriageHomeOwnershipStat => 'ВЛАДЕНИЕ ЖИЛЬЁМ';

  @override
  String get marriageDivorceRiskStat => 'РИСК РАЗВОДА';

  @override
  String get marriageInfidelityStat => 'ИЗМЕНА';

  @override
  String get marriageConflictStat => 'КОНФЛИКТ';

  @override
  String get marriageDistanceStat => 'ДИСТАНЦИЯ';

  @override
  String get marriageSeekInPartnerTitle => '★ ИСКАТЬ В ПАРТНЁРЕ';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ ИЗБЕГАТЬ В ПАРТНЁРЕ';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'Реализация: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Даракарака';

  @override
  String get marriageSpouseKarakaSuffix => 'Карака супруга';

  @override
  String get marriageDarakarakaDkLabel => 'ДАРАКАРАКА (DK)';

  @override
  String get marriage7thWord => '7-й';

  @override
  String get marriageSignLabel => 'ЗНАК';

  @override
  String get marriageLordInLabel => 'УПРАВИТЕЛЬ В';

  @override
  String get marriageStrengthLabel => 'СИЛА';

  @override
  String get marriageSpouseWord => 'Супруг(а)';

  @override
  String get marriageProfileSuffix => 'Профиль';

  @override
  String get marriageSpouseTraitsTitle => '★ ЧЕРТЫ СУПРУГА';

  @override
  String get marriageLikelyProfessionsTitle => '● ВЕРОЯТНЫЕ ПРОФЕССИИ';

  @override
  String get marriageHarmonyWord => 'Гармония';

  @override
  String get marriageRadarSuffix => 'Радар';

  @override
  String get marriagePhysicalLabel => 'Физическое';

  @override
  String get marriageSharedValuesLabel => 'Общие ценности';

  @override
  String get marriageConflictResolutionLabel => 'Разрешение конфликтов';

  @override
  String get marriageMangalDoshLabel => '⚠ МАНГАЛ-ДОША';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'Тяжесть: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'Отмена: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Навамша';

  @override
  String get multiChartTitleChild => 'Ребёнок';

  @override
  String get multiChartTitleLove => 'Любовь';

  @override
  String get multiChartTitleKarma => 'Карма';

  @override
  String get multiChartTitleDefault => 'Мульти-карта';

  @override
  String get multiChartSuffixProbability => 'Вероятность';

  @override
  String get multiChartSuffixCompatibility => 'Совместимость';

  @override
  String get multiChartSuffixLinkage => 'Связь';

  @override
  String get multiChartSuffixReport => 'Отчёт';

  @override
  String get multiChartParticipantsLabel => 'УЧАСТНИКИ';

  @override
  String get multiChartAnalysisWord => 'Анализ';

  @override
  String get multiChartConfidenceSuffix => 'Уверенность';

  @override
  String get multiChartQualityBadge => 'КАЧЕСТВО';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'Проанализируйте этот отчёт по ведической астрологии и дайте подробные выводы:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'Вот специализированный отчёт по ведической астрологии. Пожалуйста, тщательно проанализируйте его и дайте практические рекомендации:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'Изучите этот анализ по ведической астрологии и объясните ключевые выводы простым языком:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'Скопировано для $label!';
  }

  @override
  String get childProbTitle1 => 'Ребёнок';

  @override
  String get childProbTitle2 => 'Вероятность';

  @override
  String get childNumberOfChildrenHeader1 => 'Число';

  @override
  String get childNumberOfChildrenHeader2 => 'Дети';

  @override
  String get childTimingHeader1 => 'Время';

  @override
  String get childTimingHeader2 => 'Мула-даша';

  @override
  String get child5thHouseHeader1 => '5-й дом';

  @override
  String get analysisWord => 'Анализ';

  @override
  String get jupiterWord => 'Юпитер';

  @override
  String get childD7Header1 => 'Саптамша D7';

  @override
  String get childBeejaHeader1 => 'Биджа и Кшетра';

  @override
  String get childBeejaHeader2 => 'Спхута';

  @override
  String get childDoshaHeader1 => 'Доша';

  @override
  String get childVedicHeader1 => 'Ведическое';

  @override
  String get childVedicHeader2 => 'Средства';

  @override
  String get progenyProbabilityLabel => 'ВЕРОЯТНОСТЬ ПОТОМСТВА';

  @override
  String get favorableWindowsLabel => 'БЛАГОПРИЯТНЫЕ ОКНА';

  @override
  String get partnerOneLabel => 'Партнёр 1';

  @override
  String get partnerTwoLabel => 'Партнёр 2';

  @override
  String get moonSignLabel => 'Знак Луны';

  @override
  String get lordInDusthana => 'Управитель в Дустхане';

  @override
  String get lordStrengthLabel => 'Сила управителя';

  @override
  String get houseStrengthLabel => 'Сила дома';

  @override
  String get dignityLabel => 'Достоинство';

  @override
  String get directBadge => 'Прямой';

  @override
  String get notCombustBadge => 'Не комбустирован';

  @override
  String get in5thHouseBadge => 'В 5-м доме';

  @override
  String get aspects5thBadge => 'Аспектирует 5-й';

  @override
  String get no5thConnectionBadge => 'Нет связи с 5-м';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Юпитер в $sign';
  }

  @override
  String get d7LagnaLabel => 'Лагна D7';

  @override
  String get d7FifthSignLabel => '5-й знак D7';

  @override
  String get d7FifthLordLabel => 'Управитель 5-го D7';

  @override
  String get jupiterInD7Label => 'Юпитер в D7';

  @override
  String get jupiterDignityLabel => 'Достоинство Юпитера';

  @override
  String get d7StrengthLabel => 'Сила D7';

  @override
  String get yesWord => 'Да';

  @override
  String get noWord => 'Нет';

  @override
  String get beejaSphutaTitle => 'БИДЖА-СПХУТА';

  @override
  String get kshetraSphutaTitle => 'КШЕТРА-СПХУТА';

  @override
  String get degreeLabel => 'Градус';

  @override
  String get signLordLabel => 'Управитель знака';

  @override
  String get presentInLabel => 'Присутствует в';

  @override
  String get netPenaltyLabel => 'Чистый штраф';

  @override
  String get remedyGemstone => 'Средства через драгоценные камни';

  @override
  String get remedyMantra => 'Средства через мантры';

  @override
  String get remedyRitual => 'Ритуальные средства';

  @override
  String get remedyLifestyle => 'Средства через образ жизни';

  @override
  String get remedyCharitable => 'Благотворительные средства';

  @override
  String copiedForName(String name) {
    return 'Скопировано для $name!';
  }

  @override
  String get mahadashaLabel => 'Махадаша';

  @override
  String get mdPeriodLabel => 'Период MD';

  @override
  String get antardashaLabel => 'Антардаша';

  @override
  String get adPeriodLabel => 'Период AD';

  @override
  String get pratyantardashaLabel => 'Пратьянтардаша';

  @override
  String get favorabilityLabel => 'Благоприятность';

  @override
  String factorPrefix(String factor) {
    return 'Фактор: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'Применяется к: $value';
  }

  @override
  String get qualityTag => 'КАЧЕСТВО';

  @override
  String get reliabilityVeryHigh => 'Очень высокая надёжность';

  @override
  String get reliabilityGuidanceLevel => 'Чтение на уровне рекомендаций';

  @override
  String get karmaLinkTitle1 => 'Карма';

  @override
  String get karmaLinkTitle2 => 'Связь';

  @override
  String get karmaFoundationHeader1 => 'Кармическая';

  @override
  String get karmaFoundationHeader2 => 'Основа';

  @override
  String get karmaPairwiseHeader1 => 'Парные';

  @override
  String get karmaPairwiseHeader2 => 'Связи';

  @override
  String get karmaGroupHeader1 => 'Групповая';

  @override
  String get karmaGroupHeader2 => 'Модель';

  @override
  String get karmaPastLifeHeader1 => 'Прошлая жизнь';

  @override
  String get karmaPastLifeHeader2 => 'Цели';

  @override
  String get karmaCurrentLifeHeader1 => 'Текущая жизнь';

  @override
  String get karmaCurrentLifeHeader2 => 'Обучение';

  @override
  String get karmaDebtsHeader2 => 'Долги';

  @override
  String get karmaMoolaDashaHeader1 => 'Мула-даша';

  @override
  String get karmaMoolaDashaHeader2 => 'Время';

  @override
  String get karmaDeepAuditHeader1 => 'Глубокий анализ';

  @override
  String get karmaDeepAuditHeader2 => 'Таблица';

  @override
  String get karmaHeroLabel => 'КАРМИЧЕСКАЯ СВЯЗЬ ПРОШЛЫХ ЖИЗНЕЙ';

  @override
  String get karmaKetuMastery => 'МАСТЕРСТВО КЕТУ';

  @override
  String get nakshatraLabel => 'Накшатра';

  @override
  String get deityLabel => 'Божество';

  @override
  String get masteryScoreLabel => 'Балл мастерства';

  @override
  String get karmaRahuGrowth => 'РОСТ ПО РАХУ';

  @override
  String get growthScoreLabel => 'Балл роста';

  @override
  String get karmaAtmakaraka => 'АТМАКАРАКА';

  @override
  String get karmaSaturnKarma => 'КАРМА САТУРНА';

  @override
  String get karma12thHouse => '12-Й ДОМ';

  @override
  String get karma9thHousePunya => 'ПУНЬЯ 9-ГО ДОМА';

  @override
  String get bhavaScoreLabel => 'Балл бхавы';

  @override
  String get karmaD60Signature => 'СИГНАТУРА D60';

  @override
  String get depthScoreLabel => 'Балл глубины';

  @override
  String get linkageStrengthLabel => 'Сила связи';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'ФАКТОРЫ СВЯЗИ (активно: $count)';
  }

  @override
  String get factorColumnLabel => 'Фактор';

  @override
  String get weightColumnLabel => 'Вес';

  @override
  String get meaningColumnLabel => 'Значение';

  @override
  String get statusColumnLabel => 'Статус';

  @override
  String get karmaPastLifeConnection => 'СВЯЗЬ ПРОШЛОЙ ЖИЗНИ';

  @override
  String get karmaCurrentLifeDynamic => 'ДИНАМИКА ТЕКУЩЕЙ ЖИЗНИ';

  @override
  String get karmaWhatTheyTeach => 'ЧЕМУ ОНИ УЧАТ ДРУГ ДРУГА';

  @override
  String get karmaGroupThemeHeader => 'ГРУППОВАЯ КАРМИЧЕСКАЯ ТЕМА';

  @override
  String get karmaSharedSettingHeader => 'ОБЩАЯ ОБСТАНОВКА ПРОШЛОЙ ЖИЗНИ';

  @override
  String get karmaCollectiveKetuHeader => 'КОЛЛЕКТИВНЫЙ ПАТТЕРН КЕТУ';

  @override
  String get karmaCollectiveRahuHeader => 'КОЛЛЕКТИВНЫЙ ПАТТЕРН РАХУ';

  @override
  String get housesPrefixLabel => 'Дома: ';

  @override
  String get signsPrefixLabel => 'Знаки: ';

  @override
  String get karmicCohesionLabel => 'Кармическая сплочённость';

  @override
  String get karmaGroupSoulContractHeader => 'ГРУППОВОЙ ДОГОВОР ДУШИ';

  @override
  String get goalLabel => 'Цель';

  @override
  String get karmaSharedGoalHeader => 'ОБЩАЯ ЦЕЛЬ ПРОШЛОЙ ЖИЗНИ';

  @override
  String get howToGrowHeader => 'КАК РАСТИ';

  @override
  String moolaDashaPrefix(String value) {
    return 'Мула-даша: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'ОБЩИЙ ГРУППОВОЙ УРОК';

  @override
  String get karmaMutualTeachingHeader => 'КАРТА ВЗАИМНОГО ОБУЧЕНИЯ';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'Динамика обучения проявится по мере углубления кармических связей.';

  @override
  String get typeFieldLabel => 'Тип';

  @override
  String get basisFieldLabel => 'Основа';

  @override
  String get resolutionPathHeader => 'ПУТЬ РАЗРЕШЕНИЯ';

  @override
  String dashaTimingPrefix(String value) {
    return 'Время по даше: $value';
  }

  @override
  String get mutualDebtsHeader => 'ВЗАИМНЫЕ ДОЛГИ';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'Даты';

  @override
  String get groupKarmicWindowHeader => 'ГРУППОВОЕ КАРМИЧЕСКОЕ ОКНО';

  @override
  String parametersAuditedHeading(int count) {
    return 'ПРОВЕРЕНО ПАРАМЕТРОВ: $count';
  }

  @override
  String get valuePrefixLabel => 'Значение: ';

  @override
  String weightPrefix(String value) {
    return 'В: $value';
  }

  @override
  String get loveCompatTitle1 => 'Любовь';

  @override
  String get loveCompatTitle2 => 'Совместимость';

  @override
  String get loveAttractionHeader1 => 'Притяжение и';

  @override
  String get loveAttractionHeader2 => 'Химия';

  @override
  String get loveEmotionalHeader1 => 'Эмоциональная';

  @override
  String get loveEmotionalHeader2 => 'Гармония';

  @override
  String get loveMentalHeader1 => 'Психика';

  @override
  String get loveMentalHeader2 => 'Взаимопонимание';

  @override
  String get lovePassionHeader1 => 'Страсть и';

  @override
  String get lovePassionHeader2 => 'Физическое';

  @override
  String get loveLongtermHeader1 => 'Долгосрочное';

  @override
  String get loveKarmicHeader1 => 'Кармическая любовь';

  @override
  String get loveKarmicHeader2 => 'Связь';

  @override
  String get loveChallengesHeader1 => 'Сложности и';

  @override
  String get loveChallengesHeader2 => 'Трения';

  @override
  String get loveTimingHeader1 => 'Время для любви';

  @override
  String get loveRelationshipHeader1 => 'Отношения';

  @override
  String get loveRelationshipHeader2 => 'Динамика';

  @override
  String get loveRemediesHeader1 => 'Средства и';

  @override
  String get loveRemediesHeader2 => 'Рекомендации';

  @override
  String get loveCompatHeroLabel => 'ЛЮБОВНАЯ СОВМЕСТИМОСТЬ';

  @override
  String get loveChipAttraction => 'Притяжение';

  @override
  String get loveChipPassion => 'Страсть';

  @override
  String get loveChipChallenge => 'Вызов';

  @override
  String get venusSignLabel => 'Знак Венеры';

  @override
  String get attractionScoreLabel => 'Оценка притяжения';

  @override
  String get activeContactsLabel => 'Активные контакты';

  @override
  String get magneticPullLabel => 'Магнетическое притяжение';

  @override
  String get initialAttractionLabel => 'Первоначальное притяжение';

  @override
  String get emotionalScoreLabel => 'Эмоциональный балл';

  @override
  String get elementMatchLabel => 'Соответствие стихий';

  @override
  String get harmonyLabel => 'Гармония';

  @override
  String get kootaYoni => 'ЙОНИ';

  @override
  String get kootaGana => 'ГАНА';

  @override
  String get kootaTara => 'ТАРА';

  @override
  String get doshaPresentBadge => 'Доша присутствует';

  @override
  String get noDoshaBadge => 'Доши нет';

  @override
  String get axisLabel => 'Ось';

  @override
  String get mentalScoreLabel => 'Ментальный балл';

  @override
  String get mercuryDynamicsLabel => 'ДИНАМИКА МЕРКУРИЯ';

  @override
  String get communicationStyleLabel => 'СООТВЕТСТВИЕ СТИЛЯ ОБЩЕНИЯ';

  @override
  String get intellectualConnectionLabel => 'ИНТЕЛЛЕКТУАЛЬНАЯ СВЯЗЬ';

  @override
  String get passionScoreLabel => 'Оценка страсти';

  @override
  String get marsVenusLabel => 'ВЗАИМОДЕЙСТВИЕ МАРСА И ВЕНЕРЫ';

  @override
  String get physicalChemistryLabel => 'ФИЗИЧЕСКАЯ ХИМИЯ';

  @override
  String get yoniCompatLabel => 'СОВМЕСТИМОСТЬ ПО ЙОНИ';

  @override
  String get longtermScoreLabel => 'Долгосрочный балл';

  @override
  String get seventhHouseSynastryLabel => 'СИНАСТРИЯ 7-ГО ДОМА';

  @override
  String get commitmentPotentialLabel => 'ПОТЕНЦИАЛ ОБЯЗАТЕЛЬСТВ';

  @override
  String get jupiterBlessingLabel => 'БЛАГОСЛОВЕНИЕ ЮПИТЕРА';

  @override
  String get d9NavamsaResonanceLabel => 'РЕЗОНАНС НАВАМШИ D9';

  @override
  String get saturnLongevityLabel => 'ДОЛГОЛЕТИЕ ПО САТУРНУ';

  @override
  String get karmicScoreLabel => 'Кармический балл';

  @override
  String get darakarakaLinkLabel => 'СВЯЗЬ ПО ДАРАКАРАКЕ';

  @override
  String get sourceLabel => 'Источник';

  @override
  String get emotionalGiverReceiverLabel => 'ЭМОЦИОНАЛЬНЫЙ ДАРИТЕЛЬ/ПОЛУЧАТЕЛЬ';

  @override
  String get powerBalanceLabel => 'БАЛАНС СИЛ';

  @override
  String get growthDynamicLabel => 'ДИНАМИКА РОСТА';

  @override
  String get addressesLabel => 'Затрагивает';

  @override
  String get loveScoresLabel => 'БАЛЛЫ ЛЮБВИ';

  @override
  String get loveCapacityLabel => 'СПОСОБНОСТЬ\nК ЛЮБВИ';

  @override
  String get emotionalAvailabilityLabel => 'ЭМОЦИОНАЛЬНАЯ\nДОСТУПНОСТЬ';

  @override
  String get romanticAttractionLabel => 'РОМАНТИЧЕСКОЕ\nПРИТЯЖЕНИЕ';

  @override
  String get commitmentWord => 'ОБЯЗАТЕЛЬСТВА';

  @override
  String get intimacyWord => 'БЛИЗОСТЬ';

  @override
  String get fidelityWord => 'ВЕРНОСТЬ';

  @override
  String get loveProfileTitle => 'Профиль любви';

  @override
  String get loveStyleLabel => 'СТИЛЬ ЛЮБВИ';

  @override
  String get attractionStyleLabel => 'СТИЛЬ ПРИТЯЖЕНИЯ';

  @override
  String get lovePathLabel => 'ПУТЬ ЛЮБВИ';

  @override
  String get currentPhaseLabel => 'ТЕКУЩАЯ ФАЗА';

  @override
  String get commitmentStyleLabel => 'СТИЛЬ ОБЯЗАТЕЛЬСТВ';

  @override
  String get loveWord => 'Любовь';

  @override
  String get karakasWord => 'Караки';

  @override
  String get attractedToLabel => 'ПРИВЛЕКАЕТ К';

  @override
  String get whatPartnerSeesLabel => 'ЧТО ВИДИТ ПАРТНЁР';

  @override
  String get romancePatternTitle => 'Модель романтики';

  @override
  String get firstLoveAgeLabel => 'ВОЗРАСТ ПЕРВОЙ ЛЮБВИ';

  @override
  String get relationshipCountLabel => 'КОЛИЧЕСТВО ОТНОШЕНИЙ';

  @override
  String get avgDurationLabel => 'СРЕДНЯЯ ПРОДОЛЖИТЕЛЬНОСТЬ';

  @override
  String get breakupTriggerLabel => 'ТРИГГЕР РАЗРЫВА';

  @override
  String get heartbreakRecoveryLabel => 'ВОССТАНОВЛЕНИЕ ПОСЛЕ РАЗРЫВА';

  @override
  String get loveTrendTitle => 'Тенденция любви';

  @override
  String get newLoveWindowsTitle => 'Окна новой любви';

  @override
  String get loveBlocksTitle => 'Блоки любви';

  @override
  String get activeBlocksLabel => 'АКТИВНЫЕ БЛОКИ';

  @override
  String get loveMarriagePctLabel => '% БРАКА ПО ЛЮБВИ';

  @override
  String get heartbreakVulnLabel => 'УЯЗВИМОСТЬ К РАЗБИТОМУ СЕРДЦУ';

  @override
  String get selfSabotageLabel => 'САМОСАБОТАЖ';

  @override
  String get emotionalIqLabel => 'ЭМОЦИОНАЛЬНЫЙ IQ';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'Реализация: $pct%';
  }

  @override
  String get languagesWord => 'Языки';

  @override
  String get givesLabel => 'ДАЁТ';

  @override
  String get receivesLabel => 'ПОЛУЧАЕТ';

  @override
  String get idealWord => 'Идеал';

  @override
  String get partnerWord => 'Партнёр';

  @override
  String get seekTheseTraitsLabel => 'ИЩИТЕ ЭТИ ЧЕРТЫ';

  @override
  String get dealbreakersLabel => 'НЕПРИЕМЛЕМЫЕ КАЧЕСТВА';

  @override
  String get propertyScoresLabel => 'БАЛЛЫ СОБСТВЕННОСТИ';

  @override
  String get acquisitionCapacityLabel => 'СПОСОБНОСТЬ\nК ПРИОБРЕТЕНИЮ';

  @override
  String get homeOwnershipPctLabel => '% ВЛАДЕНИЯ\nЖИЛЬЁМ';

  @override
  String get reWealthPotentialLabel => 'ПОТЕНЦИАЛ\nБОГАТСТВА В НЕДВИЖИМОСТИ';

  @override
  String get rentalWord => 'АРЕНДА';

  @override
  String get vehiclesWord => 'ТРАНСПОРТ';

  @override
  String get landPctLabel => '% ЗЕМЛИ';

  @override
  String get propertyProfileTitle => 'Профиль собственности';

  @override
  String get karmaTypeLabel => 'ТИП КАРМЫ';

  @override
  String get environmentLabel => 'ОКРУЖЕНИЕ';

  @override
  String get styleLabel => 'СТИЛЬ';

  @override
  String get sizeLabel => 'РАЗМЕР';

  @override
  String get locationLabel => 'МЕСТОПОЛОЖЕНИЕ';

  @override
  String get actionNext12mLabel => 'ДЕЙСТВИЕ НА СЛЕДУЮЩИЕ 12 МЕС.';

  @override
  String get propertyWord => 'Собственность';

  @override
  String get propertyYogasTitle => 'Йоги собственности';

  @override
  String get drainsLabel => 'УТЕЧКИ';

  @override
  String get boostersLabel => 'УСИЛИТЕЛИ';

  @override
  String get propertyTrendTitle => 'Тенденция собственности';

  @override
  String get buyingWindowsTitle => 'Окна покупки';

  @override
  String get constructionWindowsTitle => 'Окна строительства';

  @override
  String get maternalInherPctLabel => '% НАСЛЕДСТВА ПО МАТЕРИ';

  @override
  String get paternalInherPctLabel => '% НАСЛЕДСТВА ПО ОТЦУ';

  @override
  String get multiHomePctLabel => '% НЕСКОЛЬКИХ ДОМОВ';

  @override
  String get investmentPctLabel => '% ИНВЕСТИЦИЙ';

  @override
  String get vehicleProfileTitle => 'Профиль транспорта';

  @override
  String get countLabel => 'КОЛИЧЕСТВО';

  @override
  String get firstAgeLabel => 'ПЕРВЫЙ ВОЗРАСТ';

  @override
  String get categoryLabel => 'КАТЕГОРИЯ';

  @override
  String get luxuryLabel => 'РОСКОШЬ';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'Всего за жизнь: $count · Реализация: $pct%';
  }

  @override
  String get pressureWord => 'ДАВЛЕНИЕ';

  @override
  String get protectionWord => 'ЗАЩИТА';

  @override
  String get astrologicalWord => 'Астрологическое';

  @override
  String get keyRisksHeader1 => 'Ключ';

  @override
  String get keyRisksHeader2 => 'Риски';

  @override
  String get reportCopiedShort => 'Отчёт скопирован!';

  @override
  String get keyScoresLabel => 'КЛЮЧЕВЫЕ БАЛЛЫ';

  @override
  String allScoresCountLabel(int count) {
    return 'Все баллы ($count)';
  }

  @override
  String get windowsWord => 'Окна';

  @override
  String get genericFailedMsg => 'Неудача';

  @override
  String get unknownWord => 'Неизвестно';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'Выберите 2-$max карт(ы)';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'Выберите $max карт(ы)';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'Выполняется анализ $label...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'Выберите от 2 до $max карт для анализа кармических связей';
  }

  @override
  String get pickMaleFemaleHint => 'Выберите мужскую и женскую карту';

  @override
  String get personOneLabel => 'Человек 1';

  @override
  String get personTwoLabel => 'Человек 2';

  @override
  String get analysisFailedMsg => 'Не удалось выполнить анализ';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'Анализировать $count карт(ы)';
  }

  @override
  String get contextGeneralLabel => 'Общее';

  @override
  String get contextLoveLabel => 'Любовь';

  @override
  String get contextBusinessLabel => 'Бизнес';

  @override
  String get contextFamilyLabel => 'Семья';

  @override
  String get contextTeamLabel => 'Команда';

  @override
  String get contextFriendshipLabel => 'Дружба';

  @override
  String get relationshipIntelTitle => 'Интеллект отношений';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'Анализ $count карт...';
  }

  @override
  String get relationshipContextLabel => 'Контекст отношений';

  @override
  String get kundliMilanReportTitle => 'Отчёт Кундли-Милан';

  @override
  String get runningMilanAnalysisLabel => 'Выполняется анализ Милан...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return 'Выбрано: $count/2';
  }

  @override
  String get runMilanAnalysisBtn => 'Запустить анализ Милан';

  @override
  String get noChartsCreateFirst =>
      'Нет карт. Сначала создайте натальную карту.';

  @override
  String get selectBirthChartAnalyze => 'Выберите натальную карту для анализа';

  @override
  String get doshAnalysis => 'Анализ дош';

  @override
  String doshActiveCount(Object active, Object total) {
    return 'Активно $active / проверено $total';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return 'Активно $active / проверено йог $total';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'АКТИВНЫЕ ЙОГИ ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'Скрыть неактивные йоги ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'Показать неактивные йоги ($count)';
  }

  @override
  String get loadFailed => 'Неудача';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet MD → Антардаши';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet AD → Пратьянтардаши';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet PD → Сукшмадаши';
  }

  @override
  String dashaDrillSub(Object planet) {
    return '$planet Подпериоды';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'Управитель рождения: $lord • Остаток: $balance лет';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Лагна: $lagna • Остаток: $balance лет';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years лет';
  }

  @override
  String get dashaCurrentPeriod => 'Текущий период даши';

  @override
  String dashaAsOf(Object date) {
    return 'На дату: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Активные йоги в текущем периоде ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Активные доши в текущем периоде ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'Йоги не активированы';

  @override
  String get dashaNoDoshasTriggered => 'Доши не активированы';

  @override
  String get divD1Name => 'Раши (D-1)';

  @override
  String get divD1Desc => 'Физическое существование, все дела';

  @override
  String get divD2Name => 'Хора (D-2)';

  @override
  String get divD2Desc => 'Богатство, деньги';

  @override
  String get divD3Name => 'Дрекана (D-3)';

  @override
  String get divD3Desc => 'Братья и сёстры, смелость';

  @override
  String get divD4Name => 'Чатуртхамша (D-4)';

  @override
  String get divD4Desc => 'Собственность, жилище, удача';

  @override
  String get divD5Name => 'Панчамша (D-5)';

  @override
  String get divD5Desc => 'Слава, власть, могущество';

  @override
  String get divD6Name => 'Шаштхамша (D-6)';

  @override
  String get divD6Desc => 'Проблемы со здоровьем';

  @override
  String get divD7Name => 'Саптамша (D-7)';

  @override
  String get divD7Desc => 'Дети, внуки';

  @override
  String get divD8Name => 'Аштамша (D-8)';

  @override
  String get divD8Desc => 'Внезапные неприятности, тяжбы';

  @override
  String get divD9Name => 'Навамша (D-9)';

  @override
  String get divD9Desc => 'Брак, супруг(а), дхарма';

  @override
  String get divD10Name => 'Дашамша (D-10)';

  @override
  String get divD10Desc => 'Карьера, профессия';

  @override
  String get divD11Name => 'Рудрамша (D-11)';

  @override
  String get divD11Desc => 'Смерть, разрушение';

  @override
  String get divD12Name => 'Двадашамша (D-12)';

  @override
  String get divD12Desc => 'Родители, кровные родственники';

  @override
  String get divD16Name => 'Шодашамша (D-16)';

  @override
  String get divD16Desc => 'Транспорт, удобства, удовольствия';

  @override
  String get divD20Name => 'Вимшамша (D-20)';

  @override
  String get divD20Desc => 'Духовные вопросы, религия';

  @override
  String get divD24Name => 'Чатурвимшамша (D-24)';

  @override
  String get divD24Desc => 'Обучение, знания, образование';

  @override
  String get divD27Name => 'Накшатрамша (D-27)';

  @override
  String get divD27Desc => 'Сильные стороны, слабости, природа';

  @override
  String get divD30Name => 'Тримшамша (D-30)';

  @override
  String get divD30Desc => 'Пороки, подсознание, наказание';

  @override
  String get divD40Name => 'Кхаведамша (D-40)';

  @override
  String get divD40Desc =>
      'Благоприятность/неблагоприятность (по материнской линии)';

  @override
  String get divD45Name => 'Акшаведамша (D-45)';

  @override
  String get divD45Desc => 'Все дела (по отцовской линии)';

  @override
  String get divD60Name => 'Шаштьямша (D-60)';

  @override
  String get divD60Desc => 'Карма прошлой жизни — САМОЕ ВАЖНОЕ';

  @override
  String get lifeAreaCareer => 'Карьера';

  @override
  String get lifeAreaWealth => 'Богатство';

  @override
  String get lifeAreaMarriage => 'Брак';

  @override
  String get lifeAreaHealth => 'Здоровье';

  @override
  String get lifeAreaSpirituality => 'Духовность';

  @override
  String lifeAreaGrade(Object grade) {
    return 'Оценка: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'Факторы:';

  @override
  String planetNakPada(Object nakshatra, Object pada) {
    return 'Накш: $nakshatra ($pada)';
  }

  @override
  String planetNakLord(Object lord) {
    return 'УН: $lord';
  }

  @override
  String planetLongitude(Object value) {
    return 'Долг: $value°';
  }

  @override
  String get chakraOverallHealth => 'Общее здоровье';

  @override
  String get careerWord => 'Карьера';

  @override
  String get failedToLoad => 'Не удалось загрузить';

  @override
  String get kundliAscendantLagna => 'Асцендент (Лагна)';

  @override
  String get kundliMoonSignRashi => 'Знак Луны (Раши)';

  @override
  String get kundliSunSign => 'Знак Солнца';

  @override
  String kundliEngineLabel(Object engine) {
    return 'Движок: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'Градус: $degree°  •  Накшатра: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'Управитель накшатры: $lord  •  Достоинство: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'Карта $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'Карта $base';
  }

  @override
  String get careerSummary => 'Сводка по карьере';

  @override
  String get phase => 'Фаза';

  @override
  String get confidenceLabel => 'Уверенность';

  @override
  String get careerScores => 'Баллы по карьере';

  @override
  String get stabilityLabel => 'Стабильность';

  @override
  String get growthLabel => 'Рост';

  @override
  String get gradeExcellent => 'Отлично';

  @override
  String get gradeGood => 'Хорошо';

  @override
  String get gradeAverage => 'Средне';

  @override
  String get gradeBelowAvg => 'Ниже среднего';

  @override
  String get gradeWeak => 'Слабая';

  @override
  String get careerTypeDomain => 'Карьера и область';

  @override
  String get careerTimeline => 'Хронология карьеры';

  @override
  String dashaLabel(Object dasha) {
    return 'Даша: $dasha';
  }

  @override
  String get improvementSuggestions => 'Предложения по улучшению';

  @override
  String get chartDetails => 'Детали карты';

  @override
  String get keyHousesCareer => 'Ключевые дома (карьера)';

  @override
  String get keyCareerPlanets => 'Ключевые планеты карьеры';

  @override
  String get empty => 'Пусто';

  @override
  String get guna => 'Гуна';

  @override
  String get dasha => 'Даша';

  @override
  String get satwik => 'Саттвик';

  @override
  String get rajasik => 'Раджасик';

  @override
  String get tamasik => 'Тамасик';

  @override
  String get charGroupCorePersonality => 'Основная личность';

  @override
  String get charGroupTrustHonesty => 'Доверие и честность';

  @override
  String get charGroupLoyaltyCommitment => 'Преданность и обязательства';

  @override
  String get charGroupStrategicPrivacy => 'Стратегия и приватность';

  @override
  String get charGroupFinancial => 'Финансовая';

  @override
  String get charGroupAngerConflict => 'Гнев и конфликт';

  @override
  String get charGroupMoralDharmic => 'Нравственность и дхарма';

  @override
  String get charGroupIntellectCommunication => 'Интеллект и общение';

  @override
  String get charGroupEmotionalProfile => 'Эмоциональный профиль';

  @override
  String get charGroupMentalHealth => 'Психическое здоровье';

  @override
  String get charGroupRomantic => 'Романтическое';

  @override
  String get charGroupMarriageFamily => 'Брак и семья';

  @override
  String get charGroupOverallLife => 'Жизнь в целом';

  @override
  String get grahaDrishti => 'Граха-Дришти (аспекты планет)';

  @override
  String get grahaDrishtiSubtitle => 'Кто на кого влияет (%)';

  @override
  String get lagnaAspectsReceived => 'Аспекты, получаемые Лагной';

  @override
  String get rashiDrishti => 'Раши-Дришти (аспекты знаков)';

  @override
  String get shadbalaRupas => 'рупа';

  @override
  String get bhavaHouse1 => 'Личность/Тело';

  @override
  String get bhavaHouse2 => 'Богатство/Семья';

  @override
  String get bhavaHouse3 => 'Братья и сёстры/Смелость';

  @override
  String get bhavaHouse4 => 'Дом/Мать';

  @override
  String get bhavaHouse5 => 'Дети/Интеллект';

  @override
  String get bhavaHouse6 => 'Враги/Здоровье';

  @override
  String get bhavaHouse7 => 'Брак/Партнёр';

  @override
  String get bhavaHouse8 => 'Долговечность';

  @override
  String get bhavaHouse9 => 'Удача/Гуру';

  @override
  String get bhavaHouse10 => 'Карьера/Отец';

  @override
  String get bhavaHouse11 => 'Доходы/Друзья';

  @override
  String get bhavaHouse12 => 'Потери/Мокша';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • Управитель: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Сарва Аштакаварга (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'Всего: $total рекха (среднее по знаку = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'Всего: $total рекха • В натальном знаке: $score';
  }

  @override
  String get today => 'Сегодня';

  @override
  String gocharTransitScores(Object date) {
    return 'Гочар (баллы транзита) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Луна рождения: $sign';
  }

  @override
  String get gocharBest => 'ЛУЧШИЙ';

  @override
  String get gocharWorst => 'ХУДШИЙ';

  @override
  String copiedOpening(Object ai) {
    return 'Скопировано! Открываем $ai...';
  }

  @override
  String get openLink => 'ОТКРЫТЬ ↗';

  @override
  String get discussReportWithAI => 'ОБСУДИТЬ ЭТОТ ОТЧЁТ С ИИ';

  @override
  String get reliabilityHigh => 'Высокая надёжность';

  @override
  String get reliabilityModerate => 'Умеренная надёжность';

  @override
  String get reliabilityLow => 'Ниже — только для ориентира';

  @override
  String get reliabilityGoodEdu => 'Хорошая надёжность · подтверждено по D-24';

  @override
  String get relationshipWord => 'Отношения';

  @override
  String get intelligenceWord => 'Интеллект';

  @override
  String get relationshipIntelligence => 'ИНТЕЛЛЕКТ ОТНОШЕНИЙ';

  @override
  String get typeLabel => 'ТИП';

  @override
  String get trustLabel => 'ДОВЕРИЕ';

  @override
  String get dhokaRisk => 'РИСК ПРЕДАТЕЛЬСТВА';

  @override
  String get powerLabel => 'Власть';

  @override
  String get integrity => 'Честность';

  @override
  String get warmth => 'Теплота';

  @override
  String get trustWord => 'Доверие';

  @override
  String get assertLabel => 'Напористость';

  @override
  String get character => 'Характер';

  @override
  String get love => 'Любовь';

  @override
  String get businessWord => 'Бизнес';

  @override
  String get karmic => 'Кармическая';

  @override
  String get enmityRisk => 'Риск вражды';

  @override
  String get hdrChartProfiles => 'Профили карт';

  @override
  String get hdrPairwiseAnalysis => 'Парный анализ';

  @override
  String get hdrCriticalPatterns => 'Критические паттерны';

  @override
  String get hdrGroupRecommendations => 'Рекомендации для группы';

  @override
  String get sharedPractices => 'ОБЩИЕ ПРАКТИКИ';

  @override
  String get hdrIndividualGuidance => 'Индивидуальные рекомендации';

  @override
  String get growthAreas => 'ОБЛАСТИ РОСТА';

  @override
  String get hdrCoreTheme => 'Основная тема';

  @override
  String get growthOriented => 'ОРИЕНТИРОВАН НА РОСТ';

  @override
  String get groupTheme => 'ТЕМА ГРУППЫ';

  @override
  String get compatibility => 'СОВМЕСТИМОСТЬ';

  @override
  String get unifiedScoreLabel => 'ЕДИНЫЙ БАЛЛ';

  @override
  String get ashtakoot => 'АШТАКУТА';

  @override
  String get probability => 'ВЕРОЯТНОСТЬ';

  @override
  String get hdrAshtakootSummary => 'Сводка Аштакуты';

  @override
  String get hdrGunBreakdown => 'Разбивка по 8 Гунам';

  @override
  String get hdrMangalDosh => 'Мангал-доша';

  @override
  String get hdrD9CrossChart => 'Перекрёстная карта D-9';

  @override
  String get d9Compatibility => 'СОВМЕСТИМОСТЬ ПО D-9';

  @override
  String get hdrDomainCompatibility => 'Совместимость по областям';

  @override
  String get emotional => 'Эмоциональная';

  @override
  String get intellectual => 'Интеллектуальная';

  @override
  String get spiritual => 'Духовная';

  @override
  String get financial => 'Финансовая';

  @override
  String get domestic => 'Бытовое';

  @override
  String get communicationWord => 'Общение';

  @override
  String get sharedDharma => 'Общая дхарма';

  @override
  String get familyCreation => 'Создание семьи';

  @override
  String get hdrMarriageTiming => 'Время для брака';

  @override
  String get jointMarriageWindows => 'Совместные окна брака';

  @override
  String get engagementWindows => 'Окна помолвки';

  @override
  String get recommendedLabel => 'Рекомендовано';

  @override
  String get hdrKeyRisks => 'Ключевые риски';

  @override
  String get hdrFinalVerdict => 'Итоговый вердикт';

  @override
  String get marriageVerdict => 'ВЕРДИКТ О БРАКЕ';

  @override
  String get educationWord => 'Образование';

  @override
  String get learningSuffix => 'и обучение';

  @override
  String get coreEducationScores => 'ОСНОВНЫЕ БАЛЛЫ ОБРАЗОВАНИЯ';

  @override
  String get academicSuccess => 'АКАДЕМИЧЕСКИЙ УСПЕХ';

  @override
  String get learningCapacity => 'СПОСОБНОСТЬ К ОБУЧЕНИЮ';

  @override
  String get memory => 'ПАМЯТЬ';

  @override
  String get intelligence => 'ИНТЕЛЛЕКТ';

  @override
  String get research => 'ИССЛЕДОВАНИЯ';

  @override
  String get hdrIntellectualProfile => 'Интеллектуальный профиль';

  @override
  String get learningSignature => 'СИГНАТУРА ОБУЧЕНИЯ';

  @override
  String get hdrSubjectKaraka => 'Карака предмета';

  @override
  String get hdrHouseFoundations => 'Основы по домам';

  @override
  String get hdrMercuryJupiter => 'Меркурий и Юпитер';

  @override
  String get hdrEducationYogas => 'Йоги образования';

  @override
  String get hdrDivisionalValidation => 'Проверка по дробным картам';

  @override
  String get standing => 'ПОЛОЖЕНИЕ';

  @override
  String get hdrSubjectRanking => 'Ранжирование предметов';

  @override
  String get hdrDegreeLikelihood => 'Вероятность степени';

  @override
  String get hdrStudyPeriods => 'Периоды обучения';

  @override
  String get earlySchooling => 'Раннее школьное обучение';

  @override
  String get higherEducation => 'Высшее образование';

  @override
  String get postgradResearch => 'Аспирантура · Исследования';

  @override
  String get hdrLearningPreferences => 'Предпочтения в обучении';

  @override
  String get hdrChallengesGifts => 'Трудности и дары';

  @override
  String get challenges => 'ТРУДНОСТИ';

  @override
  String get cognitiveGifts => 'КОГНИТИВНЫЕ ДАРЫ';

  @override
  String get naturalAbilities => 'ПРИРОДНЫЕ СПОСОБНОСТИ';

  @override
  String get hdrSaraswatiRemedies => 'Средства Сарасвати';

  @override
  String get studentVerdict => 'ВЕРДИКТ ДЛЯ УЧАЩЕГОСЯ';

  @override
  String get educationCareerLinkage => 'СВЯЗЬ ОБРАЗОВАНИЯ И КАРЬЕРЫ';

  @override
  String get startupSuffix => 'и стартапы';

  @override
  String get coreBusinessScores => 'ОСНОВНЫЕ БАЛЛЫ БИЗНЕСА';

  @override
  String get overallBusiness => 'БИЗНЕС В ЦЕЛОМ';

  @override
  String get ventureSuccess => 'УСПЕХ ПРЕДПРИЯТИЯ';

  @override
  String get eleventhHouse => '11-Й ДОМ';

  @override
  String get gains => 'ДОХОДЫ';

  @override
  String get investor => 'ИНВЕСТОР';

  @override
  String get hdrFounderArchetype => 'Архетип основателя';

  @override
  String get hdrTenthEleventhHouses => '10-й и 11-й дома';

  @override
  String get hdrBusinessYogas => 'Йоги бизнеса';

  @override
  String get hdrRecommendedDomains => 'Рекомендуемые области';

  @override
  String get hdrBusinessStyle => 'Стиль бизнеса';

  @override
  String get hdrFounderSkills => 'Навыки основателя';

  @override
  String get hdrFundingProfile => 'Профиль финансирования';

  @override
  String get recommendedPath => 'РЕКОМЕНДУЕМЫЙ ПУТЬ';

  @override
  String get investorAttract => 'ПРИВЛЕЧЕНИЕ ИНВЕСТОРОВ';

  @override
  String get familyBacking => 'ПОДДЕРЖКА СЕМЬИ';

  @override
  String get hybridViability => 'ЖИЗНЕСПОСОБНОСТЬ ГИБРИДНОЙ МОДЕЛИ';

  @override
  String get launchWindow => 'Окно запуска';

  @override
  String get scaleWindow => 'Окно масштабирования';

  @override
  String get hdrBusinessRisks => 'Риски бизнеса';

  @override
  String get recoveryCapacity => 'СПОСОБНОСТЬ К ВОССТАНОВЛЕНИЮ';

  @override
  String get hdrRemediesSolutions => 'Средства и решения';

  @override
  String get aiConnectionLost => 'Соединение потеряно. Попробуйте ещё раз.';

  @override
  String get aiSomethingWrong => 'Что-то пошло не так';

  @override
  String get aiNoResponse => 'Нет ответа';

  @override
  String get aiConnectionError => 'Ошибка соединения. Попробуйте ещё раз.';

  @override
  String get aiAutoDetect => 'Автоопределение';

  @override
  String aiAutoArrow(String lang) {
    return 'Авто → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'Язык: $lang';
  }

  @override
  String get aiNoBirthCharts => 'Натальные карты не найдены';

  @override
  String get aiCreateChartFirst =>
      'Сначала создайте натальную карту, чтобы общаться с ИИ';

  @override
  String get aiSelectChartBegin =>
      'Выберите натальную карту, чтобы начать анализ';

  @override
  String aiAnalyzingName(String name) {
    return 'Анализируется: $name';
  }

  @override
  String get aiChange => 'Изменить';

  @override
  String get aiAnalyzingChart => 'Анализируем вашу карту...';

  @override
  String get aiAskStarsHint => 'Спросите звёзды о чём угодно...';

  @override
  String get aiSuggestedFollowups => 'Предложенные вопросы';

  @override
  String get aiThinking => 'Думаю...';

  @override
  String get aiThanks => 'Спасибо!';

  @override
  String get aiFeedbackNoted => 'Отзыв принят';

  @override
  String get svcAll => 'Все';

  @override
  String get svcNoServices => 'Нет доступных услуг';

  @override
  String get svcFree => 'БЕСПЛАТНО';

  @override
  String get astroFailedStartCall => 'Не удалось начать звонок';

  @override
  String get astroFailedStartChat => 'Не удалось начать чат';

  @override
  String astroErrorDetail(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get astroExperience => 'Опыт';

  @override
  String get astroSessions => 'Сессии';

  @override
  String get astroMinutes => 'Минуты';

  @override
  String get astroAbout => 'О себе';

  @override
  String get astroLanguages => 'Языки';

  @override
  String get astroRateCard => 'Прайс-лист';

  @override
  String get astroVoice => 'Голос';

  @override
  String astroReviews(int count) {
    return 'Отзывы ($count)';
  }

  @override
  String get astroNoReviews => 'Отзывов пока нет';

  @override
  String get astroAnonymous => 'Аноним';

  @override
  String get forgotPasswordSubtitle =>
      'Введите вашу почту, и мы отправим вам\nссылку для сброса пароля.';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'Отправить ссылку повторно';

  @override
  String get appName => 'Nakshtralogy';

  @override
  String get cosmicJourneyAwaits => 'Ваше космическое путешествие ждёт';

  @override
  String get home => 'Главная';

  @override
  String get astrologers => 'Астрологи';

  @override
  String get services => 'Услуги';

  @override
  String get wallet => 'Кошелёк';

  @override
  String get profile => 'Профиль';

  @override
  String get live => 'Прямой эфир';

  @override
  String get kundli => 'Кундли';

  @override
  String get chat => 'Чат';

  @override
  String get call => 'Звонок';

  @override
  String get video => 'Видео';

  @override
  String get signIn => 'Войти';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get fullName => 'Полное имя';

  @override
  String get phone => 'Телефон';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get sendResetLink => 'Отправить ссылку для сброса';

  @override
  String get backToSignIn => 'Назад ко входу';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get continueGoogle => 'Продолжить с Google';

  @override
  String get required => 'Требуется';

  @override
  String get minSixChars => 'Минимум 6 символов';

  @override
  String get passwordsMismatch => 'Пароли не совпадают';

  @override
  String get validEmailRequired => 'Требуется действительный адрес эл. почты';

  @override
  String get loginFailed => 'Не удалось войти';

  @override
  String get signupFailed => 'Не удалось зарегистрироваться';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get todaysHoroscope => 'СЕГОДНЯШНИЙ ГОРОСКОП';

  @override
  String get todaysRashi => 'Сегодняшняя раши';

  @override
  String get tapDetails => 'Нажмите для деталей';

  @override
  String get allServices => 'Все услуги';

  @override
  String get seeAll => 'СМОТРЕТЬ ВСЕ';

  @override
  String get topAstrologers => 'Лучшие астрологи';

  @override
  String get onlineExperts => 'Онлайн-эксперты готовы к консультации';

  @override
  String get searchAstrologers => 'Поиск астрологов...';

  @override
  String get noAstrologersFound => 'Астрологи не найдены';

  @override
  String get online => 'В сети';

  @override
  String get offline => 'Не в сети';

  @override
  String get busy => 'Занят(а)';

  @override
  String get perMin => '/мин';

  @override
  String get noCharts => 'Натальных карт пока нет';

  @override
  String get createFirst => 'Создайте свою первую Джанам Кундли';

  @override
  String get createChart => 'Создать карту';

  @override
  String get newBirthChart => 'Новая натальная карта';

  @override
  String get clientName => 'Имя клиента';

  @override
  String get gender => 'Пол';

  @override
  String get male => 'Мужской';

  @override
  String get female => 'Женский';

  @override
  String get other => 'Другое';

  @override
  String get dateOfBirth => 'Дата рождения';

  @override
  String get timeOfBirth => 'Время рождения';

  @override
  String get birthPlace => 'Место рождения';

  @override
  String get birthPlaceHint => 'Введите название города для поиска...';

  @override
  String get generateKundli => 'Создать Кундли';

  @override
  String get birthChartCreated => 'Натальная карта создана!';

  @override
  String get deleteChart => 'Удалить карту?';

  @override
  String get cannotUndo => 'Это действие нельзя отменить.';

  @override
  String get primary => 'ОСНОВНАЯ';

  @override
  String get viewKundli => 'Просмотреть Кундли';

  @override
  String get completeBirthChart => 'Полная натальная карта';

  @override
  String get birthDetails => 'Данные рождения';

  @override
  String get name => 'Имя';

  @override
  String get dob => 'Дата рождения';

  @override
  String get tob => 'Время рождения';

  @override
  String get place => 'Место';

  @override
  String get summary => 'Сводка';

  @override
  String get planets => 'Планеты';

  @override
  String get divisions => 'Дробные карты';

  @override
  String get vimshottari => 'Вимшоттари';

  @override
  String get moola => 'Мула';

  @override
  String get gochar => 'Гочар';

  @override
  String get dosh => 'Доша';

  @override
  String get yoga => 'Йога';

  @override
  String get shadbala => 'Шадбала';

  @override
  String get ashtakavarga => 'Аштакаварга';

  @override
  String get aspects => 'Аспекты';

  @override
  String get lifeAreas => 'Сферы жизни';

  @override
  String get bhava => 'Бхава';

  @override
  String get chakras => 'Чакры';

  @override
  String get dashaActive => 'Активные даши';

  @override
  String get lagna => 'Лагна';

  @override
  String get moon => 'Луна';

  @override
  String get sun => 'Солнце';

  @override
  String get premiumSection => 'Премиум-раздел';

  @override
  String get unlockReading =>
      'Откройте это чтение, чтобы увидеть подробный анализ.';

  @override
  String get unlock => 'Открыть';

  @override
  String get retrograde => 'Ретроградная';

  @override
  String get combust => 'Комбустированная';

  @override
  String get vargottama => 'Варготтама';

  @override
  String get exalted => 'В экзальтации';

  @override
  String get debilitated => 'В падении';

  @override
  String get addBalance => 'Пополнить баланс';

  @override
  String get amount => 'Сумма';

  @override
  String get walletBalance => 'Баланс кошелька';

  @override
  String get recharge => 'Пополнение';

  @override
  String get bonus => 'Бонус';

  @override
  String get serviceLabel => 'Служение';

  @override
  String get refund => 'Возврат';

  @override
  String get noTransactions => 'Нет транзакций';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get savedAstrologers => 'Сохранённые астрологи';

  @override
  String get noSavedAstrologers => 'Сохранённых астрологов пока нет';

  @override
  String get myOrders => 'Мои заказы';

  @override
  String get communicationHistory => 'История общения';

  @override
  String get chatHistory => 'История чата';

  @override
  String get callHistory => 'История звонков';

  @override
  String get logout => 'Выйти';

  @override
  String get chatMessages => 'Сообщения чата';

  @override
  String get typeMessage => 'Введите сообщение...';

  @override
  String get sessionEnded => 'Сессия завершена';

  @override
  String get endChat => 'Завершить чат?';

  @override
  String get endChatConfirm =>
      'Вы уверены, что хотите завершить эту сессию чата?';

  @override
  String get sendPhoto => 'Отправить фото';

  @override
  String get sendPDF => 'Отправить PDF';

  @override
  String get upload => 'Загрузить';

  @override
  String get fileNotFound => 'Файл не найден';

  @override
  String get voiceCall => 'Голосовой звонок';

  @override
  String get videoCall => 'Видеозвонок';

  @override
  String get ringing => 'Звоним...';

  @override
  String get connected => 'СОЕДИНЕНО';

  @override
  String get endCall => 'Завершить звонок';

  @override
  String get mute => 'Выключить микрофон';

  @override
  String get unmute => 'Включить микрофон';

  @override
  String get speaker => 'Динамик';

  @override
  String get camera => 'Камера';

  @override
  String get flip => 'Переключить камеру';

  @override
  String get liveStreams => 'Прямые эфиры';

  @override
  String get noLiveStreams => 'Сейчас нет прямых эфиров';

  @override
  String get astrologerUnavailable =>
      'Астролог недоступен. Завершаем трансляцию.';

  @override
  String get streamEnded => 'Трансляция завершена';

  @override
  String get superChat => 'Супер-чат';

  @override
  String get sendGift => 'Отправить подарок';

  @override
  String get goBack => 'Назад';

  @override
  String get appPermissions => 'Разрешения приложения';

  @override
  String get grantPermissions => 'Предоставить разрешения';

  @override
  String get skipForNow => 'Пропустить пока';

  @override
  String get microphone => 'Микрофон';

  @override
  String get notifications => 'Уведомления';

  @override
  String get storage => 'Хранилище';

  @override
  String get ok => 'ОК';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Редактировать';

  @override
  String get delete => 'Удалить';

  @override
  String get retry => 'Повторить';

  @override
  String get send => 'Отправить';

  @override
  String get refresh => 'Обновить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get noData => 'Нет данных';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успешно';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get language => 'Язык';

  @override
  String get english => 'Английский';

  @override
  String get myDetails => 'Мои данные';

  @override
  String get myKundlis => 'Мои Кундли';

  @override
  String get walletRecharge => 'Кошелёк и пополнение';

  @override
  String get consultationHistory => 'История консультаций';

  @override
  String get helpSupport => 'Помощь и поддержка';

  @override
  String get biometricLogin => 'Биометрический вход';

  @override
  String get pastVoiceConsultations => 'Прошлые голосовые консультации';

  @override
  String get pastTextConversations => 'Прошлые текстовые переписки';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get totalCredit => 'Всего зачислено';

  @override
  String get totalDebit => 'Всего списано';

  @override
  String get statement => 'Выписка';

  @override
  String get allTypes => 'Все типы';

  @override
  String get prev => 'Назад';

  @override
  String get next => 'Далее';

  @override
  String get allInsights => 'Все выводы';

  @override
  String get yourCompleteReading => 'ВАШ ПОЛНЫЙ АНАЛИЗ';

  @override
  String get expertEngines => 'экспертных движков';

  @override
  String get eachInsightConsultation =>
      'Каждый вывод — это полноценная консультация';

  @override
  String get engines => 'ДВИЖКИ';

  @override
  String get dataPoints => 'ТОЧКИ ДАННЫХ';

  @override
  String get singleChart => 'ЕДИНОЕ';

  @override
  String get careerPurpose => 'КАРЬЕРА И ЦЕЛЬ';

  @override
  String get wealthAssets => 'БОГАТСТВО И АКТИВЫ';

  @override
  String get loveRelationships => 'ЛЮБОВЬ И ОТНОШЕНИЯ';

  @override
  String get healthWellness => 'ЗДОРОВЬЕ И БЛАГОПОЛУЧИЕ';

  @override
  String get soulKarma => 'ДУША И КАРМА';

  @override
  String get specialistReports => 'Специализированные отчёты';

  @override
  String get searchByNameSpeciality => 'Поиск по имени, специализации...';

  @override
  String get sortedByRating => 'По рейтингу';

  @override
  String get initiatingChat => 'Начинаем чат...';

  @override
  String get startingCall => 'Начинаем звонок...';

  @override
  String get yrs => 'лет';

  @override
  String get chatWithAISpecialist => 'Чат со специалистом ИИ';

  @override
  String get tapToStart => 'Нажмите, чтобы начать';

  @override
  String get astrologer => 'Астролог';

  @override
  String get reports => 'Отчёты';

  @override
  String get milan => 'Милан';

  @override
  String get forecast => 'Прогноз';

  @override
  String get rashi => 'Раши';

  @override
  String get jupiterFavorsBold => 'Юпитер благоприятствует смелым шагам';

  @override
  String get careerIlluminated =>
      'Ваш сектор карьеры освещён — доверьтесь своей интуиции.';

  @override
  String get todaysForecast => 'Прогноз на сегодня';

  @override
  String get engCareer => 'Карьера и работа';

  @override
  String get engBusiness => 'Бизнес и стартапы';

  @override
  String get engEducation => 'Образование и обучение';

  @override
  String get engLifePath => 'Жизненный путь и удача';

  @override
  String get engWealth => 'Богатство и финансы';

  @override
  String get engDebt => 'Долги и восстановление';

  @override
  String get engProperty => 'Собственность и активы';

  @override
  String get engLegal => 'Право и споры';

  @override
  String get engLove => 'Любовь и романтика';

  @override
  String get engMarriage => 'Брак и семья';

  @override
  String get engKundliMilan => 'Кундли-Милан';

  @override
  String get engRelationship => 'Интеллект отношений';

  @override
  String get engLoveCompat => 'Любовная совместимость';

  @override
  String get engChildProb => 'Вероятность рождения детей';

  @override
  String get engHealth => 'Здоровье и благополучие';

  @override
  String get engMental => 'Психика и стресс';

  @override
  String get engCharacter => 'Анализ характера';

  @override
  String get engPastLife => 'Прошлые жизни и карма';

  @override
  String get engKarmaLink => 'Кармическая связь';

  @override
  String get noChatSessions => 'Пока нет сессий чата';

  @override
  String get chatAppearHere =>
      'Ваши беседы с астрологами будут отображаться здесь.';

  @override
  String get noCallsYet => 'Пока нет звонков';

  @override
  String get callAppearHere =>
      'История ваших звонков с астрологами будет отображаться здесь.';

  @override
  String get chatWith => 'Чат с';

  @override
  String get msgs => 'сообщ.';

  @override
  String get voiceCallLabel => 'Голосовой звонок';

  @override
  String get videoCallLabel => 'Видеозвонок';

  @override
  String get pullToRefresh => 'Потяните вниз, чтобы обновить';

  @override
  String get sessionExpired => 'Сессия истекла';

  @override
  String get connectionFailed => 'Не удалось подключиться';

  @override
  String get callActive => 'Звонок активен';

  @override
  String get lessThanOneMin => 'Осталось меньше 1 минуты';

  @override
  String get noMessages => 'В этой сессии нет сообщений';

  @override
  String get gocharForAllSigns => 'Сегодняшний гочар для всех 12 знаков';

  @override
  String get selectChart => 'Выберите карту для анализа';

  @override
  String get selectTwoCharts => 'Выберите две карты';

  @override
  String get analyzing => 'Анализируем...';

  @override
  String get browseAstrologers => 'Смотреть астрологов';

  @override
  String get probableNumber => 'ВЕРОЯТНОЕ ЧИСЛО';

  @override
  String get genderTendency => 'СКЛОННОСТЬ К ПОЛУ';

  @override
  String get son => 'СЫН';

  @override
  String get daughter => 'ДОЧЬ';

  @override
  String get occupants => 'ОБИТАТЕЛИ';

  @override
  String get beneficAspects => 'БЛАГОПРИЯТНЫЕ АСПЕКТЫ';

  @override
  String get maleficAspects => 'НЕБЛАГОПРИЯТНЫЕ АСПЕКТЫ';

  @override
  String get nextFavorableWindow => 'СЛЕДУЮЩЕЕ БЛАГОПРИЯТНОЕ ОКНО';

  @override
  String get totalDoshaPenalty => 'ОБЩИЙ ШТРАФ ЗА ДОШИ';

  @override
  String get cancellationFactors => 'ФАКТОРЫ ОТМЕНЫ';

  @override
  String get combinedFertility => 'СОВМЕЩЁННЫЙ ПОКАЗАТЕЛЬ ФЕРТИЛЬНОСТИ';

  @override
  String get planetPositions => 'ПОЛОЖЕНИЯ ПЛАНЕТ';

  @override
  String get bestWindows => 'ЛУЧШИЕ ОКНА';

  @override
  String get worstWindows => 'ХУДШИЕ ОКНА';

  @override
  String get scoreComponents => 'КОМПОНЕНТЫ БАЛЛА';

  @override
  String get topOpportunities => 'ГЛАВНЫЕ ВОЗМОЖНОСТИ';

  @override
  String get topRisks => 'ГЛАВНЫЕ РИСКИ';

  @override
  String get remedies => 'СРЕДСТВА';

  @override
  String get keyInsights => 'КЛЮЧЕВЫЕ ВЫВОДЫ';

  @override
  String get overallVerdict => 'ОБЩИЙ ВЕРДИКТ';

  @override
  String get venusContacts => 'ПЕРЕКРЁСТНЫЕ КОНТАКТЫ ВЕНЕРЫ';

  @override
  String get contact => 'Контакт';

  @override
  String get effect => 'Эффект';

  @override
  String get moonSignCompat => 'СОВМЕСТИМОСТЬ ЗНАКОВ ЛУНЫ';

  @override
  String get hisMoon => 'ЕГО ЛУНА';

  @override
  String get herMoon => 'ЕЁ ЛУНА';

  @override
  String get nakshatraCompat => 'СОВМЕСТИМОСТЬ НАКШАТР';

  @override
  String get ketuContacts => 'КОНТАКТЫ КЕТУ';

  @override
  String get rahuContacts => 'КОНТАКТЫ РАХУ';

  @override
  String get pastLifeIndication => 'ПОКАЗАТЕЛЬ ПРОШЛОЙ ЖИЗНИ';

  @override
  String get totalChallengePenalty => 'ОБЩИЙ ШТРАФ ЗА СЛОЖНОСТИ';

  @override
  String get manifestation => 'ПРОЯВЛЕНИЕ';

  @override
  String get cancellation => 'ОТМЕНА';

  @override
  String get navigation => 'НАВИГАЦИЯ';

  @override
  String get potentialStrengths => 'ПОТЕНЦИАЛЬНЫЕ СИЛЬНЫЕ СТОРОНЫ';

  @override
  String get areasToNurture => 'ОБЛАСТИ ДЛЯ РАЗВИТИЯ';

  @override
  String get relationshipGuidance => 'РЕКОМЕНДАЦИИ ПО ОТНОШЕНИЯМ';

  @override
  String get detailedSummary => 'ПОДРОБНАЯ СВОДКА';

  @override
  String get discussWithAI => 'ОБСУДИТЬ С ИИ';

  @override
  String get planet => 'Планета';

  @override
  String get sign => 'Знак';

  @override
  String get house => 'Дом';

  @override
  String get strength => 'Сила';

  @override
  String get copy => 'КОПИРОВАТЬ';

  @override
  String get confidence => 'УВЕРЕННОСТЬ';

  @override
  String get d7Saptamsa => 'САПТАМША D7';

  @override
  String get numberExplanation => 'ОБЪЯСНЕНИЕ ЧИСЛА';

  @override
  String get genderExplanation => 'ОБЪЯСНЕНИЕ ПОЛА';

  @override
  String get inFifth => 'В 5-м?';

  @override
  String get primaryArchetype => 'ОСНОВНОЙ АРХЕТИП';

  @override
  String get mitigation => 'СМЯГЧЕНИЕ';

  @override
  String get soulCareerAlign => 'Согласованность души и карьеры';

  @override
  String get favorablePeriods => 'Благоприятные периоды';

  @override
  String get challengingPeriods => 'Сложные периоды';

  @override
  String get keyHouses => 'Ключевые дома';

  @override
  String get keyPlanets => 'Ключевые планеты';

  @override
  String get characterOverview => 'Обзор характера';

  @override
  String get noYogasActive => 'В этой карте сейчас нет активных йог.';

  @override
  String get basedOnPlanetStrengths =>
      'На основе силы планет и положения домов';

  @override
  String get basedOnTransits => 'На основе текущих транзитов планет';

  @override
  String get currentPlanetPositions =>
      'Текущие положения планет с вашим знаком в качестве 1-го дома';

  @override
  String get favorablePeriodAdvice =>
      'Благоприятный период — сосредоточьтесь на карьерном росте и отношениях.';

  @override
  String get noClassicalYogas =>
      'Без классических йог обучения успех приходит через постоянные усилия.';

  @override
  String get walletDeduction => 'Сумма будет списана с вашего кошелька';

  @override
  String get bhakootAxis => 'ОСЬ БХАКУТ';

  @override
  String get basis => 'ОСНОВА';

  @override
  String get selectChartsForMilan => 'Выберите 2 карты для анализа Милан';

  @override
  String get selectMultiCharts => 'Выберите 2–5 карт';

  @override
  String get running => 'ТЕКУЩИЙ';

  @override
  String get past => 'прошлое';

  @override
  String get topActiveDoshas => 'ГЛАВНЫЕ АКТИВНЫЕ ДОШИ';

  @override
  String get allDoshas => 'ВСЕ ДОШИ';

  @override
  String get activeYogas => 'Активные йоги';

  @override
  String get activeDoshas => 'Активные доши';

  @override
  String get yogaAnalysis => 'Анализ йог';

  @override
  String get factors => 'Факторы';

  @override
  String get dominantPlanet => 'Доминирующая планета';

  @override
  String get startSession => 'Начать сессию';

  @override
  String get notesSaved => 'Заметки сохранены';

  @override
  String get unlocked => 'Открыто! Приятного чтения.';

  @override
  String get todaysGochar => 'Сегодняшний гочар';

  @override
  String get todaysTransitChart => 'Сегодняшняя транзитная карта';

  @override
  String get lifeAreaPredictions => 'Прогнозы по сферам жизни';

  @override
  String get strengths => 'Сильные стороны';

  @override
  String get weaknesses => 'Слабости';

  @override
  String get ruledBy => 'Управляется';

  @override
  String get kundliMilan => 'Кундли-Милан';

  @override
  String get startKundliMilan => 'Начать Кундли-Милан';

  @override
  String get recommendations => 'Рекомендации';

  @override
  String get cancellations => 'Отмены';

  @override
  String get dashaSync => 'Синхронизация даш';

  @override
  String get transitMarriageWindows => 'Транзитные окна брака';

  @override
  String get overlappingWindows => 'Пересекающиеся окна брака';

  @override
  String get overallStrength => 'ОБЩАЯ СИЛА';

  @override
  String get stability => 'УСТОЙЧИВОСТЬ';

  @override
  String get growth => 'РОСТ';

  @override
  String get clarity => 'ЯСНОСТЬ';

  @override
  String get recognition => 'ПРИЗНАНИЕ';

  @override
  String get satisfaction => 'УДОВЛЕТВОРЁННОСТЬ';

  @override
  String get verdict => 'ВЕРДИКТ';

  @override
  String get topRoles => 'ГЛАВНЫЕ РОЛИ';

  @override
  String get areasForGrowth => 'ОБЛАСТИ ДЛЯ РОСТА';

  @override
  String get bestIndustries => 'ЛУЧШИЕ ОТРАСЛИ';

  @override
  String get employment => 'Наёмная работа';

  @override
  String get entrepreneurship => 'Предпринимательство';

  @override
  String get freelance => 'Фриланс';

  @override
  String get portfolio => 'Портфолио';

  @override
  String get burnoutRisk => 'Риск выгорания';

  @override
  String get careerStagnation => 'Застой в карьере';

  @override
  String get workplaceConflict => 'Конфликт на работе';

  @override
  String get positioning => 'ПОЗИЦИОНИРОВАНИЕ';

  @override
  String get skillDevelopment => 'РАЗВИТИЕ НАВЫКОВ';

  @override
  String get network => 'СЕТЬ СВЯЗЕЙ';

  @override
  String get visibility => 'ВИДИМОСТЬ';

  @override
  String get lagnaLord => 'Управитель Лагны';

  @override
  String get tenthLord => 'Управитель 10-го дома';

  @override
  String get lord => 'УПРАВИТЕЛЬ';

  @override
  String get lordPlacedIn => 'УПРАВИТЕЛЬ РАСПОЛОЖЕН В';

  @override
  String get lordDignity => 'ДОСТОИНСТВО УПРАВИТЕЛЯ';

  @override
  String get d9Dignity => 'ДОСТОИНСТВО ПО D9';

  @override
  String get careerAnalysis => 'Анализ карьеры';

  @override
  String get launchWindows => 'Окна запуска';

  @override
  String get peakWindows => 'Окна пика';

  @override
  String get promotionWindows => 'Окна повышения';

  @override
  String get riskWindows => 'Окна риска';

  @override
  String get timingWindows => 'Временные окна';

  @override
  String get careerRisks => 'Риски карьеры';

  @override
  String get astrologicalRemedies => 'Астрологические средства';

  @override
  String get practicalSolutions => 'Практические решения';

  @override
  String get analysisConfidence => 'Уверенность анализа';

  @override
  String get careerArchetype => 'Архетип карьеры';

  @override
  String get workStructure => 'Структура работы';

  @override
  String get teamLeadership => 'Лидерство в команде';

  @override
  String get idealEnvironment => 'Идеальная среда';

  @override
  String get idealOrgSize => 'Идеальный размер организации';

  @override
  String get fitScore => 'БАЛЛ СООТВЕТСТВИЯ';

  @override
  String get recommended => 'РЕКОМЕНДОВАНО';

  @override
  String get divisionalValidation => 'Проверка по дробным картам';

  @override
  String get houseAnalysis => 'Анализ домов';

  @override
  String get jaiminiKarakas => 'Караки по Джаймини';

  @override
  String get copyFullReport => 'Скопировать данные полного отчёта';

  @override
  String get reportCopied => 'Данные отчёта скопированы!';

  @override
  String get biometricNotAvailable => 'Биометрия недоступна на этом устройстве';

  @override
  String biometricErrorMsg(Object error) {
    return 'Ошибка биометрии: $error';
  }

  @override
  String get biometricVerifyReason =>
      'Подтвердите, чтобы включить биометрический вход';

  @override
  String get dobFormatLabel => 'Дата рождения (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'Время рождения (HH:MM)';

  @override
  String get phoneLabel => 'Телефон';

  @override
  String get activeBadge => 'АКТИВНО';

  @override
  String get chartCategoryLabel => 'Категория';

  @override
  String get freePrimaryDescription =>
      'Бесплатный основной — используется для ежедневного гороскопа и бесплатных услуг с одной картой';

  @override
  String get searchChartsHint => 'Поиск по имени или дате рождения...';

  @override
  String unlockPriceLabel(Object price) {
    return 'Открыть за $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'Откройте доступ к этому ИИ-специалисту за $price (единоразово), покупка безопасно через магазин приложений.';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'Откройте доступ к этому ИИ-специалисту за $price (единоразово). Сумма будет списана с вашего кошелька.';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'Этот специалист еще не доступен для покупки.';

  @override
  String get couldNotCompletePurchase =>
      'Не удалось завершить покупку. Попробуйте снова.';

  @override
  String get couldNotUnlockWalletBalance =>
      'Не удалось разблокировать (проверьте баланс кошелька)';

  @override
  String get freeBadge => 'БЕСПЛАТНО';

  @override
  String activeSessionInProgress(Object kind) {
    return 'У вас есть активная $kind в процессе';
  }

  @override
  String get returnLabel => 'Вернуться';

  @override
  String get enableNotificationsForAlerts =>
      'Включите уведомления, чтобы получать оповещения о консультациях и предложениях';

  @override
  String get enableLabel => 'Включить';

  @override
  String get notificationsEnabled => 'Уведомления включены';

  @override
  String get couldNotEnableNotifications =>
      'Не удалось включить — разрешите уведомления в браузере';

  @override
  String get amountInrLabel => 'Сумма (₹)';

  @override
  String get noteOptionalLabel => 'Заметка (необязательно)';

  @override
  String get txnDate => 'ДАТА';

  @override
  String get txnDescription => 'ОПИСАНИЕ';

  @override
  String get txnType => 'ТИП';

  @override
  String get txnAmount => 'СУММА';

  @override
  String get txnBalance => 'БАЛАНС';

  @override
  String get credit => 'Пополнение';

  @override
  String get debit => 'Списание';

  @override
  String get razorpayStripeNote =>
      '💳 В production-версии это перенаправит на Razorpay/Stripe.';

  @override
  String get downloadPdf => 'Скачать PDF';

  @override
  String get chatWithAiCta => 'Чат с ИИ';

  @override
  String get pdfServiceUnavailable =>
      'Служба PDF временно недоступна. Попробуйте позже.';

  @override
  String get pleaseUnlockFirst => 'Сначала разблокируйте это.';

  @override
  String get couldNotGeneratePdf => 'Не удалось создать PDF. Попробуйте снова.';

  @override
  String get statConsults => 'КОНСУЛЬТАЦИИ';

  @override
  String get statCharts => 'КАРТЫ';

  @override
  String get statWallet => 'КОШЕЛЁК';

  @override
  String get firstChartPrimaryInfo =>
      'Ваша первая карта — это бесплатная основная карта. Дополнительные карты открывают услуги по отдельности.';

  @override
  String get tryDifferentFilter => 'Попробуйте другой фильтр';

  @override
  String get defaultChartName => 'Карта';

  @override
  String get balAbbr => 'Бал.';

  @override
  String get aiTimePassTitle => 'Выберите время чата';

  @override
  String get aiTimePassHint => 'Оплата из кошелька. Время начинается сейчас — повторная покупка добавляется к оставшемуся времени.';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes мин';
  }

  @override
  String aiTimePassPay(Object price) {
    return 'Оплатить $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return 'Осталось $minutes мин';
  }
}
