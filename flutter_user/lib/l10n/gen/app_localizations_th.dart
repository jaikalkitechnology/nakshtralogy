// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get awChooseLanguage => 'เลือกภาษาของคุณ';

  @override
  String get awGoogleFailed =>
      'เข้าสู่ระบบด้วย Google ไม่สำเร็จ โปรดลองอีกครั้ง';

  @override
  String get awCompleteProfileTitle => 'กรอกโปรไฟล์ของคุณให้สมบูรณ์';

  @override
  String awWelcomeName(String name) {
    return 'ยินดีต้อนรับ $name!';
  }

  @override
  String get awCompleteProfileSubtitle =>
      'ข้อมูลเล็กน้อยเพื่อปรับแต่ง Nakshatralogy ให้เหมาะกับคุณ';

  @override
  String get awRegionLabel => 'ภูมิภาค';

  @override
  String get awRegionIndia => 'อินเดีย';

  @override
  String get awRegionInternational => 'นานาชาติ';

  @override
  String get awPreferredLanguage => 'ภาษาที่ต้องการ';

  @override
  String get awFinishSetup => 'เสร็จสิ้นการตั้งค่า';

  @override
  String get awChatFileWebUnsupported =>
      'ยังไม่รองรับการแชร์ไฟล์บนเว็บ โปรดใช้แอปบนมือถือ';

  @override
  String get awVideoUnsupported =>
      'เบราว์เซอร์นี้ไม่รองรับการโทรวิดีโอ โปรดใช้แอปบนมือถือของเราหรือเบราว์เซอร์เดสก์ท็อปที่รองรับ';

  @override
  String get awClose => 'ปิด';

  @override
  String get pwPremiumTitle => 'รายงานพรีเมียม';

  @override
  String get pwLockedSubtitle =>
      'ปลดล็อกการวิเคราะห์แบบเต็มรูปแบบสำหรับดวงชะตานี้';

  @override
  String pwUnlockFull(Object name) {
    return 'ปลดล็อก $name แบบเต็มรูปแบบ';
  }

  @override
  String pwUnlockPrice(Object price) {
    return 'ปลดล็อก · $price';
  }

  @override
  String get pwOneTime =>
      'ปลดล็อกครั้งเดียว — เป็นของคุณตลอดไปสำหรับดวงชะตานี้';

  @override
  String get pwWhatYouGet => 'สิ่งที่คุณจะได้รับ';

  @override
  String get pwYourBalance => 'ยอดคงเหลือในกระเป๋าเงินของคุณ';

  @override
  String get pwInsufficient => 'ยอดคงเหลือไม่เพียงพอ';

  @override
  String get pwRechargeToUnlock => 'เติมเงินเพื่อปลดล็อก';

  @override
  String get pwRechargeAmount => 'จำนวนเงินที่เติม (₹)';

  @override
  String get pwAddMoney => 'เติมเงิน';

  @override
  String get pwRechargeDone => 'เติมเงินในกระเป๋าเงินสำเร็จ';

  @override
  String get pwRechargeFailed => 'เติมเงินไม่สำเร็จ กรุณาลองอีกครั้ง';

  @override
  String get pwUnlockFailed => 'ไม่สามารถปลดล็อกได้ กรุณาลองอีกครั้ง';

  @override
  String get pwUnlockedNow => 'ปลดล็อกแล้ว! กำลังโหลดรายงานของคุณ…';

  @override
  String get pwProcessing => 'กำลังดำเนินการ…';

  @override
  String get pwPrimaryNoDelete =>
      'Kundli หลักของคุณไม่สามารถลบได้ — ใช้งานฟรีตลอดไป';

  @override
  String get pwPrimaryNoEdit => 'Kundli หลักของคุณไม่สามารถแก้ไขได้';

  @override
  String get pwLoadingAccess => 'กำลังตรวจสอบสิทธิ์การเข้าถึง…';

  @override
  String get pwMaybeLater => 'ไว้ทีหลัง';

  @override
  String get updatePhoto => 'อัปเดตรูปภาพ';

  @override
  String get takePhoto => 'กล้อง';

  @override
  String get chooseFromGallery => 'แกลเลอรี';

  @override
  String get removePhoto => 'ลบรูปภาพ';

  @override
  String get photoUpdated => 'อัปเดตรูปภาพแล้ว';

  @override
  String get photoUploadFailed => 'ไม่สามารถอัปโหลดรูปภาพได้ กรุณาลองอีกครั้ง';

  @override
  String get tapToChangePhoto => 'แตะเพื่อเปลี่ยนรูปภาพ';

  @override
  String get klSubtitle =>
      'รายงานความเชื่อมโยงกรรมชาติที่แล้วเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get klTitle => 'ความเชื่อมโยงกรรมชาติที่แล้ว';

  @override
  String get klSnapshotHeader => 'ภาพรวมความเชื่อมโยงกรรม';

  @override
  String get klGaugePairwise => 'ความเชื่อมโยงเฉลี่ยแบบคู่';

  @override
  String get klGaugeCohesion => 'ความสามัคคีของกลุ่ม';

  @override
  String get klGaugeRahuKetu => 'การสั่นพ้องของ Rahu-Ketu';

  @override
  String get klGaugeAtmakaraka => 'การสั่นพ้องของจิตวิญญาณ';

  @override
  String get klGaugeD60 => 'การสั่นพ้อง D60';

  @override
  String get klChipSoulResonance => 'การสั่นพ้องลายเซ็นจิตวิญญาณที่แข็งแกร่ง';

  @override
  String get klChipD60Resonance => 'การสั่นพ้องชาติที่แล้ว D60 ที่แข็งแกร่ง';

  @override
  String get klChipCohesiveGroup => 'กลุ่มที่มีความสามัคคี';

  @override
  String get klChipNoDebts => 'ไม่พบหนี้กรรม';

  @override
  String get klProfilesTitle => 'โปรไฟล์ดวงชะตา';

  @override
  String get klKetuAt => 'Ketu อยู่ที่';

  @override
  String get klRahuAt => 'Rahu อยู่ที่';

  @override
  String get klFoundationTitle => 'รากฐานกรรมของแต่ละดวงชะตา';

  @override
  String get klFoundationSubtitle =>
      'ความเชี่ยวชาญในชาติที่แล้วและทิศทางชีวิตปัจจุบันของแต่ละดวงวิญญาณ';

  @override
  String get klKetuMastery => 'ความเชี่ยวชาญของ Ketu';

  @override
  String get klRahuGrowth => 'การเติบโตของ Rahu';

  @override
  String get klNinthHousePunya => 'Punya เรือนที่ 9';

  @override
  String get klD60Depth => 'ความลึกของกรรม D60';

  @override
  String get klAtmakarakaAgenda => 'วาระของจิตวิญญาณ';

  @override
  String get klSaturnKarma => 'กรรมของ Saturn';

  @override
  String get klPairwiseTitle => 'ความเชื่อมโยงกรรมแบบคู่';

  @override
  String get klActiveFactors => 'ปัจจัยความเชื่อมโยงที่กำลังทำงาน';

  @override
  String get klGroupPatternTitle => 'รูปแบบกรรมของกลุ่ม';

  @override
  String get klSharedSetting => 'ฉากชาติที่แล้วร่วมกัน';

  @override
  String get klCohesionScore => 'ความสามัคคีทางกรรม';

  @override
  String get klPastGoalsTitle => 'เป้าหมายในชาติที่แล้ว';

  @override
  String get klLearningTitle => 'บทเรียนในชีวิตปัจจุบัน';

  @override
  String get klTeachingMap => 'แผนที่บทเรียนซึ่งกันและกัน';

  @override
  String get klDebtsTitle => 'หนี้กรรมและการคลี่คลาย';

  @override
  String get klNoDebtsDetected => 'ไม่พบหนี้กรรมในกลุ่มนี้';

  @override
  String get klTimingTitle => 'จังหวะเวลากรรมตาม Moola Dasha';

  @override
  String get klAuditTitle => 'ตารางตรวจสอบเชิงลึก';

  @override
  String klAuditSubtitle(Object count) {
    return 'ตรวจสอบพารามิเตอร์กรรม $count รายการ';
  }

  @override
  String get klTopicLinkage => 'ความเชื่อมโยงกรรมโดยรวมของเรา';

  @override
  String get klTopicPairwise => 'พันธะกรรมของคู่ใดคู่หนึ่งโดยเฉพาะ';

  @override
  String get klTopicDebts => 'หนี้กรรมที่ต้องคลี่คลาย';

  @override
  String get klTopicLessons => 'สิ่งที่เรามาเรียนรู้ในชาตินี้';

  @override
  String get klTopicTiming => 'จังหวะเวลาที่ดีที่สุดสำหรับกลุ่มของเรา';

  @override
  String get klTopicGroup => 'เรื่องราวชาติที่แล้วร่วมกันของเรา';

  @override
  String get lcSubtitle =>
      'รายงานความเข้ากันได้ด้านความรักเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get lcTitle => 'ความเข้ากันได้ด้านความรัก';

  @override
  String get lcSnapshotHeader => 'ภาพรวมความเข้ากันได้ด้านความรัก';

  @override
  String get lcGaugeAttraction => 'แรงดึงดูด';

  @override
  String get lcGaugeEmotional => 'ความกลมกลืนทางอารมณ์';

  @override
  String get lcGaugeMental => 'ความเข้าใจทางความคิด';

  @override
  String get lcGaugePassion => 'ความหลงใหล';

  @override
  String get lcGaugeLongterm => 'ความกลมกลืนระยะยาว';

  @override
  String get lcChipStrongMental => 'การเชื่อมโยงทางความคิดที่แข็งแกร่ง';

  @override
  String get lcChipStrongLongterm => 'ศักยภาพระยะยาวที่แข็งแกร่ง';

  @override
  String get lcChipStrongPassion => 'เคมีทางกายภาพที่แข็งแกร่ง';

  @override
  String get lcChipLowFriction => 'ความขัดแย้งโดยรวมต่ำ';

  @override
  String get lcChipKarmicPull => 'แรงดึงดูดทางกรรมที่แข็งแกร่ง';

  @override
  String get lcPartnersTitle => 'ภาพรวมคู่ของคุณ';

  @override
  String get lcVenusSuffix => 'ราศี Venus';

  @override
  String get lcAttractionTitle => 'แรงดึงดูดและเคมี';

  @override
  String get lcAttractionScore => 'คะแนนแรงดึงดูด';

  @override
  String get lcActiveContacts => 'การประสานของ Venus ที่กำลังทำงาน';

  @override
  String get lcEmotionalTitle => 'ความกลมกลืนทางอารมณ์';

  @override
  String get lcEmotionalScore => 'คะแนนความกลมกลืนทางอารมณ์';

  @override
  String get lcNakshatraCompat => 'ความเข้ากันได้ของ Nakshatra';

  @override
  String get lcYoniKoota => 'Yoni Koota';

  @override
  String get lcGanaKoota => 'Gana Koota';

  @override
  String get lcTaraKoota => 'Tara Koota';

  @override
  String get lcBhakootAxis => 'แกน Bhakoot';

  @override
  String get lcMentalTitle => 'ความเข้าใจทางความคิด';

  @override
  String get lcMentalScore => 'คะแนนความเข้าใจทางความคิด';

  @override
  String get lcPassionTitle => 'ความหลงใหลและกายภาพ';

  @override
  String get lcPassionScore => 'คะแนนความหลงใหล';

  @override
  String get lcLongtermTitle => 'ความกลมกลืนระยะยาว';

  @override
  String get lcLongtermScore => 'คะแนนความกลมกลืนระยะยาว';

  @override
  String get lcCommitmentPotential => 'ศักยภาพความมุ่งมั่นผูกพัน';

  @override
  String get lc7thHouseSynastry => 'Synastry เรือนที่ 7';

  @override
  String get lcJupiterBlessing => 'พรจาก Jupiter';

  @override
  String get lcD9Resonance => 'การสั่นพ้อง D9 Navamsa';

  @override
  String get lcSaturnLongevity => 'ความยืนยาวจาก Saturn';

  @override
  String get lcKarmicTitle => 'พันธะรักทางกรรม';

  @override
  String get lcKarmicScore => 'คะแนนพันธะทางกรรม';

  @override
  String get lcKetuContacts => 'การประสานของ Ketu';

  @override
  String get lcRahuContacts => 'การประสานของ Rahu';

  @override
  String get lcChallengesTitle => 'ความท้าทายและความขัดแย้ง';

  @override
  String get lcNoChallenges => 'ไม่พบจุดขัดแย้งที่สำคัญในดวงชะตาทั้งสอง';

  @override
  String get lcTotalPenalty => 'คะแนนหักรวมจากความท้าทาย';

  @override
  String get lcTimingTitle => 'จังหวะเวลาความรัก — Moola Dasha';

  @override
  String get lcDynamicsTitle => 'พลวัตความสัมพันธ์';

  @override
  String get lcPowerBalance => 'สมดุลอำนาจ';

  @override
  String get lcGiverReceiver => 'ผู้ให้/ผู้รับทางอารมณ์';

  @override
  String get lcGrowthDynamic => 'พลวัตการเติบโต';

  @override
  String get lcAreasToNurture => 'ด้านที่ควรบ่มเพาะ';

  @override
  String get lcTopicTiming => 'จังหวะเวลาที่ดีที่สุดสำหรับความสัมพันธ์ของเรา';

  @override
  String get lcTopicChallenges => 'ความท้าทายที่ต้องฝ่าฟัน';

  @override
  String get lcTopicKarmic => 'ความเชื่อมโยงทางกรรมของเรา';

  @override
  String get lcTopicRemedies => 'แนวทางแก้ไขที่แนะนำ';

  @override
  String get lcTopicLongterm => 'ศักยภาพระยะยาวของเรา';

  @override
  String get lcTopicDynamics => 'พลวัตความสัมพันธ์ของเรา';

  @override
  String get cpSubtitle =>
      'รายงานความน่าจะเป็นเรื่องบุตรเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get cpTitle => 'ความน่าจะเป็นเรื่องบุตร';

  @override
  String get cpSnapshotHeader => 'ภาพรวมความน่าจะเป็นเรื่องบุตร';

  @override
  String get cpGauge5thHouse => 'เรือนที่ 5';

  @override
  String get cpGaugeJupiter => 'Jupiter/Putrakaraka';

  @override
  String get cpGaugeD7 => 'D7 Saptamsa';

  @override
  String get cpGaugeSphuta => 'Beeja-Kshetra';

  @override
  String get cpGaugeTiming => 'จังหวะเวลา Dasha';

  @override
  String get cpChipStrongPutrakaraka => 'Putrakaraka (Jupiter) ที่แข็งแกร่ง';

  @override
  String get cpChipLowDoshaPenalty => 'คะแนนหักจาก Dosha ต่ำ';

  @override
  String get cpChipFavorableTiming => 'จังหวะเวลา Dasha ที่เอื้ออำนวย';

  @override
  String get cpChipNoDoshas => 'ไม่พบ Dosha เกี่ยวกับบุตร';

  @override
  String get cpPartnersTitle => 'ภาพรวมคู่ของคุณ';

  @override
  String get cpLagnaSuffix => 'Lagna';

  @override
  String get cpMoonSuffix => 'ราศี Moon';

  @override
  String get cpNumberTitle => 'จำนวนบุตรและแนวโน้มเพศ';

  @override
  String get cpProbableNumber => 'จำนวนที่น่าจะเป็น';

  @override
  String get cpFirstChildTendency => 'แนวโน้มบุตรคนแรก';

  @override
  String get cpSpacing => 'หมายเหตุระยะห่าง';

  @override
  String get cpTimingTitle => 'จังหวะเวลา — Moola Dasha';

  @override
  String get cpCombinedTiming => 'จังหวะเวลารวม';

  @override
  String get cpNextWindow => 'ช่วงเวลาที่เอื้ออำนวยถัดไป';

  @override
  String get cp5thHouseTitle => 'การวิเคราะห์เรือนที่ 5';

  @override
  String get cp5thHouseSubtitle => 'เรือนแห่งบุตร (Putra Bhava) ของแต่ละบุคคล';

  @override
  String get cpJupiterTitle => 'Jupiter — การวิเคราะห์ Putrakaraka';

  @override
  String get cpJupiterSubtitle => 'ตัวแทนธรรมชาติของบุตร ของแต่ละบุคคล';

  @override
  String get cpD7Title => 'การวิเคราะห์ D7 Saptamsa';

  @override
  String get cpD7Subtitle => 'ดวงแบ่งภาคเฉพาะสำหรับบุตร';

  @override
  String get cpD7Strength => 'ความแข็งแกร่งของ D7';

  @override
  String get cpSphutaTitle => 'Beeja และ Kshetra Sphuta';

  @override
  String get cpBeejaSphuta => 'Beeja Sphuta (เมล็ดพันธุ์)';

  @override
  String get cpKshetraSphuta => 'Kshetra Sphuta (ผืนนา)';

  @override
  String get cpDoshaTitle => 'การวิเคราะห์ Dosha';

  @override
  String get cpNoDoshasDetected =>
      'ไม่พบ Dosha ที่เกี่ยวข้องกับบุตรในดวงชะตาทั้งสอง';

  @override
  String get cpRemediesTitle => 'แนวทางแก้ไขที่แนะนำ';

  @override
  String get cpAddresses => 'แก้ไขปัญหา';

  @override
  String get cpTopicTiming => 'จังหวะเวลาที่ดีที่สุดสำหรับการตั้งครรภ์';

  @override
  String get cpTopicNumber => 'เราจะมีบุตรกี่คน';

  @override
  String get cpTopicDosha => 'Dosha ที่ต้องแก้ไข';

  @override
  String get cpTopicRemedies => 'แนวทางแก้ไขที่แนะนำ';

  @override
  String get cpTopicFifthHouse => 'ความแข็งแกร่งเรือนที่ 5 ของเรา';

  @override
  String get cpTopicJupiter => 'บทบาทของ Jupiter ในเรื่องนี้';

  @override
  String get riSubtitle =>
      'รายงานวิเคราะห์ความสัมพันธ์เชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get riTitle => 'วิเคราะห์ความสัมพันธ์';

  @override
  String get riSnapshotHeader => 'ภาพรวมกลุ่ม';

  @override
  String get riGaugeCohesion => 'ความสามัคคีของกลุ่ม';

  @override
  String get riGaugeTrust => 'บรรยากาศความไว้วางใจ';

  @override
  String get riGaugeProductivity => 'ประสิทธิภาพการทำงาน';

  @override
  String get riGaugeCreativity => 'ความคิดสร้างสรรค์';

  @override
  String get riChipNoAlerts => 'ไม่มีการแจ้งเตือนที่สำคัญ';

  @override
  String get riChipStrongCohesion => 'ความสามัคคีของกลุ่มที่แข็งแกร่ง';

  @override
  String get riChipHighTrust => 'บรรยากาศความไว้วางใจสูง';

  @override
  String get riChipNoHiddenEnemy => 'ไม่พบสัญญาณศัตรูแอบแฝง';

  @override
  String get riChipHealthyGroup => 'กลุ่มโดยรวมมีความสมดุลดี';

  @override
  String get riProfilesTitle => 'โปรไฟล์ดวงชะตา';

  @override
  String riProfilesSubtitle(Object count) {
    return '$count คนในกลุ่มนี้';
  }

  @override
  String get riLagnaSuffix => 'Lagna';

  @override
  String get riIntegrity => 'ความซื่อสัตย์';

  @override
  String get riWarmth => 'ความอบอุ่น';

  @override
  String get riTrustworthiness => 'ความน่าไว้วางใจ';

  @override
  String get riAssertiveness => 'ความกล้าแสดงออก';

  @override
  String get riGroupDynamicsTitle => 'ภาพรวมพลวัตของกลุ่ม';

  @override
  String get riMostSupportive => 'ผู้สนับสนุนมากที่สุด';

  @override
  String get riMostChallenged => 'ท้าทายที่สุด';

  @override
  String get riHiddenEnemyAlert => 'ตรวจพบสัญญาณศัตรูแอบแฝง';

  @override
  String get riBestWorstTitle => 'คู่ที่ดีที่สุดและท้าทายที่สุด';

  @override
  String get riBestPair => 'พันธะที่แข็งแกร่งที่สุด';

  @override
  String get riWorstPair => 'ต้องให้ความสนใจ';

  @override
  String get riAlliances => 'พันธมิตรที่เป็นไปได้';

  @override
  String get riConflicts => 'จุดขัดแย้งที่เป็นไปได้';

  @override
  String get riPairwiseTitle => 'การวิเคราะห์แบบคู่';

  @override
  String riPairwiseSubtitle(Object count) {
    return 'วิเคราะห์แล้ว $count คู่';
  }

  @override
  String get riDynamic => 'พลวัต';

  @override
  String get riKarmicLink => 'ความเชื่อมโยงทางกรรม';

  @override
  String get riMutualTrust => 'ความไว้วางใจซึ่งกันและกัน';

  @override
  String get riBetrayalRisk => 'ความเสี่ยงการทรยศ';

  @override
  String get riPowerDistribution => 'การกระจายอำนาจ';

  @override
  String get riPowerHealth => 'สุขภาพสมดุลอำนาจ';

  @override
  String get riCriticalPatternsTitle => 'รูปแบบสำคัญ';

  @override
  String get riGroupRecsTitle => 'คำแนะนำสำหรับกลุ่ม';

  @override
  String get riSharedPractices => 'แนวปฏิบัติร่วมกัน';

  @override
  String get riCommStyle => 'รูปแบบการสื่อสารที่แนะนำ';

  @override
  String get riGrowthFocus => 'จุดเน้นการเติบโตที่แนะนำ';

  @override
  String get riIndividualTitle => 'คำแนะนำรายบุคคล';

  @override
  String get riBestAllies => 'พันธมิตรที่ดีที่สุด';

  @override
  String get riHandleWithCare => 'ควรระมัดระวังเป็นพิเศษ';

  @override
  String get riCoreThemeTitle => 'แก่นเรื่องหลักของกลุ่ม';

  @override
  String get riLayerPairwise => 'ความสมบูรณ์แบบคู่';

  @override
  String get riLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get riLayerD9 => 'Navamsa (D9)';

  @override
  String get riLayerD10 => 'Dashamsa (D10)';

  @override
  String get riLayerD30 => 'Trimshamsa (D30)';

  @override
  String get riLayerJaimini => 'สัญญาณ Jaimini';

  @override
  String get riLayerBehavior => 'ความชัดเจนด้านพฤติกรรม';

  @override
  String get riLayerCoherence => 'ความเชื่อมโยงของกลุ่ม';

  @override
  String get riTopicDynamics => 'พลวัตกลุ่มของเรา';

  @override
  String get riTopicPairwise => 'ความเข้ากันได้ของคู่ใดคู่หนึ่งโดยเฉพาะ';

  @override
  String get riTopicAlerts => 'การแจ้งเตือนที่สำคัญ';

  @override
  String get riTopicGrowth => 'เราจะเติบโตไปด้วยกันได้อย่างไร';

  @override
  String get riTopicRecs => 'แนวปฏิบัติที่แนะนำ';

  @override
  String get riTopicTheme => 'แก่นเรื่องหลักของกลุ่มเรา';

  @override
  String get kmSubtitle => 'รายงาน Kundli Milan เชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get kmTitle => 'Kundli Milan';

  @override
  String get kmSnapshotHeader => 'ภาพรวมความเข้ากันได้';

  @override
  String kmAshtakootScore(Object score) {
    return 'Ashtakoot: $score/36';
  }

  @override
  String get kmGaugeAshtakoot => 'Ashtakoot %';

  @override
  String get kmGaugeD9 => 'กรรมการแต่งงาน D9';

  @override
  String get kmGaugeMangal => 'สมดุล Mangal';

  @override
  String get kmGaugePapa => 'สมดุลทางกรรม';

  @override
  String get kmGaugeAk => 'การสั่นพ้องของจิตวิญญาณ';

  @override
  String get kmChipNoNadi => 'ไม่มี Nadi Dosh';

  @override
  String get kmChipNoBhakoot => 'ไม่มี Bhakoot Dosh';

  @override
  String get kmChipMangalCancelled => 'Mangal Dosh ถูกยกเลิก';

  @override
  String get kmChipPapaBalanced => 'ภาระกรรมสมดุล';

  @override
  String get kmChipStrongChemistry => 'เคมีทางกายภาพที่แข็งแกร่ง';

  @override
  String get kmChipStrongD9 => 'กรรมการแต่งงาน D9 ที่แข็งแกร่ง';

  @override
  String get kmChipLongevity => 'ความสอดคล้องด้านอายุยืนที่แข็งแกร่ง';

  @override
  String get kmAshtakootTitle => 'Ashtakoot Guna Milan';

  @override
  String get kmAshtakootSubtitle =>
      'ระบบจับคู่แบบคลาสสิก 8 ข้อ จากคะแนนเต็ม 36';

  @override
  String get kmNadiSeverity => 'ความรุนแรงของ Nadi';

  @override
  String get kmBhakootSeverity => 'ความรุนแรงของ Bhakoot';

  @override
  String get kmGanaSignature => 'ลายเซ็น Gana';

  @override
  String get kmMangalTitle => 'การตรวจสอบ Mangal Dosha';

  @override
  String get kmD9Title => 'D9 Navamsa — กรรมการแต่งงาน';

  @override
  String get kmD9Subtitle =>
      'ดวงการแต่งงานระดับจิตวิญญาณ ซึ่งถือว่าสำคัญที่สุดตามตำราคลาสสิก';

  @override
  String get kmD9Score => 'ความเข้ากันได้ D9';

  @override
  String get kmLagnaRelation => 'ความสัมพันธ์ของ Lagna';

  @override
  String get km7thLordRelation => 'ความสัมพันธ์ของเจ้าเรือนที่ 7';

  @override
  String get kmKarakasTitle => 'Karaka ของจิตวิญญาณและคู่สมรส';

  @override
  String get kmAtmakaraka => 'ดาวแห่งจิตวิญญาณ (Atmakaraka)';

  @override
  String get kmAkCompatibility => 'การสั่นพ้องลายเซ็นจิตวิญญาณ';

  @override
  String get kmUlCompatibility => 'ความสอดคล้องของ Karaka คู่สมรส';

  @override
  String get kmUlSigns => 'เจ้าเรือน Upapada';

  @override
  String get kmChemistryTitle => 'เคมีระหว่าง Venus-Mars';

  @override
  String get kmPhysicalChemistry => 'เคมีทางกายภาพ';

  @override
  String get kmEmotionalWarmth => 'ความอบอุ่นทางอารมณ์';

  @override
  String get kmAestheticAlignment => 'ความสอดคล้องด้านสุนทรียะ';

  @override
  String get kmElementalSynthesis => 'การผสานธาตุ';

  @override
  String get kmHouseCrossTitle => 'การวิเคราะห์ไขว้เรือนที่ 7 และ 8';

  @override
  String get km78Compatibility => 'ความเข้ากันได้เรือนที่ 7-8';

  @override
  String get km8thHouseSignature => 'ลายเซ็นอายุยืนร่วมกัน';

  @override
  String get kmLongevityAlignment => 'ความสอดคล้องด้านอายุยืน';

  @override
  String get km7thLordFriendship => 'มิตรภาพของเจ้าเรือนที่ 7';

  @override
  String get kmDomainsTitle => 'ความเข้ากันได้แยกตามด้าน';

  @override
  String get kmConflictEngagement => 'รูปแบบการจัดการความขัดแย้ง';

  @override
  String get kmDashaTitle => 'ความสอดคล้องของ Dasha และ Transit';

  @override
  String get kmDashaSync => 'ความสอดคล้องของ Dasha';

  @override
  String get kmTransitAlignment => 'ความสอดคล้องของ Transit';

  @override
  String get kmTimingTitle => 'จังหวะเวลาการแต่งงาน';

  @override
  String get kmMarriageWindow => 'ช่วงเวลาการแต่งงาน';

  @override
  String get kmEngagementWindow => 'ช่วงเวลาการหมั้น';

  @override
  String get kmRecommendedRange => 'ช่วงเวลาที่แนะนำ';

  @override
  String get kmMuhurtaNotes => 'หมายเหตุ Muhurta';

  @override
  String get kmRisksTitle => 'ความเสี่ยงที่ต้องแก้ไข';

  @override
  String get kmConflictRisk => 'ความเสี่ยงความขัดแย้ง';

  @override
  String get kmCommunicationRisk => 'ความเสี่ยงด้านการสื่อสาร';

  @override
  String get kmFinanceRisk => 'ความเสี่ยงความขัดแย้งด้านการเงิน';

  @override
  String get kmFamilyDynamicsRisk => 'ความเสี่ยงพลวัตครอบครัว';

  @override
  String get kmMentalHealthRisk => 'ความเสี่ยงความสอดคล้องด้านสุขภาพจิต';

  @override
  String get kmStrengthsTitle => 'จุดแข็งด้านความเข้ากันได้อันดับต้น';

  @override
  String get kmSharedGrowth => 'ศักยภาพการเติบโตร่วมกัน';

  @override
  String get kmSharedCreative => 'ศักยภาพความคิดสร้างสรรค์ร่วมกัน';

  @override
  String get kmJourneyTitle => 'เส้นทางและการเติบโตของความสัมพันธ์';

  @override
  String get kmCurrentPhase => 'ระยะปัจจุบัน';

  @override
  String get kmEarlyArc => 'ช่วงต้นของการแต่งงาน';

  @override
  String get kmMiddleArc => 'ช่วงกลางของการแต่งงาน';

  @override
  String get kmMatureArc => 'ช่วงการแต่งงานที่มั่นคง';

  @override
  String get kmElderArc => 'ช่วงปีสูงวัย';

  @override
  String get kmPeakPhase => 'ช่วงความเป็นเพื่อนคู่คิดสูงสุด';

  @override
  String get kmGrowthAreas => 'ด้านที่ควรพัฒนา';

  @override
  String get kmCommProtocols => 'แนวทางการสื่อสาร';

  @override
  String get kmSharedPractices => 'แนวปฏิบัติร่วมกัน';

  @override
  String get kmImprovementTitle => 'แก่นเรื่องหลักและแผนการพัฒนา';

  @override
  String get kmVerdictTitle => 'บทสรุปสุดท้าย';

  @override
  String get kmRealizationPotential => 'ศักยภาพความสำเร็จของความสัมพันธ์';

  @override
  String get kmLayerAshtakoot => 'Ashtakoot';

  @override
  String get kmLayerD9 => 'D9 Navamsa';

  @override
  String get kmLayerMangalPapa => 'Mangal และ Papasamya';

  @override
  String get kmLayerVenusMars => 'Venus-Mars';

  @override
  String get kmLayerDashaSync => 'ความสอดคล้องของ Dasha';

  @override
  String get kmLayerH7H8 => 'การไขว้เรือนที่ 7-8';

  @override
  String get kmLayerAkResonance => 'การสั่นพ้องของ Atmakaraka';

  @override
  String get kmLayerDomains => 'มิติด้านต่างๆ';

  @override
  String get kmTopicAshtakoot => 'คะแนน Ashtakoot ของเรา';

  @override
  String get kmTopicMangal => 'ข้อกังวลเกี่ยวกับ Mangal Dosha';

  @override
  String get kmTopicD9 => 'กรรมการแต่งงานของเรา (D9)';

  @override
  String get kmTopicTiming => 'จังหวะเวลาการแต่งงานที่ดีที่สุด';

  @override
  String get kmTopicRisks => 'ความเสี่ยงที่ควรเตรียมรับมือ';

  @override
  String get kmTopicGrowth => 'เราจะเติบโตไปด้วยกันได้อย่างไร';

  @override
  String get kmTopicRemedies => 'แนวทางแก้ไขที่แนะนำ';

  @override
  String get kmTopicVerdict => 'เราควรแต่งงานกันหรือไม่';

  @override
  String get pkSubtitle =>
      'รายงานชาติที่แล้วและกรรมเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get pkTitle => 'ชาติที่แล้วและกรรม';

  @override
  String get pkSnapshotHeader => 'ภาพรวมชาติที่แล้ว';

  @override
  String pkHeroSummary(Object theme, Object relation, Object strategy) {
    return 'ดวงชะตาของคุณแสดงลายเซ็นชาติที่แล้วแบบ \'$theme\' ซึ่งขณะนี้ $relation เข้าสู่ชาตินี้ เส้นทางที่แนะนำ: $strategy';
  }

  @override
  String get pkGaugeSignature => 'ความแข็งแกร่งของลายเซ็น';

  @override
  String get pkGaugeMasteryPreserved => 'ความเชี่ยวชาญที่คงไว้';

  @override
  String get pkGaugeClearingProgress => 'การชำระกรรม';

  @override
  String get pkGaugeMaturity => 'ความเป็นผู้ใหญ่ทางชาติที่แล้ว';

  @override
  String get pkGaugeMemoryAccess => 'การเข้าถึงความทรงจำ';

  @override
  String get pkChipGoodProgress => 'ความคืบหน้าการชำระกรรมที่ดี';

  @override
  String get pkChipLowDebt => 'หนี้กรรมต่ำ';

  @override
  String get pkChipMatureSoul => 'ลายเซ็นจิตวิญญาณที่เป็นผู้ใหญ่';

  @override
  String get pkChipGiftedPast => 'ดวงชะตามีของขวัญจากชาติที่แล้ว';

  @override
  String get pkChipAccomplished => 'ชาติที่แล้วที่ประสบความสำเร็จ';

  @override
  String get pkChipMasteryPreserved => 'ความเชี่ยวชาญที่ส่งต่อมาอย่างแข็งแกร่ง';

  @override
  String get pkKetuTitle => 'Ketu — ความเชี่ยวชาญในอดีตของคุณ';

  @override
  String get pkKetuSubtitle => 'ทักษะที่จิตวิญญาณของคุณเชี่ยวชาญมาแล้ว';

  @override
  String get pkMasteryStrength => 'ความแข็งแกร่งของความเชี่ยวชาญ';

  @override
  String get pkSkillsCarried => 'ทักษะที่ส่งต่อมา';

  @override
  String get pkInstincts => 'สัญชาตญาณโดยกำเนิด';

  @override
  String get pkKetuDignity => 'ศักดิ์ของ Ketu';

  @override
  String get pkRahuTitle => 'Rahu — ขอบเขตการเติบโตของจิตวิญญาณคุณ';

  @override
  String get pkRahuSubtitle => 'สิ่งที่จิตวิญญาณของคุณมาเพื่อทำให้สำเร็จ';

  @override
  String get pkUnmetDesires => 'ความปรารถนาที่ยังไม่สมหวัง';

  @override
  String get pkProfileTitle => 'โปรไฟล์ชาติที่แล้วของคุณ';

  @override
  String get pkProfession => 'อาชีพที่น่าจะเป็น';

  @override
  String get pkSocialStanding => 'สถานะทางสังคม';

  @override
  String get pkRegion => 'ภูมิภาคที่น่าจะเป็น';

  @override
  String get pkCulturalArchetype => 'ต้นแบบทางวัฒนธรรม';

  @override
  String get pkAccomplishment => 'ระดับความสำเร็จ';

  @override
  String get pkAuthority => 'ระดับอำนาจ';

  @override
  String get pkFamilyRole => 'บทบาทในครอบครัว';

  @override
  String get pkSecondaryProfession => 'อาชีพรอง';

  @override
  String get pkClimateAffinity => 'ความชอบเรื่องภูมิอากาศ';

  @override
  String get pkForeignResidence => 'กรรมเรื่องการอาศัยต่างแดน';

  @override
  String get pkRelationshipsTitle => 'ความสัมพันธ์ในอดีตที่ส่งต่อมา';

  @override
  String get pkSpouseConnection => 'การเชื่อมโยงกับคู่สมรสอีกครั้ง';

  @override
  String get pkChildrenConnection => 'การเชื่อมโยงกับบุตรอีกครั้ง';

  @override
  String get pkCarriedRelationTypes => 'รูปแบบความสัมพันธ์';

  @override
  String get pkPartnerArchetype => 'ต้นแบบคู่ครองในชาติที่แล้ว';

  @override
  String get pkDarakaraka => 'Karaka คู่สมรส (Darakaraka)';

  @override
  String get pkParentsKarma => 'รูปแบบกรรมกับบิดามารดา';

  @override
  String get pkSiblingKarma => 'รูปแบบกรรมกับพี่น้อง';

  @override
  String get pkSpiritualTitle => 'ชีวิตทางจิตวิญญาณของคุณในตอนนั้น';

  @override
  String get pkSpiritualLevel => 'ระดับจิตวิญญาณ';

  @override
  String get pkPracticeSignature => 'รูปแบบการปฏิบัติ';

  @override
  String get pkMeditativeCapacity => 'ความสามารถด้านการทำสมาธิ';

  @override
  String get pkDevotionalPractice => 'การปฏิบัติภักติ';

  @override
  String get pkYogicAttainment => 'ความสำเร็จทางโยคะ';

  @override
  String get pkMokshaProximity => 'ความใกล้ Moksha';

  @override
  String get pkKarmicDebtsTitle => 'หนี้กรรมและทรัพย์สินในตอนนั้น';

  @override
  String get pkTotalKarmicDebt => 'หนี้กรรมรวม';

  @override
  String get pkPrimaryDebtType => 'ประเภทหนี้หลัก';

  @override
  String get pkRelationshipDebt => 'หนี้ด้านความสัมพันธ์';

  @override
  String get pkFinancialDebt => 'หนี้ด้านการเงิน';

  @override
  String get pkServiceDebt => 'หนี้ด้านการรับใช้';

  @override
  String get pkDharmicDebt => 'หนี้ด้านธรรมะ';

  @override
  String get pkPitruKarma => 'กรรม Pitru (บรรพบุรุษฝ่ายบิดา)';

  @override
  String get pkMatruKarma => 'กรรม Matru (ฝ่ายมารดา)';

  @override
  String get pkWealthLevel => 'ระดับทรัพย์สินในตอนนั้น';

  @override
  String get pkWealthKarmaCarried => 'กรรมด้านทรัพย์สินที่ส่งต่อมา';

  @override
  String get pkResourcePattern => 'การบริหารทรัพยากร';

  @override
  String get pkGainSource => 'แหล่งที่มาของรายได้';

  @override
  String get pkEchoesTitle => 'เสียงสะท้อนในชาตินี้';

  @override
  String get pkOnRelationships => 'ต่อความสัมพันธ์';

  @override
  String get pkOnCareer => 'ต่ออาชีพการงาน';

  @override
  String get pkOnHealth => 'ต่อสุขภาพ';

  @override
  String get pkOnSpirituality => 'ต่อจิตวิญญาณ';

  @override
  String get pkDominantArea => 'สิ่งที่ส่งต่อมาแข็งแกร่งที่สุด';

  @override
  String get pkAttractions => 'แรงดึงดูดตามธรรมชาติ';

  @override
  String get pkAversions => 'ความรังเกียจตามธรรมชาติ';

  @override
  String get pkUnexplainedFears => 'ความกลัวที่อธิบายไม่ได้';

  @override
  String get pkMagneticPulls => 'แรงดึงดูดที่รุนแรง';

  @override
  String get pkResolutionTitle => 'การคลี่คลายและสำเร็จกรรม';

  @override
  String get pkPrimaryPathway => 'เส้นทางหลัก';

  @override
  String get pkSecondaryPathway => 'เส้นทางรอง';

  @override
  String get pkClearingProgress => 'ความคืบหน้าการชำระกรรม';

  @override
  String get pkRemainingWork => 'งานที่เหลืออยู่';

  @override
  String get pkSettlementTimeline => 'กรอบเวลาการคลี่คลาย';

  @override
  String get pkAccelerationPractices => 'แนวปฏิบัติที่ช่วยเร่งการคลี่คลาย';

  @override
  String get pkPriorityAreas => 'ด้านที่ควรให้ความสำคัญ';

  @override
  String get pkVerificationTitle => 'ยืนยันข้ามดวงชะตา (D60)';

  @override
  String get pkD60Label => 'ยุคชาติที่แล้ว D60';

  @override
  String get pkD60Ketu => 'ตำแหน่ง Ketu ใน D60';

  @override
  String get pkD60Standing => 'สถานะโดยรวม';

  @override
  String get pkMemoryTitle => 'ความทรงจำและสัญชาตญาณ';

  @override
  String get pkMemoryAccess => 'การเข้าถึงความทรงจำ';

  @override
  String get pkRegressionFit => 'ความเหมาะสมกับการบำบัดแบบย้อนอดีต';

  @override
  String get pkDreamVisits => 'การมาเยือนในความฝัน';

  @override
  String get pkDejaVuFrequency => 'ความถี่ของอาการดีจาวู';

  @override
  String get pkSpontaneousRemembrance => 'การระลึกได้เองโดยฉับพลัน';

  @override
  String get pkRemembrancePractices => 'แนวปฏิบัติเพื่อการระลึกชาติ';

  @override
  String get pkTimelineTitle => 'ไทม์ไลน์การกระตุ้น';

  @override
  String get pkGiftsActivation => 'การกระตุ้นของขวัญจากชาติที่แล้ว';

  @override
  String get pkSurfaceWindow => 'ช่วงเวลาที่ปรากฏขึ้น';

  @override
  String get pkRisksTitle => 'ความเสี่ยงและรูปแบบเรื้อรัง';

  @override
  String get pkTraumaResidue => 'ร่องรอยบาดแผลทางใจ';

  @override
  String get pkSpiritualBypass => 'ความเสี่ยงการหลีกเลี่ยงทางจิตวิญญาณ';

  @override
  String get pkMajorRisks => 'ความเสี่ยงหลัก';

  @override
  String get pkChronicImprints => 'รอยประทับเรื้อรัง';

  @override
  String get pkKarmicLoops => 'วงวนของกรรม';

  @override
  String get pkImprovementTitle => 'แผนการพัฒนา';

  @override
  String get pkRoadmapTitle => 'แผนที่นำทางชาติที่แล้วของคุณ';

  @override
  String get pkMaturity => 'ความเป็นผู้ใหญ่ทางชาติที่แล้ว';

  @override
  String get pkLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get pkLayerD9 => 'Navamsa (D9)';

  @override
  String get pkLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get pkLayerKetuDepth => 'ความลึกของ Ketu';

  @override
  String get pkLayerAtmakaraka => 'ดาวแห่งจิตวิญญาณ (Atmakaraka)';

  @override
  String get pkTopicMastery => 'ความเชี่ยวชาญในชาติที่แล้วของฉัน';

  @override
  String get pkTopicUnfinished => 'กรรมที่ยังไม่สำเร็จของฉัน';

  @override
  String get pkTopicRelationships => 'ความสัมพันธ์ในชาติที่แล้วของฉัน';

  @override
  String get pkTopicDebts => 'หนี้กรรมของฉัน';

  @override
  String get pkTopicResolution => 'จะคลี่คลายกรรมของฉันได้อย่างไร';

  @override
  String get pkTopicMemory => 'การเข้าถึงความทรงจำชาติที่แล้ว';

  @override
  String get pkTopicTiming => 'ช่วงเวลาที่ดีที่สุด';

  @override
  String get pkTopicProfile => 'ฉันเป็นใครในชาติที่แล้ว';

  @override
  String get chSubtitle =>
      'รายงานวิเคราะห์บุคลิกภาพเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get chTitle => 'การวิเคราะห์บุคลิกภาพ';

  @override
  String get chSnapshotHeader => 'ภาพรวมบุคลิกภาพ';

  @override
  String get chGaugeIntegrity => 'ความซื่อสัตย์';

  @override
  String get chGaugeResilience => 'ความยืดหยุ่นทางใจ';

  @override
  String get chGaugeSelfAwareness => 'การตระหนักรู้ในตนเอง';

  @override
  String get chGaugeStability => 'ความมั่นคงทางอารมณ์';

  @override
  String get chGaugeMoralFabric => 'รากฐานทางศีลธรรม';

  @override
  String get chChipRajaYoga => 'มี Raja Yoga';

  @override
  String get chChipHighIntegrity => 'ความซื่อสัตย์สูง';

  @override
  String get chChipResilient => 'นิสัยที่ยืดหยุ่นทางใจ';

  @override
  String get chChipDharmic => 'แนวโน้มทางธรรมะที่แข็งแกร่ง';

  @override
  String get chChipEmpathetic => 'มีความเห็นอกเห็นใจโดยธรรมชาติ';

  @override
  String get chChipLoyal => 'ซื่อสัตย์ภักดีอย่างลึกซึ้ง';

  @override
  String get chChipGiftedCharacter => 'ดวงชะตามีพรสวรรค์ด้านบุคลิกภาพ';

  @override
  String get chSoulTitle => 'ลายเซ็นจิตวิญญาณของคุณ';

  @override
  String get chSoulIntegration => 'การผสานจิตวิญญาณกับบุคลิกภาพ';

  @override
  String get chAmatyakarakaTheme => 'เสียงบุคลิกภาพสนับสนุน';

  @override
  String get chAtmakarakaDignity => 'ศักดิ์ของดาวแห่งจิตวิญญาณ';

  @override
  String get chAtmakarakaHouse => 'ตำแหน่งเรือน';

  @override
  String get chSurfaceTitle => 'บุคลิกภาพภายนอกและธาตุเจ้าเรือน';

  @override
  String get chLagnaSign => 'ราศีลัคนา (Ascendant)';

  @override
  String get chConstitution => 'ธาตุเจ้าเรือน';

  @override
  String get chSurfaceSignature => 'ภาพลักษณ์ที่ผู้อื่นมองเห็น';

  @override
  String get chPhysicalConstitution => 'ธาตุร่างกาย';

  @override
  String get chLagnaLord => 'เจ้าเรือนลัคนา';

  @override
  String get chLagnaOccupants => 'ดาวในเรือนลัคนา';

  @override
  String get chMindEmotionsTitle => 'จิตใจ อารมณ์ และอัตตา';

  @override
  String get chEmotionalNature => 'ธรรมชาติทางอารมณ์ของคุณ';

  @override
  String get chMentalStability => 'ความมั่นคงทางจิตใจ';

  @override
  String get chSelfConfidence => 'ความมั่นใจในตนเองที่ดี';

  @override
  String get chEgoNature => 'อัตตาและมโนภาพตนเองของคุณ';

  @override
  String get chAuthorityRelationship => 'ความสัมพันธ์กับผู้มีอำนาจ';

  @override
  String get chPrideTendency => 'แนวโน้มความทะนงตน';

  @override
  String get chMoodPatterns => 'รูปแบบอารมณ์';

  @override
  String get chKemadrumaPresent =>
      'มี Kemadruma Yoga — ควรดูแลสภาพอารมณ์ตนเองเป็นพิเศษ';

  @override
  String get chFatherImprint => 'คุณภาพรอยประทับจากบิดา';

  @override
  String get chCommunicationTitle => 'รูปแบบการสื่อสารและสติปัญญา';

  @override
  String get chIntellectStyle => 'รูปแบบสติปัญญา';

  @override
  String get chCommStyle => 'รูปแบบการสื่อสาร';

  @override
  String get chDecisionStyle => 'รูปแบบการตัดสินใจ';

  @override
  String get chDiscrimination => 'ความสามารถในการแยกแยะ';

  @override
  String get chPersonaTitle => 'ภาพลักษณ์สาธารณะเทียบกับตัวตนที่แท้จริง';

  @override
  String get chAuthenticityGap => 'ช่องว่างความเป็นตัวตนที่แท้จริง';

  @override
  String get chGunaTitle => 'โปรไฟล์ Guna และ Dosha';

  @override
  String get chGunaSubtitle =>
      'ธรรมชาติภายในและธาตุเจ้าเรือนของคุณ ตามแบบเวทคลาสสิก';

  @override
  String get chSattva => 'Sattva';

  @override
  String get chRajas => 'Rajas';

  @override
  String get chTamas => 'Tamas';

  @override
  String get chDominantGuna => 'Guna เด่น';

  @override
  String get chPitta => 'Pitta';

  @override
  String get chKapha => 'Kapha';

  @override
  String get chVata => 'Vata';

  @override
  String get chDominantDosha => 'Dosha เด่น';

  @override
  String get chRahuRestlessness => 'ความกระวนกระวายจาก Rahu';

  @override
  String get chKetuDetachment => 'ความปล่อยวางจาก Ketu';

  @override
  String get chYogasTitle => 'Yoga ด้านบุคลิกภาพ';

  @override
  String get chRajaYogaStrength => 'ความแข็งแกร่งของ Raja Yoga';

  @override
  String get chGiftYogas => 'Yoga แห่งพรสวรรค์';

  @override
  String get chTestYogas => 'Yoga แห่งบททดสอบ';

  @override
  String get chStrengthsTitle => 'จุดแข็งและพรสวรรค์';

  @override
  String get chSignatureVirtues => 'คุณธรรมเด่นประจำตัว';

  @override
  String get chNaturalTalents => 'พรสวรรค์โดยธรรมชาติ';

  @override
  String get chSoftSkills => 'ทักษะทางสังคม (Soft Skills)';

  @override
  String get chHiddenStrengths => 'จุดแข็งที่ซ่อนอยู่ควรพัฒนา';

  @override
  String get chShadowTitle => 'ด้านมืดและด้านที่ควรพัฒนา';

  @override
  String get chShadowSubtitle => 'การตระหนักรู้เบาๆ ถึงรูปแบบที่ควรปรับปรุง';

  @override
  String get chShadowPatterns => 'รูปแบบด้านมืด';

  @override
  String get chBlindSpots => 'จุดบอด';

  @override
  String get chEmotionalWounds => 'บาดแผลทางอารมณ์';

  @override
  String get chShadowWorkPriorities =>
      'สิ่งที่ควรให้ความสำคัญในการทำงานกับด้านมืด';

  @override
  String get chMoralTests => 'บททดสอบทางศีลธรรม';

  @override
  String get chRelationshipsTitle => 'ความสัมพันธ์และรูปแบบทางสังคม';

  @override
  String get chWarmth => 'ความอบอุ่นระหว่างบุคคล';

  @override
  String get chEmpathy => 'ความสามารถด้านความเห็นอกเห็นใจ';

  @override
  String get chLoyalty => 'ความสามารถด้านความภักดี';

  @override
  String get chBoundaries => 'การตั้งขอบเขต';

  @override
  String get chSocialConfidence => 'ความมั่นใจทางสังคม';

  @override
  String get chTrustGiving => 'ระดับพื้นฐานการให้ความไว้วางใจ';

  @override
  String get chConflictStyle => 'รูปแบบการจัดการความขัดแย้ง';

  @override
  String get chEthicsTitle => 'จริยธรรมและเข็มทิศศีลธรรม';

  @override
  String get chDharmaOrientation => 'แนวโน้มทางธรรมะ';

  @override
  String get chTruthfulness => 'ความสัตย์จริง';

  @override
  String get chCompassion => 'ความเมตตา';

  @override
  String get chGenerosity => 'ความเอื้อเฟื้อ';

  @override
  String get chEthicalConsistency => 'ความสม่ำเสมอทางจริยธรรม';

  @override
  String get chIntegrityPressure => 'ความซื่อสัตย์ภายใต้แรงกดดัน';

  @override
  String get chJusticeFairness => 'ความยุติธรรมและความเป็นธรรม';

  @override
  String get chMoralTrajectory => 'พัฒนาการทางศีลธรรม';

  @override
  String get chEiTitle => 'ความฉลาดทางอารมณ์';

  @override
  String get chEiSelfAwareness => 'การตระหนักรู้ในตนเอง';

  @override
  String get chEiSelfRegulation => 'การควบคุมตนเอง';

  @override
  String get chEiEmpathy => 'ความเห็นอกเห็นใจ';

  @override
  String get chEiSocialSkills => 'ทักษะทางสังคม';

  @override
  String get chMotivation => 'แรงจูงใจภายใน';

  @override
  String get chVulnerabilityComfort => 'ความสบายใจกับความเปราะบาง';

  @override
  String get chEmotionalExpression => 'ความสบายใจในการแสดงออกทางอารมณ์';

  @override
  String get chEmotionalReceptivity => 'การเปิดรับทางอารมณ์';

  @override
  String get chVerificationTitle => 'ยืนยันข้ามดวงชะตา (D9/D12/D30/D60)';

  @override
  String get chD9Label => 'D9 ธรรมะ-บุคลิกภาพ';

  @override
  String get chD12Label => 'D12 มรดกจากบรรพบุรุษ';

  @override
  String get chD30Label => 'D30 โปรไฟล์ด้านมืด';

  @override
  String get chD60Label => 'D60 บุคลิกภาพชาติที่แล้ว';

  @override
  String get chD30Standing => 'สถานะด้านมืด';

  @override
  String get chMaternalInheritance => 'มรดกจากฝ่ายมารดา';

  @override
  String get chAncestralKarmaWeight => 'น้ำหนักกรรมบรรพบุรุษ';

  @override
  String get chTimelineTitle => 'ไทม์ไลน์บุคลิกภาพ';

  @override
  String get chFormationWindow => 'ช่วงเวลาการก่อร่างบุคลิกภาพ';

  @override
  String get chMaturationWindow => 'ช่วงเวลาการเติบโตเต็มที่';

  @override
  String get chLegacyWindow => 'ช่วงเวลาแห่งมรดกตกทอด';

  @override
  String get chPeakMaturationAge => 'ช่วงอายุที่เติบโตเต็มที่สูงสุด';

  @override
  String chAgeRangeLabel(Object ageRange) {
    return 'อายุ $ageRange';
  }

  @override
  String get chImprovementTitle => 'แผนการพัฒนา';

  @override
  String get chRoadmapTitle => 'แผนที่นำทางบุคลิกภาพของคุณ';

  @override
  String get chAuthenticExpression => 'การแสดงออกอย่างเป็นตัวของตัวเอง';

  @override
  String get chRealizationPotential => 'ศักยภาพการตระหนักรู้บุคลิกภาพ';

  @override
  String get chLayerAtmakaraka => 'ดาวแห่งจิตวิญญาณ (Atmakaraka)';

  @override
  String get chLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get chLayerD9 => 'Navamsa (D9)';

  @override
  String get chLayerD30 => 'Trimshamsa (D30)';

  @override
  String get chLayerLagnaMoon => 'ลัคนาและ Moon';

  @override
  String get chLayerArudha => 'Arudha Lagna';

  @override
  String get chTopicStrengths => 'จุดแข็งด้านบุคลิกภาพของฉัน';

  @override
  String get chTopicShadow => 'รูปแบบด้านมืดของฉัน';

  @override
  String get chTopicSoul => 'ลายเซ็นจิตวิญญาณของฉัน';

  @override
  String get chTopicRelationships => 'รูปแบบความสัมพันธ์ของฉัน';

  @override
  String get chTopicEthics => 'จริยธรรมและค่านิยมของฉัน';

  @override
  String get chTopicGuna => 'โปรไฟล์ Guna และ Dosha ของฉัน';

  @override
  String get chTopicGrowth => 'จะพัฒนาบุคลิกภาพของฉันได้อย่างไร';

  @override
  String get chTopicTiming => 'จังหวะเวลาที่ดีที่สุดในการพัฒนาบุคลิกภาพ';

  @override
  String get lpSubtitle =>
      'รายงานเส้นทางชีวิตและโชคลาภเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get lpTitle => 'เส้นทางชีวิตและโชคลาภ';

  @override
  String get lpSnapshotHeader => 'ภาพรวมเส้นทางชีวิต';

  @override
  String lpHeroSummary(Object archetype, Object domain, Object probability) {
    return 'คุณคือ $archetype ที่มีเป้าหมายหลักด้าน $domain การวิเคราะห์ของเราแสดงศักยภาพความสำเร็จในชีวิตโดยรวม $probability%';
  }

  @override
  String get lpGaugeDharma => 'ความชัดเจนทางธรรมะ';

  @override
  String get lpGaugeFortune => 'พื้นฐานโชคลาภ';

  @override
  String get lpGaugeCoherence => 'ความสอดคล้องของเส้นทาง';

  @override
  String get lpGaugeFulfillment => 'ความสำเร็จสมหวัง';

  @override
  String get lpGaugeMomentum => 'แรงส่งทางกรรม';

  @override
  String get lpChipRareGift => 'ของขวัญแห่งโชคชะตาที่หายาก';

  @override
  String get lpChipFreeWillStrong => 'เจตจำนงเสรีที่แข็งแกร่ง';

  @override
  String get lpChipGraceSupported => 'ได้รับการสนับสนุนจากพระคุณ';

  @override
  String get lpChipLightKarma => 'ภาระกรรมเบา';

  @override
  String get lpChipRecognitionPotential => 'ศักยภาพการได้รับการยอมรับ';

  @override
  String get lpChipSpiritualPath => 'แรงดึงดูดทางจิตวิญญาณที่แข็งแกร่ง';

  @override
  String get lpChipBlessed => 'ดวงชะตามีพร';

  @override
  String get lpSoulPathTitle => 'เส้นทางจิตวิญญาณของคุณ';

  @override
  String get lpSoulPlanet => 'ดาวแห่งจิตวิญญาณ';

  @override
  String get lpCareerPlanet => 'ดาวแห่งเป้าหมาย';

  @override
  String get lpSoulClarity => 'ความชัดเจนของเป้าหมาย';

  @override
  String get lpLifeChapter => 'บทปัจจุบันของชีวิต';

  @override
  String get lpPrimaryDomain => 'ด้านเป้าหมายหลัก';

  @override
  String get lpKarakaTitle => 'ดาวแห่งธรรมะของคุณ';

  @override
  String get lpKarakaSubtitle =>
      'แต่ละดาวสนับสนุนเป้าหมายชีวิตของคุณมากน้อยเพียงใด';

  @override
  String get lpVerificationTitle => 'ยืนยันข้ามดวงชะตา (D9 / D60)';

  @override
  String get lpD9Label => 'D9 ความสอดคล้องของจิตวิญญาณ';

  @override
  String lpD9Explain(Object stage) {
    return 'ระยะวิวัฒนาการจิตวิญญาณของคุณคือ \'$stage\' ในดวง Navamsa';
  }

  @override
  String get lpD9JupiterDignity => 'ศักดิ์ของ Jupiter';

  @override
  String get lpD9DharmaMultiplier => 'ตัวคูณธรรมะ';

  @override
  String get lpD60Label => 'D60 ลายเซ็นชาติที่แล้ว';

  @override
  String get lpKarmaType => 'ประเภทกรรมชาติที่แล้ว';

  @override
  String get lpKetuMastery => 'ความเชี่ยวชาญชาติที่แล้วของ Ketu';

  @override
  String get lpRahuGrowthDir => 'ทิศทางการเติบโตของ Rahu';

  @override
  String get lpYogasTitle => 'Yoga แห่งโชคลาภและอุปสรรคดวงชะตา';

  @override
  String get lpFortuneBoost => 'ตัวเสริมโชคลาภ';

  @override
  String get lpLuckDrain => 'ตัวลดทอนโชคลาภ';

  @override
  String get lpFortuneBoosters => 'ปัจจัยเสริมโชคลาภ';

  @override
  String get lpLuckBlocks => 'อุปสรรคดวงชะตา';

  @override
  String get lpPurposeTitle => 'ด้านเป้าหมายและชื่อเสียง';

  @override
  String get lpDomainLeadership => 'ความเป็นผู้นำ';

  @override
  String get lpDomainWisdom => 'ปัญญาและการสอน';

  @override
  String get lpDomainService => 'การรับใช้';

  @override
  String get lpDomainHealing => 'การเยียวยา';

  @override
  String get lpDomainCreative => 'การแสดงออกเชิงสร้างสรรค์';

  @override
  String get lpPrimaryDomainBadge => 'หลัก';

  @override
  String get lpFameRecognition => 'ชื่อเสียงและการยอมรับ';

  @override
  String get lpSocialInfluence => 'อิทธิพลทางสังคม';

  @override
  String get lpRecognitionDomain => 'สาขาที่ได้รับการยอมรับ';

  @override
  String get lpPublicImage => 'ภาพลักษณ์สาธารณะ';

  @override
  String get lpHistoricalImpact => 'ศักยภาพผลกระทบทางประวัติศาสตร์';

  @override
  String get lpTimelineTitle => 'ไทม์ไลน์โชคลาภและชีวิต';

  @override
  String get lpCurrentPhase => 'ระยะโชคลาภปัจจุบัน';

  @override
  String get lpJupiterReturn => 'Jupiter Return';

  @override
  String get lpSaturnReturn => 'Saturn Return';

  @override
  String get lpSadeSati => 'Sade Sati';

  @override
  String get lpGoldenWindow => 'ช่วงเวลาทอง';

  @override
  String get lpTransformationWindow => 'ช่วงเวลาแห่งการเปลี่ยนแปลง';

  @override
  String get lpPeakYears => 'ปีแห่งโชคลาภสูงสุด';

  @override
  String get lpChallengingYears => 'ปีที่ท้าทาย';

  @override
  String get lpMilestonesTitle => 'จุดหมายสำคัญและจุดเปลี่ยนของชีวิต';

  @override
  String get lpFirstTurningPoint => 'จุดเปลี่ยนสำคัญครั้งแรก';

  @override
  String get lpMidlifeTransform => 'การเปลี่ยนแปลงช่วงกลางชีวิต';

  @override
  String get lpLateLifeFulfillment => 'ความสำเร็จสมหวังในบั้นปลายชีวิต';

  @override
  String lpDharmicMilestone(Object age) {
    return 'จุดหมายทางธรรมะ (อายุ $age)';
  }

  @override
  String lpAgeLabel(Object age) {
    return 'อายุ $age';
  }

  @override
  String get lpDestinyTitle => 'โชคชะตากับเจตจำนงเสรี';

  @override
  String get lpDestinyStat => 'น้ำหนักโชคชะตา';

  @override
  String get lpFreeWillStat => 'แรงขับเจตจำนงเสรี';

  @override
  String get lpFateStrength => 'ความแข็งแกร่งของลายเซ็นโชคชะตา';

  @override
  String get lpSelfCreation => 'ความสามารถในการสร้างตนเอง';

  @override
  String get lpEffortGrace => 'ความพยายามกับพระคุณ';

  @override
  String get lpKarmicTitle => 'บทเรียนทางกรรม';

  @override
  String get lpRahuGrowthLabel => 'Rahu — ความท้าทายด้านการเติบโต';

  @override
  String get lpKetuSurrenderLabel => 'Ketu — แก่นเรื่องการปล่อยวาง';

  @override
  String get lpSaturnLessonLabel => 'Saturn — บทเรียนแห่งวินัย';

  @override
  String get lpTestDifficulty => 'ระดับความยากของบททดสอบชีวิต';

  @override
  String get lpLessonsInProgress => 'บทเรียนที่กำลังดำเนินอยู่';

  @override
  String get lpSoulContract => 'ด้านสัญญาจิตวิญญาณ';

  @override
  String get lpSoulExperience => 'สิ่งที่จิตวิญญาณของคุณมาเพื่อสัมผัส';

  @override
  String get lpSoulMastery => 'สิ่งที่จิตวิญญาณของคุณมาเพื่อเชี่ยวชาญ';

  @override
  String get lpSpiritualTitle => 'เส้นทางจิตวิญญาณ';

  @override
  String get lpSpiritualInclination => 'แนวโน้มทางจิตวิญญาณ';

  @override
  String get lpMeditationReceptivity => 'ความพร้อมรับการทำสมาธิ';

  @override
  String get lpTeacherKarma => 'กรรมกับครู/คุรุ';

  @override
  String get lpPilgrimageBenefit => 'ประโยชน์จากการแสวงบุญ';

  @override
  String get lpSelfRealization => 'ศักยภาพการรู้แจ้งในตนเอง';

  @override
  String get lpDivineConnection => 'การเชื่อมโยงกับสิ่งศักดิ์สิทธิ์';

  @override
  String get lpTraditionAffinity => 'ความผูกพันกับประเพณี';

  @override
  String get lpIntuitionStrength => 'ความแข็งแกร่งของสัญชาตญาณ';

  @override
  String get lpMantraEfficacy => 'ประสิทธิภาพของการสวดมนต์/มนตร์';

  @override
  String get lpInnerGuidance => 'ความไว้วางใจในสัญชาตญาณภายใน';

  @override
  String get lpPropheticDreams => 'ความไวต่อความฝันเชิงทำนาย';

  @override
  String get lpDifficultyTitle => 'ความยากลำบากและความท้าทายในชีวิต';

  @override
  String get lpEarlyLife => 'ช่วงต้นของชีวิต';

  @override
  String get lpMidlife => 'ช่วงกลางของชีวิต';

  @override
  String get lpLateLife => 'ช่วงปลายของชีวิต';

  @override
  String get lpStruggleToSuccess => 'กรรมจากความยากลำบากสู่ความสำเร็จ';

  @override
  String get lpUnlivedLifeRisk => 'ความเสี่ยงชีวิตที่ยังไม่ได้ใช้อย่างเต็มที่';

  @override
  String get lpChallenges => 'ความท้าทายในชีวิต';

  @override
  String get lpFortuneDrains => 'ปัจจัยบั่นทอนโชคลาภเรื้อรัง';

  @override
  String get lpRegretAreas => 'ด้านที่เสี่ยงต่อความเสียใจ';

  @override
  String get lpRedFlags => 'สัญญาณเตือนด้านทิศทาง';

  @override
  String get lpBlessingsTitle => 'พรและแก่นเรื่องหลักของชีวิต';

  @override
  String get lpKarmicRoot => 'รากฐานทางกรรม';

  @override
  String get lpBlessingsList => 'พรของคุณ';

  @override
  String get lpFulfillmentPriorities =>
      'สิ่งที่ควรให้ความสำคัญเพื่อความสำเร็จสมหวัง';

  @override
  String get lpImprovementTitle => 'แผนการพัฒนา';

  @override
  String get lpDharmaPriorities => 'สิ่งที่ควรให้ความสำคัญด้านธรรมะ';

  @override
  String get lpRoadmapTitle => 'แผนที่นำทางโชคชะตาของคุณ';

  @override
  String get lpStrategy => 'กลยุทธ์';

  @override
  String get lpFulfillmentPotential => 'ศักยภาพความสำเร็จสมหวัง';

  @override
  String get lpNext12Focus => 'จุดเน้นใน 12 เดือนข้างหน้า';

  @override
  String get lpLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get lpLayerD9 => 'Navamsa (D9)';

  @override
  String get lpLayerD60 => 'Shashtiamsa (D60)';

  @override
  String get lpLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get lpLayerTransit => 'การโคจรผ่านปัจจุบัน (Transit)';

  @override
  String get lpTopicPurpose => 'เป้าหมายชีวิตของฉัน';

  @override
  String get lpTopicFortune => 'Yoga แห่งโชคลาภของฉัน';

  @override
  String get lpTopicKarma => 'บทเรียนทางกรรมของฉัน';

  @override
  String get lpTopicMilestones => 'จุดหมายสำคัญที่กำลังจะมาถึง';

  @override
  String get lpTopicDestiny => 'โชคชะตากับเจตจำนงเสรี';

  @override
  String get lpTopicSpiritual => 'เส้นทางจิตวิญญาณของฉัน';

  @override
  String get lpTopicChallenges => 'ความท้าทายในชีวิตของฉัน';

  @override
  String get lpTopicTiming => 'ช่วงเวลาที่ดีที่สุด';

  @override
  String get dbSubtitle =>
      'รายงานหนี้สินและการฟื้นตัวเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get dbTitle => 'หนี้สินและการฟื้นตัว';

  @override
  String get dbSnapshotHeader => 'ภาพรวมการฟื้นตัวจากหนี้สิน';

  @override
  String dbHeroSummary(
    Object phase,
    Object personality,
    Object probability,
    Object years,
  ) {
    return 'ขณะนี้คุณอยู่ในระยะ \'$phase\' ด้วยแนวทางการจัดการเงินแบบ $personality การวิเคราะห์ของเราแสดงโอกาส $probability% ที่จะปลดหนี้ได้ภายในประมาณ $years ปี';
  }

  @override
  String get dbGaugeCapacity => 'ศักยภาพการฟื้นตัว';

  @override
  String get dbGaugeProbability => 'โอกาสการฟื้นตัว';

  @override
  String get dbGaugeFreedomNow => 'ความเป็นอิสระจากหนี้ในปัจจุบัน';

  @override
  String get dbGaugeDti => 'สุขภาพรายได้';

  @override
  String get dbGaugeResilience => 'ความยืดหยุ่นทางใจ';

  @override
  String get dbChipCleanKarma => 'กรรมด้านหนี้สินที่ดี';

  @override
  String get dbChipStrongRecovery => 'ศักยภาพการฟื้นตัวที่แข็งแกร่ง';

  @override
  String get dbChipHealthyDti => 'สัดส่วนหนี้สินต่อรายได้ที่ดี';

  @override
  String get dbChipResilient => 'ความยืดหยุ่นทางจิตใจสูง';

  @override
  String get dbChipCycleBreakable => 'วงจรหนี้สามารถทำลายได้';

  @override
  String get dbChipLowReindebt => 'ความเสี่ยงกลับไปเป็นหนี้ซ้ำต่ำ';

  @override
  String get dbChipGoodNegotiator => 'โอกาสเจรจาต่อรองที่ดี';

  @override
  String get dbProfileTitle => 'โปรไฟล์หนี้สินของคุณ';

  @override
  String get dbPhaseLabel => 'ระยะปัจจุบัน';

  @override
  String get dbPrimaryCategoryLabel => 'หมวดหมู่หลัก';

  @override
  String get dbKarakaLabel => 'Karaka แห่งหนี้สิน';

  @override
  String get dbProtectorLabel => 'การป้องกันจากเจ้าหนี้';

  @override
  String get dbSecondaryCategories => 'หมวดหมู่รอง';

  @override
  String get dbUnsecuredRatio => 'สัดส่วนหนี้ไม่มีหลักประกัน';

  @override
  String get dbKarakaTitle => 'ดาวแห่งหนี้สินของคุณ';

  @override
  String get dbKarakaSubtitle =>
      'แต่ละดาวสนับสนุนการฟื้นตัวจากหนี้สินของคุณมากน้อยเพียงใด';

  @override
  String get dbVerificationTitle => 'ยืนยันข้ามดวงชะตา (D6)';

  @override
  String get dbD6Label => 'ดวง D6 หนี้สินและศัตรู';

  @override
  String get dbD6LordDignity => 'ความแข็งแกร่งของเจ้าเรือนที่ 6';

  @override
  String get dbD6Severity => 'ความรุนแรงของกรรมหนี้สิน';

  @override
  String get dbD6Multiplier => 'ตัวคูณหนี้สิน D6';

  @override
  String get dbYogasTitle => 'Yoga หนี้สินและการป้องกัน';

  @override
  String get dbPressureNow => 'แรงกดดันหนี้สินในปัจจุบัน';

  @override
  String get dbRecoveryBoost => 'ตัวเสริมการฟื้นตัว';

  @override
  String get dbClearingLabel => 'Yoga แห่งการปลดหนี้';

  @override
  String get dbCreatingLabel => 'Yoga แห่งการก่อหนี้';

  @override
  String get dbCategoriesTitle => 'หมวดหมู่หนี้สินที่ควรจับตา';

  @override
  String get dbCategoriesSubtitle =>
      'หนี้สินประเภทใดที่ต้องให้ความสนใจมากที่สุด';

  @override
  String get dbTimelineTitle => 'ไทม์ไลน์สู่การปลอดหนี้';

  @override
  String get dbFreeWindowLabel => 'ช่วงเวลาปลอดหนี้';

  @override
  String get dbClearanceEstimate => 'ประมาณการปลดหนี้เต็มจำนวน';

  @override
  String get dbPeakYears => 'ปีที่หนี้สินสูงสุด';

  @override
  String get dbClearanceYears => 'ปีแห่งการปลดหนี้';

  @override
  String get dbBorrowTitle => 'แนวทางการกู้ยืมอย่างชาญฉลาด';

  @override
  String get dbLoanSuitability => 'ความเหมาะสมในการกู้ยืม';

  @override
  String get dbBestLoanType => 'ประเภทเงินกู้ที่เหมาะสมที่สุด';

  @override
  String get dbLeverageCeiling => 'เพดานการก่อหนี้';

  @override
  String get dbNegotiationSuccess => 'ความสำเร็จในการเจรจาต่อรอง';

  @override
  String get dbCreditorAggression => 'ความเสี่ยงแรงกดดันจากเจ้าหนี้';

  @override
  String get dbLegalEscalation => 'ความเสี่ยงการดำเนินคดีทางกฎหมาย';

  @override
  String get dbNegotiationApproach => 'แนวทางที่แนะนำ';

  @override
  String get dbAvoidLoanTypes => 'ประเภทเงินกู้ที่ควรหลีกเลี่ยง';

  @override
  String get dbRiskTitle => 'การจับตาความเสี่ยงและจุดเปราะบาง';

  @override
  String get dbRiskDefault => 'ความเสี่ยงผิดนัดชำระหนี้';

  @override
  String get dbRiskDefaultExp =>
      'โอกาสที่จะพลาดการชำระหนี้ตามกำหนดจนถูกจัดเป็นสถานะผิดนัดชำระกับผู้ให้กู้';

  @override
  String get dbRiskDefaultFix =>
      'ตั้งระบบชำระขั้นต่ำอัตโนมัติและสำรองเงินไว้ 1 เดือน เพื่อไม่ให้รายได้ที่ขาดหายไปหนึ่งรอบส่งผลกระทบต่อเนื่อง';

  @override
  String get dbRiskBankruptcy => 'ความเสี่ยงล้มละลาย';

  @override
  String get dbRiskBankruptcyExp =>
      'ความน่าจะเป็นที่ภาระหนี้สินจะเพิ่มขึ้นเกินกว่าที่รายได้และทรัพย์สินจะรองรับได้จริง';

  @override
  String get dbRiskBankruptcyFix =>
      'ขอคำปรึกษาจากผู้เชี่ยวชาญด้านหนี้สินก่อนกู้เงินหรือขอวงเงินสินเชื่อใหม่';

  @override
  String get dbRiskAssetSeizure => 'ความเสี่ยงถูกยึดทรัพย์สิน';

  @override
  String get dbRiskAssetSeizureExp =>
      'โอกาสที่การผิดนัดชำระเงินกู้แบบมีหลักประกันจะนำไปสู่การยึดหลักประกันหรือทรัพย์สินโดยผู้ให้กู้';

  @override
  String get dbRiskAssetSeizureFix =>
      'ให้ความสำคัญกับการชำระเงินกู้แบบมีหลักประกันเป็นอันดับแรก และรีไฟแนนซ์แต่เนิ่นๆ หากมีแนวโน้มจะขาดการชำระ';

  @override
  String get dbRiskChronic => 'ความเสี่ยงกลับไปเป็นหนี้ซ้ำเรื้อรัง';

  @override
  String get dbRiskChronicExp =>
      'แนวโน้มที่จะกลับไปเป็นหนี้อีกครั้งแม้จะปลดหนี้ปัจจุบันได้แล้ว';

  @override
  String get dbRiskChronicFix =>
      'สร้างกองทุนฉุกเฉินไว้ก่อนที่จะเพิ่มการใช้จ่ายเพื่อไลฟ์สไตล์หลังปลดหนี้';

  @override
  String get dbReindebtTrigger => 'ตัวกระตุ้นการกลับไปเป็นหนี้';

  @override
  String get dbCycleBreakFeasibility => 'ความเป็นไปได้ในการทำลายวงจรหนี้';

  @override
  String get dbMajorRisks => 'ความเสี่ยงหลัก';

  @override
  String get dbHiddenSignals => 'สัญญาณหนี้สินที่ซ่อนอยู่';

  @override
  String get dbCrisisTitle => 'การเตรียมพร้อมรับมือวิกฤต';

  @override
  String get dbCrisisSubtitle =>
      'วิธีสังเกตปัญหาแต่เนิ่นๆ และตอบสนองอย่างมีสติ';

  @override
  String get dbWarningSigns => 'สัญญาณเตือนล่วงหน้า';

  @override
  String get dbMitigationActions => 'สิ่งที่ควรทำเพื่อรับมือ';

  @override
  String get dbFamilyTitle => 'หนี้สินครอบครัวและบรรพบุรุษ';

  @override
  String get dbInheritedDebtProb => 'โอกาสได้รับหนี้สินตกทอด';

  @override
  String get dbFamilyDrag => 'แรงฉุดจากหนี้สินครอบครัว';

  @override
  String get dbInheritedSource => 'แหล่งที่มาที่น่าจะเป็น';

  @override
  String get dbCoreBlockerLabel => 'อุปสรรคหลัก';

  @override
  String get dbPsychologyTitle => 'จิตวิทยาการเงินของคุณ';

  @override
  String get dbResilience => 'ความยืดหยุ่นทางใจ';

  @override
  String get dbDiscipline => 'วินัยภายใต้แรงกดดัน';

  @override
  String get dbSocialSupport => 'แรงสนับสนุนทางสังคม';

  @override
  String get dbDepressionRisk => 'ความเปราะบางต่อความเครียดทางการเงิน';

  @override
  String get dbStressTolerance => 'ความทนทานต่อความเครียด';

  @override
  String get dbRootCause => 'สาเหตุพฤติกรรมเชิงลึก';

  @override
  String get dbImprovementTitle => 'แผนการพัฒนา';

  @override
  String get dbRoadmapTitle => 'แผนที่นำทางสู่การปลอดหนี้ของคุณ';

  @override
  String get dbRecoveryProbability => 'ความน่าจะเป็นในการฟื้นตัว';

  @override
  String get dbClearanceTimeline => 'ไทม์ไลน์การปลดหนี้';

  @override
  String get dbYears => 'ปี';

  @override
  String get dbDtiHealth => 'สุขภาพสัดส่วนหนี้สินต่อรายได้';

  @override
  String get dbDtiCategory => 'หมวดหมู่ DTI';

  @override
  String get dbBreakEvenMonths => 'จำนวนเดือนถึงจุดคุ้มทุน';

  @override
  String get dbIncomeAcceleration => 'การเติบโตของรายได้ที่จำเป็น';

  @override
  String get dbLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get dbLayerD6 => 'หนี้สินและศัตรู (D6)';

  @override
  String get dbLayerD9 => 'Navamsa (D9)';

  @override
  String get dbLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get dbLayerTransit => 'การโคจรผ่านปัจจุบัน (Transit)';

  @override
  String get dbTopicRecovery => 'ไทม์ไลน์การฟื้นตัวของฉัน';

  @override
  String get dbTopicNegotiate => 'การเจรจากับเจ้าหนี้';

  @override
  String get dbTopicBorrowing => 'ตอนนี้ปลอดภัยที่จะกู้ยืมหรือไม่';

  @override
  String get dbTopicCrisis => 'การเตรียมพร้อมรับมือวิกฤต';

  @override
  String get dbTopicAncestral => 'กรรมหนี้สินจากบรรพบุรุษ';

  @override
  String get dbTopicTimeline => 'ปีที่ดีที่สุดในการปลดหนี้';

  @override
  String get dbTopicPsychology => 'จิตวิทยาการเงินของฉัน';

  @override
  String get dbTopicCategories => 'หนี้สินใดที่ควรให้ความสำคัญก่อน';

  @override
  String get mnSubtitle => 'รายงานสุขภาวะเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get mnTitle => 'จิตใจและความเครียด';

  @override
  String get mnSnapshotHeader => 'ภาพรวมสุขภาวะ';

  @override
  String get mnResilience => 'ความยืดหยุ่นทางใจ';

  @override
  String get mnStability => 'ความมั่นคง';

  @override
  String get mnEmotionalBalance => 'สมดุลทางอารมณ์';

  @override
  String get mnInnerCalm => 'ความสงบภายใน';

  @override
  String get mnSelfAwareness => 'การตระหนักรู้ในตนเอง';

  @override
  String get mnStatusThriving => 'เบ่งบานเต็มที่';

  @override
  String get mnStatusSteady => 'มั่นคงและสม่ำเสมอ';

  @override
  String get mnStatusBuildingStrength => 'กำลังสร้างความเข้มแข็ง';

  @override
  String get mnStatusNeedsGentleCare => 'ต้องการการดูแลเบาๆ';

  @override
  String get mnStatusReachOut => 'ถึงเวลาขอความช่วยเหลือ';

  @override
  String get mnChipStable => 'อารมณ์มั่นคง';

  @override
  String get mnChipSupported => 'ได้รับการสนับสนุนที่ดี';

  @override
  String get mnChipSelfAware => 'ตระหนักรู้ในตนเองสูง';

  @override
  String get mnChipResilient => 'ฟื้นตัวได้ดี';

  @override
  String get mnChipSecureAttachment => 'ความผูกพันที่มั่นคง';

  @override
  String get mnChipHealingReady => 'พร้อมสำหรับการเยียวยา';

  @override
  String get mnChipMindBodyBalance => 'สมดุลกายและใจ';

  @override
  String get mnSupportBannerTitle => 'ข้อความเบาๆ ถึงคุณ';

  @override
  String get mnSupportBannerBody =>
      'ดวงชะตาของคุณบ่งชี้ว่านี่อาจเป็นช่วงเวลาที่ดีในการพึ่งพาแรงสนับสนุนเพิ่มเติม — เพื่อนที่ไว้ใจได้ สมาชิกในครอบครัว หรือผู้เชี่ยวชาญ การขอความช่วยเหลือเป็นสัญญาณของความเข้มแข็ง ไม่ใช่ความอ่อนแอ';

  @override
  String get mnProfileTitle => 'แผนผังทางอารมณ์ของคุณ';

  @override
  String get mnStressDriver => 'ตัวกระตุ้นความเครียด';

  @override
  String get mnStabilityAnchor => 'จุดยึดเหนี่ยวความมั่นคง';

  @override
  String get mnSoulLevelKarma => 'รูปแบบระดับจิตวิญญาณ';

  @override
  String get mnSubtleSignature => 'ลายเซ็นทางอารมณ์ที่ละเอียดอ่อน';

  @override
  String get mnKarakaTitle => 'จิตใจและดาวเคราะห์ของคุณ';

  @override
  String get mnKarakaSubtitle => 'ดาวใดที่หล่อหลอมโลกภายในของคุณ';

  @override
  String get mnYogasTitle => 'จุดแข็งและด้านที่ควรพัฒนา';

  @override
  String get mnCurrentPhase => 'ระยะปัจจุบัน';

  @override
  String get mnCurrentStressLevel => 'ระดับความเครียดปัจจุบัน';

  @override
  String get mnRecentStrain => 'ความตึงเครียดทางอารมณ์ล่าสุด';

  @override
  String get mnStrengths => 'จุดแข็ง';

  @override
  String get mnGrowthAreas => 'ด้านที่ควรพัฒนา';

  @override
  String get mnSadeSatiStatus => 'สถานะ Sade Sati';

  @override
  String get mnVerificationTitle => 'ยืนยันข้ามดวงชะตา';

  @override
  String get mnD9Confirmation => 'การยืนยันจาก D9';

  @override
  String get mnD30Confirmation => 'การยืนยันจาก D30';

  @override
  String get mnMoodPatternsTitle => 'รูปแบบอารมณ์และความวิตกกังวล';

  @override
  String get mnMoodPatternsSubtitle =>
      'การรับรู้อย่างอ่อนโยน ไม่ใช่การวินิจฉัยโรค';

  @override
  String get mnAnxietyPatterns => 'รูปแบบความวิตกกังวล';

  @override
  String get mnMoodPatterns => 'รูปแบบอารมณ์ตกต่ำ';

  @override
  String get mnPrimaryPattern => 'รูปแบบหลัก';

  @override
  String get mnRumination => 'แนวโน้มคิดมาก';

  @override
  String get mnHypervigilance => 'ความตื่นตัวไวเกินปกติ';

  @override
  String get mnHopelessnessVuln => 'ความอ่อนไหวต่ออารมณ์ตกต่ำ';

  @override
  String get mnEnergyDepletion => 'แนวโน้มพลังงานหมดลง';

  @override
  String get mnMotivationBaseline => 'พื้นฐานแรงจูงใจ';

  @override
  String get mnRegulationTitle => 'การควบคุมอารมณ์และการรับมือ';

  @override
  String get mnEmotionalRegulation => 'การควบคุมอารมณ์';

  @override
  String get mnSelfSoothing => 'ความสามารถในการปลอบใจตนเอง';

  @override
  String get mnExpressionStyle => 'รูปแบบการแสดงออก';

  @override
  String get mnRecoveryTime => 'ระยะเวลาในการฟื้นตัว';

  @override
  String get mnTriggerIntensity => 'ความรุนแรงของตัวกระตุ้น';

  @override
  String get mnHealthyCoping => 'พฤติกรรมรับมือที่ดีต่อสุขภาพ';

  @override
  String get mnWatchFor => 'สิ่งที่ควรสังเกตอย่างอ่อนโยน';

  @override
  String get mnSleepTitle => 'การนอนหลับและการพักผ่อน';

  @override
  String get mnSleepQuality => 'คุณภาพการนอนหลับ';

  @override
  String get mnSleepAsRegulator => 'การนอนหลับในฐานะตัวควบคุมอารมณ์';

  @override
  String get mnInsomniaTendency => 'แนวโน้มนอนไม่หลับ';

  @override
  String get mnNightmareTendency => 'แนวโน้มฝันชัดเจน';

  @override
  String get mnSleepHygienePriority => 'ความสำคัญของสุขอนามัยการนอน';

  @override
  String get mnBurnoutTitle => 'ภาวะหมดไฟและพลังงาน';

  @override
  String get mnBurnoutVulnerability => 'ความเปราะบางต่อภาวะหมดไฟ';

  @override
  String get mnBurnoutRecovery => 'ความสามารถในการฟื้นตัวจากภาวะหมดไฟ';

  @override
  String get mnBurnoutStage => 'ระยะภาวะหมดไฟในปัจจุบัน';

  @override
  String get mnSelfDrivingTendency => 'แนวโน้มผลักดันตนเอง';

  @override
  String get mnBurnoutTriggers => 'ตัวกระตุ้นภาวะหมดไฟ';

  @override
  String get mnConnectionTitle => 'การเชื่อมโยงและแรงสนับสนุน';

  @override
  String get mnSocialSupport => 'คุณภาพแรงสนับสนุนทางสังคม';

  @override
  String get mnLonelinessVuln => 'ความเปราะบางต่อความเหงา';

  @override
  String get mnSolitudeNeed => 'ความต้องการอยู่ตามลำพัง';

  @override
  String get mnSocialComfort => 'ความสบายใจในสังคม';

  @override
  String get mnTraumaSensitivity => 'ความไวต่อบาดแผลทางใจ';

  @override
  String get mnHealingReadiness => 'ความพร้อมสำหรับการเยียวยา';

  @override
  String get mnProcessingStyle => 'รูปแบบการประมวลผลทางอารมณ์';

  @override
  String get mnMindBodyIntegration => 'การผสานกายและใจ';

  @override
  String get mnPtsdVuln => 'ความไวต่อการตอบสนองต่อบาดแผลทางใจ';

  @override
  String get mnSelfAwarenessTitle => 'การตระหนักรู้ในตนเองและการเติบโต';

  @override
  String get mnSelfAwarenessScore => 'การตระหนักรู้ในตนเอง';

  @override
  String get mnEmotionalVocabulary => 'คลังคำศัพท์ทางอารมณ์';

  @override
  String get mnTherapyReadiness => 'ความพร้อมสำหรับการบำบัด';

  @override
  String get mnJournalingBenefit => 'ประโยชน์จากการเขียนบันทึก';

  @override
  String get mnInnerDialogue => 'คุณภาพบทสนทนาภายในใจ';

  @override
  String get mnAwarenessOfPatterns => 'การตระหนักรู้รูปแบบของตนเอง';

  @override
  String get mnEscapePatternVuln => 'ความเสี่ยงต่อพฤติกรรมหลีกหนี';

  @override
  String get mnEscapeChannels => 'สิ่งที่ควรสังเกตอย่างอ่อนโยน';

  @override
  String get mnHealthyAlternatives => 'ทางเลือกที่ดีต่อสุขภาพ';

  @override
  String get mnTherapyFitTitle => 'ความเหมาะสมของการบำบัดและการสนับสนุน';

  @override
  String get mnCrisisSupportRec => 'คำแนะนำด้านการสนับสนุน';

  @override
  String get mnSupportNetwork => 'เปิดใช้เครือข่ายสนับสนุนของคุณ';

  @override
  String get mnSelfAdvocacy => 'ความพร้อมในการปกป้องสิทธิ์ตนเอง';

  @override
  String get mnMedicationReceptivity => 'การเปิดรับการใช้ยา';

  @override
  String get mnTimelineTitle => 'ไทม์ไลน์สุขภาวะ';

  @override
  String get mnPeakWellnessYears => 'ปีแห่งสุขภาวะสูงสุด';

  @override
  String get mnExtraCareYears => 'ปีที่ควรดูแลตนเองเป็นพิเศษ';

  @override
  String get mnTransformationWindows => 'ช่วงเวลาแห่งการเปลี่ยนแปลงเชิงบวก';

  @override
  String get mnTherapyWindow => 'ช่วงเวลาที่แนะนำสำหรับการบำบัด';

  @override
  String get mnPracticesTitle => 'แนวปฏิบัติเพื่อสุขภาวะประจำวัน';

  @override
  String get mnMorningPractices => 'แนวปฏิบัติยามเช้า';

  @override
  String get mnEveningPractices => 'แนวปฏิบัติยามเย็น';

  @override
  String get mnBreathwork => 'การฝึกลมหายใจ';

  @override
  String get mnMovement => 'การเคลื่อนไหวร่างกาย';

  @override
  String get mnNutrition => 'โภชนาการ';

  @override
  String get mnNatureExposure => 'ความต้องการใกล้ชิดธรรมชาติ';

  @override
  String get mnDigitalDetox => 'ความต้องการดีท็อกซ์ดิจิทัล';

  @override
  String get mnImprovementTitle => 'แผนการพัฒนา';

  @override
  String get mnReliabilityTitle => 'ความน่าเชื่อถือ';

  @override
  String get mnLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get mnLayerD9 => 'ดวงจิตวิญญาณ (D9)';

  @override
  String get mnLayerD30 => 'ดวง D30';

  @override
  String get mnLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get mnLayerTransit => 'การโคจรผ่าน (Transit)';

  @override
  String get mnTopicResilience => 'ฉันมีความยืดหยุ่นทางอารมณ์แค่ไหน';

  @override
  String get mnTopicCoping => 'กลยุทธ์การรับมือที่ดีที่สุดของฉันคืออะไร';

  @override
  String get mnTopicSleep => 'ฉันจะปรับปรุงการนอนหลับได้อย่างไร';

  @override
  String get mnTopicBurnout => 'ฉันมีความเสี่ยงภาวะหมดไฟหรือไม่';

  @override
  String get mnTopicTherapy => 'รูปแบบการบำบัดแบบใดเหมาะกับฉัน';

  @override
  String get mnTopicPractices => 'แนวปฏิบัติประจำวันแบบใดช่วยฉันได้มากที่สุด';

  @override
  String get mnTopicTiming => 'ปีใดคือปีแห่งสุขภาวะที่ดีที่สุดของฉัน';

  @override
  String get mnTopicSupport =>
      'ฉันจะสร้างเครือข่ายสนับสนุนที่แข็งแกร่งได้อย่างไร';

  @override
  String get lgSubtitle => 'รายงานกฎหมายเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get lgTitle => 'กฎหมายและข้อพิพาท';

  @override
  String get lgSnapshotHeader => 'ภาพรวมด้านกฎหมาย';

  @override
  String get lgResilience => 'ความยืดหยุ่นด้านกฎหมาย';

  @override
  String get lgResolutionCapacity => 'ความสามารถในการยุติข้อพิพาท';

  @override
  String get lgVictoryPotential => 'ศักยภาพในการชนะคดี';

  @override
  String get lgLegalSafety => 'ความปลอดภัยทางกฎหมาย';

  @override
  String get lgNegotiationSkill => 'ทักษะการเจรจาต่อรอง';

  @override
  String get lgStatusExcellent => 'ยอดเยี่ยม';

  @override
  String get lgStatusStrong => 'แข็งแกร่ง';

  @override
  String get lgStatusModerate => 'ปานกลาง';

  @override
  String get lgStatusDeveloping => 'กำลังพัฒนา';

  @override
  String get lgStatusChallenging => 'ท้าทาย';

  @override
  String get lgChipResolver => 'ผู้ยุติข้อพิพาทที่เชี่ยวชาญ';

  @override
  String get lgChipWinner => 'มีโอกาสชนะคดีสูง';

  @override
  String get lgChipNegotiator => 'นักเจรจาต่อรองโดยธรรมชาติ';

  @override
  String get lgChipDocumented => 'มีเอกสารครบถ้วน';

  @override
  String get lgChipLowRisk => 'ความเสี่ยงทางกฎหมายต่ำ';

  @override
  String get lgChipMoralAuthority => 'มีความน่าเชื่อถือทางศีลธรรม';

  @override
  String get lgChipLegalAptitude => 'มีความถนัดด้านกฎหมาย';

  @override
  String get lgProfileTitle => 'โปรไฟล์และกรรมด้านกฎหมายของคุณ';

  @override
  String get lgPrimaryDriver => 'ปัจจัยขับเคลื่อนหลัก';

  @override
  String get lgDharmaAnchor => 'จุดยึดเหนี่ยวทางธรรมะ';

  @override
  String get lgAggressionMarker => 'ตัวชี้วัดความก้าวร้าว';

  @override
  String get lgDocumentationKaraka => 'คุณภาพเอกสาร';

  @override
  String get lgKarakaTitle => 'ดาวแห่งกฎหมายของคุณ';

  @override
  String get lgKarakaSubtitle => 'ดาวใดที่หล่อหลอมโชคชะตาด้านกฎหมายของคุณ';

  @override
  String get lgYogasTitle => 'Yoga ด้านกฎหมายและการป้องกัน';

  @override
  String get lgCurrentPhase => 'ระยะปัจจุบัน';

  @override
  String get lgProtections => 'การป้องกัน';

  @override
  String get lgDisputePressures => 'แรงกดดันจากข้อพิพาท';

  @override
  String get lgVerificationTitle => 'ยืนยันข้ามดวงชะตา';

  @override
  String get lgD6Litigation => 'ดวง D6 คดีความ';

  @override
  String get lgD9Dharma => 'ดวง D9 ธรรมะ';

  @override
  String get lgMoralAuthority => 'ความน่าเชื่อถือทางศีลธรรม';

  @override
  String get lgVictoryTitle => 'การวิเคราะห์โอกาสชนะคดี';

  @override
  String get lgAsPlaintiff => 'ในฐานะโจทก์';

  @override
  String get lgAsDefendant => 'ในฐานะจำเลย';

  @override
  String get lgSettlementPreference => 'แนวโน้มการยอมความ';

  @override
  String get lgDisputeCategoriesTitle => 'หมวดหมู่ข้อพิพาทที่ควรจับตา';

  @override
  String get lgLowRiskCategories => 'หมวดหมู่ความเสี่ยงต่ำ';

  @override
  String get lgConflictStyleTitle => 'รูปแบบความขัดแย้งและศัตรู';

  @override
  String get lgConfrontationComfort => 'ความสบายใจในการเผชิญหน้า';

  @override
  String get lgArgumentPersuasiveness => 'ความสามารถในการโน้มน้าวใจ';

  @override
  String get lgEmotionalRegulation => 'การควบคุมอารมณ์';

  @override
  String get lgGrudgeHolding => 'แนวโน้มการผูกใจเจ็บ';

  @override
  String get lgEnemyAnalysisLabel => 'การวิเคราะห์ศัตรู';

  @override
  String get lgVisibleEnemies => 'ศัตรูที่มองเห็นได้';

  @override
  String get lgHiddenEnemies => 'ศัตรูที่ซ่อนอยู่';

  @override
  String get lgWorkplaceEnemies => 'ศัตรูในที่ทำงาน';

  @override
  String get lgFamilyEnemies => 'ศัตรูในครอบครัว';

  @override
  String get lgLegalEnemies => 'ศัตรูทางกฎหมาย';

  @override
  String get lgEnemyDefeatCapacity => 'ความสามารถในการเอาชนะศัตรู';

  @override
  String get lgCriminalFinancialTitle =>
      'การจับตาความเสี่ยงด้านอาชญากรรมและการเงิน';

  @override
  String get lgCriminalRisk => 'ความเสี่ยงพัวพันคดีอาญา';

  @override
  String get lgVictimOfCrime => 'โอกาสตกเป็นเหยื่ออาชญากรรม';

  @override
  String get lgFalseAccusation => 'ความเสี่ยงถูกกล่าวหาเท็จ';

  @override
  String get lgImprisonmentRisk => 'ความเสี่ยงถูกจำคุก';

  @override
  String get lgTaxDisputeRisk => 'ความเสี่ยงข้อพิพาทด้านภาษี';

  @override
  String get lgFinancialFraudRisk => 'ความเสี่ยงการฉ้อโกงทางการเงิน';

  @override
  String get lgBusinessLitigationRisk => 'ความเสี่ยงคดีความทางธุรกิจ';

  @override
  String get lgBankruptcyRisk => 'ความเสี่ยงล้มละลาย';

  @override
  String get lgAuditVulnerability => 'ความเสี่ยงถูกตรวจสอบ';

  @override
  String get lgProtectionPriority => 'สิ่งที่ควรป้องกันก่อน';

  @override
  String get lgContractsTitle => 'สัญญาและการเจรจาต่อรอง';

  @override
  String get lgContractClarity => 'ความชัดเจนของสัญญา';

  @override
  String get lgDocumentationDiscipline => 'วินัยด้านเอกสาร';

  @override
  String get lgFinePrintAwareness => 'ความใส่ใจในรายละเอียดสัญญา';

  @override
  String get lgSignatureCaution => 'ความระมัดระวังในการลงนาม';

  @override
  String get lgMediationReceptivity => 'การเปิดรับการไกล่เกลี่ย';

  @override
  String get lgNegotiationSkillFull => 'ทักษะการเจรจาต่อรอง';

  @override
  String get lgCompromiseWillingness => 'ความยินยอมประนีประนอม';

  @override
  String get lgFaceSavingNeeds => 'ความต้องการรักษาหน้า';

  @override
  String get lgMediatorHireRecommendation => 'คำแนะนำการว่าจ้างผู้ไกล่เกลี่ย';

  @override
  String get lgTypicalContractIssues => 'ปัญหาสัญญาที่พบบ่อย';

  @override
  String get lgCareerFitTitle => 'ความเหมาะสมกับอาชีพด้านกฎหมาย';

  @override
  String get lgProfessionAffinity => 'ความเหมาะสมกับอาชีพ';

  @override
  String get lgRoleFit => 'บทบาทที่เหมาะสมที่สุด';

  @override
  String get lgLawStudentSuccess => 'ความสำเร็จในฐานะนักศึกษากฎหมาย';

  @override
  String get lgBarExamSuccess => 'ความสำเร็จในการสอบเนติบัณฑิต';

  @override
  String get lgTimelineTitle => 'ไทม์ไลน์ด้านกฎหมาย';

  @override
  String get lgNewMatterChance => 'โอกาสเกิดคดีใหม่ (ใน 12 เดือนข้างหน้า)';

  @override
  String get lgOngoingCaseOutcome => 'ผลลัพธ์คดีที่กำลังดำเนินอยู่';

  @override
  String get lgRecommendedAction => 'แนวทางที่แนะนำ';

  @override
  String get lgPeakDisputeYears => 'ปีที่มีข้อพิพาทสูงสุด';

  @override
  String get lgClarityYears => 'ปีแห่งความชัดเจนทางกฎหมาย';

  @override
  String get lgAvoidancePeriods => 'ช่วงเวลาสำคัญที่ควรหลีกเลี่ยง';

  @override
  String get lgFavorableWindows => 'ช่วงเวลาที่เอื้ออำนวยต่อการยุติข้อพิพาท';

  @override
  String get lgRisksTitle => 'ความเสี่ยงและจุดเปราะบาง';

  @override
  String get lgChronicVulnerabilities => 'จุดเปราะบางเรื้อรัง';

  @override
  String get lgAvoidDashaPeriods => 'ช่วง Dasha ที่ควรจับตา';

  @override
  String get lgPreventivePriorities => 'สิ่งที่ควรป้องกันก่อน';

  @override
  String get lgRedFlags => 'สถานการณ์ที่ควรระวัง';

  @override
  String get lgImprovementTitle => 'แผนการพัฒนา';

  @override
  String get lgReliabilityTitle => 'ความน่าเชื่อถือ';

  @override
  String get lgLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get lgLayerD6 => 'ดวงคดีความ (D6)';

  @override
  String get lgLayerD9 => 'ดวงธรรมะ (D9)';

  @override
  String get lgLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get lgLayerTransit => 'การโคจรผ่าน (Transit)';

  @override
  String get lgTopicWinChance => 'โอกาสชนะคดีของฉันมีมากแค่ไหน';

  @override
  String get lgTopicStrategy => 'กลยุทธ์ทางกฎหมายที่ดีที่สุดสำหรับฉันคืออะไร';

  @override
  String get lgTopicContract => 'ความเสี่ยงในสัญญาที่ควรจับตาคืออะไร';

  @override
  String get lgTopicTiming =>
      'จังหวะเวลาที่ดีที่สุดในการยุติข้อพิพาทคือเมื่อใด';

  @override
  String get lgTopicSettlement => 'ฉันควรยอมความหรือสู้คดี';

  @override
  String get lgTopicEnemies => 'ใครคือศัตรูที่ซ่อนอยู่ของฉัน';

  @override
  String get lgTopicProtection => 'ฉันจะปกป้องตนเองทางกฎหมายได้อย่างไร';

  @override
  String get lgTopicCareer => 'ฉันเหมาะกับอาชีพด้านกฎหมายหรือไม่';

  @override
  String get prSubtitle => 'รายงานทรัพย์สินเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get prTitle => 'ทรัพย์สินและอสังหาริมทรัพย์';

  @override
  String get prSnapshotHeader => 'ภาพรวมทรัพย์สิน';

  @override
  String get prAcquisitionCapacity => 'ศักยภาพในการได้มาซึ่งทรัพย์สิน';

  @override
  String get prHomeOwnership => 'การเป็นเจ้าของบ้าน';

  @override
  String get prWealthPotential => 'ศักยภาพความมั่งคั่ง';

  @override
  String get prRentalIncome => 'รายได้จากค่าเช่า';

  @override
  String get prLandOwnership => 'การเป็นเจ้าของที่ดิน';

  @override
  String get prStatusExcellent => 'ยอดเยี่ยม';

  @override
  String get prStatusStrong => 'แข็งแกร่ง';

  @override
  String get prStatusModerate => 'ปานกลาง';

  @override
  String get prStatusDeveloping => 'กำลังพัฒนา';

  @override
  String get prStatusChallenging => 'ท้าทาย';

  @override
  String get prChipHomeOwner => 'เจ้าของบ้าน';

  @override
  String get prChipWealthBuilder => 'นักสร้างความมั่งคั่ง';

  @override
  String get prChipLandOwner => 'เจ้าของที่ดิน';

  @override
  String get prChipInvestor => 'นักลงทุนอสังหาริมทรัพย์';

  @override
  String get prChipInheritance => 'มีแนวโน้มได้รับมรดก';

  @override
  String get prChipVehicle => 'เจ้าของยานพาหนะ';

  @override
  String get prChipGlobalAsset => 'มีแนวโน้มมีทรัพย์สินต่างประเทศ';

  @override
  String get prProfileTitle => 'รูปแบบทรัพย์สินของคุณ';

  @override
  String get prHomeAesthetics => 'สุนทรียะของบ้าน';

  @override
  String get prHomeSanctuary => 'บ้านในฐานะที่พักพิงใจ';

  @override
  String get prComfortInvestment => 'การลงทุนเพื่อความสะดวกสบาย';

  @override
  String get prVastuPriority => 'ความสำคัญของ Vastu';

  @override
  String get prNaturalElements => 'องค์ประกอบทางธรรมชาติ';

  @override
  String get prNextActionLabel => 'ขั้นตอนถัดไป';

  @override
  String get prKarakaTitle => 'ดาวแห่งทรัพย์สินของคุณ';

  @override
  String get prKarakaSubtitle => 'ดาวใดที่หล่อหลอมโชคด้านทรัพย์สินของคุณ';

  @override
  String get prPrimaryKaraka => 'Karaka หลัก';

  @override
  String get prDurableAsset => 'Karaka แห่งทรัพย์สินถาวร';

  @override
  String get prYogasTitle => 'Yoga และ Dosha ด้านทรัพย์สิน';

  @override
  String get prCurrentPhase => 'ระยะปัจจุบัน';

  @override
  String get prBoosters => 'ตัวเสริม';

  @override
  String get prDrains => 'ตัวลดทอน';

  @override
  String get prVerificationTitle => 'ยืนยันข้ามดวงชะตา';

  @override
  String get prD4Property => 'ดวงทรัพย์สิน D4';

  @override
  String get prD16Vehicle => 'ดวงยานพาหนะ D16';

  @override
  String get prVehicleFit => 'ความเหมาะสมด้านยานพาหนะ';

  @override
  String get prJourneyTitle => 'เส้นทางและไทม์ไลน์การเป็นเจ้าของ';

  @override
  String get prFirstHomeAge => 'อายุที่ได้บ้านหลังแรก';

  @override
  String get prFirstHomeType => 'ประเภทบ้านหลังแรก';

  @override
  String get prMultipleHomes => 'การมีบ้านหลายหลัง';

  @override
  String get prNewPropertySoon => 'ทรัพย์สินใหม่ในเร็วๆ นี้';

  @override
  String get prFirstMajorWindow => 'ช่วงเวลาสำคัญครั้งแรก';

  @override
  String get prBuyingWindow => 'ช่วงเวลาที่เหมาะซื้อ';

  @override
  String get prConstructionWindow => 'ช่วงเวลาที่เหมาะก่อสร้าง';

  @override
  String get prNextOpportunity => 'โอกาสถัดไป';

  @override
  String get prLifetimePropertyCount => 'จำนวนทรัพย์สินตลอดชีวิต';

  @override
  String get prInheritanceTitle => 'มรดกและทรัพย์สินครอบครัว';

  @override
  String get prMaternalInheritance => 'มรดกจากฝ่ายมารดา';

  @override
  String get prPaternalInheritance => 'มรดกจากฝ่ายบิดา';

  @override
  String get prAncestralProperty => 'ทรัพย์สินบรรพบุรุษ';

  @override
  String get prFamilyDisputeRisk => 'ความเสี่ยงข้อพิพาทในครอบครัว';

  @override
  String get prInheritanceTiming => 'จังหวะเวลาการรับมรดก';

  @override
  String get prInheritanceType => 'ประเภทมรดก';

  @override
  String get prLandInvestTitle => 'ที่ดิน การลงทุน และทรัพย์สินต่างประเทศ';

  @override
  String get prPropertyInvestor => 'คะแนนนักลงทุนอสังหาริมทรัพย์';

  @override
  String get prAppreciationLuck => 'โชคด้านมูลค่าเพิ่มขึ้น';

  @override
  String get prInvestorMindset => 'แนวคิดแบบนักลงทุน';

  @override
  String get prLandType => 'ประเภทที่ดิน';

  @override
  String get prRentalCount => 'จำนวนอสังหาริมทรัพย์ให้เช่า';

  @override
  String get prMultipleLand => 'การมีที่ดินหลายแปลง';

  @override
  String get prFarmEstate => 'โอกาสมีฟาร์ม/ที่ดินขนาดใหญ่';

  @override
  String get prGlobalPropertyLabel => 'ทรัพย์สินต่างประเทศ';

  @override
  String get prForeignProperty => 'ทรัพย์สินในต่างแดน';

  @override
  String get prNriAffinity => 'แนวโน้มทรัพย์สินแบบ NRI';

  @override
  String get prVehiclesTitle => 'ยานพาหนะ';

  @override
  String get prVehicleCount => 'จำนวนยานพาหนะ';

  @override
  String get prVehicleFirstAge => 'อายุที่ได้ยานพาหนะคันแรก';

  @override
  String get prVehicleCategory => 'ประเภทยานพาหนะ';

  @override
  String get prVehicleQuality => 'คุณภาพยานพาหนะ';

  @override
  String get prLuxuryAffinity => 'ความชอบสินค้าหรู';

  @override
  String get prVehicleLossRisk => 'ความเสี่ยงยานพาหนะสูญหาย/เสียหาย';

  @override
  String get prLegalRiskTitle => 'การจับตาความเสี่ยงทางกฎหมาย';

  @override
  String get prBoundaryDisputes => 'ข้อพิพาทเรื่องแนวเขตที่ดิน';

  @override
  String get prPartitionDisputes => 'ข้อพิพาทเรื่องการแบ่งทรัพย์สิน';

  @override
  String get prTitleIssues => 'ปัญหาเรื่องกรรมสิทธิ์/เอกสาร';

  @override
  String get prTenantConflict => 'ข้อขัดแย้งระหว่างผู้เช่ากับเจ้าของ';

  @override
  String get prForcedSale => 'ความเสี่ยงถูกบังคับขาย';

  @override
  String get prPropertyDamage => 'ความเสี่ยงทรัพย์สินเสียหาย';

  @override
  String get prInsurancePriority => 'ความสำคัญของการทำประกัน';

  @override
  String get prProtectionUrgency => 'ความเร่งด่วนในการป้องกัน';

  @override
  String get prProtectiveFactors => 'ปัจจัยป้องกัน';

  @override
  String get prChronicVulnerabilities => 'จุดเปราะบางเรื้อรัง';

  @override
  String get prDueDiligenceTitle => 'รายการตรวจสอบก่อนตัดสินใจ';

  @override
  String get prPreventiveMeasures => 'มาตรการป้องกัน';

  @override
  String get prImprovementTitle => 'แผนการพัฒนา';

  @override
  String get prReliabilityTitle => 'ความน่าเชื่อถือ';

  @override
  String get prLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get prLayerD4 => 'ดวงทรัพย์สิน (D4)';

  @override
  String get prLayerD16 => 'ดวงยานพาหนะ (D16)';

  @override
  String get prLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get prLayerTransit => 'การโคจรผ่าน (Transit)';

  @override
  String get prTopicBuying => 'เวลาที่ดีที่สุดในการซื้อคือเมื่อใด';

  @override
  String get prTopicInherit => 'ฉันจะได้รับมรดกทรัพย์สินหรือไม่';

  @override
  String get prTopicVehicle => 'ฉันจะได้ยานพาหนะเมื่อใด';

  @override
  String get prTopicRental => 'ศักยภาพรายได้จากค่าเช่า?';

  @override
  String get prTopicLand => 'โอกาสเป็นเจ้าของที่ดิน?';

  @override
  String get prTopicLegal => 'ความเสี่ยงทางกฎหมายที่ควรจับตา?';

  @override
  String get prTopicForeign => 'โอกาสมีทรัพย์สินต่างประเทศ?';

  @override
  String get prTopicTiming => 'ช่วงเวลาที่ดีที่สุดสำหรับทรัพย์สิน?';

  @override
  String get edTitle => 'การวิเคราะห์การศึกษาและการเรียนรู้';

  @override
  String get edSubtitle => 'รายงานการศึกษาเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get edSnapshotHeader => 'ภาพรวมการศึกษาของคุณ';

  @override
  String get edOverallStrength => 'ความแข็งแกร่งโดยรวม';

  @override
  String get edAcademicSuccess => 'ความสำเร็จทางวิชาการ';

  @override
  String get edLearningCapacity => 'ความสามารถในการเรียนรู้';

  @override
  String get edIntellect => 'สติปัญญา';

  @override
  String get edMemory => 'ความจำ';

  @override
  String get edStatusExcellent => 'ศักยภาพยอดเยี่ยม';

  @override
  String get edStatusStrong => 'ศักยภาพแข็งแกร่ง';

  @override
  String get edStatusModerate => 'ศักยภาพปานกลาง';

  @override
  String get edStatusDeveloping => 'ศักยภาพกำลังพัฒนา';

  @override
  String get edStatusChallenging => 'ระยะที่ท้าทาย';

  @override
  String get edChipSaraswati => 'Saraswati Yoga';

  @override
  String get edChipGajaKesari => 'Gaja Kesari Yoga';

  @override
  String get edChipBudhaAditya => 'Budha Aditya Yoga';

  @override
  String get edChipResearch => 'ความสามารถด้านการวิจัยที่แข็งแกร่ง';

  @override
  String get edChipScholarship => 'ศักยภาพได้รับทุนการศึกษา';

  @override
  String get edChipDoctorate => 'ศักยภาพระดับปริญญาเอก';

  @override
  String get edChipForeign => 'สนับสนุนการศึกษาต่างประเทศ';

  @override
  String get edChipLifelong => 'ผู้เรียนรู้ตลอดชีวิต';

  @override
  String get edLearningStyleTitle => 'รูปแบบการเรียนรู้ของคุณ';

  @override
  String get edSoulPlanet => 'ดาวแห่งจิตวิญญาณ';

  @override
  String get edSoulHint => 'แรงขับภายในที่ลึกที่สุดและเป้าหมายชีวิตของคุณ';

  @override
  String get edSubjectPlanet => 'ดาวแห่งวิชาเรียน';

  @override
  String get edTechAtmakaraka => 'Atmakaraka (เชิงเทคนิค)';

  @override
  String get edTechAmatyakaraka => 'Amatyakaraka (เชิงเทคนิค)';

  @override
  String get edSubjectKarakaStrength => 'ความแข็งแกร่งของ Karaka วิชาเรียน';

  @override
  String get edFoundationTitle => 'รากฐานทางการศึกษา';

  @override
  String get edHouse4 => 'การศึกษาช่วงต้น';

  @override
  String get edHouse5 => 'สติปัญญา';

  @override
  String get edHouse9 => 'การศึกษาระดับสูง';

  @override
  String get edPurvaPunya => 'บุญจากชาติที่แล้ว';

  @override
  String get edStudyPlanetsTitle => 'ดาวแห่งการเรียนของคุณ';

  @override
  String get edYogasTitle => 'Yoga ด้านการศึกษาในดวงชะตาของคุณ';

  @override
  String get edYogaBudhaAditya => 'Budha Aditya';

  @override
  String get edYogaGajaKesari => 'Gaja Kesari';

  @override
  String get edYogaSaraswati => 'Saraswati';

  @override
  String get edYogaPresent => 'มี';

  @override
  String get edYogaAbsent => 'ไม่มี';

  @override
  String get edYogaNoneNote =>
      'ไม่มี Yoga การศึกษาแบบคลาสสิก — ความสำเร็จจะมาจากความพยายามและวินัยที่สม่ำเสมอ';

  @override
  String get edVerificationTitle => 'การยืนยันข้ามดวงชะตา';

  @override
  String get edD24Learning => 'D24 — ดวงการเรียนรู้เชิงลึก';

  @override
  String get edD4Formal => 'D4 — ดวงการศึกษาในระบบ';

  @override
  String get edD9Dharma => 'D9 — ดวงธรรมะแห่งการเรียนรู้';

  @override
  String get edD60Karma => 'D60 — กรรมการเรียนรู้จากชาติที่แล้ว';

  @override
  String get edSubjectsTitle => 'วิชาที่เหมาะกับคุณที่สุด';

  @override
  String get edSubjectsSubtitle => 'จัดอันดับตามความสอดคล้องกับดวงชะตา';

  @override
  String get edLowAffinity => 'วิชาที่มีความสอดคล้องต่ำ';

  @override
  String get edDegreesTitle => 'โอกาสด้านปริญญาและระดับการศึกษา';

  @override
  String get edExpectedLevel => 'ระดับที่คาดว่าจะถึง';

  @override
  String get edDegreeFormal => 'ปริญญาในระบบ';

  @override
  String get edDegreePostgrad => 'ปริญญาโท';

  @override
  String get edDegreeDoctorate => 'ปริญญาเอก';

  @override
  String get edDegreeForeign => 'การศึกษาต่างประเทศ';

  @override
  String get edTimelineTitle => 'ไทม์ไลน์การศึกษา';

  @override
  String get edEarlySchooling => 'ช่วงเวลาการศึกษาช่วงต้น';

  @override
  String get edHigherEducation => 'ช่วงเวลาการศึกษาระดับสูง';

  @override
  String get edPostgradResearch => 'ช่วงเวลาปริญญาโท/วิจัย';

  @override
  String get edPeakLearningAge => 'ช่วงอายุที่เรียนรู้ได้ดีที่สุด';

  @override
  String get edPreferencesTitle => 'ความชอบด้านการเรียนรู้และการสนับสนุน';

  @override
  String get edPrefStudyMode => 'รูปแบบการเรียน';

  @override
  String get edPrefTiming => 'เวลาที่เหมาะสมที่สุด';

  @override
  String get edPrefEnvironment => 'สภาพแวดล้อม';

  @override
  String get edPrefLocation => 'สถานที่';

  @override
  String get edPrefForeign => 'การเรียนต่างประเทศ';

  @override
  String get edGuruRelationship => 'ความผูกพันกับครู/คุรุ';

  @override
  String get edMentorAvailability => 'ความพร้อมของพี่เลี้ยง';

  @override
  String get edPeerLearning => 'การเรียนรู้จากเพื่อน';

  @override
  String get edAuthorityDeference => 'ความเคารพต่อผู้มีอำนาจ';

  @override
  String get edStrengthsTitle => 'จุดแข็งและความท้าทาย';

  @override
  String get edCognitiveGifts => 'พรสวรรค์ด้านสติปัญญา';

  @override
  String get edNaturalAbilities => 'ความสามารถในการเรียนรู้โดยธรรมชาติ';

  @override
  String get edHiddenCapacities => 'ศักยภาพที่ซ่อนอยู่';

  @override
  String get edConcentration => 'ความยากในการมีสมาธิ';

  @override
  String get edBreakRisk => 'ความเสี่ยงหยุดการศึกษากลางคัน';

  @override
  String get edDisciplineConsistency => 'ความสม่ำเสมอด้านวินัย';

  @override
  String get edScholarshipLikelihood => 'โอกาสได้รับทุนการศึกษา';

  @override
  String get edCareerLinkTitle => 'การศึกษา → เส้นทางอาชีพ';

  @override
  String get edDirectionRec => 'ทิศทางที่แนะนำ';

  @override
  String get edIntegrationStrategy => 'กลยุทธ์การผสานรวม';

  @override
  String get edCareerLinkage => 'ความเชื่อมโยงกับอาชีพ';

  @override
  String get edAlignedSubjects => 'วิชาที่สอดคล้องกับอาชีพ';

  @override
  String get edDegreeUtility => 'ประโยชน์ของปริญญาต่ออาชีพ';

  @override
  String get edImprovementTitle => 'แผนการพัฒนาของคุณ';

  @override
  String get edReliabilityTitle => 'ความน่าเชื่อถือของการทำนาย';

  @override
  String get edLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get edLayerD4 => 'การศึกษาในระบบ (D4)';

  @override
  String get edLayerD9 => 'Navamsa (D9)';

  @override
  String get edLayerD24 => 'การเรียนรู้เชิงลึก (D24)';

  @override
  String get edLayerD60 => 'การเรียนรู้จากชาติที่แล้ว (D60)';

  @override
  String get edLayerAmk => 'Karaka วิชาเรียน';

  @override
  String get edLayerMj => 'Mercury-Jupiter';

  @override
  String get edLayerDasha => 'จังหวะเวลาดาวเคราะห์';

  @override
  String get edTopicSubjects => 'วิชาที่เหมาะกับฉันที่สุด';

  @override
  String get edTopicDegree => 'โอกาสด้านปริญญา';

  @override
  String get edTopicAbroad => 'การเรียนต่างประเทศ';

  @override
  String get edTopicExam => 'ผลการสอบ';

  @override
  String get edTopicHabits => 'นิสัยการเรียน';

  @override
  String get edTopicCareerLink => 'ความเชื่อมโยงการศึกษาสู่อาชีพ';

  @override
  String get edTopicTiming => 'ช่วงเวลาด้านการศึกษา';

  @override
  String get edTopicScholarship => 'โอกาสได้รับทุนการศึกษา';

  @override
  String get hwTitle => 'การวิเคราะห์สุขภาพและสุขภาวะ';

  @override
  String get hwSubtitle => 'รายงานสุขภาพและสุขภาวะเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get hwSnapshotHeader => 'ภาพรวมสุขภาพของคุณ';

  @override
  String get hwOverallVitality => 'พลังชีวิต';

  @override
  String get hwImmunity => 'ภูมิคุ้มกัน';

  @override
  String get hwRecovery => 'การฟื้นตัว';

  @override
  String get hwMentalWellness => 'สุขภาวะทางจิตใจ';

  @override
  String get hwStressTolerance => 'ความทนทานต่อความเครียด';

  @override
  String get hwStatusThriving => 'เบ่งบานเต็มที่';

  @override
  String get hwStatusGood => 'พลังชีวิตดี';

  @override
  String get hwStatusBalanced => 'สมดุล';

  @override
  String get hwStatusNeedsCare => 'ต้องการการดูแล';

  @override
  String get hwStatusNeedsAttention => 'ต้องการความสนใจ';

  @override
  String get hwChipImmunity => 'ภูมิคุ้มกันแข็งแรง';

  @override
  String get hwChipRecovery => 'ฟื้นตัวเร็ว';

  @override
  String get hwChipMentalBalance => 'จิตใจสมดุล';

  @override
  String get hwChipStressResilience => 'ทนทานต่อความเครียด';

  @override
  String get hwChipFertility => 'สนับสนุนภาวะเจริญพันธุ์';

  @override
  String get hwChipWorkLife => 'สมดุลชีวิตและการทำงานที่ดี';

  @override
  String get hwChipLowAddiction => 'ความเสี่ยงการเสพติดต่ำ';

  @override
  String get hwConstitutionTitle => 'ธาตุร่างกายของคุณ';

  @override
  String get hwConstitutionSubtitle =>
      'ธาตุเจ้าเรือนตามหลักอายุรเวทจากดวงชะตาของคุณ';

  @override
  String get hwDominantDosha => 'เด่น';

  @override
  String get hwSecondaryDosha => 'รอง';

  @override
  String get hwPrimaryKaraka => 'ตัวชี้วัดสุขภาพหลัก';

  @override
  String get hwStrongestSystem => 'ระบบที่แข็งแรงที่สุด';

  @override
  String get hwWeakestSystem => 'ระบบที่ควรดูแลเสริม';

  @override
  String get hwBodyMapTitle => 'แผนที่ดาวเคราะห์ประจำร่างกายของคุณ';

  @override
  String get hwBodyMapSubtitle => '9 ดาวเคราะห์ กับ 9 ระบบร่างกาย';

  @override
  String get hwYogaTitle => 'รูปแบบสุขภาพในดวงชะตาของคุณ';

  @override
  String get hwYogaSubtitle => 'Yoga ปกป้องเทียบกับ Yoga ที่กดดันให้เกิดโรค';

  @override
  String get hwDiseasePressureLabel => 'แรงกดดันจากโรค';

  @override
  String get hwAreasTitle => 'จุดในร่างกายที่ควรจับตา';

  @override
  String get hwAreasSubtitle => 'จุดเปราะบางแยกตามส่วนของร่างกาย';

  @override
  String get hwProtectedAreas => 'จุดที่ได้รับการปกป้องดี';

  @override
  String get hwCategoriesTitle => 'การจับตาหมวดหมู่โรค';

  @override
  String get hwCategoriesSubtitle => 'ความอ่อนไหวในหมวดหมู่สุขภาพหลัก';

  @override
  String get hwLowRiskCategories => 'หมวดหมู่ความเสี่ยงต่ำ';

  @override
  String get hwMentalTitle => 'สุขภาวะทางจิตใจและอารมณ์';

  @override
  String get hwMentalSubtitle =>
      'ความยืดหยุ่นทางอารมณ์และความต้องการการสนับสนุน';

  @override
  String get hwMentalVulnerability => 'ความอ่อนไหวทางอารมณ์';

  @override
  String get hwEmotionalRegulation => 'การควบคุมอารมณ์';

  @override
  String get hwSupportRec => 'คำแนะนำด้านการสนับสนุน';

  @override
  String get hwTendencies => 'แนวโน้มทางจิตใจ';

  @override
  String get hwTimelineTitle => 'ไทม์ไลน์สุขภาพ';

  @override
  String get hwTimelineSubtitle =>
      'ปีสุขภาพดีที่สุด ปีที่ควรระวัง และช่วงเวลาฟื้นตัว';

  @override
  String get hwPeakYears => 'ปีแห่งสุขภาวะสูงสุด';

  @override
  String get hwCautionYears => 'ปีที่ควรระวัง';

  @override
  String get hwRecoveryWindow => 'ช่วงเวลาฟื้นตัว';

  @override
  String get hwCheckupYears => 'ปีที่แนะนำให้ตรวจสุขภาพ';

  @override
  String get hwCurrentPhase => 'ระยะปัจจุบัน';

  @override
  String get hwLifestyleTitle => 'แนวทางการใช้ชีวิตของคุณ';

  @override
  String get hwLifestyleSubtitle =>
      'สิ่งที่ดวงชะตาบอกเกี่ยวกับพฤติกรรมประจำวัน';

  @override
  String get hwSleepDiscipline => 'ผลกระทบจากวินัยการนอน';

  @override
  String get hwDietDiscipline => 'ผลกระทบจากวินัยการกิน';

  @override
  String get hwExerciseNeed => 'ความต้องการออกกำลังกาย';

  @override
  String get hwSunlightNeed => 'ความต้องการแสงแดด';

  @override
  String get hwStressSusceptibility => 'ความอ่อนไหวต่อความเครียด';

  @override
  String get hwHydrationSensitivity => 'ความอ่อนไหวต่อการขาดน้ำ';

  @override
  String get hwSocialType => 'ประเภทพลังงานทางสังคม';

  @override
  String get hwHealingSpeed => 'ความเร็วในการฟื้นตัว';

  @override
  String get hwTreatmentResponse => 'การตอบสนองต่อการรักษา';

  @override
  String get hwAltHealing => 'ความเหมาะสมกับการเยียวยาทางเลือก';

  @override
  String get hwSpecialTitle => 'ช่วงชีวิตและหัวข้อพิเศษ';

  @override
  String get hwSpecialSubtitle =>
      'ภาวะเจริญพันธุ์ สุขภาพวัยเด็ก พฤติกรรม และภาวะหมดไฟ';

  @override
  String get hwFertility => 'ตัวชี้วัดภาวะเจริญพันธุ์';

  @override
  String get hwHormonalBalance => 'สมดุลฮอร์โมน';

  @override
  String get hwReproductiveStrength => 'ความแข็งแรงของระบบสืบพันธุ์';

  @override
  String get hwChildhoodVuln => 'ความเปราะบางด้านสุขภาพวัยเด็ก';

  @override
  String get hwChildhoodStatus => 'สุขภาพวัยเด็ก';

  @override
  String get hwAddictionVuln => 'ความเปราะบางต่อการเสพติด';

  @override
  String get hwAddictionRecovery => 'ศักยภาพในการฟื้นตัว';

  @override
  String get hwBurnoutVuln => 'ความเปราะบางต่อภาวะหมดไฟ';

  @override
  String get hwWorkLifeBalance => 'สมดุลชีวิตและการทำงาน';

  @override
  String get hwStressTriggers => 'ตัวกระตุ้นความเครียด';

  @override
  String get hwProtectiveFactors => 'ปัจจัยป้องกัน';

  @override
  String get hwChallengesTitle => 'ความท้าทายที่ควรจับตา';

  @override
  String get hwChallengesSubtitle => 'จุดที่ควรเน้นการดูแลป้องกัน';

  @override
  String get hwMitigation => 'วิธีจัดการรับมือ';

  @override
  String get hwChronicAreas => 'จุดเปราะบางเรื้อรัง';

  @override
  String get hwPreventivePriorities => 'สิ่งที่ควรป้องกันก่อน';

  @override
  String get hwImprovementTitle => 'แผนสุขภาวะของคุณ';

  @override
  String get hwImprovementSubtitle =>
      'ขั้นตอนปฏิบัติจริงและแนวทางเยียวยาแบบดั้งเดิม';

  @override
  String get hwReliabilityTitle => 'ความน่าเชื่อถือของการอ่านดวง';

  @override
  String get hwLayerD1 => 'ดวงกำเนิด (D1)';

  @override
  String get hwLayerD6 => 'ดวงสุขภาพ (D6)';

  @override
  String get hwLayerD30 => 'ดวงสุขภาพละเอียด (D30)';

  @override
  String get hwLayerDasha => 'จังหวะเวลาดาวเคราะห์';

  @override
  String get hwLayerTransit => 'การโคจรผ่านปัจจุบัน (Transit)';

  @override
  String get hwDisclaimerLabel => 'ข้อจำกัดความรับผิดชอบทางการแพทย์';

  @override
  String get hwTopicImmunity => 'เสริมสร้างภูมิคุ้มกัน';

  @override
  String get hwTopicSleep => 'การนอนหลับและการพักผ่อน';

  @override
  String get hwTopicStress => 'การจัดการความเครียด';

  @override
  String get hwTopicFertility => 'จังหวะเวลาภาวะเจริญพันธุ์';

  @override
  String get hwTopicDiet => 'อาหารและโภชนาการ';

  @override
  String get hwTopicTiming => 'ช่วงเวลาด้านสุขภาพ';

  @override
  String get hwTopicMental => 'สุขภาวะทางจิตใจ';

  @override
  String get hwTopicPrevention => 'แผนการดูแลป้องกัน';

  @override
  String get lvSubtitle => 'รายงานความรักเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get lvTitle => 'ความรักและความสัมพันธ์';

  @override
  String get lvLovePotential => 'ศักยภาพความรัก';

  @override
  String get lvEmotionalAvail => 'เปิดใจทางอารมณ์';

  @override
  String get lvAttraction => 'แรงดึงดูด';

  @override
  String get lvCommitment => 'ความมุ่งมั่นผูกพัน';

  @override
  String get lvCommunication => 'การสื่อสาร';

  @override
  String get lvFidelity => 'ความซื่อสัตย์';

  @override
  String get lvChipLoyal => 'หัวใจที่ซื่อสัตย์';

  @override
  String get lvChipOpenHeart => 'ใจกว้าง เปิดรับ';

  @override
  String get lvChipCommunicator => 'นักสื่อสารที่เก่งกาจ';

  @override
  String get lvChipMature => 'จัดการความขัดแย้งได้ดี';

  @override
  String get lvChipEmotionallyWise => 'ฉลาดทางอารมณ์';

  @override
  String get lvLoveStyle => 'รูปแบบความรักของคุณ';

  @override
  String get lvAttractionStyle => 'รูปแบบแรงดึงดูด';

  @override
  String get lvLangGiven => 'คุณแสดงความรักด้วย';

  @override
  String get lvLangReceived => 'คุณรู้สึกได้รับความรักจาก';

  @override
  String get lvLovePlanets => 'ดาวแห่งความรักของคุณ';

  @override
  String get lvLoveKaraka => 'ความรัก';

  @override
  String get lvEmotionKaraka => 'อารมณ์';

  @override
  String get lvPassionKaraka => 'ความหลงใหล';

  @override
  String get lvPathToLove => 'เส้นทางสู่ความรักของคุณ';

  @override
  String get lvPathSub => 'แต่งงานด้วยความรักหรือแบบคลุมถุงชน';

  @override
  String get lvLoveMarriage => 'แต่งงานด้วยความรัก';

  @override
  String get lvArrangedMarriage => 'แต่งงานแบบคลุมถุงชน';

  @override
  String get lvParentalAccept => 'การยอมรับจากบิดามารดา';

  @override
  String get lvInterCaste => 'ต่างวรรณะ/ศาสนา';

  @override
  String get lvIdealPartner => 'คู่ครองในอุดมคติของคุณ';

  @override
  String get lvPersonality => 'บุคลิกภาพ';

  @override
  String get lvAppearance => 'รูปลักษณ์';

  @override
  String get lvIdealTraits => 'คุณลักษณะในอุดมคติ';

  @override
  String get lvWhatMatters => 'สิ่งที่สำคัญที่สุด';

  @override
  String get lvDrawnTo => 'ดึงดูดใจกับ';

  @override
  String get lvDealbreakers => 'สิ่งที่รับไม่ได้';

  @override
  String get lvYourAppeal => 'เสน่ห์ของคุณ';

  @override
  String get lvLoveStory => 'เรื่องราวความรักของคุณ';

  @override
  String get lvLoveStorySub => 'รูปแบบความสัมพันธ์';

  @override
  String get lvFirstLove => 'รักแรก';

  @override
  String get lvRelationCount => 'ความสัมพันธ์สำคัญ';

  @override
  String get lvDuration => 'ระยะเวลาโดยทั่วไป';

  @override
  String get lvDepth => 'ความลึกซึ้งทางอารมณ์';

  @override
  String get lvDatingPattern => 'รูปแบบการออกเดท';

  @override
  String get lvCommitIntimacy => 'ความมุ่งมั่นผูกพันและความใกล้ชิด';

  @override
  String get lvCommitReady => 'ความพร้อมสำหรับความมุ่งมั่นผูกพัน';

  @override
  String get lvIntimacyDrive => 'แรงขับด้านความใกล้ชิด';

  @override
  String get lvSensuality => 'ความรู้สึกทางกาย';

  @override
  String get lvEmpathy => 'ความเห็นอกเห็นใจ';

  @override
  String get lvCommitStyle => 'รูปแบบความมุ่งมั่นผูกพัน';

  @override
  String get lvChemistry => 'รูปแบบเคมีความรัก';

  @override
  String get lvMakesCommit => 'สิ่งที่ทำให้คุณมุ่งมั่นผูกพัน';

  @override
  String get lvMakesFlee => 'สิ่งที่ทำให้คุณถอยห่าง';

  @override
  String get lvEmotional => 'ความฉลาดทางอารมณ์';

  @override
  String get lvEmotionalIQ => 'ความฉลาดทางอารมณ์ (EQ)';

  @override
  String get lvConflictStyle => 'รูปแบบการจัดการความขัดแย้ง';

  @override
  String get lvTiming => 'จังหวะเวลาความรัก';

  @override
  String get lvNewLove12 => 'ความรักใหม่ใน 12 เดือน';

  @override
  String get lvEnergyNow => 'พลังงานในปัจจุบัน';

  @override
  String get lvPhaseNow => 'ระยะปัจจุบัน';

  @override
  String get lvPeakRomance => 'ปีแห่งความโรแมนติกสูงสุด';

  @override
  String get lvNewLoveWindow => 'ช่วงเวลาความรักใหม่';

  @override
  String get lvChallenges => 'ความท้าทายที่ควรจับตา';

  @override
  String get lvRiskHeartbreak => 'ความเปราะบางต่อความอกหัก';

  @override
  String get lvRiskSabotage => 'การทำลายโอกาสตนเอง';

  @override
  String get lvRiskCommitFear => 'ความกลัวความผูกมัด';

  @override
  String get lvRiskRepeat => 'รูปแบบที่เกิดซ้ำ';

  @override
  String get lvRiskWorkaholic => 'ให้ความสำคัญกับงานมากกว่าความรัก';

  @override
  String get lvRedFlags => 'สัญญาณเตือนที่ควรจับตา';

  @override
  String get lvHealing => 'สิ่งที่ควรเยียวยา';

  @override
  String get lvFocusArea => 'จุดที่ควรเน้น';

  @override
  String get lvHealDir => 'ทิศทางการเยียวยา';

  @override
  String get lvImprovementPlan => 'แผนการพัฒนา';

  @override
  String get lvReliability => 'ความน่าเชื่อถือของการทำนาย';

  @override
  String get lvLayerBirth => 'ดวงกำเนิด (D1)';

  @override
  String get lvLayerNavamsa => 'Navamsa (D9)';

  @override
  String get lvLayerSaptamsa => 'Saptamsa (D7)';

  @override
  String get lvLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get lvLayerTransit => 'การโคจรผ่านปัจจุบัน (Transit)';

  @override
  String get lvTopicWhen => 'ฉันจะพบรักเมื่อใด';

  @override
  String get lvTopicSoulmate => 'เกี่ยวกับคู่แท้ของฉัน';

  @override
  String get lvTopicCurrent => 'ความสัมพันธ์ปัจจุบันของฉัน';

  @override
  String get lvTopicHeal => 'การเยียวยาจากอดีต';

  @override
  String get lvTopicCommit => 'ความช่วยเหลือด้านความมุ่งมั่นผูกพัน';

  @override
  String get lvTopicLoveVsArranged => 'แต่งงานด้วยความรักหรือแบบคลุมถุงชน';

  @override
  String get lvTopicHeartbreak => 'การหลีกเลี่ยงความอกหัก';

  @override
  String get lvTopicConfidence => 'ความมั่นใจในความรัก';

  @override
  String get mrSubtitle => 'รายงานการแต่งงานเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get mrTitle => 'การแต่งงานและครอบครัว';

  @override
  String get mrMarriagePotential => 'ศักยภาพการแต่งงาน';

  @override
  String get mrHarmony => 'ความกลมกลืน';

  @override
  String get mrLongevity => 'ความยืนยาว';

  @override
  String get mrSatisfaction => 'ความพึงพอใจ';

  @override
  String get mrStability => 'ความมั่นคงในบ้าน';

  @override
  String get mrClarity => 'ความชัดเจน';

  @override
  String get mrChipHarmony => 'พันธะที่กลมกลืน';

  @override
  String get mrChipNoMangal => 'ไม่มี Mangal Dosh';

  @override
  String get mrChipLongLasting => 'ยั่งยืนยาวนาน';

  @override
  String get mrChipHome => 'มีแนวโน้มมีบ้านเป็นของตนเอง';

  @override
  String get mrChipInLaws => 'ญาติฝ่ายคู่สมรสดี';

  @override
  String get mrChipChildren => 'ได้รับพรเรื่องบุตร';

  @override
  String get mrSpouse => 'คู่สมรสในอนาคตของคุณ';

  @override
  String get mrSpouseSub => 'สิ่งที่ดวงชะตาบ่งบอก';

  @override
  String get mrSpouseTraits => 'บุคลิกภาพที่น่าจะเป็น';

  @override
  String get mrSpouseWork => 'อาชีพที่น่าจะเป็น';

  @override
  String get mrAgeDiff => 'ส่วนต่างของอายุ';

  @override
  String get mrCulture => 'ความเข้ากันทางวัฒนธรรม';

  @override
  String get mrEducation => 'การศึกษา';

  @override
  String get mrFamilyBg => 'ภูมิหลังครอบครัว';

  @override
  String get mrSoulPartnership => 'จิตวิญญาณและความเป็นหุ้นส่วน';

  @override
  String get mrSelfPlanet => 'ตัวคุณในความสัมพันธ์';

  @override
  String get mrSpousePlanet => 'ดาวคู่สมรสของคุณ';

  @override
  String get mrSoulAlignment => 'ความสอดคล้องทางจิตวิญญาณ';

  @override
  String get mrAlignStrong =>
      'จิตวิญญาณของคุณและคู่ครองในอุดมคติมีความสอดคล้องกันอย่างมาก — สนับสนุนพันธะที่สมหวังอย่างลึกซึ้ง';

  @override
  String get mrAlignModerate =>
      'จิตวิญญาณของคุณและคู่ครองในอุดมคติมีความสอดคล้องกันปานกลาง — พันธะที่สมหวังจะเติบโตได้ด้วยความพยายามอย่างมีสติ';

  @override
  String get mrAlignLow =>
      'จิตวิญญาณและความเป็นหุ้นส่วนของคุณต้องการการผสานอย่างมีสติ — เลือกคู่ครองที่สอดคล้องกับคุณค่าภายในของคุณอย่างแท้จริง';

  @override
  String get mrTechDarakaraka => 'ดาวคู่สมรส (Darakaraka)';

  @override
  String get mrUpapada => 'จุดการแต่งงาน (Upapada)';

  @override
  String get mrUpapadaLord => 'เจ้าเรือน Upapada';

  @override
  String get mrFoundation => 'รากฐานการแต่งงาน';

  @override
  String get mrMarriageSign => 'ราศีการแต่งงาน';

  @override
  String get mrMarriageLord => 'เจ้าเรือนการแต่งงาน';

  @override
  String get mrHouseStrength => 'ความแข็งแกร่งของเรือน';

  @override
  String get mrPartnerHint => 'เบาะแสเกี่ยวกับคู่ครองจากดวงชะตาของคุณ';

  @override
  String get mrHarmonyHdr => 'ความกลมกลืนด้านความเข้ากันได้';

  @override
  String get mrHarmonySub => 'คุณทั้งสองจะเชื่อมโยงกันอย่างไร';

  @override
  String get mrEmotional => 'ด้านอารมณ์';

  @override
  String get mrIntellectual => 'ด้านสติปัญญา';

  @override
  String get mrPhysical => 'ความใกล้ชิดทางกาย';

  @override
  String get mrFinancial => 'ด้านการเงิน';

  @override
  String get mrCommunication => 'การสื่อสาร';

  @override
  String get mrSharedValues => 'คุณค่าร่วมกัน';

  @override
  String get mrSpiritual => 'ด้านจิตวิญญาณ';

  @override
  String get mrConflictRes => 'การแก้ไขความขัดแย้ง';

  @override
  String get mrTiming => 'จังหวะเวลาการแต่งงาน';

  @override
  String get mrFirstMarriageAge => 'อายุที่น่าจะแต่งงาน';

  @override
  String get mrDelayChance => 'โอกาสล่าช้า';

  @override
  String get mrMarriageWindow => 'ช่วงเวลาการแต่งงาน';

  @override
  String get mrSecondaryWindow => 'ช่วงเวลาสำรอง';

  @override
  String get mrCurrentReadiness => 'ในตอนนี้';

  @override
  String get mrJourney => 'เส้นทางการแต่งงาน';

  @override
  String get mrJourneySub => 'พันธะจะพัฒนาไปอย่างไร';

  @override
  String get mrPhaseEarly => 'ช่วงปีแรก';

  @override
  String get mrPhaseMid => 'ช่วงปีกลาง';

  @override
  String get mrPhaseMature => 'ช่วงปีที่มั่นคง';

  @override
  String get mrPhaseLate => 'ช่วงปีหลัง';

  @override
  String get mrTip => 'เคล็ดลับ';

  @override
  String get mrFamilyHome => 'ครอบครัวและบ้าน';

  @override
  String get mrInLaws => 'ความสัมพันธ์กับญาติฝ่ายคู่สมรส';

  @override
  String get mrFamilyHarmony => 'ความกลมกลืนในครอบครัว';

  @override
  String get mrHomeOwnership => 'การเป็นเจ้าของบ้าน';

  @override
  String get mrDomesticPeace => 'ความสงบสุขในบ้าน';

  @override
  String get mrFertility => 'ภาวะเจริญพันธุ์';

  @override
  String get mrParenting => 'ความกลมกลืนในการเลี้ยงดูบุตร';

  @override
  String get mrChildren => 'บุตร';

  @override
  String get mrLikelyCount => 'จำนวนที่น่าจะเป็น';

  @override
  String get mrVerification => 'การยืนยันข้ามดวงชะตา';

  @override
  String get mrD9 => 'ดวงการแต่งงาน (D9)';

  @override
  String get mrD10 => 'ดวงอาชีพและคู่สมรส (D10)';

  @override
  String get mrD60 => 'ดวงกรรม (D60)';

  @override
  String get mrChallenges => 'ความท้าทายที่ควรจับตา';

  @override
  String get mrMangalPresent =>
      'มี Mangal Dosh ในดวงชะตา — ควรพิจารณาแนวทางแก้ไขและการจับคู่อย่างรอบคอบ';

  @override
  String get mrMangalAbsent =>
      'ไม่พบ Mangal Dosh — เป็นสัญญาณที่ดีต่อการแต่งงาน';

  @override
  String get mrRiskConflict => 'ความขัดแย้ง';

  @override
  String get mrRiskSeparation => 'การแยกทาง';

  @override
  String get mrRiskDistance => 'ความห่างเหินทางอารมณ์';

  @override
  String get mrRiskInfidelity => 'การนอกใจ';

  @override
  String get mrRiskFinance => 'ความขัดแย้งเรื่องเงิน';

  @override
  String get mrPartnerGuide => 'แนวทางเลือกคู่ครอง';

  @override
  String get mrPartnerGuideSub => 'สิ่งที่ควรมองหา';

  @override
  String get mrSeek => 'มองหา';

  @override
  String get mrMatchingPriorities => 'สิ่งที่ควรให้ความสำคัญในการจับคู่';

  @override
  String get mrImprovementPlan => 'แผนการพัฒนา';

  @override
  String get mrReliability => 'ความน่าเชื่อถือของการทำนาย';

  @override
  String get mrLayerBirth => 'ดวงกำเนิด (D1)';

  @override
  String get mrLayerNavamsa => 'Navamsa (D9)';

  @override
  String get mrLayerDashamsa => 'Dashamsa (D10)';

  @override
  String get mrLayerShashtiamsa => 'กรรม (D60)';

  @override
  String get mrLayerDarakaraka => 'ดาวคู่สมรส';

  @override
  String get mrTopicWhen => 'ฉันจะแต่งงานเมื่อใด';

  @override
  String get mrTopicSpouse => 'เกี่ยวกับคู่สมรสของฉัน';

  @override
  String get mrTopicCompat => 'เคล็ดลับความเข้ากันได้';

  @override
  String get mrTopicDelay => 'การแต่งงานล่าช้า';

  @override
  String get mrTopicMangal => 'Mangal Dosh';

  @override
  String get mrTopicChildren => 'จังหวะเวลามีบุตร';

  @override
  String get mrTopicInLaws => 'ความสัมพันธ์กับญาติฝ่ายคู่สมรส';

  @override
  String get mrTopicHarmony => 'การสร้างความกลมกลืน';

  @override
  String get wlSubtitle => 'รายงานความมั่งคั่งเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get wlTitle => 'ความมั่งคั่งและการเงิน';

  @override
  String get wlWealthPotential => 'ศักยภาพความมั่งคั่ง';

  @override
  String get wlAccumulation => 'การสะสมทรัพย์';

  @override
  String get wlIncomeFlow => 'กระแสรายได้';

  @override
  String get wlRetention => 'การรักษาทรัพย์สิน';

  @override
  String get wlSustainability => 'ความยั่งยืน';

  @override
  String get wlSavings => 'วินัยการออม';

  @override
  String get wlChipSaver => 'นักออมโดยธรรมชาติ';

  @override
  String get wlChipMultiIncome => 'มีรายได้หลายทาง';

  @override
  String get wlChipStrongYogas => 'Yoga แห่งความมั่งคั่ง';

  @override
  String get wlChipLowDebt => 'หนี้สินต่ำ';

  @override
  String get wlChipInheritance => 'มีแนวโน้มได้รับมรดก';

  @override
  String get wlChipInvestor => 'นักลงทุนที่ชาญฉลาด';

  @override
  String get wlWealthClass => 'ระดับความมั่งคั่ง';

  @override
  String get wlWealthType => 'ประเภทความมั่งคั่งหลัก';

  @override
  String get wlPrimarySource => 'รายได้หลัก';

  @override
  String get wlPeakAge => 'ช่วงอายุที่มั่งคั่งสูงสุด';

  @override
  String get wlBoosters => 'สิ่งที่เสริมความมั่งคั่งของคุณ';

  @override
  String get wlBoostersSub => 'การผสมผสานด้านการเงินที่ทรงพลัง';

  @override
  String get wlWealthImpact => 'เสริม';

  @override
  String get wlDrains => 'ตัวลดทอนความมั่งคั่ง';

  @override
  String get wlIncomeSources => 'แหล่งที่มาของรายได้';

  @override
  String get wlIncomeSourcesSub => 'เงินของคุณมาจากที่ใด';

  @override
  String get wlPrimary => 'หลัก';

  @override
  String get wlInvestment => 'แผนการลงทุน';

  @override
  String get wlInvestmentSub => 'สัดส่วนสินทรัพย์ที่เหมาะสม';

  @override
  String get wlRiskAppetite => 'ความเสี่ยงที่รับได้';

  @override
  String get wlInvestStyle => 'รูปแบบการลงทุน';

  @override
  String get wlDrivenBy => 'ขับเคลื่อนโดย';

  @override
  String get wlMoneyPersonality => 'บุคลิกภาพด้านการเงิน';

  @override
  String get wlMoneyType => 'ประเภทการเงิน';

  @override
  String get wlSpending => 'การใช้จ่าย';

  @override
  String get wlSavingsDiscipline => 'วินัยการออม';

  @override
  String get wlCharity => 'แนวโน้มการบริจาค';

  @override
  String get wlLuxury => 'การใช้จ่ายฟุ่มเฟือย';

  @override
  String get wlWindfalls => 'โชคลาภและโอกาส';

  @override
  String get wlWindfallsSub => 'เงินที่ได้จากโชค';

  @override
  String get wlInheritanceChance => 'มรดก';

  @override
  String get wlSuddenGains => 'รายได้ที่ได้มาอย่างฉับพลัน';

  @override
  String get wlLottery => 'หวย/การเก็งกำไร';

  @override
  String get wlInsurance => 'การเคลมประกัน';

  @override
  String get wlWindfallSource => 'แหล่งที่มาของโชคลาภที่น่าจะเป็น';

  @override
  String get wlMoneyPlanets => 'ดาวแห่งการเงินของคุณ';

  @override
  String get wlPrimaryKaraka => 'ดาวการเงินหลัก';

  @override
  String get wlSecondaryKaraka => 'ดาวการเงินรอง';

  @override
  String get wlTimeline => 'ไทม์ไลน์ความมั่งคั่ง';

  @override
  String get wlPeakYears => 'ปีที่รุ่งเรืองที่สุด';

  @override
  String get wlGoodPeriod => 'ช่วงเวลาที่รุ่งเรือง';

  @override
  String get wlSuddenGainWindow => 'ช่วงเวลารายได้ฉับพลัน';

  @override
  String get wlToughPeriod => 'ช่วงเวลาที่ควรระมัดระวัง';

  @override
  String get wlDebtRisks => 'หนี้สินและความเสี่ยงด้านการเงิน';

  @override
  String get wlDebtChance => 'โอกาสเป็นหนี้';

  @override
  String get wlLoanBurden => 'ภาระเงินกู้';

  @override
  String get wlDrainSources => 'สิ่งที่ควรระวัง';

  @override
  String get wlStrengthen => 'สิ่งที่ควรเสริมความแข็งแกร่ง';

  @override
  String get wlWeakestDriver => 'ปัจจัยขับเคลื่อนการเงินที่อ่อนแอที่สุด';

  @override
  String get wlHowToFix => 'วิธีเสริมความแข็งแกร่ง';

  @override
  String get wlImprovementPlan => 'แผนการพัฒนา';

  @override
  String get wlReliability => 'ความน่าเชื่อถือของการทำนาย';

  @override
  String get wlLayerBirth => 'เรือนความมั่งคั่ง (D1)';

  @override
  String get wlLayerHora => 'ดวง Hora (D2)';

  @override
  String get wlLayerNavamsa => 'Navamsa (D9)';

  @override
  String get wlLayerDasha => 'จังหวะเวลา Dasha';

  @override
  String get wlLayerTransit => 'การโคจรผ่านปัจจุบัน (Transit)';

  @override
  String get wlTopicGrow => 'จะสร้างความมั่งคั่งได้อย่างไร';

  @override
  String get wlTopicInvest => 'ควรลงทุนที่ใด';

  @override
  String get wlTopicDebt => 'การจัดการหนี้สิน';

  @override
  String get wlTopicProperty => 'การซื้ออสังหาริมทรัพย์';

  @override
  String get wlTopicRetire => 'การวางแผนเกษียณ';

  @override
  String get wlTopicPassive => 'รายได้แบบพาสซีฟ';

  @override
  String get wlTopicWindfall => 'รายได้ที่ได้มาอย่างฉับพลัน';

  @override
  String get wlTopicTiming => 'จังหวะเวลาด้านการเงินที่ดีที่สุด';

  @override
  String get bzSubtitle => 'รายงานธุรกิจเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get bzTitle => 'ธุรกิจและสตาร์ทอัพ';

  @override
  String get bzBusinessPotential => 'ศักยภาพทางธุรกิจ';

  @override
  String get bzEntrepreneurship => 'ความเป็นผู้ประกอบการ';

  @override
  String get bzVenture => 'ความสำเร็จของกิจการ';

  @override
  String get bzWealth => 'ความมั่งคั่งจากธุรกิจ';

  @override
  String get bzRiskAppetite => 'ความเสี่ยงที่รับได้';

  @override
  String get bzLongevity => 'ความยั่งยืน';

  @override
  String get bzChipWealthMagnet => 'แม่เหล็กดึงดูดความมั่งคั่ง';

  @override
  String get bzChipMoneyYoga => 'Yoga แห่งเงินทอง';

  @override
  String get bzChipLeadership => 'ความเป็นผู้นำ';

  @override
  String get bzChipPartnerFit => 'เหมาะกับการมีหุ้นส่วน';

  @override
  String get bzChipGains => 'ผลกำไรที่แข็งแกร่ง';

  @override
  String get bzChipInvestor => 'น่าสนใจสำหรับนักลงทุน';

  @override
  String get bzChipFounder => 'แนวคิดแบบผู้ก่อตั้ง';

  @override
  String get bzWhatsWorking => 'สิ่งที่เป็นข้อได้เปรียบของคุณ';

  @override
  String get bzWhatsWorkingSub => 'พรสวรรค์ทางธุรกิจของคุณ';

  @override
  String get bzClassicYogas => 'การผสมผสานความมั่งคั่งแบบคลาสสิก';

  @override
  String get bzFounderType => 'ประเภทผู้ก่อตั้งของคุณ';

  @override
  String get bzSoulBusiness => 'จิตวิญญาณและเป้าหมายทางธุรกิจ';

  @override
  String get bzSoulPlanet => 'แรงขับจิตวิญญาณของคุณ';

  @override
  String get bzBusinessPlanet => 'จิตใจทางธุรกิจของคุณ';

  @override
  String get bzDirectionStrength => 'ความชัดเจนของทิศทาง';

  @override
  String get bzAlignStrong =>
      'เป้าหมายจิตวิญญาณและทิศทางธุรกิจของคุณสอดคล้องกันอย่างมาก — การสร้างกิจการจะรู้สึกเป็นธรรมชาติและสมหวัง';

  @override
  String get bzAlignModerate =>
      'เป้าหมายจิตวิญญาณและทิศทางธุรกิจของคุณสอดคล้องกันปานกลาง — กิจการจะทำงานได้ดีที่สุดเมื่อสะท้อนคุณค่าที่ลึกซึ้งของคุณ';

  @override
  String get bzAlignLow =>
      'เป้าหมายจิตวิญญาณและทิศทางธุรกิจของคุณต้องการการปรับให้สอดคล้องกันอย่างมีสติ — เลือกกิจการที่ตรงกับตัวตนของคุณอย่างแท้จริง';

  @override
  String get bzTechAtmakaraka => 'ดาวแห่งจิตวิญญาณ (Atmakaraka)';

  @override
  String get bzTechAmatyakaraka => 'ดาวแห่งธุรกิจ (Amatyakaraka)';

  @override
  String get bzTechDarakaraka => 'ดาวแห่งหุ้นส่วน (Darakaraka)';

  @override
  String get bzFoundation => 'รากฐานทางธุรกิจ';

  @override
  String get bzCareerHouse => 'เรือนอาชีพ';

  @override
  String get bzGainsHouse => 'เรือนผลได้';

  @override
  String get bzLord => 'เจ้าเรือน';

  @override
  String get bzGainsPotential => 'ศักยภาพผลได้';

  @override
  String get bzNetwork => 'พลังเครือข่าย';

  @override
  String get bzRecovery => 'ความแข็งแกร่งในการฟื้นตัว';

  @override
  String get bzVerification => 'การยืนยันข้ามดวงชะตา';

  @override
  String get bzD10 => 'ดวงอาชีพ (D10)';

  @override
  String get bzD11 => 'ดวงผลได้ (D11)';

  @override
  String get bzD9 => 'ดวงเป้าหมาย (D9)';

  @override
  String get bzD60 => 'ดวงกรรม (D60)';

  @override
  String get bzFounderSkills => 'ทักษะของผู้ก่อตั้ง';

  @override
  String get bzSkillStrategy => 'การคิดเชิงกลยุทธ์';

  @override
  String get bzSkillExecution => 'การลงมือปฏิบัติ';

  @override
  String get bzSkillPeople => 'การบริหารคน';

  @override
  String get bzSkillSales => 'การขายและการโน้มน้าวใจ';

  @override
  String get bzSkillFinance => 'ไหวพริบทางการเงิน';

  @override
  String get bzSkillOps => 'วินัยด้านการปฏิบัติงาน';

  @override
  String get bzTopSkill => 'ทักษะเด่นที่สุด';

  @override
  String get bzDomains => 'สาขาธุรกิจที่เหมาะที่สุด';

  @override
  String get bzDomainsSub => 'จัดอันดับตามความเหมาะสมโดยธรรมชาติ';

  @override
  String get bzFit => 'ความเหมาะสม';

  @override
  String get bzBusinessStyleHdr => 'รูปแบบธุรกิจ';

  @override
  String get bzStyleService => 'สินค้าหรือบริการ';

  @override
  String get bzStyleMarket => 'จุดเน้นตลาด';

  @override
  String get bzStyleTech => 'แนวทางด้านเทคโนโลยี';

  @override
  String get bzStyleLeadership => 'รูปแบบความเป็นผู้นำ';

  @override
  String get bzStylePartnership => 'ทำคนเดียวหรือมีหุ้นส่วน';

  @override
  String get bzWhereBuild => 'ขอบเขตการเข้าถึง';

  @override
  String get bzExpansion => 'การขยายกิจการ';

  @override
  String get bzSetup => 'การจัดตั้ง';

  @override
  String get bzPartnership => 'หุ้นส่วนและทีมงาน';

  @override
  String get bzIdealCofounder => 'ผู้ร่วมก่อตั้งในอุดมคติ';

  @override
  String get bzPartnerViability => 'ความเหมาะสมกับการมีหุ้นส่วน';

  @override
  String get bzTeamBuilding => 'การสร้างทีม';

  @override
  String get bzCofounderFit => 'ความเหมาะสมกับผู้ร่วมก่อตั้ง';

  @override
  String get bzAdvisorNetwork => 'เครือข่ายที่ปรึกษา';

  @override
  String get bzFunding => 'เงินทุนและการเงิน';

  @override
  String get bzRecommendedPath => 'แนวทางการระดมทุนที่แนะนำ';

  @override
  String get bzInvestorAttract => 'ความน่าสนใจสำหรับนักลงทุน';

  @override
  String get bzFamilyBacking => 'การสนับสนุนจากครอบครัว';

  @override
  String get bzHybridViability => 'การทำงานประจำควบคู่ธุรกิจ';

  @override
  String get bzFallback => 'งานประจำเป็นทางสำรอง';

  @override
  String get bzDebtStyle => 'รูปแบบการก่อหนี้';

  @override
  String get bzTimeline => 'ไทม์ไลน์ธุรกิจ';

  @override
  String get bzCurrentPhase => 'ในตอนนี้';

  @override
  String get bzLaunchWindow => 'ช่วงเวลาเปิดตัว';

  @override
  String get bzScaleWindow => 'ช่วงเวลาการเติบโต';

  @override
  String get bzPeakAge => 'ปีที่รุ่งเรืองที่สุด';

  @override
  String get bzChallenges => 'ความท้าทายที่ควรจับตา';

  @override
  String get bzRiskFinancial => 'ความเสี่ยงขาดทุน';

  @override
  String get bzRiskBurnout => 'ภาวะหมดไฟ';

  @override
  String get bzRiskTeam => 'ความขัดแย้งในทีม';

  @override
  String get bzRiskLegal => 'กฎหมาย/ข้อกำกับดูแล';

  @override
  String get bzFinancialExp =>
      'ความเสี่ยงขาดทุนจากการลงทุนเกินตัวหรือจังหวะกระแสเงินสดที่ไม่เหมาะสมระหว่างดำเนินกิจการ';

  @override
  String get bzFinancialFix =>
      'สำรองเงินสดไว้ เริ่มต้นแบบประหยัด และตรวจสอบความต้องการของตลาดก่อนขยายการลงทุน';

  @override
  String get bzBurnoutExp =>
      'การผลักดันตัวเองหนักเกินไปเป็นเวลานานอาจบั่นทอนพลังงานและสมาธิของคุณ';

  @override
  String get bzBurnoutFix =>
      'รักษาเวลาพักผ่อน มอบหมายงานแต่เนิ่นๆ และวางจังหวะการผลักดันครั้งใหญ่ให้ตรงกับช่วงเวลาที่เอื้ออำนวย';

  @override
  String get bzTeamExp =>
      'ความขัดแย้งกับผู้ร่วมก่อตั้งหรือพนักงานอาจทำให้ธุรกิจชะลอตัว';

  @override
  String get bzTeamFix =>
      'กำหนดบทบาทและความคาดหวังเป็นลายลักษณ์อักษรให้ชัดเจน และสื่อสารกันอย่างสม่ำเสมอ';

  @override
  String get bzLegalExp =>
      'ปัญหาด้านการปฏิบัติตามกฎระเบียบ สัญญา หรือข้อกำกับดูแลอาจเป็นอุปสรรค';

  @override
  String get bzLegalFix =>
      'ให้ตรวจสอบสัญญา จัดเก็บเอกสารให้เรียบร้อย และปรึกษาผู้เชี่ยวชาญแต่เนิ่นๆ';

  @override
  String get bzImprovementPlan => 'แผนการพัฒนา';

  @override
  String get bzBestDirection => 'ทิศทางที่ดีที่สุด';

  @override
  String get bzStrategy => 'กลยุทธ์การสร้างธุรกิจ';

  @override
  String get bzTopFields => 'สาขาชั้นนำ';

  @override
  String get bzEmploymentPath => 'งานประจำหรือธุรกิจส่วนตัว';

  @override
  String get bzRoadmap => 'แผนที่นำทางการเติบโต';

  @override
  String get bzRoadmapSub => 'แผนกิจการของคุณ';

  @override
  String get bzReliability => 'ความน่าเชื่อถือของการทำนาย';

  @override
  String get bzLayerBirth => 'ดวงกำเนิด (D1)';

  @override
  String get bzLayerNavamsa => 'Navamsa (D9)';

  @override
  String get bzLayerDashamsa => 'อาชีพ (D10)';

  @override
  String get bzLayerLabhamsa => 'ผลได้ (D11)';

  @override
  String get bzLayerShashtiamsa => 'กรรม (D60)';

  @override
  String get bzTopicStart => 'ฉันควรเริ่มต้นตอนนี้หรือไม่';

  @override
  String get bzTopicIdea => 'ไอเดียธุรกิจที่ดีที่สุด';

  @override
  String get bzTopicPartner => 'การหาผู้ร่วมก่อตั้ง';

  @override
  String get bzTopicFunding => 'จะระดมทุนได้อย่างไร';

  @override
  String get bzTopicScale => 'ควรขยายกิจการเมื่อใด';

  @override
  String get bzTopicRisk => 'การจัดการความเสี่ยง';

  @override
  String get bzTopicJob => 'งานประจำหรือธุรกิจส่วนตัว';

  @override
  String get bzTopicTiming => 'จังหวะเวลาที่ดีที่สุด';

  @override
  String get crTitle => 'การวิเคราะห์อาชีพและการงาน';

  @override
  String get crSubtitle => 'รายงานอาชีพเชิงเวทที่ขับเคลื่อนด้วย AI';

  @override
  String get crCrumbHome => 'หน้าแรก';

  @override
  String get crCrumbReports => 'รายงาน';

  @override
  String get crCareerPotential => 'ศักยภาพทางอาชีพ';

  @override
  String get crStatusStrong => 'ศักยภาพแข็งแกร่ง';

  @override
  String get crStatusGood => 'ศักยภาพดี';

  @override
  String get crStatusModerate => 'ศักยภาพปานกลาง';

  @override
  String get crStatusDeveloping => 'ศักยภาพกำลังพัฒนา';

  @override
  String get crStatusChallenging => 'ระยะที่ท้าทาย';

  @override
  String get crOverallCareer => 'อาชีพโดยรวม';

  @override
  String get crStability => 'ความมั่นคงทางอาชีพ';

  @override
  String get crGrowth => 'ศักยภาพการเติบโต';

  @override
  String get crRecognition => 'การได้รับการยอมรับ';

  @override
  String get crSatisfaction => 'ความพึงพอใจ';

  @override
  String get crChipLeadership => 'ความเป็นผู้นำ';

  @override
  String get crChipCreativity => 'ความคิดสร้างสรรค์';

  @override
  String get crChipBusiness => 'ธุรกิจ';

  @override
  String get crChipStableIncome => 'รายได้มั่นคง';

  @override
  String get crChipLearning => 'การเรียนรู้';

  @override
  String get crChipGrowth => 'การเติบโตระยะยาว';

  @override
  String get crChipTechnical => 'ทักษะเชิงเทคนิค';

  @override
  String get crChipRecognition => 'การได้รับการยอมรับ';

  @override
  String get crTopInsights => 'ข้อมูลเชิงลึกสำคัญ';

  @override
  String get crWhatDefines => 'อะไรคือสิ่งที่กำหนดอาชีพของคุณ';

  @override
  String get crSoulCareer => 'จิตวิญญาณและเป้าหมายทางอาชีพ';

  @override
  String get crSoulPlanet => 'ดาวแห่งเป้าหมายจิตวิญญาณ';

  @override
  String get crCareerPlanet => 'ดาวแห่งอาชีพ';

  @override
  String get crMeaning => 'ความหมาย';

  @override
  String get crAlignment => 'ความสอดคล้องระหว่างจิตวิญญาณกับอาชีพ';

  @override
  String get crAlignStrong =>
      'ความสนใจโดยธรรมชาติของคุณและเส้นทางอาชีพสอดคล้องกันอย่างมาก';

  @override
  String get crAlignModerate =>
      'ความสนใจโดยธรรมชาติของคุณและเส้นทางอาชีพสอดคล้องกันปานกลาง';

  @override
  String get crAlignLow =>
      'ความสนใจโดยธรรมชาติของคุณและเส้นทางอาชีพต้องการการปรับให้สอดคล้องกันอย่างมีสติ';

  @override
  String get crTechAtmakaraka => 'Atmakaraka (ตัวชี้วัดจิตวิญญาณ)';

  @override
  String get crTechAmatyakaraka => 'Amatyakaraka (ตัวชี้วัดอาชีพ)';

  @override
  String get crDegrees => 'องศา';

  @override
  String get crDignity => 'ศักดิ์';

  @override
  String get crFoundation => 'รากฐานทางอาชีพ';

  @override
  String get crCareerSign => 'ราศีอาชีพ';

  @override
  String get crCareerLord => 'เจ้าเรือนอาชีพ';

  @override
  String get crLordPosition => 'ตำแหน่งเจ้าเรือน';

  @override
  String get crCareerStrength => 'ความแข็งแกร่งทางอาชีพ';

  @override
  String get crProfStyle => 'รูปแบบการทำงานมืออาชีพ';

  @override
  String get crBestFields => 'สาขาที่เหมาะที่สุด';

  @override
  String get crTechnicalDetails => 'รายละเอียดเชิงเทคนิค';

  @override
  String get crHouseLabel => 'เรือน';

  @override
  String get crVerification => 'การยืนยันด้านอาชีพข้ามดวงชะตา';

  @override
  String get crD10Career => 'D10 · อาชีพ';

  @override
  String get crD9Purpose => 'D9 · เป้าหมาย';

  @override
  String get crD60Karma => 'D60 · กรรม';

  @override
  String get crStatusNeedsImprovement => 'ต้องปรับปรุง';

  @override
  String get crStatusWellAligned => 'สอดคล้องดี';

  @override
  String get crStatusStrongSupport => 'สนับสนุนอย่างแข็งแกร่ง';

  @override
  String get crStatusModerateSupport => 'สนับสนุนปานกลาง';

  @override
  String get crChartDetails => 'รายละเอียดดวงชะตาเชิงเทคนิค';

  @override
  String get crPersonality => 'บุคลิกภาพทางอาชีพของคุณ';

  @override
  String get crGrowthAreas => 'ด้านที่ควรพัฒนา';

  @override
  String get crBestRoles => 'บทบาทที่เหมาะที่สุด';

  @override
  String get crBestIndustries => 'อุตสาหกรรมที่เหมาะที่สุด';

  @override
  String get crEnvironment => 'สภาพแวดล้อมการทำงาน';

  @override
  String get crWorkStyle => 'รูปแบบการทำงานที่เหมาะที่สุด';

  @override
  String get crEmployment => 'การเป็นลูกจ้าง';

  @override
  String get crBusiness => 'ธุรกิจ';

  @override
  String get crFreelance => 'ฟรีแลนซ์/ที่ปรึกษา';

  @override
  String get crPortfolio => 'แบบผสมผสาน';

  @override
  String get crLeadership => 'ความเป็นผู้นำ';

  @override
  String get crFit => 'ความเหมาะสม';

  @override
  String get crBestFit => 'เหมาะสมที่สุด';

  @override
  String get crTimeline => 'ไทม์ไลน์อาชีพ';

  @override
  String get crPastPeak => 'จุดสูงสุดในอดีต';

  @override
  String get crPresentPhase => 'ระยะปัจจุบัน';

  @override
  String get crUpcoming => 'โอกาสที่กำลังจะมาถึง';

  @override
  String get crFutureExpansion => 'การขยายตัวในอนาคต';

  @override
  String get crRiskPeriod => 'ช่วงเวลาเสี่ยง';

  @override
  String get crViewDasha => 'ช่วงดาวเคราะห์ (เชิงเทคนิค)';

  @override
  String get crChallenges => 'ความท้าทายที่ควรจับตา';

  @override
  String get crRiskBurnout => 'ภาวะหมดไฟ';

  @override
  String get crRiskRecognition => 'การยอมรับที่ล่าช้า';

  @override
  String get crRiskConflict => 'ความขัดแย้งในที่ทำงาน';

  @override
  String get crRiskFinancial => 'ความไม่มั่นคงทางการเงิน';

  @override
  String get crRiskOverqual => 'การใช้ศักยภาพไม่เต็มที่';

  @override
  String get crPrevention => 'การป้องกัน';

  @override
  String get crBurnoutExp =>
      'ช่วงเวลาที่ยาวนานและกดดันอาจบั่นทอนพลังงานของคุณเมื่อเวลาผ่านไป';

  @override
  String get crBurnoutFix =>
      'รักษาเวลาพักผ่อน ตั้งขอบเขต และวางจังหวะการทุ่มเทให้เหมาะสม';

  @override
  String get crRecognitionExp =>
      'รางวัลและการยอมรับอาจมาช้ากว่าความพยายามที่คุณทุ่มเท';

  @override
  String get crRecognitionFix =>
      'บันทึกผลงานความสำเร็จและทำให้ผู้บังคับบัญชาเห็นคุณูปการของคุณ';

  @override
  String get crConflictExp =>
      'ความขัดแย้งกับเพื่อนร่วมงานหรือผู้มีอำนาจอาจเกิดขึ้นได้เป็นครั้งคราว';

  @override
  String get crConflictFix =>
      'สื่อสารอย่างสงบและเลือกต่อสู้ในเรื่องที่คุ้มค่าอย่างชาญฉลาด';

  @override
  String get crFinancialExp => 'รายได้อาจรู้สึกไม่สม่ำเสมอในบางช่วงเวลา';

  @override
  String get crFinancialFix =>
      'สำรองเงินไว้และหลีกเลี่ยงการผูกมัดทางการเงินมากเกินไป';

  @override
  String get crOverqualExp =>
      'บางครั้งคุณอาจรู้สึกว่าไม่ได้ใช้ศักยภาพเต็มที่หรือขาดความท้าทาย';

  @override
  String get crOverqualFix =>
      'มองหาบทบาทที่ท้าทายมากขึ้นและเรียนรู้อย่างต่อเนื่องเพื่อรักษาความมีส่วนร่วม';

  @override
  String get crImprovementPlan => 'แผนการพัฒนาอาชีพ';

  @override
  String get crCatPlanetary => 'ด้านดาวเคราะห์และจิตวิญญาณ';

  @override
  String get crCatPractical => 'ขั้นตอนปฏิบัติจริง';

  @override
  String get crTraditionalExplain => 'คำอธิบายตามโหราศาสตร์แบบดั้งเดิม';

  @override
  String get crActionPlan => 'แผนปฏิบัติการอาชีพ 30 วัน';

  @override
  String get crWeek1 => 'สัปดาห์ที่ 1 · ปรับปรุงโปรไฟล์';

  @override
  String get crWeek2 => 'สัปดาห์ที่ 2 · พัฒนาทักษะ';

  @override
  String get crWeek3 => 'สัปดาห์ที่ 3 · สร้างเครือข่าย';

  @override
  String get crWeek4 => 'สัปดาห์ที่ 4 · สร้างการมองเห็นด้านอาชีพ';

  @override
  String get crWeek1Tip =>
      'ปรับปรุงเรซูเม่และ LinkedIn ของคุณให้เน้นจุดแข็งทางอาชีพที่โดดเด่นที่สุด';

  @override
  String get crWeek2Tip =>
      'เลือกทักษะที่มีคุณค่าสูงหนึ่งอย่างในสาขาที่เหมาะกับคุณและฝึกฝนทุกวัน';

  @override
  String get crWeek3Tip =>
      'ติดต่อพี่เลี้ยงอีกครั้งและติดต่อผู้ติดต่อใหม่ในวงการอีกสองคน';

  @override
  String get crWeek4Tip =>
      'แบ่งปันผลงานของคุณต่อสาธารณะและอาสาทำโครงการที่มีการมองเห็นสูง';

  @override
  String get crPriority => 'ลำดับความสำคัญ';

  @override
  String get crTimeRequired => 'เวลา';

  @override
  String get crExpectedBenefit => 'ประโยชน์';

  @override
  String get crPriorityHigh => 'สูง';

  @override
  String get crPriorityMedium => 'ปานกลาง';

  @override
  String get crRoadmap => 'แผนที่นำทางอาชีพจาก AI';

  @override
  String get crNext12 => '12 เดือนข้างหน้า';

  @override
  String get crBestFocus => 'จุดเน้นที่ดีที่สุด';

  @override
  String get crSkillsLearn => 'ทักษะที่ควรเรียนรู้';

  @override
  String get crIndustriesTarget => 'อุตสาหกรรมเป้าหมาย';

  @override
  String get crExpectedOutcome => 'ผลลัพธ์ที่คาดหวัง';

  @override
  String get crReliability => 'ความน่าเชื่อถือของการทำนาย';

  @override
  String get crReliabilityHigh => 'ความน่าเชื่อถือสูง';

  @override
  String get crReliabilityGood => 'ความน่าเชื่อถือดี';

  @override
  String get crReliabilityModerate => 'ความน่าเชื่อถือปานกลาง';

  @override
  String get crReliabilityExplain =>
      'รายงานนี้ผสมผสานดวงกำเนิด ดวงแบ่งภาค และตัวชี้วัดแบบ Jaimini ของคุณ คะแนนสะท้อนถึงระดับความสอดคล้องกันของชั้นข้อมูลดวงชะตาเหล่านี้';

  @override
  String get crChartLayers => 'ชั้นดวงชะตาและน้ำหนัก';

  @override
  String get crBirthChart => 'ดวงกำเนิด (D1)';

  @override
  String get crNavamsa => 'Navamsa (D9)';

  @override
  String get crDashamsa => 'Dashamsa (D10)';

  @override
  String get crShashtiamsa => 'Shashtiamsa (D60)';

  @override
  String get crDiscussAi => 'พูดคุยกับ AI';

  @override
  String get crAskAbout => 'ถามเกี่ยวกับ';

  @override
  String get crTopicChange => 'การเปลี่ยนสายอาชีพ';

  @override
  String get crTopicGovt => 'งานราชการ';

  @override
  String get crTopicBusiness => 'ธุรกิจ';

  @override
  String get crTopicPromotion => 'การเลื่อนตำแหน่ง';

  @override
  String get crTopicMarriage => 'การแต่งงานกับอาชีพ';

  @override
  String get crTopicAbroad => 'ต่างประเทศ';

  @override
  String get crTopicIncome => 'รายได้';

  @override
  String get crTopicPurpose => 'เป้าหมาย';

  @override
  String get crTopicResume => 'เรซูเม่';

  @override
  String get crTopicCopied => 'คัดลอกคำถามแล้ว — วางลงในแชท AI ของคุณ';

  @override
  String crAlignExplainKaraka(Object soul, Object career) {
    return '$soul นำทางเสียงเรียกจากภายในของคุณ ในขณะที่ $career หล่อหลอมอาชีพภายนอกของคุณ';
  }

  @override
  String get rzTodayOutlook => 'แนวโน้มดวงประจำวันของราศี';

  @override
  String get rzPlanetaryEnergy => 'พลังงานดาวเคราะห์วันนี้';

  @override
  String get rzBestSign => 'ราศีที่ดีที่สุด';

  @override
  String get rzChallengingSign => 'ราศีที่ท้าทายที่สุด';

  @override
  String get rzDominantPlanet => 'ดาวเด่น';

  @override
  String get rzOverallMood => 'อารมณ์โดยรวม';

  @override
  String get rzMoodBright => 'สดใสและกระตือรือร้น';

  @override
  String get rzMoodCalm => 'สงบและมั่นคง';

  @override
  String get rzMoodMixed => 'พลังงานผสมผสาน';

  @override
  String get rzMoodTense => 'ตึงเครียดและควรระมัดระวัง';

  @override
  String get rzTodayEnergy => 'พลังงานวันนี้';

  @override
  String get rzCaution => 'ควรระวัง';

  @override
  String get rzWeak => 'อ่อนแอ';

  @override
  String get rzAllSigns => 'ราศีทั้งหมด';

  @override
  String get rzAiSummary => 'สรุปโดย AI';

  @override
  String get rzPlanetaryInfluence => 'อิทธิพลดาวเคราะห์วันนี้';

  @override
  String get rzStrongInfluences => 'อิทธิพลที่แข็งแกร่ง';

  @override
  String get rzShowTechnical => 'แสดงรายละเอียดเชิงเทคนิค';

  @override
  String get rzOpportunities => 'โอกาสวันนี้';

  @override
  String get rzAvoidTitle => 'สิ่งที่ควรหลีกเลี่ยงวันนี้';

  @override
  String get rzTechnicalReason => 'เหตุผลเชิงเทคนิค';

  @override
  String get rzAvoidDecisions => 'การรีบตัดสินใจเรื่องสำคัญ';

  @override
  String get rzAvoidArguments => 'การโต้เถียงอย่างรุนแรง';

  @override
  String get rzAvoidInvestments => 'การลงทุนก้อนใหญ่';

  @override
  String get rzAvoidOverthink => 'การคิดมากกับเรื่องเล็กน้อย';

  @override
  String get rzAvoidOverspend => 'การใช้จ่ายที่ไม่จำเป็น';

  @override
  String get rzAvoidStress => 'ความเครียดและการทำงานหนักเกินไป';

  @override
  String get rzPlanetaryChart => 'ดวงดาวเคราะห์วันนี้';

  @override
  String get rzWhatChartMeans => 'ดวงนี้หมายความว่าอย่างไร';

  @override
  String get rzChartExplain =>
      'แผนภาพนี้แสดงตำแหน่งของดาวแต่ละดวงบนท้องฟ้าวันนี้ เทียบกับราศีของคุณ ดาวที่อยู่ในเรือนที่เอื้ออำนวยจะช่วยเสริมวัน ส่วนดาวในเรือนที่ท้าทายต้องการความระมัดระวัง';

  @override
  String get rzDoNetworking => 'การสร้างเครือข่ายและเชื่อมโยง';

  @override
  String get rzDoLearning => 'การเรียนรู้สิ่งใหม่';

  @override
  String get rzDoMeditation => 'การทำสมาธิและความสงบ';

  @override
  String get rzDoFamily => 'เวลาสำหรับครอบครัว';

  @override
  String get rzDoCreative => 'งานสร้างสรรค์';

  @override
  String get rzDoRest => 'การพักผ่อนและดูแลตนเอง';

  @override
  String get rzAiRecommendations => 'คำแนะนำจาก AI วันนี้';

  @override
  String get rzTechnical => 'โหราศาสตร์เชิงเทคนิค';

  @override
  String get rzTransitScore => 'คะแนน Transit';

  @override
  String get rzVedha => 'Vedha (อุปสรรค)';

  @override
  String get rzGocharDetails => 'รายละเอียด Gochar';

  @override
  String get rzAdvancedOnly => 'สำหรับผู้ใช้ขั้นสูง';

  @override
  String get rzTomorrow => 'แนวโน้มวันพรุ่งนี้';

  @override
  String get rzTomorrowEnergy => 'พลังงานวันพรุ่งนี้';

  @override
  String get rzImproving => 'กำลังดีขึ้น';

  @override
  String get rzWeaker => 'อ่อนลงเล็กน้อย';

  @override
  String get rzSteady => 'คงที่';

  @override
  String get rzTomorrowUpLine =>
      'คาดว่าพลังงานจะเพิ่มขึ้นในวันพรุ่งนี้ — วางแผนล่วงหน้าสำหรับงานสำคัญ';

  @override
  String get rzTomorrowDownLine =>
      'พลังงานอาจลดลงเล็กน้อยในวันพรุ่งนี้ — ทำให้วันนั้นเบาสบายและมั่นคง';

  @override
  String get rzTomorrowFlatLine =>
      'พลังงานคงที่ในวันพรุ่งนี้ — เป็นวันที่สงบและสมดุล';

  @override
  String get rzWeeklyTrend => 'แนวโน้มรายสัปดาห์';

  @override
  String get rzMonthlyTrend => 'แนวโน้มรายเดือน';

  @override
  String get rzBestDayWeek => 'วันที่ดีที่สุด';

  @override
  String get rzHardestDay => 'วันที่ยากที่สุด';

  @override
  String get rzLuckyToday => 'โชคดีวันนี้';

  @override
  String get rzKarakaSun => 'ความมั่นใจและพลังชีวิต';

  @override
  String get rzKarakaMoon => 'อารมณ์และความสงบใจ';

  @override
  String get rzKarakaMars => 'พลังงานและแรงขับเคลื่อน';

  @override
  String get rzKarakaMercury => 'การสื่อสารและการเรียนรู้';

  @override
  String get rzKarakaJupiter => 'ปัญญาและการเติบโต';

  @override
  String get rzKarakaVenus => 'ความสัมพันธ์และความสะดวกสบาย';

  @override
  String get rzKarakaSaturn => 'วินัยและความอดทน';

  @override
  String get rzKarakaRahu => 'ความทะเยอทะยานและการเปลี่ยนแปลง';

  @override
  String get rzKarakaKetu => 'จิตวิญญาณและการปล่อยวาง';

  @override
  String rzHomeSummary(Object dom, Object chal) {
    return '$dom กำหนดโทนของวัน ในขณะที่ $chal ต้องการความอดทนและความระมัดระวัง';
  }

  @override
  String rzInsightGood(Object karaka) {
    return 'วันนี้ดีสำหรับ $karaka';
  }

  @override
  String rzInsightHard(Object karaka) {
    return 'วันนี้ควรค่อยเป็นค่อยไปกับเรื่อง $karaka';
  }

  @override
  String rzInfluenceGood(Object karaka) {
    return '$karaka ได้รับการสนับสนุนที่ดีในวันนี้';
  }

  @override
  String rzInfluenceHard(Object karaka) {
    return '$karaka อาจพบความล่าช้าในวันนี้';
  }

  @override
  String rzDetailSummary(Object strong, Object weak) {
    return 'วันนี้สนับสนุน $strong ในขณะที่ $weak ต้องการความอดทนและความระมัดระวัง';
  }

  @override
  String get fdEnergyScore => 'คะแนนพลังงานวันนี้';

  @override
  String get fdStatusAverage => 'ปานกลาง';

  @override
  String get fdStatusMixed => 'ผสมผสาน';

  @override
  String get fdStatusChallenging => 'ท้าทาย';

  @override
  String get fdTheme => 'ธีมของวันนี้';

  @override
  String get fdExplainToday => 'อธิบายวันนี้';

  @override
  String get fdTodaysFocus => 'จุดเน้นวันนี้';

  @override
  String get fdTopRecommendation => 'คำแนะนำอันดับต้น';

  @override
  String get fdTopCaution => 'ข้อควรระวังอันดับต้น';

  @override
  String get fdReadingTime => 'เวลาในการอ่าน';

  @override
  String get fdSeconds30 => '30 วินาที';

  @override
  String get fdCareer => 'อาชีพ';

  @override
  String get fdMoney => 'การเงิน';

  @override
  String get fdLove => 'ความรัก';

  @override
  String get fdHealth => 'สุขภาพ';

  @override
  String get fdTravel => 'การเดินทาง';

  @override
  String get fdFamily => 'ครอบครัว';

  @override
  String get fdBestToDo => 'สิ่งที่ควรทำวันนี้';

  @override
  String get fdAvoidToday => 'สิ่งที่ควรหลีกเลี่ยงวันนี้';

  @override
  String get fdConfidenceLabel => 'ความเชื่อมั่น';

  @override
  String get fdBestTime => 'เวลาที่เหมาะสมที่สุด';

  @override
  String get fdRecommended => 'แนะนำ';

  @override
  String get fdReason => 'เหตุผล';

  @override
  String get fdRisk => 'ความเสี่ยง';

  @override
  String get fdRecommendation => 'คำแนะนำ';

  @override
  String get fdNoActions =>
      'ไม่มีอะไรสำคัญที่ต้องเร่งทำวันนี้ — ทำกิจวัตรตามปกติอย่างสงบและมั่นคง';

  @override
  String get fdNoCautions =>
      'ไม่มีข้อควรระวังสำคัญวันนี้ — ดำเนินชีวิตตามปกติด้วยความรอบคอบ';

  @override
  String get fdHighlights => 'ไฮไลต์ของวันนี้';

  @override
  String get fdProbVeryHigh => 'สูงมาก';

  @override
  String get fdProbHigh => 'สูง';

  @override
  String get fdProbElevated => 'ค่อนข้างสูง';

  @override
  String get fdProbCaution => 'ควรระวัง';

  @override
  String get fdWhatToDo => 'สิ่งที่ควรทำ';

  @override
  String get fdLifeAreas => 'ด้านต่างๆ ของชีวิต';

  @override
  String get fdTapDetails => 'แตะเพื่อดูรายละเอียด';

  @override
  String get fdArea1 => 'ตนเองและสุขภาพ';

  @override
  String get fdArea2 => 'ทรัพย์สินและครอบครัว';

  @override
  String get fdArea3 => 'การสื่อสาร';

  @override
  String get fdArea4 => 'บ้านและความสะดวกสบาย';

  @override
  String get fdArea5 => 'ความคิดสร้างสรรค์และความรัก';

  @override
  String get fdArea6 => 'งานและหน้าที่';

  @override
  String get fdArea7 => 'ความสัมพันธ์';

  @override
  String get fdArea8 => 'การเปลี่ยนแปลงและความลึกซึ้ง';

  @override
  String get fdArea9 => 'โชคลาภและการเดินทาง';

  @override
  String get fdArea10 => 'อาชีพและสถานะ';

  @override
  String get fdArea11 => 'ผลได้และเครือข่าย';

  @override
  String get fdArea12 => 'การพักผ่อนและจิตวิญญาณ';

  @override
  String get fdTodaysMeaning => 'ความหมายของวันนี้';

  @override
  String get fdGoodFor => 'เหมาะสำหรับ';

  @override
  String get fdAvoid => 'หลีกเลี่ยง';

  @override
  String get fdPlanetSupport => 'การสนับสนุนจากดาวเคราะห์';

  @override
  String get fdWhyPrediction => 'เหตุใดจึงทำนายเช่นนี้?';

  @override
  String get fdAdvancedDetails => 'รายละเอียดขั้นสูง';

  @override
  String get fdAiRecommendation => 'คำแนะนำจาก AI';

  @override
  String get fdOverallStatus => 'สถานะโดยรวม';

  @override
  String get fdNoPlanetTransit => 'วันนี้ไม่มีดาวสำคัญโคจรผ่านด้านนี้';

  @override
  String get fdFinancialOutlook => 'แนวโน้มด้านการเงิน';

  @override
  String get fdIncomeProbability => 'ความน่าจะเป็นด้านรายได้';

  @override
  String get fdExpenseProbability => 'ความน่าจะเป็นด้านรายจ่าย';

  @override
  String get fdNetBalance => 'ยอดคงเหลือทางการเงินสุทธิ';

  @override
  String get fdAvoidSpending => 'หลีกเลี่ยงการใช้จ่าย';

  @override
  String get fdRelationshipOutlook => 'แนวโน้มด้านความสัมพันธ์';

  @override
  String get fdOverallScore => 'คะแนนโดยรวม';

  @override
  String get fdPartner => 'คู่ครอง';

  @override
  String get fdRomance => 'ความโรแมนติก';

  @override
  String get fdWorkplace => 'ที่ทำงาน';

  @override
  String get fdPublicImage => 'ภาพลักษณ์สาธารณะ';

  @override
  String get fdBestActivity => 'กิจกรรมที่เหมาะที่สุด';

  @override
  String get fdWeakArea => 'จุดอ่อน';

  @override
  String get fdBiggestOpportunity => 'โอกาสที่ใหญ่ที่สุด';

  @override
  String get fdBiggestRisk => 'ความเสี่ยงที่ใหญ่ที่สุด';

  @override
  String get fdProbability => 'ความน่าจะเป็น';

  @override
  String get fdProtection => 'คำแนะนำการป้องกัน';

  @override
  String get fdDescription => 'คำอธิบาย';

  @override
  String get fdBestTimeToday => 'เวลาที่ดีที่สุดวันนี้';

  @override
  String get fdAvoidDuring => 'ควรหลีกเลี่ยงในช่วง';

  @override
  String get fdPredictionConfidence => 'ความเชื่อมั่นของการทำนาย';

  @override
  String get fdConfBasis => 'การทำนายวันนี้ผสมผสาน';

  @override
  String get fdConfNatal => 'ดวงกำเนิด';

  @override
  String get fdConfTransit => 'การโคจรผ่านปัจจุบัน';

  @override
  String get fdConfDasha => 'ช่วงเวลาดาวเคราะห์';

  @override
  String get fdConfStrength => 'ความแข็งแกร่งของดาว';

  @override
  String get fdConfHouse => 'การกระตุ้นเรือน';

  @override
  String get fdAskAi => 'ถาม AI';

  @override
  String get fdAskAiSub => 'แตะคำถามเพื่อดูคำตอบวันนี้';

  @override
  String get fdQ1 => 'ทำไมงานถึงติดขัดวันนี้?';

  @override
  String get fdQ2 => 'เวลาที่ดีที่สุดวันนี้คือเมื่อใด?';

  @override
  String get fdQ3 => 'วันนี้เหมาะกับเรื่องการเงินหรือไม่?';

  @override
  String get fdQ4 => 'วันนี้เหมาะกับการเดินทางหรือไม่?';

  @override
  String get fdQ5 => 'วันนี้ฉันควรหลีกเลี่ยงอะไร?';

  @override
  String get fdMoreSuggestions => 'คำแนะนำเพิ่มเติม';

  @override
  String fdAiSummaryLine(Object top, Object weak, Object fin) {
    return 'วันนี้เหมาะที่สุดสำหรับ $top ส่วน $weak อาจรู้สึกติดขัด จึงควรหลีกเลี่ยงการตัดสินใจสำคัญในเรื่องนั้น ด้านการเงินวันนี้ดูเหมือนจะ $fin';
  }

  @override
  String fdThemeFocusLine(Object top) {
    return 'พลังงานของคุณวันนี้รวมศูนย์อยู่ที่ $top — ทุ่มเทให้กับด้านนี้และค่อยเป็นค่อยไปกับด้านอื่น';
  }

  @override
  String get gochToday => 'วันนี้';

  @override
  String get gochOverallScore => 'คะแนน Transit โดยรวม';

  @override
  String get gochNeutral => 'เป็นกลาง';

  @override
  String get gochChallenging => 'ท้าทาย';

  @override
  String get gochTopPositive => 'จุดบวกอันดับต้น';

  @override
  String get gochTopChallenges => 'ความท้าทายอันดับต้น';

  @override
  String get gochFilterAll => 'ทั้งหมด';

  @override
  String get gochFavorability => 'ความเอื้ออำนวย';

  @override
  String get gochAlerts => 'การแจ้งเตือน Transit';

  @override
  String get gochAlertCritical => 'วิกฤต';

  @override
  String get gochAlertWarning => 'ควรระวัง';

  @override
  String get gochAlertOpportunity => 'โอกาส';

  @override
  String get gochAiFocus => 'จุดเน้นจาก AI วันนี้';

  @override
  String get gochLifeScores => 'คะแนนด้านต่างๆ ของชีวิต';

  @override
  String get gochWhy => 'ทำไม?';

  @override
  String get gochCurrentTransits => 'Transit ที่กำลังทำงาน';

  @override
  String get gochDailyPlan => 'แผนประจำวันของคุณ';

  @override
  String get gochMorning => 'เช้า';

  @override
  String get gochAfternoon => 'บ่าย';

  @override
  String get gochEvening => 'เย็น';

  @override
  String get gochNight => 'กลางคืน';

  @override
  String get gochSmartReco => 'คำแนะนำอัจฉริยะ';

  @override
  String get gochExplain => 'อธิบาย Transit วันนี้';

  @override
  String get gochDo => 'ควรทำ';

  @override
  String get gochDont => 'ควรหลีกเลี่ยง';

  @override
  String get gochDoWork => 'จัดการงานสำคัญ';

  @override
  String get gochDoMeditate => 'ทำสมาธิและใคร่ครวญ';

  @override
  String get gochDoStart => 'เริ่มต้นแผนใหม่';

  @override
  String get gochDoFinish => 'ทำงานค้างให้เสร็จ';

  @override
  String get gochDontArgue => 'หลีกเลี่ยงการโต้เถียง';

  @override
  String get gochDontImpulsive => 'หลีกเลี่ยงการตัดสินใจโดยหุนหันพลันแล่น';

  @override
  String get gochDontOverspend => 'หลีกเลี่ยงการใช้จ่ายเกินตัว';

  @override
  String gochThemeGrowth(Object area) {
    return 'วันแห่งการเติบโตใน $area — ทุ่มเทให้กับด้านนี้';
  }

  @override
  String gochThemeChallenge(Object area) {
    return 'วันนี้ควรอดทนกับ $area — ค่อยเป็นค่อยไป';
  }

  @override
  String gochPosLine(Object area) {
    return '$area ได้รับการสนับสนุนที่ดีในตอนนี้';
  }

  @override
  String gochChalLine(Object area) {
    return '$area ต้องการความใส่ใจเป็นพิเศษวันนี้';
  }

  @override
  String gochAiFocusLine(Object a1, Object a2) {
    return 'วันนี้ทุ่มพลังงานให้กับ $a1 และผ่อนหนักผ่อนเบากับ $a2';
  }

  @override
  String get divBeginner => 'ผู้เริ่มต้น';

  @override
  String get divSearchHint => 'ค้นหา: อาชีพ การแต่งงาน การศึกษา…';

  @override
  String get divSummaryTitle => 'สรุปดวงแบ่งภาค';

  @override
  String get divTotalCharts => 'จำนวนดวงทั้งหมด';

  @override
  String get divMostImportant => 'สำคัญที่สุด';

  @override
  String get divRecommendedForYou => 'แนะนำสำหรับคุณ';

  @override
  String get divCatEssential => 'ดวงสำคัญพื้นฐาน';

  @override
  String get divCatPersonal => 'ชีวิตส่วนตัว';

  @override
  String get divCatKnowledge => 'ดวงด้านความรู้';

  @override
  String get divCatAdvanced => 'ดวงขั้นสูง';

  @override
  String get divGoalProperty => 'ทรัพย์สิน';

  @override
  String get divGoalKarma => 'กรรม';

  @override
  String get divBadgeHighlyRec => 'แนะนำอย่างยิ่ง';

  @override
  String get divBadgeRec => 'แนะนำ';

  @override
  String get divBadgeUseful => 'มีประโยชน์';

  @override
  String get divBadgeOptional => 'ไม่บังคับ';

  @override
  String get divBadgeAdvOnly => 'สำหรับผู้เชี่ยวชาญเท่านั้น';

  @override
  String get divRecommendBest => 'แนะนำดวงที่ดีที่สุด';

  @override
  String get divNoMatch => 'ไม่พบดวงที่ตรงกับการค้นหาของคุณ';

  @override
  String get divLifeAreas => 'ด้านต่างๆ ของชีวิต';

  @override
  String divAiUse(Object purpose) {
    return 'ใช้ดวงนี้เพื่อวิเคราะห์ $purpose';
  }

  @override
  String divHeroSummary(Object c1, Object c2) {
    return 'ดวง $c1 และ $c2 ของคุณมีความสำคัญเป็นพิเศษ — เริ่มต้นที่ดวงเหล่านี้สำหรับด้านที่เกี่ยวข้อง แล้วจึงสำรวจดวงอื่นๆ ตามความจำเป็น';
  }

  @override
  String divRecReasonHouse(Object house) {
    return 'เรือนที่ $house ของคุณควรพิจารณาอย่างละเอียด — ดวงนี้แสดงให้เห็นในเชิงลึก';
  }

  @override
  String divRecReasonPlanet(Object planet) {
    return '$planet เป็นดาวสำคัญแต่กำลังถูกทดสอบ — ดวงนี้เผยให้เห็นสภาวะเชิงลึกของดาวดวงนี้';
  }

  @override
  String divRecReasonDasha(Object planet) {
    return 'คุณกำลังอยู่ใน Mahadasha ของ $planet ดวงนี้จึงเหมาะสมเป็นพิเศษในตอนนี้';
  }

  @override
  String divRecSummary(Object c1) {
    return 'จากดวงชะตาของคุณ $c1 ควรเป็นสิ่งที่คุณให้ความสำคัญที่สุด ดวงด้านล่างเรียงลำดับตามความเกี่ยวข้องกับคุณในตอนนี้';
  }

  @override
  String divWhenToUseLine(Object purpose) {
    return 'เปิดดวงนี้เมื่อคุณต้องการศึกษาเรื่อง $purpose';
  }

  @override
  String get yogaHelpful => 'เป็นประโยชน์';

  @override
  String get yogaInactive => 'ไม่ทำงาน';

  @override
  String get yogaTabMoney => 'การเงิน';

  @override
  String get yogaTabRare => 'หายาก';

  @override
  String get yogaSummaryTitle => 'สรุป Yoga';

  @override
  String get yogaActiveYogas => 'Yoga ที่กำลังทำงาน';

  @override
  String get yogaTotalYogas => 'Yoga ทั้งหมด';

  @override
  String get yogaMostPowerful => 'ทรงพลังที่สุด';

  @override
  String get yogaFortuneRating => 'โชคลาภโดยรวม';

  @override
  String get yogaBenefits => 'ประโยชน์';

  @override
  String get yogaSupportingPlanets => 'ดาวสนับสนุน';

  @override
  String get yogaRanking => '5 อันดับ Yoga ที่แข็งแกร่งที่สุด';

  @override
  String get yogaExplain => 'อธิบาย Yoga ของฉัน';

  @override
  String get yogaExplainSubtitle => 'Yoga ของคุณสนับสนุนคุณอย่างไร';

  @override
  String get yogaNoneActive => 'ยังไม่มี Yoga ที่ทำงานอยู่';

  @override
  String get yogaNoneInCategory => 'ไม่มี Yoga ในหมวดหมู่นี้';

  @override
  String yogaHeroSummary(Object count, Object planets) {
    return 'ดวงชะตาของคุณมี Yoga ที่กำลังทำงานอยู่ $count รายการ ซึ่งเป็นการผสมผสานของดาวเคราะห์ที่ช่วยสนับสนุน การผสมผสานที่เกี่ยวข้องกับ $planets สร้างอิทธิพลที่เป็นประโยชน์อย่างยิ่งต่อการเติบโตและความสำเร็จ';
  }

  @override
  String yogaAiLine(Object name, Object areas) {
    return '$name สนับสนุนด้าน $areas และประโยชน์จะเพิ่มขึ้นเมื่อดาวที่เกี่ยวข้องทำงานอยู่ในช่วง Dasha หรือ Transit';
  }

  @override
  String get yogaAiGeneric =>
      'Yoga นี้เป็นการผสมผสานที่สนับสนุนในดวงชะตาของคุณ ซึ่งเสริมความแข็งแกร่งให้กับด้านชีวิตที่เกี่ยวข้อง';

  @override
  String get yogaExplainReassure =>
      'Yoga คือจุดเด่นของดวงชะตาคุณ — การผสมผสานของดาวเคราะห์ที่เป็นประโยชน์และทำงานเพื่อคุณ ยิ่ง Yoga แข็งแกร่งเท่าใด ก็ยิ่งให้ประโยชน์ที่ยั่งยืนมากเท่านั้น โดยเฉพาะในช่วงเวลาของดาวที่ประกอบกันเป็น Yoga นั้น';

  @override
  String get doshSevere => 'รุนแรง';

  @override
  String get doshVeryMild => 'เล็กน้อยมาก';

  @override
  String get doshLow => 'ต่ำ';

  @override
  String get doshHigh => 'สูง';

  @override
  String get doshCritical => 'วิกฤต';

  @override
  String get doshSummaryTitle => 'สรุป Dosha';

  @override
  String get doshActiveDoshas => 'Dosha ที่กำลังทำงาน';

  @override
  String get doshTotalChecked => 'ตรวจสอบทั้งหมด';

  @override
  String get doshOverallSeverity => 'ความรุนแรงโดยรวม';

  @override
  String get doshNoneActive =>
      'ไม่มี Dosha ที่กำลังทำงาน — ดวงชะตาสะอาดปราศจากมลทิน!';

  @override
  String get doshCategory => 'หมวดหมู่';

  @override
  String get doshConfidence => 'ความเชื่อมั่น';

  @override
  String get doshWhyFormed => 'เหตุใดจึงเกิดขึ้น';

  @override
  String get doshAffectedAreas => 'ด้านที่ได้รับผลกระทบ';

  @override
  String get doshTimeline => 'ไทม์ไลน์';

  @override
  String get doshDefinition => 'คำนิยาม';

  @override
  String get doshFormationRule => 'กฎการเกิด Dosha';

  @override
  String get doshSupportingPlanets => 'ดาวที่เกี่ยวข้อง';

  @override
  String get doshCancellation => 'Yoga การยกเลิก Dosha';

  @override
  String get doshNoCancellation => 'ไม่พบ';

  @override
  String get doshAreaChildren => 'บุตร';

  @override
  String get doshAreaMind => 'จิตใจ';

  @override
  String get remMantra => 'มนตร์';

  @override
  String get remGemstone => 'อัญมณี';

  @override
  String get remDonation => 'การบริจาค';

  @override
  String get remTemple => 'วัด';

  @override
  String get remFasting => 'การถือศีลอด';

  @override
  String get remLifestyle => 'วิถีชีวิต';

  @override
  String get remLifestyleGeneric =>
      'ฝึกความกตัญญู วินัย และการให้ทานที่เกี่ยวข้องกับดาวดวงนี้ และรักษาความประพฤติที่ดี';

  @override
  String get doshExplain => 'อธิบาย Dosha ของฉัน';

  @override
  String get doshExplainSubtitle =>
      'มุมมองที่สงบและปฏิบัติได้จริงต่อ Dosha ของคุณ';

  @override
  String get doshExplainReassure =>
      'Dosha เป็นเรื่องปกติ — เกือบทุกดวงชะตามี Dosha บ้าง Dosha เป็นเพียงแนวโน้ม ไม่ใช่โชคชะตาที่ตายตัว การตระหนักรู้ ความประพฤติที่ดี และการแก้ไขง่ายๆ จะช่วยลดผลกระทบในทางปฏิบัติ จึงไม่จำเป็นต้องกังวล';

  @override
  String get doshAiGeneric =>
      'Dosha นี้อธิบายแนวโน้มในดวงชะตาของคุณ ผลกระทบในทางปฏิบัติมักไม่รุนแรงและสามารถปรับสมดุลได้ด้วยการตระหนักรู้และการแก้ไขง่ายๆ';

  @override
  String doshHeroSummary(Object active, Object total) {
    return 'ดวงชะตาของคุณมี Dosha ที่กำลังทำงาน $active รายการ จากทั้งหมดที่ตรวจสอบ $total รายการ ส่วนใหญ่ไม่รุนแรง มีเพียงไม่กี่รายการที่ต้องให้ความสนใจ ด้วยความเข้าใจและการแก้ไขง่ายๆ ผลกระทบในทางปฏิบัติสามารถบรรเทาลงได้';
  }

  @override
  String doshAiLine(Object areas, Object planet) {
    return 'Dosha นี้ส่งผลกระทบหลักต่อ $areas ในช่วง $planet ผลกระทบอาจรู้สึกรุนแรงขึ้น และการแก้ไขจะช่วยปรับสมดุล';
  }

  @override
  String doshTimelineLine(Object planet) {
    return 'ผลกระทบจะรู้สึกได้มากที่สุดในช่วง Mahadasha และ Antardasha ของ $planet และเมื่อ $planet กำลังโคจรผ่าน (Transit)';
  }

  @override
  String get sbLegendary => 'ระดับตำนาน';

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
  String get sbSummary => 'สรุปความแข็งแกร่งของดาวเคราะห์';

  @override
  String get sbAverageStrength => 'ความแข็งแกร่งเฉลี่ย';

  @override
  String get sbHighestRupa => 'Rupa สูงสุด';

  @override
  String get sbRupa => 'Rupa';

  @override
  String get sbRanking => 'การจัดอันดับดาวเคราะห์';

  @override
  String get sbRequired => 'ที่ต้องการ';

  @override
  String get sbExcess => 'ส่วนเกิน';

  @override
  String get sbDeficit => 'ส่วนขาด';

  @override
  String get sbTotalShadbala => 'Shadbala รวม';

  @override
  String get sbExplain => 'อธิบายความแข็งแกร่งดาวเคราะห์ของฉัน';

  @override
  String get sbExplainSubtitle =>
      'สรุปง่ายๆ เกี่ยวกับความแข็งแกร่งของดาวเคราะห์ของคุณ';

  @override
  String get sbInfoTitle => 'ทำความเข้าใจ Shadbala';

  @override
  String get sbQWhatIs => 'Shadbala คืออะไร?';

  @override
  String get sbQRupas => 'Rupa คืออะไร?';

  @override
  String get sbQHowCalc => 'ความแข็งแกร่งคำนวณอย่างไร?';

  @override
  String get sbQHowUse => 'วิธีใช้ข้อมูลนี้';

  @override
  String get sbWhyStrong => 'เหตุใดจึงแข็งแกร่ง';

  @override
  String get sbWhyWeak => 'เหตุใดจึงอ่อนแอ';

  @override
  String get sbDuringMahadasha => 'ในช่วง Mahadasha';

  @override
  String get sbEffects => 'ผลกระทบ';

  @override
  String get sbLifeAreas => 'ด้านต่างๆ ของชีวิต';

  @override
  String get sbPlanetDetails => 'รายละเอียดดาวเคราะห์';

  @override
  String get sbBodyWhatIs =>
      'Shadbala (\'พลังหกประการ\') วัดว่าดาวเคราะห์แต่ละดวงมีพลังมากเพียงใดในการให้ผล โดยรวมแหล่งพลังที่เป็นอิสระต่อกันหกแหล่ง';

  @override
  String get sbBodyRupas =>
      'ความแข็งแกร่งวัดเป็นหน่วย Rupa (1 Rupa = 60 Virupa) ดาวแต่ละดวงต้องการความแข็งแกร่งขั้นต่ำเป็น Rupa จึงจะนับว่าแข็งแกร่ง ยิ่งมี Rupa มากเท่าใด ก็ยิ่งให้ผลได้เต็มที่มากขึ้นเท่านั้น';

  @override
  String get sbBodyHowCalc =>
      'พลังหกประการที่นำมารวมกัน ได้แก่ Sthana (ตำแหน่ง) Dig (ทิศทาง) Kala (เวลา) Chesta (การเคลื่อนที่) Naisargika (ธรรมชาติ) และ Drik (มุมมอง) ผลรวมจะถูกเทียบกับค่าขั้นต่ำที่ดาวนั้นต้องการเพื่อให้ได้เป็นเปอร์เซ็นต์';

  @override
  String get sbBodyHowUse =>
      'ดาวที่มีค่ามากกว่า 100% จะให้ผลตามความหมายของมันได้อย่างสบายๆ ส่วนที่ต่ำกว่า 100% ต้องการการสนับสนุน ควรใช้ดาวที่แข็งแกร่งที่สุดของคุณสำหรับเรื่องสำคัญ และให้การแก้ไขและความอดทนกับดาวที่อ่อนแอที่สุด';

  @override
  String get sbRemedyStrong =>
      'ได้รับการสนับสนุนที่ดี — ไม่จำเป็นต้องมีการแก้ไขพิเศษ คุณสามารถใช้ช่วงเวลาของดาวดวงนี้ได้อย่างมั่นใจ';

  @override
  String sbHeroSummary(Object strongP, Object strongTrait, Object weakP) {
    return '$strongP คือดาวที่แข็งแกร่งที่สุดของคุณ ให้การสนับสนุนที่ยอดเยี่ยมสำหรับ $strongTrait ส่วน $weakP เป็นดาวที่อ่อนแอที่สุดและได้ประโยชน์จากการแก้ไขมากที่สุด';
  }

  @override
  String sbCardAi(Object planet, Object category, Object karakatva) {
    return '$planet มี Shadbala ระดับ $category ดังนั้น $karakatva จึงได้รับการสนับสนุนตามนั้น';
  }

  @override
  String sbWhyLine(Object bala, Object rupa) {
    return 'แข็งแกร่งที่สุดผ่าน $bala ($rupa rupa)';
  }

  @override
  String sbWeakLine(Object bala) {
    return 'อ่อนแอที่สุดใน $bala ซึ่งทำให้ผลรวมลดลง';
  }

  @override
  String sbMahadashaLine(Object planet, Object karak) {
    return 'ในช่วง Mahadasha ของ $planet $karak จะโดดเด่นขึ้นมา';
  }

  @override
  String sbEffectStrong(Object karak) {
    return 'ด้วย Shadbala ที่แข็งแกร่ง $karak จะได้รับการสนับสนุนโดยธรรมชาติ';
  }

  @override
  String sbEffectWeak(Object karak) {
    return 'ด้วย Shadbala ที่ไม่มากนัก $karak อาจต้องการความพยายามอย่างมีสติ';
  }

  @override
  String sbRemedyWeak(Object planet) {
    return 'เสริมความแข็งแกร่งให้ $planet ผ่านมนตร์ อัญมณี หรือการบริจาค และปฏิบัติตัวด้วยความอดทนในช่วงเวลาของดาวดวงนี้';
  }

  @override
  String get bhOverview => 'ภาพรวม';

  @override
  String get bhDetailed => 'รายละเอียด';

  @override
  String get bhavaHouses => 'เรือน';

  @override
  String get bhStrengthOverview => 'ภาพรวมความแข็งแกร่งของเรือน';

  @override
  String get bhOverallAverage => 'ค่าเฉลี่ยเรือนโดยรวม';

  @override
  String get bhStrongestHouse => 'เรือนที่แข็งแกร่งที่สุด';

  @override
  String get bhWeakestHouse => 'เรือนที่อ่อนแอที่สุด';

  @override
  String get bhBestArea => 'ด้านชีวิตที่ดีที่สุด';

  @override
  String get bhNeedsAttention => 'ต้องการความสนใจ';

  @override
  String get bhSavContribution => 'การมีส่วนร่วมของ SAV';

  @override
  String get bhLordCondition => 'สภาวะของเจ้าเรือน';

  @override
  String get bhBenefic => 'อิทธิพลที่เป็นมงคล';

  @override
  String get bhMalefic => 'อิทธิพลที่เป็นอัปมงคล';

  @override
  String get bhStrengthReasons => 'เหตุใดจึงได้คะแนนนี้';

  @override
  String get bhGoodEffects => 'ผลดี';

  @override
  String get bhChallenges => 'ความท้าทาย';

  @override
  String get bhRemedies => 'แนวทางแก้ไข';

  @override
  String get bhRanking => 'การจัดอันดับเรือน';

  @override
  String get bhSav => 'SAV';

  @override
  String get bhExplain => 'อธิบายเรือนของฉัน';

  @override
  String get bhExplainSubtitle => 'สรุปง่ายๆ เกี่ยวกับเรือนทั้ง 12 ของคุณ';

  @override
  String bhHeroSummary(
    Object s1,
    Object s2,
    Object strongArea,
    Object weakArea,
  ) {
    return 'เรือนที่แข็งแกร่งที่สุดของคุณคือ $s1 และ $s2 $strongArea แข็งแกร่งโดยธรรมชาติ ในขณะที่ $weakArea ต้องการความพยายามมากขึ้น';
  }

  @override
  String bhLordLine(Object lord, Object relation) {
    return 'เจ้าเรือน $lord วางตัวอยู่ในฐานะ $relation';
  }

  @override
  String bhWhyLine(Object sav) {
    return 'เรือนนี้มีคะแนนมงคล (SAV) $sav คะแนน ดาวที่สถิตอยู่และมุมมองที่ได้รับเป็นตัวกำหนดคะแนนที่เหลือ';
  }

  @override
  String bhGoodLine(Object meaning) {
    return 'เมื่อแข็งแกร่ง จะสนับสนุน $meaning';
  }

  @override
  String bhChallengeLine(Object meaning) {
    return 'เมื่ออ่อนแอ $meaning อาจต้องการความพยายามและการดูแลเป็นพิเศษ';
  }

  @override
  String bhRemedyLine(Object lord) {
    return 'เสริมความแข็งแกร่งให้เจ้าเรือน $lord และให้ความสำคัญกับเรื่องของเรือนนี้เพื่อยกระดับ';
  }

  @override
  String bhCardAi(Object house, Object strengthWord, Object meaning) {
    return '$house ของคุณ $strengthWord ปกครองด้าน $meaning';
  }

  @override
  String get kunNavamsa => 'Navamsa (D9)';

  @override
  String get kunD10 => 'Dasamsa (D10)';

  @override
  String get kunPlacement => 'ตำแหน่งดาวเคราะห์';

  @override
  String get kunHousesTitle => 'รายละเอียดเรือน';

  @override
  String get kunPlanet => 'ดาวเคราะห์';

  @override
  String get kunNakshatra => 'Nakshatra';

  @override
  String get kunPada => 'Pada';

  @override
  String get kunLord => 'เจ้าเรือน';

  @override
  String get kunExplain => 'อธิบายดวงชะตาของฉัน';

  @override
  String get kunExplainSubtitle => 'สรุปง่ายๆ เกี่ยวกับดวงชะตาของคุณ';

  @override
  String kunHouseLine(Object ordinal, Object meaning) {
    return 'เรือนที่ $ordinal ปกครองด้าน $meaning';
  }

  @override
  String kunHouseOccupied(Object planets) {
    return '$planets ที่สถิตอยู่ที่นี่เป็นตัวกำหนดผลลัพธ์';
  }

  @override
  String kunExplainAsc(Object asc) {
    return 'ลัคนาของคุณคือ $asc ซึ่งหล่อหลอมมุมมองของคุณและภาพลักษณ์แรกที่ผู้อื่นเห็น';
  }

  @override
  String kunExplainMoon(Object moon) {
    return 'จิตใจและอารมณ์ของคุณเป็นไปตาม Moon ใน $moon';
  }

  @override
  String kunExplainStrong(Object planet) {
    return '$planet คือดาวที่แข็งแกร่งที่สุดของคุณ — เป็นด้านที่ราบรื่นและได้รับการสนับสนุนโดยธรรมชาติ';
  }

  @override
  String kunExplainWeak(Object planet) {
    return '$planet คือดาวที่ถูกทดสอบมากที่สุดของคุณ — ความอดทนและความพยายามจะให้ผลตอบแทนที่นี่';
  }

  @override
  String get plNature => 'ธรรมชาติ';

  @override
  String get plElement => 'ธาตุ';

  @override
  String get plGender => 'เพศ';

  @override
  String get plKarakatva => 'Karakatva';

  @override
  String get plLordship => 'การเป็นเจ้าเรือน';

  @override
  String get plStrength => 'ความแข็งแกร่ง';

  @override
  String get plAspectsGiven => 'มุมมองที่ส่งออก';

  @override
  String get plAspectsReceived => 'มุมมองที่ได้รับ';

  @override
  String get plConjunction => 'การรวมดาว (Conjunction)';

  @override
  String get plHouseMeaning => 'ความหมายของเรือน';

  @override
  String get plNakshatraMeaning => 'ความหมายของ Nakshatra';

  @override
  String get plAiInterpretation => 'การตีความโดย AI';

  @override
  String get plSearchHint => 'ค้นหาดาวเคราะห์ใดก็ได้';

  @override
  String get plNoResults => 'ไม่พบดาวเคราะห์';

  @override
  String get plBenefic => 'มงคล';

  @override
  String get plMalefic => 'อัปมงคล';

  @override
  String get plMale => 'เพศชาย';

  @override
  String get plFemale => 'เพศหญิง';

  @override
  String get plNeutralGender => 'ไม่ระบุเพศ';

  @override
  String get plOwnSign => 'ราศีของตนเอง';

  @override
  String get plFriend => 'ราศีมิตร';

  @override
  String get plEnemy => 'ราศีศัตรู';

  @override
  String get plNeutral => 'เป็นกลาง';

  @override
  String get sumEther => 'อากาศธาตุ (Ether)';

  @override
  String plLordOfHouses(Object houses) {
    return 'เจ้าเรือนที่ $houses';
  }

  @override
  String plNakMeaning(Object nakLord, Object trait) {
    return 'ปกครองโดย $nakLord นำมาซึ่ง $trait';
  }

  @override
  String plAiPlace(Object planet, Object sign, Object house) {
    return '$planet สถิตอยู่ในราศี $sign เรือนที่ $house';
  }

  @override
  String plAiKarakStrong(Object karak) {
    return 'ความหมายหลักของดาวนี้ — $karak — ได้รับการสนับสนุนที่ดีที่นี่';
  }

  @override
  String plAiKarakWeak(Object karak) {
    return 'ความหมายหลักของดาวนี้ — $karak — อาจต้องการความพยายามอย่างมีสติที่นี่';
  }

  @override
  String plAiExalted(Object planet) {
    return '$planet อยู่ในราศีอุจจ์ ให้ผลดีที่สุด';
  }

  @override
  String plAiDebilitated(Object planet) {
    return '$planet อยู่ในราศีนิจ และต้องการการสนับสนุนเพื่อให้ผล';
  }

  @override
  String plAiCombust(Object planet) {
    return '$planet ถูกเผาไหม้ (Combust) จึงแสดงผลได้ไม่เต็มที่ภายใต้แสงของ Sun';
  }

  @override
  String plAiVargottama(Object planet) {
    return '$planet เป็น Vargottama — ตำแหน่งที่แข็งแกร่งซ้ำในดวง Navamsa';
  }

  @override
  String plAiRetrograde(Object planet) {
    return '$planet เป็นดาวพักร์ (Retrograde) หันพลังงานเข้าสู่ภายในและทวีความเข้มข้น';
  }

  @override
  String get plHouse1 => 'ตัวตน ร่างกาย บุคลิกภาพ และพลังชีวิต';

  @override
  String get plHouse2 => 'ทรัพย์สิน ครอบครัว คำพูด และอาหาร';

  @override
  String get plHouse3 => 'ความกล้าหาญ พี่น้อง การสื่อสาร และการเดินทางระยะสั้น';

  @override
  String get plHouse4 => 'บ้าน มารดา ความสุขสบาย ทรัพย์สิน และความสงบภายใน';

  @override
  String get plHouse5 =>
      'บุตร ความคิดสร้างสรรค์ สติปัญญา ความรัก และบุญบารมีในอดีต';

  @override
  String get plHouse6 => 'สุขภาพ ศัตรู หนี้สิน การรับใช้ และงานประจำวัน';

  @override
  String get plHouse7 => 'การแต่งงาน ความเป็นหุ้นส่วน และความสัมพันธ์ทางธุรกิจ';

  @override
  String get plHouse8 => 'อายุยืน การเปลี่ยนแปลง ความลับ และมรดก';

  @override
  String get plHouse9 => 'โชคลาภ ธรรมะ การศึกษาระดับสูง คุรุ และบิดา';

  @override
  String get plHouse10 => 'อาชีพ สถานะ อำนาจ และกรรมสาธารณะ';

  @override
  String get plHouse11 =>
      'ผลได้ รายได้ เพื่อน เครือข่าย และความปรารถนาที่สมหวัง';

  @override
  String get plHouse12 => 'การสูญเสีย รายจ่าย ต่างแดน จิตวิญญาณ และการหลุดพ้น';

  @override
  String get sumVeryStrong => 'แข็งแกร่งมาก';

  @override
  String get sumStrong => 'แข็งแกร่ง';

  @override
  String get sumAverage => 'ปานกลาง';

  @override
  String get sumWeak => 'อ่อนแอ';

  @override
  String get sumNeedsAttention => 'ต้องการความสนใจ';

  @override
  String get sumFire => 'ธาตุไฟ';

  @override
  String get sumEarth => 'ธาตุดิน';

  @override
  String get sumAir => 'ธาตุลม';

  @override
  String get sumWater => 'ธาตุน้ำ';

  @override
  String get sumMovable => 'จรราศี (Movable)';

  @override
  String get sumFixed => 'สถิรราศี (Fixed)';

  @override
  String get sumDual => 'อุภยราศี (Dual)';

  @override
  String get sumDirEast => 'ทิศตะวันออก';

  @override
  String get sumDirWest => 'ทิศตะวันตก';

  @override
  String get sumDirNorth => 'ทิศเหนือ';

  @override
  String get sumDirSouth => 'ทิศใต้';

  @override
  String get sumDirNE => 'ทิศตะวันออกเฉียงเหนือ';

  @override
  String get sumDirNW => 'ทิศตะวันตกเฉียงเหนือ';

  @override
  String get sumDirSE => 'ทิศตะวันออกเฉียงใต้';

  @override
  String get sumDirSW => 'ทิศตะวันตกเฉียงใต้';

  @override
  String get sumSnapshotTitle => 'ภาพรวมโหราศาสตร์ของคุณ';

  @override
  String get sumMahadasha => 'Mahadasha';

  @override
  String get sumAntardasha => 'Antardasha';

  @override
  String get sumNakshatra => 'Janma Nakshatra';

  @override
  String get sumElement => 'ธาตุ';

  @override
  String get sumModality => 'ลักษณะราศี';

  @override
  String get sumLuckyDirection => 'ทิศมงคล';

  @override
  String get sumHighlights => 'ประเด็นสำคัญ';

  @override
  String get sumStrongPlanet => 'ดาวที่แข็งแกร่งที่สุด';

  @override
  String get sumWeakPlanet => 'ดาวที่อ่อนแอที่สุด';

  @override
  String get sumYogas => 'Yoga';

  @override
  String get sumDoshas => 'Dosha';

  @override
  String get sumRetrograde => 'ดาวพักร์';

  @override
  String get sumCombust => 'ถูกเผาไหม้ (Combust)';

  @override
  String get sumExalted => 'ราศีอุจจ์';

  @override
  String get sumDebilitated => 'ราศีนิจ';

  @override
  String get sumVargottama => 'Vargottama';

  @override
  String get sumQuickInsights => 'ข้อมูลเชิงลึกโดยย่อ';

  @override
  String get sumSpirituality => 'จิตวิญญาณ';

  @override
  String get sumTimezone => 'เขตเวลา';

  @override
  String get sumAyanamsa => 'Ayanamsa';

  @override
  String get sumCalendarType => 'ปฏิทิน';

  @override
  String get sumCopied => 'คัดลอกไปยังคลิปบอร์ดแล้ว';

  @override
  String get sumNatureFire =>
      'คุณมีธรรมชาติที่กล้าหาญ กระตือรือร้น และเป็นผู้บุกเบิกที่นำหน้าผู้อื่น';

  @override
  String get sumNatureEarth =>
      'คุณมีธรรมชาติที่ปฏิบัติได้จริง มั่นคง และมีวินัย ซึ่งสร้างผลลัพธ์ที่ยั่งยืน';

  @override
  String get sumNatureAir =>
      'คุณมีธรรมชาติที่อยากรู้อยากเห็น ชอบสื่อสาร และมีสติปัญญาเฉียบแหลม เติบโตได้ดีกับไอเดียใหม่ๆ';

  @override
  String get sumNatureWater =>
      'คุณมีธรรมชาติที่ใช้สัญชาตญาณ อ่อนไหวทางอารมณ์ และเห็นอกเห็นใจผู้อื่น พร้อมความรู้สึกภายในที่ลึกซึ้ง';

  @override
  String get sumGradePhraseExcellent =>
      'ได้รับการสนับสนุนอย่างแข็งแกร่ง — มีแนวโน้มได้ผลลัพธ์ที่ดีด้วยความพยายามอย่างสม่ำเสมอ';

  @override
  String get sumGradePhraseGood =>
      'ได้รับการสนับสนุนที่ดี — โดยทั่วไปเป็นบวกหากดูแลเพิ่มเติมเล็กน้อย';

  @override
  String get sumGradePhraseAverage =>
      'ได้รับการสนับสนุนแบบผสมผสาน — ผลลัพธ์ขึ้นอยู่กับความพยายามและจังหวะเวลา';

  @override
  String get sumGradePhraseWeak =>
      'ต้องการความสนใจ — ความอดทนและการแก้ไขจะช่วยได้ในที่นี้';

  @override
  String get kDefCombust =>
      'ดาวที่อยู่ใกล้ Sun มากเกินไป ทำให้พลังงาน \'ถูกเผาไหม้\' และอ่อนกำลังลง';

  @override
  String get kDefRetrograde =>
      'ดาวที่ปรากฏว่าเคลื่อนที่ถอยหลัง ผลของดาวจะหันเข้าสู่ภายในและทวีความเข้มข้นขึ้น';

  @override
  String get kDefNakshatra =>
      'หนึ่งในกลุ่มดาวจันทรคติ 27 กลุ่มที่ Moon และดาวเคราะห์เคลื่อนผ่าน';

  @override
  String get kDefVargottama =>
      'ดาวที่อยู่ในราศีเดียวกันทั้งในดวงกำเนิด (D1) และดวง Navamsa (D9) — เป็นเครื่องหมายแห่งความแข็งแกร่ง';

  @override
  String get kDefOwnSign =>
      'ดาวที่สถิตอยู่ในราศีที่ตนเองปกครอง ซึ่งรู้สึกเหมือนอยู่บ้านและให้ผลลัพธ์ที่มั่นคง';

  @override
  String get kDefExalted =>
      'ดาวที่อยู่ในราศีที่มีความแข็งแกร่งสูงสุด ให้ผลลัพธ์ที่ดีที่สุด';

  @override
  String get kDefDebilitated =>
      'ดาวที่อยู่ในราศีที่อ่อนแอที่สุด ซึ่งยากที่จะให้ผลลัพธ์ที่ดี';

  @override
  String get kDefMooltrikona => 'ส่วนพิเศษของราศีของตนเองที่ดาวมีพลังเป็นพิเศษ';

  @override
  String get kDefAscendant =>
      'ราศีที่ขึ้นบนขอบฟ้าตะวันออกในเวลาเกิด — คือ Lagna รากฐานของดวงชะตา';

  @override
  String get kDefMahadasha =>
      'ช่วงเวลาหลักของดาวเคราะห์ที่ส่งอิทธิพลต่อชีวิตในระยะเวลายาวนาน';

  @override
  String get kDefAntardasha =>
      'ช่วงย่อยภายใน Mahadasha ที่ปรับแต่งผลลัพธ์ให้ละเอียดขึ้น';

  @override
  String get kDefPada =>
      'หนึ่งในสี่ส่วนย่อยของ Nakshatra ที่ดาวเคราะห์สถิตอยู่';

  @override
  String get aspGivesAspectTo => 'ส่งมุมมองไปยัง';

  @override
  String get aspReceivesAspectFrom => 'รับมุมมองจาก';

  @override
  String get aspInfluences => 'อิทธิพล';

  @override
  String get aspNoInfluence => 'ไม่มีอิทธิพล';

  @override
  String get aspNoAspect => 'ไม่มีมุมมอง';

  @override
  String get aspPresent => 'มี';

  @override
  String get aspAbsent => 'ไม่มี';

  @override
  String get aspNotPresent => 'ไม่ปรากฏ';

  @override
  String get aspSpecialAspect => 'มุมมองพิเศษ';

  @override
  String get aspAspectWord => 'มุมมอง (Aspect)';

  @override
  String get aspTotalGiven => 'มุมมองที่ส่งออก';

  @override
  String get aspTotalReceived => 'มุมมองที่ได้รับ';

  @override
  String get aspStrongestInfluence => 'อิทธิพลที่แข็งแกร่งที่สุด';

  @override
  String get aspMedium => 'ปานกลาง';

  @override
  String get aspAspectPresent => 'มีมุมมอง';

  @override
  String get aspReason => 'เหตุผล';

  @override
  String get aspBoth => 'ทั้งสอง';

  @override
  String get aspTargetHouse => 'เรือนเป้าหมาย';

  @override
  String get aspTargetSign => 'ราศีเป้าหมาย';

  @override
  String get aspLagnaReceives => 'Lagna ได้รับมุมมองจาก';

  @override
  String get aspNoAspectFrom => 'ไม่มีมุมมองจาก';

  @override
  String get aspPlanetToPlanet => 'ดาวสู่ดาว';

  @override
  String get aspSignToSign => 'ราศีสู่ราศี';

  @override
  String get aspCombinedAspect => 'มุมมองรวม';

  @override
  String get aspGrahaAspect => 'Graha Drishti';

  @override
  String get aspRashiAspect => 'Rashi Drishti';

  @override
  String get aspInfoTitle => 'ทำความเข้าใจมุมมอง (Drishti)';

  @override
  String get aspQGraha => 'Graha Drishti คืออะไร?';

  @override
  String get aspQRashi => 'Rashi Drishti คืออะไร?';

  @override
  String get aspQDiff => 'ความแตกต่างระหว่างสองแบบนี้';

  @override
  String get aspQPredict => 'มุมมองส่งผลต่อการทำนายอย่างไร';

  @override
  String get aspGrahaBody =>
      'Graha Drishti คือมุมมองที่ดาวเคราะห์ส่งออกจากตำแหน่งของตนเอง ดาวทุกดวงจะส่งมุมมองเต็มไปยังเรือน/ดาวที่ 7 นับจากตนเอง (อิทธิพลแบบเผชิญหน้าโดยตรง) นอกจากนี้ Mars ยังส่งมุมมองไปยังเรือนที่ 4 และ 8, Jupiter ไปยังเรือนที่ 5 และ 9, และ Saturn ไปยังเรือนที่ 3 และ 10 ส่วน Rahu และ Ketu มักได้รับมุมมองที่เรือนที่ 5, 7 และ 9 มุมมองของดาวจะแต่งแต้มดาวหรือเรือนที่ตกกระทบด้วยธรรมชาติของตนเอง';

  @override
  String get aspRashiBody =>
      'Rashi Drishti คือมุมมองแบบราศีสู่ราศีตามหลักโหราศาสตร์ Jaimini โดยไม่ขึ้นกับว่ามีดาวใดสถิตอยู่ที่นั่น ราศีจรจะส่งมุมมองไปยังราศีสถิร (ยกเว้นราศีที่อยู่ติดกัน) ราศีสถิรจะส่งมุมมองไปยังราศีจร (ยกเว้นราศีที่อยู่ติดกัน) และราศีอุภยจะส่งมุมมองไปยังราศีอุภยอื่นๆ ใช้เป็นหลักในการทำนายแบบ Jaimini และในการตัดสินความสัมพันธ์ระหว่างเรือน';

  @override
  String get aspDiffBody =>
      'Graha Drishti ถูกส่งออกโดยดาวเคราะห์และขึ้นอยู่กับตำแหน่งที่ดาวนั้นสถิตอยู่ ส่วน Rashi Drishti เป็นของราศีเองและใช้กับสิ่งใดก็ตามที่อยู่ในราศีนั้น Graha Drishti มีทิศทาง (ดาว A มองเห็นดาว B) ในขณะที่ Rashi Drishti มักเป็นแบบสองทางระหว่างราศี เมื่อทั้งสองแบบชี้ไปยังเป้าหมายเดียวกัน อิทธิพลจะยิ่งแข็งแกร่งเป็นพิเศษ';

  @override
  String get aspPredictBody =>
      'มุมมองแสดงให้เห็นว่าดาวเคราะห์ขยายอิทธิพลของตนออกไปนอกเรือนของตัวเองที่ใด มุมมองจากดาวมงคล (Jupiter, Venus, Moon/Mercury ที่มีตำแหน่งดี) จะสนับสนุนและปกป้องเป้าหมาย ส่วนมุมมองจากดาวอัปมงคล (Saturn, Mars, Sun, Rahu, Ketu) อาจสร้างแรงกดดัน ความล่าช้า หรือความท้าทาย การอ่านว่าดาวใดส่งมุมมองมายังเรือนหรือดาวใดจะช่วยอธิบายว่าเหตุใดผลลัพธ์จึงปรากฏออกมาเช่นนั้น';

  @override
  String get aspTraitSun => 'อำนาจ ความเป็นผู้นำ และพลังชีวิต';

  @override
  String get aspTraitMoon => 'ความลึกซึ้งทางอารมณ์ ความสบายใจ และสัญชาตญาณ';

  @override
  String get aspTraitMars => 'พลังงาน ความกล้าหาญ และแรงขับเคลื่อน';

  @override
  String get aspTraitMercury => 'การสื่อสาร สติปัญญา และความสามารถในการปรับตัว';

  @override
  String get aspTraitJupiter => 'ปัญญา การเติบโต และโชคลาภ';

  @override
  String get aspTraitVenus => 'ความรัก ความกลมกลืน และความสะดวกสบาย';

  @override
  String get aspTraitSaturn =>
      'วินัย ความรับผิดชอบ และความสำเร็จที่ต้องอาศัยความอดทน บางครั้งล่าช้า';

  @override
  String get aspTraitRahu =>
      'ความทะเยอทะยาน ความเข้มข้น และการเปลี่ยนแปลงที่ไม่ธรรมดา';

  @override
  String get aspTraitKetu => 'การปล่อยวาง จิตวิญญาณ และการเปลี่ยนแปลงฉับพลัน';

  @override
  String aspAiInfluence(Object planet, Object targets, Object trait) {
    return '$planet กำลังส่งอิทธิพลต่อ $targets ซึ่งอาจนำ $trait มาสู่ด้านที่ดาวเหล่านี้เป็นตัวแทน';
  }

  @override
  String aspAiNone(Object planet) {
    return '$planet ไม่ได้ส่งมุมมองพิเศษไปยังดาวดวงอื่นในที่นี้ อิทธิพลของดาวนี้ทำงานผ่านราศีและเรือนของตนเองเป็นหลัก';
  }

  @override
  String get avSummaryTitle => 'สรุป Ashtakavarga';

  @override
  String get avOverallScore => 'คะแนน SAV โดยรวม';

  @override
  String get avOverallRating => 'การประเมินโดยรวม';

  @override
  String get avStrongestSigns => 'ราศีที่แข็งแกร่งที่สุด';

  @override
  String get avWeakestSigns => 'ราศีที่อ่อนแอที่สุด';

  @override
  String get avScore => 'คะแนน';

  @override
  String get avMeaning => 'ความหมาย';

  @override
  String get avGrid => 'ตาราง';

  @override
  String get avList => 'รายการ';

  @override
  String get avOverallScoreShort => 'คะแนนโดยรวม';

  @override
  String get avNatalSignScore => 'คะแนนราศีกำเนิด';

  @override
  String get avBestSigns => 'ราศีที่ดีที่สุด';

  @override
  String get avWeakSigns => 'ราศีที่อ่อนแอ';

  @override
  String get avAiInterpretation => 'การตีความโดย AI';

  @override
  String get avVeryGood => 'ดีมาก';

  @override
  String get avVeryWeak => 'อ่อนแอมาก';

  @override
  String get avTotalSav => 'SAV รวม';

  @override
  String get avPlanetContributions => 'การมีส่วนร่วมของดาวเคราะห์';

  @override
  String get avFinance => 'การเงิน';

  @override
  String get avOverallStrength => 'ความแข็งแกร่งโดยรวม';

  @override
  String get avWhatDoesThisMean => 'สิ่งนี้หมายความว่าอย่างไร?';

  @override
  String get avSimple => 'แบบง่าย';

  @override
  String get avAdvanced => 'แบบขั้นสูง';

  @override
  String get avInfoTitle => 'ทำความเข้าใจ Ashtakavarga';

  @override
  String get avStrong => 'แข็งแกร่ง';

  @override
  String get avModerate => 'ปานกลาง';

  @override
  String get avQWhatIsAv => 'Ashtakavarga คืออะไร?';

  @override
  String get avQWhatIsSav => 'SAV คืออะไร?';

  @override
  String get avQWhatIsBav => 'BAV คืออะไร?';

  @override
  String get avQHowToRead => 'วิธีอ่านคะแนนเหล่านี้';

  @override
  String get avQSavVsBav => 'SAV เทียบกับ BAV';

  @override
  String get avABody =>
      'Ashtakavarga เป็นระบบวัดความแข็งแกร่งแบบให้คะแนนในโหราศาสตร์เวท ดาวแต่ละดวงจะให้คะแนนมงคล (bindu หรือเรียกอีกอย่างว่า rekha) แก่สิบสองราศีตามตำแหน่งของตน ยิ่งราศีใดมีคะแนนมากเท่าใด ด้านชีวิตนั้นก็จะได้รับการสนับสนุนที่ราบรื่นขึ้นในช่วงเวลาและการโคจรผ่านของดาวที่เกี่ยวข้อง';

  @override
  String get avSavBody =>
      'SAV (Sarva Ashtakavarga) คือผลรวมคะแนนจากดาวเคราะห์ทั้งเจ็ดดวงในแต่ละราศี ทำให้ได้คะแนนความแข็งแกร่งเดียวต่อราศี ช่วยให้คุณเห็นได้อย่างรวดเร็วว่าราศีใด — และเรือนที่ราศีนั้นตกอยู่ — ได้รับการสนับสนุนดีที่สุดในดวงชะตาของคุณ';

  @override
  String get avBavBody =>
      'BAV (Bhinna Ashtakavarga) แสดงคะแนนจากดาวเคราะห์ดวงเดียวตลอดสิบสองราศี บอกให้ทราบว่าดาวดวงนั้นสนับสนุนราศีใดมากที่สุด ซึ่งมีความสำคัญเมื่อ Dasha หรือ Transit ของดาวดวงนั้นกำลังทำงาน';

  @override
  String get avHowToReadBody =>
      'ตัวเลขที่สูงกว่าย่อมดีกว่า สำหรับ SAV ราศีโดยเฉลี่ยจะได้คะแนนประมาณ 28 คะแนน — สูงกว่า 30 ถือว่าแข็งแกร่ง และต่ำกว่า 25 ควรระมัดระวัง สำหรับ BAV แต่ละราศีมีค่าตั้งแต่ 0 ถึง 8 โดย 4 คือค่าเฉลี่ย ควรใช้ราศีที่แข็งแกร่งที่สุดของคุณสำหรับการกระทำที่สำคัญ และรักษาความอดทนและวินัยกับราศีที่อ่อนแอที่สุด';

  @override
  String get avSavVsBavBody =>
      'SAV คือผลรวมของดาวเคราะห์ทั้งหมดและแสดงความแข็งแกร่งโดยรวมของราศี BAV คือการมีส่วนร่วมของดาวเคราะห์ดวงเดียวและแสดงว่าดาวใดสนับสนุนราศีนั้น ใช้ SAV เพื่อดูภาพรวม และใช้ BAV เพื่อทำความเข้าใจว่าดาวใดเป็นตัวขับเคลื่อนความแข็งแกร่งของราศี';

  @override
  String avSummaryInsight(Object s1, Object s2, Object s3, Object weak) {
    return 'ดวงชะตาของคุณแข็งแกร่งที่สุดใน $s1, $s2 และ $s3 ราศีเหล่านี้ให้การสนับสนุนที่ดีกว่าในช่วงเวลาดาวเคราะห์และการโคจรผ่าน $weak ในขณะนี้มีการสนับสนุนน้อยที่สุด ดังนั้นความอดทนและวินัยจะช่วยได้ในเรื่องที่เกี่ยวข้อง';
  }

  @override
  String avBavInsight(Object planet, Object s1, Object s2) {
    return '$planet ทำงานได้แข็งแกร่งที่สุดผ่าน $s1 และ $s2 เรื่องที่ $planet ปกครองมีแนวโน้มดีขึ้นเมื่อราศีเหล่านี้ถูกกระตุ้น';
  }

  @override
  String avInsightStrong(Object s1, Object s2) {
    return 'ราศีที่แข็งแกร่งที่สุดของคุณคือ $s1 และ $s2 — ควรเริ่มต้นสิ่งสำคัญเมื่อดาวโคจรผ่านราศีเหล่านี้';
  }

  @override
  String avInsightWeak(Object s1) {
    return '$s1 มีการสนับสนุนน้อยที่สุด — ควรเคลื่อนไหวอย่างระมัดระวังและหลีกเลี่ยงการผูกมัดมากเกินไปในเรื่องที่เกี่ยวข้อง';
  }

  @override
  String avInsightBestPlanet(Object planet) {
    return '$planet มีคะแนนมากที่สุด ดังนั้นความหมายของดาวนี้จึงได้รับการสนับสนุนที่ดีในชีวิตของคุณ';
  }

  @override
  String avInsightWeakPlanet(Object planet) {
    return '$planet มีคะแนนน้อยที่สุดและได้ประโยชน์มากที่สุดจากการแก้ไขและความพยายามอย่างมีสติ';
  }

  @override
  String avInsightAverage(Object avg) {
    return 'ราศีที่มีคะแนนสูงกว่าค่าเฉลี่ยของคุณที่ $avg คะแนน มีแนวโน้มให้ผลลัพธ์ที่ราบรื่นและน่าเชื่อถือมากกว่า';
  }

  @override
  String get fcKey => 'สำคัญ';

  @override
  String get fcActions => 'การกระทำ';

  @override
  String get fcCautions => 'ข้อควรระวัง';

  @override
  String get fc12House => '12 เรือน';

  @override
  String get fcProbabilities => 'ความน่าจะเป็น';

  @override
  String get fcHousesCaps => 'เรือน';

  @override
  String get fcCritical => 'สำคัญวิกฤต';

  @override
  String get fcFlags => 'สัญญาณเตือน';

  @override
  String get fcAnalysis => 'การวิเคราะห์';

  @override
  String get fcConfidence => 'ความเชื่อมั่น';

  @override
  String get fcQualityCaps => 'คุณภาพ';

  @override
  String get fcIncomeVs => 'รายได้เทียบกับ';

  @override
  String get fcExpense => 'รายจ่าย';

  @override
  String get fcFinance => 'การเงิน';

  @override
  String get fcNetBalance => 'ยอดคงเหลือสุทธิ';

  @override
  String get fcSignature => 'ลายเซ็น';

  @override
  String get fcBestTimeForIncome => 'เวลาที่ดีที่สุดสำหรับรายได้';

  @override
  String get fcExpenseCaution => 'ข้อควรระวังด้านรายจ่าย';

  @override
  String get fcIncomeCaps => 'รายได้';

  @override
  String get fcExpenseCaps => 'รายจ่าย';

  @override
  String get fcRelationships => 'ความสัมพันธ์';

  @override
  String get fcAreasCaps => 'ด้าน';

  @override
  String get fcBestForMeetings => 'เหมาะที่สุดสำหรับการนัดพบ';

  @override
  String get fcOpportunitiesVs => 'โอกาสเทียบกับ';

  @override
  String get fcRisks => 'ความเสี่ยง';

  @override
  String get fcOutlook => 'แนวโน้ม';

  @override
  String get fcAction => 'การกระทำ';

  @override
  String get fcProtect => 'ป้องกัน';

  @override
  String get fcOpportunityCaps => 'โอกาส';

  @override
  String get fcRiskCaps => 'ความเสี่ยง';

  @override
  String get fcTopOpportunities => 'โอกาสอันดับต้น';

  @override
  String get fcTopRisks => 'ความเสี่ยงอันดับต้น';

  @override
  String get fcTiming => 'จังหวะเวลา';

  @override
  String get fcWindows => 'ช่วงเวลา';

  @override
  String get fcSlotsCaps => 'ช่วง';

  @override
  String get fcBestWindows => 'ช่วงเวลาที่ดีที่สุด';

  @override
  String get fcWorstWindows => 'ช่วงเวลาที่แย่ที่สุด';

  @override
  String get fcAvoid => 'หลีกเลี่ยง';

  @override
  String get fcHouse => 'เรือน';

  @override
  String get fcFailed => 'ล้มเหลว';

  @override
  String get lifeCareer => 'อาชีพ';

  @override
  String get lifeHealth => 'สุขภาพ';

  @override
  String get lifeWealth => 'ความมั่งคั่ง';

  @override
  String get lifeFamily => 'ครอบครัว';

  @override
  String get lifeMind => 'จิตใจ';

  @override
  String get lifeEgo => 'อัตตา';

  @override
  String get lifeAggression => 'ความก้าวร้าว';

  @override
  String get lifeConflict => 'ความขัดแย้ง';

  @override
  String get rashiElement => 'ธาตุ';

  @override
  String get rashiQuality => 'ลักษณะราศี';

  @override
  String get rashiLuckyColor => 'สีมงคล';

  @override
  String get rashiLuckyDay => 'วันมงคล';

  @override
  String get rashiLuckyNumber => 'เลขมงคล';

  @override
  String get rashiGemstone => 'อัญมณี';

  @override
  String get rashiBody => 'ร่างกาย';

  @override
  String get gocharTodaysTransitChart => 'ดวง Transit วันนี้';

  @override
  String get gocharTransit => 'Transit';

  @override
  String get thisWeek => 'สัปดาห์นี้';

  @override
  String get thisMonth => 'เดือนนี้';

  @override
  String get best => 'ดีที่สุด';

  @override
  String get worst => 'แย่ที่สุด';

  @override
  String get avg => 'เฉลี่ย';

  @override
  String get favorableLoveWindowsLabel => 'ช่วงเวลาความรักที่เอื้ออำนวย';

  @override
  String get lordLabel => 'เจ้าเรือน';

  @override
  String get lordPlacementLabel => 'ตำแหน่งเจ้าเรือน';

  @override
  String get lordDignityLabel => 'ศักดิ์ของเจ้าเรือน';

  @override
  String get categoriesSuffix => 'หมวดหมู่';

  @override
  String get coreBlockerLabel => 'อุปสรรคหลัก';

  @override
  String get coreGiftLabel => '✦ พรสวรรค์หลัก';

  @override
  String get coreThemeLabel => '● แก่นเรื่องหลัก';

  @override
  String dominantLabel(Object value) {
    return 'เด่น: $value';
  }

  @override
  String get karakasSuffix => 'Karaka';

  @override
  String get protectiveLabel => 'ปกป้อง';

  @override
  String secondaryLabel(Object value) {
    return ' · รอง: $value';
  }

  @override
  String get tagCore => 'หลัก';

  @override
  String get debtScoresHeader => '📉 คะแนนหนี้สิน';

  @override
  String get debtCurrentLoadStat => 'ภาระหนี้สิน\nปัจจุบัน';

  @override
  String get debtRecoveryCapacityStat => 'ศักยภาพ\nการฟื้นตัว';

  @override
  String get debtIntensityStat => 'ความรุนแรง';

  @override
  String get debtDefaultRiskStat => 'ความเสี่ยงผิดนัดชำระหนี้';

  @override
  String get debtProfileTitle => 'โปรไฟล์หนี้สิน';

  @override
  String get debtKarmaLabel => 'กรรม';

  @override
  String get debtPersonalityLabel => 'บุคลิกภาพ';

  @override
  String get debtPhaseLabel => 'ระยะ';

  @override
  String get debtPrimaryCategoryLabel => 'หมวดหมู่หลัก';

  @override
  String get debtWord => 'หนี้สิน';

  @override
  String get debtYogasTitle => 'Yoga หนี้สิน';

  @override
  String get debtCreatingLabel => 'ก่อหนี้';

  @override
  String get debtClearingLabel => 'ปลดหนี้';

  @override
  String get yearlyDebtTitle => 'หนี้สินรายปี';

  @override
  String get debtRepaymentTitle => 'การชำระคืน';

  @override
  String get debtDangerPeriodsTitle => 'ช่วงเวลาอันตราย';

  @override
  String get debtDefaultPctStat => '% ผิดนัดชำระ';

  @override
  String get debtBankruptcyPctStat => '% ล้มละลาย';

  @override
  String get debtChronicPctStat => '% เรื้อรัง';

  @override
  String get debtResilienceStat => 'ความยืดหยุ่นทางใจ';

  @override
  String debtRecoveryTimelineSubtitle(Object pct, Object years) {
    return 'การฟื้นตัว: $pct% · ระยะเวลา: $years ปี';
  }

  @override
  String get debtFreeWindowLabel => '🎯 ช่วงเวลาปลอดหนี้';

  @override
  String debtFreeYear(Object year) {
    return 'ปี $year';
  }

  @override
  String get legalScoresHeader => '⚖️ คะแนนด้านกฎหมาย';

  @override
  String get legalVulnerabilityStat => 'จุดเปราะบาง\nทางกฎหมาย';

  @override
  String get legalVictoryPotentialStat => 'ศักยภาพ\nการชนะคดี';

  @override
  String get legalConflictStat => 'ความขัดแย้ง';

  @override
  String get legalResolutionStat => 'การยุติข้อพิพาท';

  @override
  String get legalProfileTitle => 'โปรไฟล์ด้านกฎหมาย';

  @override
  String get legalKarmaTypeLabel => 'ประเภทกรรม';

  @override
  String get legalConflictStyleLabel => 'รูปแบบความขัดแย้ง';

  @override
  String get legalStrategyLabel => 'กลยุทธ์';

  @override
  String get legalCaseDurationLabel => 'ระยะเวลาคดี';

  @override
  String get legalCurrentStatusLabel => 'สถานะปัจจุบัน';

  @override
  String get legalWord => 'กฎหมาย';

  @override
  String get legalYogasTitle => 'Yoga ด้านกฎหมาย';

  @override
  String get legalDisputePressureLabel => 'แรงกดดันจากข้อพิพาท';

  @override
  String get legalProtectionLabel => 'การป้องกันทางกฎหมาย';

  @override
  String get legalStressTrendTitle => 'ความเครียดด้านกฎหมาย';

  @override
  String get legalVisibleEnemiesStat => 'ศัตรูที่มองเห็นได้';

  @override
  String get legalHiddenEnemiesStat => 'ศัตรูที่ซ่อนอยู่';

  @override
  String get legalCriminalRiskStat => 'ความเสี่ยงคดีอาญา';

  @override
  String get legalFalseAccusationStat => 'ถูกกล่าวหาเท็จ';

  @override
  String get legalContractKarmaTitle => 'กรรมด้านสัญญา';

  @override
  String get legalDocumentationLabel => 'เอกสาร';

  @override
  String get legalFinePrintAwareLabel => 'ใส่ใจรายละเอียดสัญญา';

  @override
  String get legalNegotiationSkillLabel => 'ทักษะการเจรจา';

  @override
  String get legalSignatureCautionLabel => 'ความระมัดระวังการลงนาม';

  @override
  String legalResilienceSubtitle(Object pct) {
    return 'ความยืดหยุ่น: $pct/100';
  }

  @override
  String get legalVictoryWord => 'ชัยชนะ';

  @override
  String get legalAnalysisSuffix => 'การวิเคราะห์';

  @override
  String get legalAsPlaintiff => 'ในฐานะโจทก์';

  @override
  String get legalAsDefendant => 'ในฐานะจำเลย';

  @override
  String get legalWinProbability => 'ความน่าจะเป็นในการชนะ';

  @override
  String get legalDisputeWord => 'ข้อพิพาท';

  @override
  String get lifepathScoresHeader => '🌟 คะแนนเส้นทางชีวิต';

  @override
  String get lifepathDharmaClarityStat => 'ความชัดเจน\nทางธรรมะ';

  @override
  String get lifepathFortuneBaselineStat => 'พื้นฐาน\nโชคลาภ';

  @override
  String get lifepathCoherenceStat => 'ความสอดคล้อง\nเส้นทางชีวิต';

  @override
  String get lifepathKarmaStat => 'กรรม';

  @override
  String get lifepathSpiritualStat => 'จิตวิญญาณ';

  @override
  String get lifepathFameStat => 'ชื่อเสียง';

  @override
  String get lifepathSoulContractTitle => 'สัญญาจิตวิญญาณ';

  @override
  String get lifepathAtmakarakaLabel => 'Atmakaraka';

  @override
  String get lifepathAkFocusLabel => 'จุดเน้นของ AK';

  @override
  String get lifepathSoulPurposeLabel => 'เป้าหมายจิตวิญญาณ';

  @override
  String get lifepathLifeChapterLabel => 'บทของชีวิต';

  @override
  String get lifepathPrimaryDomainLabel => 'ด้านหลัก';

  @override
  String get lifepathLeadershipStat => 'ความเป็นผู้นำ';

  @override
  String get lifepathWisdomTeachStat => 'ปัญญา/การสอน';

  @override
  String get lifepathServiceStat => 'การรับใช้';

  @override
  String get lifepathHealingStat => 'การเยียวยา';

  @override
  String get lifepathFortuneYogasTitle => 'Yoga แห่งโชคลาภ';

  @override
  String get lifepathLuckBlocksLabel => 'อุปสรรคดวงชะตา';

  @override
  String get lifepathFortuneBoostersLabel => 'ตัวเสริมโชคลาภ';

  @override
  String get lifepathFortuneTrendTitle => 'แนวโน้มโชคลาภ';

  @override
  String get lifepathGoldenWindowsTitle => 'ช่วงเวลาทอง ★';

  @override
  String get lifepathTransformationTitle => 'การเปลี่ยนแปลง';

  @override
  String get lifepathMilestonesTitle => 'จุดหมายสำคัญของชีวิต';

  @override
  String get lifepathKarmicLessonsTitle => 'บทเรียนทางกรรม';

  @override
  String get lifepathRahuGrowthLabel => 'การเติบโตของ Rahu';

  @override
  String get lifepathKetuSurrenderLabel => 'การปล่อยวางของ Ketu';

  @override
  String get lifepathSaturnLessonLabel => 'บทเรียนของ Saturn';

  @override
  String get lifepathLifeDifficultyLabel => 'ความยากลำบากในชีวิต';

  @override
  String get lifepathSoulExperienceTitle => '★ สิ่งที่จิตวิญญาณมาสัมผัส';

  @override
  String get lifepathBlessingsTitle => '● พร';

  @override
  String get lifepathLifeWord => 'ชีวิต';

  @override
  String get lifepathArchetypeSuffix => 'ต้นแบบ';

  @override
  String lifepathFulfillmentSubtitle(Object pct) {
    return 'ความสำเร็จสมหวัง: $pct%';
  }

  @override
  String get lifepathDestinyVsWord => 'โชคชะตากับ';

  @override
  String get lifepathFreeWillSuffix => 'เจตจำนงเสรี';

  @override
  String get lifepathDestinyStat => 'โชคชะตา';

  @override
  String get lifepathFreeWillStat => 'เจตจำนงเสรี';

  @override
  String get pastlifeScoresHeader => '🔮 คะแนนชาติที่แล้ว';

  @override
  String get pastlifeSignatureStrengthStat => 'ความแข็งแกร่ง\nลายเซ็น';

  @override
  String get pastlifeCarryForwardStat => 'สิ่งที่\nส่งต่อมา';

  @override
  String get pastlifeMasteryPreservedStat => 'ความเชี่ยวชาญ\nที่คงไว้';

  @override
  String get pastlifeUnfinishedStat => 'ยังไม่สำเร็จ';

  @override
  String get pastlifeKarmicDebtStat => 'หนี้กรรม';

  @override
  String get pastlifeProfileTitle => 'โปรไฟล์ชาติที่แล้ว';

  @override
  String get pastlifeThemeLabel => 'แก่นเรื่อง';

  @override
  String get pastlifeProfessionLabel => 'อาชีพ';

  @override
  String get pastlifeSocialStandingLabel => 'สถานะทางสังคม';

  @override
  String get pastlifeRegionLabel => 'ภูมิภาค';

  @override
  String get pastlifeSpiritualLevelLabel => 'ระดับจิตวิญญาณ';

  @override
  String get pastlifeGenderLabel => 'เพศ';

  @override
  String get pastlifeWealthLevelLabel => 'ระดับทรัพย์สิน';

  @override
  String get pastlifeFamilyRoleLabel => 'บทบาทในครอบครัว';

  @override
  String get pastlifeSkillsCarriedTitle => '★ ทักษะที่ส่งต่อมา';

  @override
  String get pastlifeNaturalAttractionsTitle => '● แรงดึงดูดตามธรรมชาติ';

  @override
  String get pastlifeUnexplainedFearsTitle => '⚠ ความกลัวที่อธิบายไม่ได้';

  @override
  String get pastlifeMagneticPullsTitle => '→ แรงดึงดูดที่รุนแรง';

  @override
  String get pastlifeRelationshipStat => 'ความสัมพันธ์';

  @override
  String get pastlifeFinancialStat => 'การเงิน';

  @override
  String get pastlifeServiceStat => 'การรับใช้';

  @override
  String get pastlifeDharmicStat => 'ธรรมะ';

  @override
  String get pastlifeOnRelationsStat => 'ต่อความสัมพันธ์';

  @override
  String get pastlifeOnCareerStat => 'ต่ออาชีพ';

  @override
  String get pastlifeOnHealthStat => 'ต่อสุขภาพ';

  @override
  String get pastlifeOnSpiritualStat => 'ต่อจิตวิญญาณ';

  @override
  String get pastlifeKarmicResolutionTitle => 'การคลี่คลายกรรม';

  @override
  String get pastlifePrimaryPathLabel => 'เส้นทางหลัก';

  @override
  String get pastlifeSecondaryPathLabel => 'เส้นทางรอง';

  @override
  String get pastlifeClearingProgressLabel => 'ความคืบหน้าการชำระกรรม';

  @override
  String get pastlifeRemainingWorkLabel => 'งานที่เหลืออยู่';

  @override
  String get pastlifeDebtTimelineLabel => 'ไทม์ไลน์หนี้กรรม';

  @override
  String get pastlifeMemoryAccessStat => 'การเข้าถึงความทรงจำ';

  @override
  String get pastlifeDreamVisitsStat => 'การมาเยือนในความฝัน';

  @override
  String get pastlifeDejaVuStat => 'ดีจาวู';

  @override
  String get pastlifeRegressionFitStat => 'ความเหมาะสมกับการบำบัดย้อนอดีต';

  @override
  String get pastlifeActivationTitle => 'การกระตุ้นชาติที่แล้ว';

  @override
  String pastlifeMaturityStatusSubtitle(Object maturity, Object status) {
    return 'ความเป็นผู้ใหญ่: $maturity · สถานะ: $status';
  }

  @override
  String get pastlifeKetuWord => 'Ketu';

  @override
  String get pastlifePastMasterySuffix => 'ความเชี่ยวชาญในอดีต';

  @override
  String get pastlifeKetuMasteredLabel => 'KETU · สิ่งที่คุณเชี่ยวชาญ';

  @override
  String get pastlifeRahuWord => 'Rahu';

  @override
  String get pastlifeFutureGrowthSuffix => 'การเติบโตในอนาคต';

  @override
  String get pastlifeRahuPullsLabel => 'RAHU · สิ่งที่ดึงคุณไปข้างหน้า';

  @override
  String pastlifeShadowPrefix(Object shadow) {
    return '⚠ ด้านมืด: $shadow';
  }

  @override
  String get mentalScoresHeader => '🧠 คะแนนสุขภาพจิต';

  @override
  String get mentalStabilityStat => 'ความมั่นคง\nทางจิตใจ';

  @override
  String get mentalEmotionalBaselineStat => 'พื้นฐาน\nทางอารมณ์';

  @override
  String get mentalResilienceStat => 'ความยืดหยุ่นทางใจ';

  @override
  String get mentalAnxietyStat => 'ความวิตกกังวล';

  @override
  String get mentalDepressionStat => 'ภาวะซึมเศร้า';

  @override
  String get mentalRegulationStat => 'การควบคุมอารมณ์';

  @override
  String get mentalProfileTitle => 'โปรไฟล์สุขภาพจิต';

  @override
  String get mentalConstitutionLabel => 'ธาตุเจ้าเรือน';

  @override
  String get mentalStressDriverLabel => 'ตัวกระตุ้นความเครียด';

  @override
  String get mentalStabilityAnchorLabel => 'จุดยึดเหนี่ยวความมั่นคง';

  @override
  String get mentalStressResponseLabel => 'การตอบสนองต่อความเครียด';

  @override
  String get mentalAttachmentStyleLabel => 'รูปแบบความผูกพัน';

  @override
  String get mentalBurnoutStageLabel => 'ระยะภาวะหมดไฟ';

  @override
  String get mentalWord => 'จิตใจ';

  @override
  String get mentalYogasTitle => 'Yoga ด้านจิตใจ';

  @override
  String get mentalStressPressureLabel => 'แรงกดดันความเครียด';

  @override
  String get mentalWellnessTrendTitle => 'แนวโน้มสุขภาวะ';

  @override
  String get mentalHealthyCopingTitle => '✓ การรับมือที่ดีต่อสุขภาพ';

  @override
  String get mentalUnhealthyRisksTitle => '⚠ ความเสี่ยงที่ไม่ดีต่อสุขภาพ';

  @override
  String get mentalRecommendedAlternativesTitle => '✦ ทางเลือกที่แนะนำ';

  @override
  String get mentalSleepQualityStat => 'คุณภาพการนอนหลับ';

  @override
  String get mentalSocialSupportStat => 'แรงสนับสนุนทางสังคม';

  @override
  String get mentalBurnoutVulnStat => 'ความเปราะบางต่อภาวะหมดไฟ';

  @override
  String get mentalSelfAwarenessStat => 'การตระหนักรู้ในตนเอง';

  @override
  String get mentalAnxietyWord => 'ความวิตกกังวล';

  @override
  String get mentalTypesSuffix => 'ประเภท';

  @override
  String get mentalTherapyWord => 'การบำบัด';

  @override
  String get mentalModalityFitSuffix => 'รูปแบบที่เหมาะสม';

  @override
  String get characterScoresHeader => '🔍 คะแนนบุคลิกภาพ';

  @override
  String get characterStrengthStat => 'ความแข็งแกร่ง\nบุคลิกภาพ';

  @override
  String get characterIntegrityStat => 'ความซื่อสัตย์';

  @override
  String get characterResilienceStat => 'ความยืดหยุ่นทางใจ';

  @override
  String get characterAwarenessStat => 'การตระหนักรู้';

  @override
  String get characterStabilityStat => 'ความมั่นคง';

  @override
  String get characterEthicsStat => 'จริยธรรม';

  @override
  String get characterSurfacePersonalityTitle => 'บุคลิกภาพภายนอก';

  @override
  String get characterLagnaLabel => 'Lagna';

  @override
  String get characterConstitutionLabel => 'ธาตุเจ้าเรือน';

  @override
  String get characterNakshatraLabel => 'Nakshatra';

  @override
  String get characterDeityLabel => 'เทพประจำ Nakshatra';

  @override
  String get characterMoonManasTitle => 'Moon Manas (จิตใจ)';

  @override
  String get characterSignLabel => 'ราศี';

  @override
  String get characterHouseLabel => 'เรือน';

  @override
  String get characterWarmthStat => 'ความอบอุ่น';

  @override
  String get characterEmpathyStat => 'ความเห็นอกเห็นใจ';

  @override
  String get characterLoyaltyStat => 'ความภักดี';

  @override
  String get characterBoundariesStat => 'การตั้งขอบเขต';

  @override
  String get characterDharmaStat => 'ธรรมะ';

  @override
  String get characterTruthStat => 'ความสัตย์จริง';

  @override
  String get characterCompassionStat => 'ความเมตตา';

  @override
  String get characterGenerosityStat => 'ความเอื้อเฟื้อ';

  @override
  String get characterSignatureVirtuesTitle => '★ คุณธรรมเด่นประจำตัว';

  @override
  String get characterNaturalTalentsTitle => '● พรสวรรค์โดยธรรมชาติ';

  @override
  String get characterShadowPatternsTitle => '⚠ รูปแบบด้านมืด';

  @override
  String get characterYogasTitle => 'Yoga ด้านบุคลิกภาพ';

  @override
  String get characterTestsLabel => 'บททดสอบ';

  @override
  String get characterGiftsLabel => 'พรสวรรค์';

  @override
  String get characterSelfAwareEiStat => 'การตระหนักรู้ในตนเอง (EI)';

  @override
  String get characterSelfRegulateStat => 'การควบคุมตนเอง';

  @override
  String get characterEmpathyEiStat => 'ความเห็นอกเห็นใจ (EI)';

  @override
  String get characterSocialSkillsStat => 'ทักษะทางสังคม';

  @override
  String characterRealizationSubtitle(Object pct) {
    return 'การตระหนักรู้: $pct%';
  }

  @override
  String get characterAtmakarakaWord => 'Atmakaraka';

  @override
  String get characterSoulSignatureSuffix => 'ลายเซ็นจิตวิญญาณ';

  @override
  String get characterAtmakarakaLabel => 'Atmakaraka';

  @override
  String get characterGunaWord => 'Guna';

  @override
  String get characterProfileSuffix => 'โปรไฟล์';

  @override
  String get characterSattvaLabel => 'Sattva';

  @override
  String get characterRajasLabel => 'Rajas';

  @override
  String get characterTamasLabel => 'Tamas';

  @override
  String get healthScoresHeader => '🏥 คะแนนสุขภาพ';

  @override
  String get healthVitalityStat => 'พลังชีวิต';

  @override
  String get healthImmunityStat => 'ภูมิคุ้มกัน';

  @override
  String get healthRecoveryStat => 'การฟื้นตัว';

  @override
  String get healthMentalStat => 'จิตใจ';

  @override
  String get healthStressTolStat => 'ความทนทานต่อความเครียด';

  @override
  String get healthYogasTitle => 'Yoga ด้านสุขภาพ';

  @override
  String get healthDiseasePressureLabel => 'แรงกดดันจากโรค';

  @override
  String get healthTrendTitle => 'แนวโน้มสุขภาพ';

  @override
  String get healthRecoveryWindowsTitle => 'ช่วงเวลาฟื้นตัว';

  @override
  String get healthCautionPeriodsTitle => 'ช่วงเวลาที่ควรระวัง';

  @override
  String get healthFertilityStat => 'ภาวะเจริญพันธุ์';

  @override
  String get healthBurnoutRiskStat => 'ความเสี่ยงภาวะหมดไฟ';

  @override
  String get healthAddictionVulnStat => 'ความเปราะบางต่อการเสพติด';

  @override
  String get healthWorkLifeBalStat => 'สมดุลชีวิตและงาน';

  @override
  String get healthAyurvedicWord => 'อายุรเวท';

  @override
  String get healthConstitutionSuffix => 'ธาตุเจ้าเรือน';

  @override
  String get healthBodyWord => 'ร่างกาย';

  @override
  String get healthSystemMapSuffix => 'แผนที่ระบบ';

  @override
  String get healthBodyZoneWord => 'บริเวณร่างกาย';

  @override
  String get healthVulnerabilitySuffix => 'จุดเปราะบาง';

  @override
  String get healthDiseaseWord => 'โรค';

  @override
  String get healthSusceptibilitySuffix => 'ความอ่อนไหว';

  @override
  String get healthLifestyleFactorsTitle => 'ปัจจัยด้านวิถีชีวิต';

  @override
  String get healthSleepDisciplineLabel => 'วินัยการนอน';

  @override
  String get healthDietDisciplineLabel => 'วินัยการกิน';

  @override
  String get healthExerciseNeedLabel => 'ความต้องการออกกำลังกาย';

  @override
  String get healthSunlightNeedLabel => 'ความต้องการแสงแดด';

  @override
  String get healthSocialTypeLabel => 'ประเภททางสังคม';

  @override
  String get healthHealingSpeedLabel => 'ความเร็วในการฟื้นตัว';

  @override
  String get wealthScoresHeader => '💰 คะแนนความมั่งคั่ง';

  @override
  String get wealthStrengthStat => 'ความแข็งแกร่ง\nด้านความมั่งคั่ง';

  @override
  String get wealthAccumulationStat => 'การสะสม\nทรัพย์';

  @override
  String get wealthIncomeFlowStat => 'กระแส\nรายได้';

  @override
  String get wealthSustainStat => 'ความยั่งยืน';

  @override
  String get wealthMultiStreamStat => 'หลายช่องทาง';

  @override
  String get wealthRetentionStat => 'การรักษาทรัพย์สิน';

  @override
  String get wealthWord => 'ความมั่งคั่ง';

  @override
  String get wealthYogasTitle => 'Yoga แห่งความมั่งคั่ง';

  @override
  String get wealthDrainsLabel => 'ตัวลดทอน';

  @override
  String get wealthBoostersLabel => 'ตัวเสริม';

  @override
  String get wealthYearlyTrendTitle => 'แนวโน้มรายปี';

  @override
  String get wealthGrowthTitle => 'การเติบโตของความมั่งคั่ง';

  @override
  String get wealthCashPressureTitle => 'แรงกดดันด้านเงินสด';

  @override
  String get wealthMoneyPersonalityTitle => 'บุคลิกภาพด้านการเงิน';

  @override
  String get wealthTypeLabel => 'ประเภทความมั่งคั่ง';

  @override
  String get wealthRiskAppetiteLabel => 'ความเสี่ยงที่รับได้';

  @override
  String get wealthInvestmentStyleLabel => 'รูปแบบการลงทุน';

  @override
  String get wealthMoneyPersonalityLabel => 'บุคลิกภาพด้านการเงิน';

  @override
  String get wealthSpendingLabel => 'การใช้จ่าย';

  @override
  String get wealthDebtProbStat => '% ความน่าจะเป็นเป็นหนี้';

  @override
  String get wealthInheritanceStat => '% มรดก';

  @override
  String get wealthSuddenGainsStat => '% รายได้ฉับพลัน';

  @override
  String get wealthSpouseBoostStat => '% เสริมจากคู่สมรส';

  @override
  String wealthSuccessProbabilitySubtitle(Object pct) {
    return 'ความน่าจะเป็นสำเร็จ: $pct%';
  }

  @override
  String get wealthLifetimeClassLabel => 'ระดับความมั่งคั่งตลอดชีวิต';

  @override
  String wealthPrimaryLabel(Object value) {
    return 'หลัก: $value';
  }

  @override
  String wealthPeakLabel(Object value) {
    return 'จุดสูงสุด: $value';
  }

  @override
  String get wealthIncomeWord => 'รายได้';

  @override
  String get wealthSourcesSuffix => 'แหล่งที่มา';

  @override
  String get wealthInvestmentWord => 'การลงทุน';

  @override
  String get wealthMixSuffix => 'สัดส่วน';

  @override
  String wealthDrivenByLabel(Object planet) {
    return 'ขับเคลื่อนโดย $planet';
  }

  @override
  String get marriageScoresHeader => '💒 คะแนนการแต่งงาน';

  @override
  String get marriageOverallStat => 'การแต่งงาน\nโดยรวม';

  @override
  String get marriageHarmonyStat => 'ความกลมกลืน\nในชีวิตคู่';

  @override
  String get marriageDomesticStabilityStat => 'ความมั่นคง\nในบ้าน';

  @override
  String get marriageLongevityStat => 'ความยืนยาว';

  @override
  String get marriageSatisfactionStat => 'ความพึงพอใจ';

  @override
  String get marriageClarityStat => 'ความชัดเจน';

  @override
  String get marriageWindowsTitle => 'ช่วงเวลาการแต่งงาน';

  @override
  String get marriagePhasesTitle => 'ระยะของการแต่งงาน';

  @override
  String get marriageInLawRelationsStat => 'ความสัมพันธ์กับญาติฝ่ายคู่สมรส';

  @override
  String get marriageFamilyHarmonyStat => 'ความกลมกลืนในครอบครัว';

  @override
  String get marriageFertilityStat => 'ภาวะเจริญพันธุ์';

  @override
  String get marriageHomeOwnershipStat => 'การเป็นเจ้าของบ้าน';

  @override
  String get marriageDivorceRiskStat => 'ความเสี่ยงหย่าร้าง';

  @override
  String get marriageInfidelityStat => 'การนอกใจ';

  @override
  String get marriageConflictStat => 'ความขัดแย้ง';

  @override
  String get marriageDistanceStat => 'ความห่างเหิน';

  @override
  String get marriageSeekInPartnerTitle => '★ สิ่งที่ควรมองหาในคู่ครอง';

  @override
  String get marriageAvoidInPartnerTitle => '⚠ สิ่งที่ควรหลีกเลี่ยงในคู่ครอง';

  @override
  String marriageRealizationSubtitle(Object pct) {
    return 'การตระหนักรู้: $pct%';
  }

  @override
  String get marriageDarakarakaWord => 'Darakaraka';

  @override
  String get marriageSpouseKarakaSuffix => 'Karaka คู่สมรส';

  @override
  String get marriageDarakarakaDkLabel => 'Darakaraka (DK)';

  @override
  String get marriage7thWord => 'เรือนที่ 7';

  @override
  String get marriageSignLabel => 'ราศี';

  @override
  String get marriageLordInLabel => 'เจ้าเรือนอยู่ที่';

  @override
  String get marriageStrengthLabel => 'ความแข็งแกร่ง';

  @override
  String get marriageSpouseWord => 'คู่สมรส';

  @override
  String get marriageProfileSuffix => 'โปรไฟล์';

  @override
  String get marriageSpouseTraitsTitle => '★ คุณลักษณะของคู่สมรส';

  @override
  String get marriageLikelyProfessionsTitle => '● อาชีพที่น่าจะเป็น';

  @override
  String get marriageHarmonyWord => 'ความกลมกลืน';

  @override
  String get marriageRadarSuffix => 'แผนภูมิเรดาร์';

  @override
  String get marriagePhysicalLabel => 'ด้านกายภาพ';

  @override
  String get marriageSharedValuesLabel => 'คุณค่าร่วมกัน';

  @override
  String get marriageConflictResolutionLabel => 'การแก้ไขความขัดแย้ง';

  @override
  String get marriageMangalDoshLabel => '⚠ Mangal Dosh';

  @override
  String marriageSeveritySubtitle(Object value) {
    return 'ความรุนแรง: $value';
  }

  @override
  String marriageCancellationSubtitle(Object value) {
    return 'การยกเลิก: $value';
  }

  @override
  String get marriageD9Word => 'D-9';

  @override
  String get marriageNavamsaSuffix => 'Navamsa';

  @override
  String get multiChartTitleChild => 'บุตร';

  @override
  String get multiChartTitleLove => 'ความรัก';

  @override
  String get multiChartTitleKarma => 'กรรม';

  @override
  String get multiChartTitleDefault => 'หลายดวงชะตา';

  @override
  String get multiChartSuffixProbability => 'ความน่าจะเป็น';

  @override
  String get multiChartSuffixCompatibility => 'ความเข้ากันได้';

  @override
  String get multiChartSuffixLinkage => 'ความเชื่อมโยง';

  @override
  String get multiChartSuffixReport => 'รายงาน';

  @override
  String get multiChartParticipantsLabel => 'ผู้เข้าร่วม';

  @override
  String get multiChartAnalysisWord => 'การวิเคราะห์';

  @override
  String get multiChartConfidenceSuffix => 'ความเชื่อมั่น';

  @override
  String get multiChartQualityBadge => 'คุณภาพ';

  @override
  String multiChartPromptChatgpt(Object formatted) {
    return 'วิเคราะห์รายงานโหราศาสตร์เวทนี้และให้ข้อมูลเชิงลึกโดยละเอียด:\n\n$formatted';
  }

  @override
  String multiChartPromptClaude(Object formatted) {
    return 'นี่คือรายงานผู้เชี่ยวชาญด้านโหราศาสตร์เวท กรุณาวิเคราะห์อย่างละเอียดและให้ข้อมูลเชิงลึกที่นำไปปฏิบัติได้:\n\n$formatted';
  }

  @override
  String multiChartPromptGemini(Object formatted) {
    return 'ตรวจสอบการวิเคราะห์โหราศาสตร์เวทนี้และอธิบายผลการค้นพบสำคัญด้วยภาษาที่เข้าใจง่าย:\n\n$formatted';
  }

  @override
  String multiChartCopiedForLabel(Object label) {
    return 'คัดลอกสำหรับ $label แล้ว!';
  }

  @override
  String get childProbTitle1 => 'บุตร';

  @override
  String get childProbTitle2 => 'ความน่าจะเป็น';

  @override
  String get childNumberOfChildrenHeader1 => 'จำนวน';

  @override
  String get childNumberOfChildrenHeader2 => 'บุตร';

  @override
  String get childTimingHeader1 => 'จังหวะเวลา';

  @override
  String get childTimingHeader2 => 'Moola Dasha';

  @override
  String get child5thHouseHeader1 => 'เรือนที่ 5';

  @override
  String get analysisWord => 'การวิเคราะห์';

  @override
  String get jupiterWord => 'Jupiter';

  @override
  String get childD7Header1 => 'D7 Saptamsa';

  @override
  String get childBeejaHeader1 => 'Beeja และ Kshetra';

  @override
  String get childBeejaHeader2 => 'Sphuta';

  @override
  String get childDoshaHeader1 => 'Dosha';

  @override
  String get childVedicHeader1 => 'เวท';

  @override
  String get childVedicHeader2 => 'แนวทางแก้ไข';

  @override
  String get progenyProbabilityLabel => 'ความน่าจะเป็นเรื่องบุตร';

  @override
  String get favorableWindowsLabel => 'ช่วงเวลาที่เอื้ออำนวย';

  @override
  String get partnerOneLabel => 'คู่ที่ 1';

  @override
  String get partnerTwoLabel => 'คู่ที่ 2';

  @override
  String get moonSignLabel => 'ราศี Moon';

  @override
  String get lordInDusthana => 'เจ้าเรือนอยู่ใน Dusthana';

  @override
  String get lordStrengthLabel => 'ความแข็งแกร่งของเจ้าเรือน';

  @override
  String get houseStrengthLabel => 'ความแข็งแกร่งของเรือน';

  @override
  String get dignityLabel => 'ศักดิ์';

  @override
  String get directBadge => 'เดินตรง';

  @override
  String get notCombustBadge => 'ไม่ถูกเผาไหม้';

  @override
  String get in5thHouseBadge => 'อยู่ในเรือนที่ 5';

  @override
  String get aspects5thBadge => 'ส่งมุมมองไปเรือนที่ 5';

  @override
  String get no5thConnectionBadge => 'ไม่มีความเชื่อมโยงกับเรือนที่ 5';

  @override
  String jupiterInSignHeading(String sign) {
    return 'Jupiter ในราศี $sign';
  }

  @override
  String get d7LagnaLabel => 'D7 Lagna';

  @override
  String get d7FifthSignLabel => 'ราศีที่ 5 ใน D7';

  @override
  String get d7FifthLordLabel => 'เจ้าเรือนที่ 5 ใน D7';

  @override
  String get jupiterInD7Label => 'Jupiter ใน D7';

  @override
  String get jupiterDignityLabel => 'ศักดิ์ของ Jupiter';

  @override
  String get d7StrengthLabel => 'ความแข็งแกร่งของ D7';

  @override
  String get yesWord => 'ใช่';

  @override
  String get noWord => 'ไม่ใช่';

  @override
  String get beejaSphutaTitle => 'Beeja Sphuta';

  @override
  String get kshetraSphutaTitle => 'Kshetra Sphuta';

  @override
  String get degreeLabel => 'องศา';

  @override
  String get signLordLabel => 'เจ้าราศี';

  @override
  String get presentInLabel => 'ปรากฏใน';

  @override
  String get netPenaltyLabel => 'คะแนนหักสุทธิ';

  @override
  String get remedyGemstone => 'การแก้ไขด้วยอัญมณี';

  @override
  String get remedyMantra => 'การแก้ไขด้วยมนตร์';

  @override
  String get remedyRitual => 'การแก้ไขด้วยพิธีกรรม';

  @override
  String get remedyLifestyle => 'การแก้ไขด้วยวิถีชีวิต';

  @override
  String get remedyCharitable => 'การแก้ไขด้วยการบริจาค';

  @override
  String copiedForName(String name) {
    return 'คัดลอกสำหรับ $name แล้ว!';
  }

  @override
  String get mahadashaLabel => 'Mahadasha';

  @override
  String get mdPeriodLabel => 'ช่วง MD';

  @override
  String get antardashaLabel => 'Antardasha';

  @override
  String get adPeriodLabel => 'ช่วง AD';

  @override
  String get pratyantardashaLabel => 'Pratyantardasha';

  @override
  String get favorabilityLabel => 'ความเอื้ออำนวย';

  @override
  String factorPrefix(String factor) {
    return 'ปัจจัย: $factor';
  }

  @override
  String appliesToLabel(String value) {
    return 'ใช้กับ: $value';
  }

  @override
  String get qualityTag => 'คุณภาพ';

  @override
  String get reliabilityVeryHigh => 'ความน่าเชื่อถือสูงมาก';

  @override
  String get reliabilityGuidanceLevel => 'การอ่านระดับแนะแนว';

  @override
  String get karmaLinkTitle1 => 'กรรม';

  @override
  String get karmaLinkTitle2 => 'ความเชื่อมโยง';

  @override
  String get karmaFoundationHeader1 => 'กรรม';

  @override
  String get karmaFoundationHeader2 => 'รากฐาน';

  @override
  String get karmaPairwiseHeader1 => 'แบบคู่';

  @override
  String get karmaPairwiseHeader2 => 'ความเชื่อมโยง';

  @override
  String get karmaGroupHeader1 => 'กลุ่ม';

  @override
  String get karmaGroupHeader2 => 'รูปแบบ';

  @override
  String get karmaPastLifeHeader1 => 'ชาติที่แล้ว';

  @override
  String get karmaPastLifeHeader2 => 'เป้าหมาย';

  @override
  String get karmaCurrentLifeHeader1 => 'ชีวิตปัจจุบัน';

  @override
  String get karmaCurrentLifeHeader2 => 'บทเรียน';

  @override
  String get karmaDebtsHeader2 => 'หนี้กรรม';

  @override
  String get karmaMoolaDashaHeader1 => 'Moola Dasha';

  @override
  String get karmaMoolaDashaHeader2 => 'จังหวะเวลา';

  @override
  String get karmaDeepAuditHeader1 => 'การตรวจสอบเชิงลึก';

  @override
  String get karmaDeepAuditHeader2 => 'ตาราง';

  @override
  String get karmaHeroLabel => 'ความเชื่อมโยงกรรมชาติที่แล้ว';

  @override
  String get karmaKetuMastery => 'ความเชี่ยวชาญของ Ketu';

  @override
  String get nakshatraLabel => 'Nakshatra';

  @override
  String get deityLabel => 'เทพประจำ';

  @override
  String get masteryScoreLabel => 'คะแนนความเชี่ยวชาญ';

  @override
  String get karmaRahuGrowth => 'การเติบโตของ Rahu';

  @override
  String get growthScoreLabel => 'คะแนนการเติบโต';

  @override
  String get karmaAtmakaraka => 'Atmakaraka';

  @override
  String get karmaSaturnKarma => 'กรรมของ Saturn';

  @override
  String get karma12thHouse => 'เรือนที่ 12';

  @override
  String get karma9thHousePunya => 'Punya เรือนที่ 9';

  @override
  String get bhavaScoreLabel => 'คะแนน Bhava';

  @override
  String get karmaD60Signature => 'ลายเซ็น D60';

  @override
  String get depthScoreLabel => 'คะแนนความลึก';

  @override
  String get linkageStrengthLabel => 'ความแข็งแกร่งของความเชื่อมโยง';

  @override
  String karmaLinkageFactorsHeader(int count) {
    return 'ปัจจัยความเชื่อมโยง ($count รายการที่ทำงานอยู่)';
  }

  @override
  String get factorColumnLabel => 'ปัจจัย';

  @override
  String get weightColumnLabel => 'น้ำหนัก';

  @override
  String get meaningColumnLabel => 'ความหมาย';

  @override
  String get statusColumnLabel => 'สถานะ';

  @override
  String get karmaPastLifeConnection => 'ความเชื่อมโยงชาติที่แล้ว';

  @override
  String get karmaCurrentLifeDynamic => 'พลวัตชีวิตปัจจุบัน';

  @override
  String get karmaWhatTheyTeach => 'สิ่งที่สอนซึ่งกันและกัน';

  @override
  String get karmaGroupThemeHeader => 'แก่นเรื่องกรรมของกลุ่ม';

  @override
  String get karmaSharedSettingHeader => 'ฉากชาติที่แล้วร่วมกัน';

  @override
  String get karmaCollectiveKetuHeader => 'รูปแบบ Ketu ร่วมของกลุ่ม';

  @override
  String get karmaCollectiveRahuHeader => 'รูปแบบ Rahu ร่วมของกลุ่ม';

  @override
  String get housesPrefixLabel => 'เรือน: ';

  @override
  String get signsPrefixLabel => 'ราศี: ';

  @override
  String get karmicCohesionLabel => 'ความสามัคคีทางกรรม';

  @override
  String get karmaGroupSoulContractHeader => 'สัญญาจิตวิญญาณของกลุ่ม';

  @override
  String get goalLabel => 'เป้าหมาย';

  @override
  String get karmaSharedGoalHeader => 'เป้าหมายชาติที่แล้วร่วมกัน';

  @override
  String get howToGrowHeader => 'จะเติบโตได้อย่างไร';

  @override
  String moolaDashaPrefix(String value) {
    return 'Moola Dasha: $value';
  }

  @override
  String get karmaSharedLessonHeader => 'บทเรียนร่วมของกลุ่ม';

  @override
  String get karmaMutualTeachingHeader => 'แผนที่บทเรียนซึ่งกันและกัน';

  @override
  String get karmaTeachingDynamicsPlaceholder =>
      'พลวัตการเรียนรู้ซึ่งกันและกันจะปรากฏชัดขึ้นเมื่อความเชื่อมโยงทางกรรมลึกซึ้งขึ้น';

  @override
  String get typeFieldLabel => 'ประเภท';

  @override
  String get basisFieldLabel => 'พื้นฐาน';

  @override
  String get resolutionPathHeader => 'เส้นทางการคลี่คลาย';

  @override
  String dashaTimingPrefix(String value) {
    return 'จังหวะเวลา Dasha: $value';
  }

  @override
  String get mutualDebtsHeader => 'หนี้กรรมร่วมกัน';

  @override
  String get mdLabel => 'MD';

  @override
  String get adLabel => 'AD';

  @override
  String get pdLabel => 'PD';

  @override
  String get datesLabel => 'วันที่';

  @override
  String get groupKarmicWindowHeader => 'ช่วงเวลากรรมของกลุ่ม';

  @override
  String parametersAuditedHeading(int count) {
    return 'ตรวจสอบพารามิเตอร์ $count รายการ';
  }

  @override
  String get valuePrefixLabel => 'ค่า: ';

  @override
  String weightPrefix(String value) {
    return 'น้ำหนัก: $value';
  }

  @override
  String get loveCompatTitle1 => 'ความรัก';

  @override
  String get loveCompatTitle2 => 'ความเข้ากันได้';

  @override
  String get loveAttractionHeader1 => 'แรงดึงดูดและ';

  @override
  String get loveAttractionHeader2 => 'เคมี';

  @override
  String get loveEmotionalHeader1 => 'อารมณ์';

  @override
  String get loveEmotionalHeader2 => 'ความกลมกลืน';

  @override
  String get loveMentalHeader1 => 'ความคิด';

  @override
  String get loveMentalHeader2 => 'ความเข้าใจ';

  @override
  String get lovePassionHeader1 => 'ความหลงใหลและ';

  @override
  String get lovePassionHeader2 => 'กายภาพ';

  @override
  String get loveLongtermHeader1 => 'ระยะยาว';

  @override
  String get loveKarmicHeader1 => 'รักทางกรรม';

  @override
  String get loveKarmicHeader2 => 'พันธะ';

  @override
  String get loveChallengesHeader1 => 'ความท้าทายและ';

  @override
  String get loveChallengesHeader2 => 'ความขัดแย้ง';

  @override
  String get loveTimingHeader1 => 'จังหวะเวลาความรัก';

  @override
  String get loveRelationshipHeader1 => 'ความสัมพันธ์';

  @override
  String get loveRelationshipHeader2 => 'พลวัต';

  @override
  String get loveRemediesHeader1 => 'แนวทางแก้ไขและ';

  @override
  String get loveRemediesHeader2 => 'คำแนะนำ';

  @override
  String get loveCompatHeroLabel => 'ความเข้ากันได้ด้านความรัก';

  @override
  String get loveChipAttraction => 'แรงดึงดูด';

  @override
  String get loveChipPassion => 'ความหลงใหล';

  @override
  String get loveChipChallenge => 'ความท้าทาย';

  @override
  String get venusSignLabel => 'ราศี Venus';

  @override
  String get attractionScoreLabel => 'คะแนนแรงดึงดูด';

  @override
  String get activeContactsLabel => 'การประสานที่กำลังทำงาน';

  @override
  String get magneticPullLabel => 'แรงดึงดูดที่รุนแรง';

  @override
  String get initialAttractionLabel => 'แรงดึงดูดเริ่มต้น';

  @override
  String get emotionalScoreLabel => 'คะแนนทางอารมณ์';

  @override
  String get elementMatchLabel => 'ความเข้ากันของธาตุ';

  @override
  String get harmonyLabel => 'ความกลมกลืน';

  @override
  String get kootaYoni => 'Yoni';

  @override
  String get kootaGana => 'Gana';

  @override
  String get kootaTara => 'Tara';

  @override
  String get doshaPresentBadge => 'มี Dosha';

  @override
  String get noDoshaBadge => 'ไม่มี Dosha';

  @override
  String get axisLabel => 'แกน';

  @override
  String get mentalScoreLabel => 'คะแนนความคิด';

  @override
  String get mercuryDynamicsLabel => 'พลวัตของ Mercury';

  @override
  String get communicationStyleLabel => 'ความเข้ากันของรูปแบบการสื่อสาร';

  @override
  String get intellectualConnectionLabel => 'ความเชื่อมโยงทางสติปัญญา';

  @override
  String get passionScoreLabel => 'คะแนนความหลงใหล';

  @override
  String get marsVenusLabel => 'ปฏิสัมพันธ์ Mars-Venus';

  @override
  String get physicalChemistryLabel => 'เคมีทางกายภาพ';

  @override
  String get yoniCompatLabel => 'ความเข้ากันได้ของ Yoni';

  @override
  String get longtermScoreLabel => 'คะแนนระยะยาว';

  @override
  String get seventhHouseSynastryLabel => 'Synastry เรือนที่ 7';

  @override
  String get commitmentPotentialLabel => 'ศักยภาพความมุ่งมั่นผูกพัน';

  @override
  String get jupiterBlessingLabel => 'พรจาก Jupiter';

  @override
  String get d9NavamsaResonanceLabel => 'การสั่นพ้อง D9 Navamsa';

  @override
  String get saturnLongevityLabel => 'ความยืนยาวจาก Saturn';

  @override
  String get karmicScoreLabel => 'คะแนนทางกรรม';

  @override
  String get darakarakaLinkLabel => 'ความเชื่อมโยง Darakaraka';

  @override
  String get sourceLabel => 'แหล่งที่มา';

  @override
  String get emotionalGiverReceiverLabel => 'ผู้ให้/ผู้รับทางอารมณ์';

  @override
  String get powerBalanceLabel => 'สมดุลอำนาจ';

  @override
  String get growthDynamicLabel => 'พลวัตการเติบโต';

  @override
  String get addressesLabel => 'แก้ไขปัญหา';

  @override
  String get loveScoresLabel => 'คะแนนความรัก';

  @override
  String get loveCapacityLabel => 'ศักยภาพ\nความรัก';

  @override
  String get emotionalAvailabilityLabel => 'ความพร้อม\nทางอารมณ์';

  @override
  String get romanticAttractionLabel => 'แรงดึงดูด\nเชิงโรแมนติก';

  @override
  String get commitmentWord => 'ความมุ่งมั่นผูกพัน';

  @override
  String get intimacyWord => 'ความใกล้ชิด';

  @override
  String get fidelityWord => 'ความซื่อสัตย์';

  @override
  String get loveProfileTitle => 'โปรไฟล์ความรัก';

  @override
  String get loveStyleLabel => 'รูปแบบความรัก';

  @override
  String get attractionStyleLabel => 'รูปแบบแรงดึงดูด';

  @override
  String get lovePathLabel => 'เส้นทางความรัก';

  @override
  String get currentPhaseLabel => 'ระยะปัจจุบัน';

  @override
  String get commitmentStyleLabel => 'รูปแบบความมุ่งมั่นผูกพัน';

  @override
  String get loveWord => 'ความรัก';

  @override
  String get karakasWord => 'Karaka';

  @override
  String get attractedToLabel => 'ดึงดูดใจกับ';

  @override
  String get whatPartnerSeesLabel => 'สิ่งที่คู่ของคุณมองเห็น';

  @override
  String get romancePatternTitle => 'รูปแบบความโรแมนติก';

  @override
  String get firstLoveAgeLabel => 'อายุรักแรก';

  @override
  String get relationshipCountLabel => 'จำนวนความสัมพันธ์';

  @override
  String get avgDurationLabel => 'ระยะเวลาเฉลี่ย';

  @override
  String get breakupTriggerLabel => 'ตัวกระตุ้นการเลิกรา';

  @override
  String get heartbreakRecoveryLabel => 'การฟื้นตัวจากความอกหัก';

  @override
  String get loveTrendTitle => 'แนวโน้มความรัก';

  @override
  String get newLoveWindowsTitle => 'ช่วงเวลาความรักใหม่';

  @override
  String get loveBlocksTitle => 'อุปสรรคความรัก';

  @override
  String get activeBlocksLabel => 'อุปสรรคที่กำลังทำงาน';

  @override
  String get loveMarriagePctLabel => '% แต่งงานด้วยความรัก';

  @override
  String get heartbreakVulnLabel => 'ความเปราะบางต่อความอกหัก';

  @override
  String get selfSabotageLabel => 'การทำลายโอกาสตนเอง';

  @override
  String get emotionalIqLabel => 'ความฉลาดทางอารมณ์';

  @override
  String fulfillmentPctLabel(String pct) {
    return 'ความสำเร็จสมหวัง: $pct%';
  }

  @override
  String get languagesWord => 'ภาษารัก';

  @override
  String get givesLabel => 'ให้';

  @override
  String get receivesLabel => 'รับ';

  @override
  String get idealWord => 'อุดมคติ';

  @override
  String get partnerWord => 'คู่ครอง';

  @override
  String get seekTheseTraitsLabel => 'มองหาคุณลักษณะเหล่านี้';

  @override
  String get dealbreakersLabel => 'สิ่งที่รับไม่ได้';

  @override
  String get propertyScoresLabel => 'คะแนนทรัพย์สิน';

  @override
  String get acquisitionCapacityLabel => 'ศักยภาพ\nการได้มา';

  @override
  String get homeOwnershipPctLabel => '% การเป็น\nเจ้าของบ้าน';

  @override
  String get reWealthPotentialLabel => 'ศักยภาพความมั่งคั่ง\nจากอสังหาฯ';

  @override
  String get rentalWord => 'ค่าเช่า';

  @override
  String get vehiclesWord => 'ยานพาหนะ';

  @override
  String get landPctLabel => '% ที่ดิน';

  @override
  String get propertyProfileTitle => 'โปรไฟล์ทรัพย์สิน';

  @override
  String get karmaTypeLabel => 'ประเภทกรรม';

  @override
  String get environmentLabel => 'สภาพแวดล้อม';

  @override
  String get styleLabel => 'รูปแบบ';

  @override
  String get sizeLabel => 'ขนาด';

  @override
  String get locationLabel => 'สถานที่';

  @override
  String get actionNext12mLabel => 'สิ่งที่ควรทำใน 12 เดือนข้างหน้า';

  @override
  String get propertyWord => 'ทรัพย์สิน';

  @override
  String get propertyYogasTitle => 'Yoga ด้านทรัพย์สิน';

  @override
  String get drainsLabel => 'ตัวลดทอน';

  @override
  String get boostersLabel => 'ตัวเสริม';

  @override
  String get propertyTrendTitle => 'แนวโน้มทรัพย์สิน';

  @override
  String get buyingWindowsTitle => 'ช่วงเวลาที่เหมาะซื้อ';

  @override
  String get constructionWindowsTitle => 'ช่วงเวลาที่เหมาะก่อสร้าง';

  @override
  String get maternalInherPctLabel => '% มรดกฝ่ายมารดา';

  @override
  String get paternalInherPctLabel => '% มรดกฝ่ายบิดา';

  @override
  String get multiHomePctLabel => '% มีบ้านหลายหลัง';

  @override
  String get investmentPctLabel => '% การลงทุน';

  @override
  String get vehicleProfileTitle => 'โปรไฟล์ยานพาหนะ';

  @override
  String get countLabel => 'จำนวน';

  @override
  String get firstAgeLabel => 'อายุครั้งแรก';

  @override
  String get categoryLabel => 'ประเภท';

  @override
  String get luxuryLabel => 'ความหรูหรา';

  @override
  String lifetimeCountFulfillmentLabel(String count, String pct) {
    return 'จำนวนตลอดชีวิต: $count · ความสำเร็จสมหวัง: $pct%';
  }

  @override
  String get pressureWord => 'แรงกดดัน';

  @override
  String get protectionWord => 'การป้องกัน';

  @override
  String get astrologicalWord => 'ทางโหราศาสตร์';

  @override
  String get keyRisksHeader1 => 'ความเสี่ยง';

  @override
  String get keyRisksHeader2 => 'สำคัญ';

  @override
  String get reportCopiedShort => 'คัดลอกรายงานแล้ว!';

  @override
  String get keyScoresLabel => 'คะแนนสำคัญ';

  @override
  String allScoresCountLabel(int count) {
    return 'คะแนนทั้งหมด ($count)';
  }

  @override
  String get windowsWord => 'ช่วงเวลา';

  @override
  String get genericFailedMsg => 'ล้มเหลว';

  @override
  String get unknownWord => 'ไม่ทราบ';

  @override
  String selectKarmaChartsLabel(int max) {
    return 'เลือกดวงชะตา 2-$max ดวง';
  }

  @override
  String selectChartsLabelCount(int max) {
    return 'เลือกดวงชะตา $max ดวง';
  }

  @override
  String runningAnalysisLabel(String label) {
    return 'กำลังวิเคราะห์ $label...';
  }

  @override
  String pickKarmicChartsHint(int max) {
    return 'เลือกดวงชะตา 2 ถึง $max ดวงเพื่อวิเคราะห์ความเชื่อมโยงทางกรรม';
  }

  @override
  String get pickMaleFemaleHint => 'เลือกดวงชะตาชายและหญิง';

  @override
  String get personOneLabel => 'บุคคลที่ 1';

  @override
  String get personTwoLabel => 'บุคคลที่ 2';

  @override
  String get analysisFailedMsg => 'การวิเคราะห์ล้มเหลว';

  @override
  String analyzeChartsCountLabel(int count) {
    return 'วิเคราะห์ดวงชะตา $count ดวง';
  }

  @override
  String get contextGeneralLabel => 'ทั่วไป';

  @override
  String get contextLoveLabel => 'ความรัก';

  @override
  String get contextBusinessLabel => 'ธุรกิจ';

  @override
  String get contextFamilyLabel => 'ครอบครัว';

  @override
  String get contextTeamLabel => 'ทีมงาน';

  @override
  String get contextFriendshipLabel => 'มิตรภาพ';

  @override
  String get relationshipIntelTitle => 'วิเคราะห์ความสัมพันธ์';

  @override
  String analyzingChartsCountLabel(int count) {
    return 'กำลังวิเคราะห์ดวงชะตา $count ดวง...';
  }

  @override
  String get relationshipContextLabel => 'บริบทความสัมพันธ์';

  @override
  String get kundliMilanReportTitle => 'รายงาน Kundli Milan';

  @override
  String get runningMilanAnalysisLabel => 'กำลังวิเคราะห์ Milan...';

  @override
  String selectedCountOfTwoLabel(int count) {
    return 'เลือกแล้ว $count/2';
  }

  @override
  String get runMilanAnalysisBtn => 'เริ่มวิเคราะห์ Milan';

  @override
  String get noChartsCreateFirst => 'ไม่มีดวงชะตา กรุณาสร้างดวงกำเนิดก่อน';

  @override
  String get selectBirthChartAnalyze => 'เลือกดวงกำเนิดที่ต้องการวิเคราะห์';

  @override
  String get doshAnalysis => 'การวิเคราะห์ Dosha';

  @override
  String doshActiveCount(Object active, Object total) {
    return 'ทำงานอยู่ $active / ตรวจสอบแล้ว $total';
  }

  @override
  String yogaActiveCount(Object active, Object total) {
    return 'ทำงานอยู่ $active / ตรวจสอบ Yoga แล้ว $total';
  }

  @override
  String yogaActiveHeader(Object count) {
    return 'Yoga ที่กำลังทำงาน ($count)';
  }

  @override
  String yogaHideInactiveCount(Object count) {
    return 'ซ่อน Yoga ที่ไม่ทำงาน ($count)';
  }

  @override
  String yogaShowInactiveCount(Object count) {
    return 'แสดง Yoga ที่ไม่ทำงาน ($count)';
  }

  @override
  String get loadFailed => 'ล้มเหลว';

  @override
  String dashaDrillMd(Object planet) {
    return '$planet MD → Antardasha';
  }

  @override
  String dashaDrillAd(Object planet) {
    return '$planet AD → Pratyantardasha';
  }

  @override
  String dashaDrillPd(Object planet) {
    return '$planet PD → Sookshmadasha';
  }

  @override
  String dashaDrillSub(Object planet) {
    return 'ช่วงย่อยของ $planet';
  }

  @override
  String dashaBirthLordBalance(Object lord, Object balance) {
    return 'เจ้าเรือนกำเนิด: $lord • คงเหลือ: $balance ปี';
  }

  @override
  String dashaLagnaBalance(Object lagna, Object balance) {
    return 'Lagna: $lagna • คงเหลือ: $balance ปี';
  }

  @override
  String dashaYearsValue(Object years) {
    return '$years ปี';
  }

  @override
  String get dashaCurrentPeriod => 'ช่วง Dasha ปัจจุบัน';

  @override
  String dashaAsOf(Object date) {
    return 'ณ วันที่: $date';
  }

  @override
  String dashaActiveYogasCount(Object count) {
    return 'Yoga ที่ทำงานในช่วงปัจจุบัน ($count)';
  }

  @override
  String dashaActiveDoshasCount(Object count) {
    return 'Dosha ที่ทำงานในช่วงปัจจุบัน ($count)';
  }

  @override
  String get dashaNoYogasTriggered => 'ไม่มี Yoga ที่ถูกกระตุ้น';

  @override
  String get dashaNoDoshasTriggered => 'ไม่มี Dosha ที่ถูกกระตุ้น';

  @override
  String get divD1Name => 'Rasi (D-1)';

  @override
  String get divD1Desc => 'การดำรงอยู่ทางกายภาพ และเรื่องทั่วไปทั้งหมด';

  @override
  String get divD2Name => 'Hora (D-2)';

  @override
  String get divD2Desc => 'ทรัพย์สิน เงินทอง';

  @override
  String get divD3Name => 'Drekkana (D-3)';

  @override
  String get divD3Desc => 'พี่น้อง ความกล้าหาญ';

  @override
  String get divD4Name => 'Chaturthamsa (D-4)';

  @override
  String get divD4Desc => 'ทรัพย์สิน ที่พักอาศัย โชคลาภ';

  @override
  String get divD5Name => 'Panchamsa (D-5)';

  @override
  String get divD5Desc => 'ชื่อเสียง อำนาจ พลัง';

  @override
  String get divD6Name => 'Shashthamsa (D-6)';

  @override
  String get divD6Desc => 'ปัญหาสุขภาพ';

  @override
  String get divD7Name => 'Saptamsa (D-7)';

  @override
  String get divD7Desc => 'บุตร หลาน';

  @override
  String get divD8Name => 'Ashtamsa (D-8)';

  @override
  String get divD8Desc => 'ปัญหาฉับพลัน คดีความ';

  @override
  String get divD9Name => 'Navamsha (D-9)';

  @override
  String get divD9Desc => 'การแต่งงาน คู่สมรส ธรรมะ';

  @override
  String get divD10Name => 'Dasamsha (D-10)';

  @override
  String get divD10Desc => 'อาชีพการงาน';

  @override
  String get divD11Name => 'Rudramsha (D-11)';

  @override
  String get divD11Desc => 'ความตาย การทำลายล้าง';

  @override
  String get divD12Name => 'Dwadasamsha (D-12)';

  @override
  String get divD12Desc => 'บิดามารดา ญาติสายเลือด';

  @override
  String get divD16Name => 'Shodasamsha (D-16)';

  @override
  String get divD16Desc => 'ยานพาหนะ ความสะดวกสบาย ความสุข';

  @override
  String get divD20Name => 'Vimsamsha (D-20)';

  @override
  String get divD20Desc => 'เรื่องจิตวิญญาณและศาสนา';

  @override
  String get divD24Name => 'Chaturvimsamsha (D-24)';

  @override
  String get divD24Desc => 'การเรียนรู้ ความรู้ การศึกษา';

  @override
  String get divD27Name => 'Nakshatramsha (D-27)';

  @override
  String get divD27Desc => 'จุดแข็ง จุดอ่อน ธรรมชาติ';

  @override
  String get divD30Name => 'Trimsamsha (D-30)';

  @override
  String get divD30Desc => 'ความชั่วร้าย จิตใต้สำนึก การลงโทษ';

  @override
  String get divD40Name => 'Khavedamsha (D-40)';

  @override
  String get divD40Desc => 'มงคล/อัปมงคล (ฝ่ายมารดา)';

  @override
  String get divD45Name => 'Akshavedamsha (D-45)';

  @override
  String get divD45Desc => 'เรื่องทั้งหมด (ฝ่ายบิดา)';

  @override
  String get divD60Name => 'Shashtyamsha (D-60)';

  @override
  String get divD60Desc => 'กรรมชาติที่แล้ว — สำคัญที่สุด';

  @override
  String get lifeAreaCareer => 'อาชีพ';

  @override
  String get lifeAreaWealth => 'ความมั่งคั่ง';

  @override
  String get lifeAreaMarriage => 'การแต่งงาน';

  @override
  String get lifeAreaHealth => 'สุขภาพ';

  @override
  String get lifeAreaSpirituality => 'จิตวิญญาณ';

  @override
  String lifeAreaGrade(Object grade) {
    return 'เกรด: $grade';
  }

  @override
  String get lifeAreaFactorsLabel => 'ปัจจัย:';

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
    return 'ลองจิจูด: $value°';
  }

  @override
  String get chakraOverallHealth => 'สุขภาพโดยรวม';

  @override
  String get careerWord => 'อาชีพ';

  @override
  String get failedToLoad => 'โหลดไม่สำเร็จ';

  @override
  String get kundliAscendantLagna => 'ลัคนา (Lagna)';

  @override
  String get kundliMoonSignRashi => 'ราศี Moon (Rashi)';

  @override
  String get kundliSunSign => 'ราศี Sun';

  @override
  String kundliEngineLabel(Object engine) {
    return 'เอนจิน: $engine';
  }

  @override
  String kundliDegreeNakshatra(Object degree, Object nakshatra, Object pada) {
    return 'องศา: $degree°  •  Nakshatra: $nakshatra ($pada)';
  }

  @override
  String kundliNakLordDignity(Object lord, Object dignity) {
    return 'เจ้า Nakshatra: $lord  •  ศักดิ์: $dignity';
  }

  @override
  String kundliChartHeader(Object base, Object sign) {
    return 'ดวง $base — $sign';
  }

  @override
  String kundliBaseChart(Object base) {
    return 'ดวง $base';
  }

  @override
  String get careerSummary => 'สรุปอาชีพ';

  @override
  String get phase => 'ระยะ';

  @override
  String get confidenceLabel => 'ความเชื่อมั่น';

  @override
  String get careerScores => 'คะแนนอาชีพ';

  @override
  String get stabilityLabel => 'ความมั่นคง';

  @override
  String get growthLabel => 'การเติบโต';

  @override
  String get gradeExcellent => 'ยอดเยี่ยม';

  @override
  String get gradeGood => 'ดี';

  @override
  String get gradeAverage => 'ปานกลาง';

  @override
  String get gradeBelowAvg => 'ต่ำกว่าค่าเฉลี่ย';

  @override
  String get gradeWeak => 'อ่อนแอ';

  @override
  String get careerTypeDomain => 'อาชีพและสาขา';

  @override
  String get careerTimeline => 'ไทม์ไลน์อาชีพ';

  @override
  String dashaLabel(Object dasha) {
    return 'Dasha: $dasha';
  }

  @override
  String get improvementSuggestions => 'ข้อเสนอแนะการพัฒนา';

  @override
  String get chartDetails => 'รายละเอียดดวงชะตา';

  @override
  String get keyHousesCareer => 'เรือนสำคัญ (อาชีพ)';

  @override
  String get keyCareerPlanets => 'ดาวสำคัญด้านอาชีพ';

  @override
  String get empty => 'ว่างเปล่า';

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
  String get charGroupCorePersonality => 'บุคลิกภาพหลัก';

  @override
  String get charGroupTrustHonesty => 'ความไว้วางใจและความซื่อสัตย์';

  @override
  String get charGroupLoyaltyCommitment => 'ความภักดีและความมุ่งมั่นผูกพัน';

  @override
  String get charGroupStrategicPrivacy => 'กลยุทธ์และความเป็นส่วนตัว';

  @override
  String get charGroupFinancial => 'การเงิน';

  @override
  String get charGroupAngerConflict => 'ความโกรธและความขัดแย้ง';

  @override
  String get charGroupMoralDharmic => 'ศีลธรรมและธรรมะ';

  @override
  String get charGroupIntellectCommunication => 'สติปัญญาและการสื่อสาร';

  @override
  String get charGroupEmotionalProfile => 'โปรไฟล์ทางอารมณ์';

  @override
  String get charGroupMentalHealth => 'สุขภาพจิต';

  @override
  String get charGroupRomantic => 'ความโรแมนติก';

  @override
  String get charGroupMarriageFamily => 'การแต่งงานและครอบครัว';

  @override
  String get charGroupOverallLife => 'ชีวิตโดยรวม';

  @override
  String get grahaDrishti => 'Graha Drishti (มุมมองของดาวเคราะห์)';

  @override
  String get grahaDrishtiSubtitle => 'ใครส่งมุมมองถึงใคร (%)';

  @override
  String get lagnaAspectsReceived => 'มุมมองที่ Lagna ได้รับ';

  @override
  String get rashiDrishti => 'Rashi Drishti (มุมมองของราศี)';

  @override
  String get shadbalaRupas => 'rupa';

  @override
  String get bhavaHouse1 => 'ตนเอง/ร่างกาย';

  @override
  String get bhavaHouse2 => 'ทรัพย์สิน/ครอบครัว';

  @override
  String get bhavaHouse3 => 'พี่น้อง/ความกล้าหาญ';

  @override
  String get bhavaHouse4 => 'บ้าน/มารดา';

  @override
  String get bhavaHouse5 => 'บุตร/สติปัญญา';

  @override
  String get bhavaHouse6 => 'ศัตรู/สุขภาพ';

  @override
  String get bhavaHouse7 => 'การแต่งงาน/คู่ครอง';

  @override
  String get bhavaHouse8 => 'อายุยืน';

  @override
  String get bhavaHouse9 => 'โชคลาภ/คุรุ';

  @override
  String get bhavaHouse10 => 'อาชีพ/บิดา';

  @override
  String get bhavaHouse11 => 'ผลได้/เพื่อน';

  @override
  String get bhavaHouse12 => 'การสูญเสีย/Moksha';

  @override
  String bhavaSignLord(Object sign, Object lord) {
    return '$sign • เจ้าเรือน: $lord';
  }

  @override
  String bhavaSav(Object value) {
    return 'SAV: $value';
  }

  @override
  String get sarvaAshtakavarga => 'Sarva Ashtakavarga (SAV)';

  @override
  String savSubtitle(Object total, Object avg) {
    return 'รวม: $total rekha (ราศีเฉลี่ย = $avg)';
  }

  @override
  String ashtakavargaBav(Object planet) {
    return '$planet — BAV';
  }

  @override
  String bavSubtitle(Object total, Object score) {
    return 'รวม: $total rekha • ที่ราศีกำเนิด: $score';
  }

  @override
  String get today => 'วันนี้';

  @override
  String gocharTransitScores(Object date) {
    return 'Gochar (คะแนน Transit) — $date';
  }

  @override
  String gocharNativeMoon(Object sign) {
    return 'Moon กำเนิด: $sign';
  }

  @override
  String get gocharBest => 'ดีที่สุด';

  @override
  String get gocharWorst => 'แย่ที่สุด';

  @override
  String copiedOpening(Object ai) {
    return 'คัดลอกแล้ว! กำลังเปิด $ai...';
  }

  @override
  String get openLink => 'เปิด ↗';

  @override
  String get discussReportWithAI => 'พูดคุยเกี่ยวกับรายงานนี้กับ AI';

  @override
  String get reliabilityHigh => 'ความน่าเชื่อถือสูง';

  @override
  String get reliabilityModerate => 'ความน่าเชื่อถือปานกลาง';

  @override
  String get reliabilityLow => 'ต่ำ — ใช้เป็นแนวทางเท่านั้น';

  @override
  String get reliabilityGoodEdu => 'ความน่าเชื่อถือดี · ยืนยันด้วย D-24';

  @override
  String get relationshipWord => 'ความสัมพันธ์';

  @override
  String get intelligenceWord => 'การวิเคราะห์';

  @override
  String get relationshipIntelligence => 'วิเคราะห์ความสัมพันธ์';

  @override
  String get typeLabel => 'ประเภท';

  @override
  String get trustLabel => 'ความไว้วางใจ';

  @override
  String get dhokaRisk => 'ความเสี่ยงการทรยศ (Dhoka)';

  @override
  String get powerLabel => 'อำนาจ';

  @override
  String get integrity => 'ความซื่อสัตย์';

  @override
  String get warmth => 'ความอบอุ่น';

  @override
  String get trustWord => 'ความไว้วางใจ';

  @override
  String get assertLabel => 'ความกล้าแสดงออก';

  @override
  String get character => 'บุคลิกภาพ';

  @override
  String get love => 'ความรัก';

  @override
  String get businessWord => 'ธุรกิจ';

  @override
  String get karmic => 'ทางกรรม';

  @override
  String get enmityRisk => 'ความเสี่ยงเป็นศัตรู';

  @override
  String get hdrChartProfiles => 'โปรไฟล์ดวงชะตา';

  @override
  String get hdrPairwiseAnalysis => 'การวิเคราะห์แบบคู่';

  @override
  String get hdrCriticalPatterns => 'รูปแบบสำคัญ';

  @override
  String get hdrGroupRecommendations => 'คำแนะนำสำหรับกลุ่ม';

  @override
  String get sharedPractices => 'แนวปฏิบัติร่วมกัน';

  @override
  String get hdrIndividualGuidance => 'คำแนะนำรายบุคคล';

  @override
  String get growthAreas => 'ด้านที่ควรพัฒนา';

  @override
  String get hdrCoreTheme => 'แก่นเรื่องหลัก';

  @override
  String get growthOriented => 'มุ่งเน้นการเติบโต';

  @override
  String get groupTheme => 'แก่นเรื่องของกลุ่ม';

  @override
  String get compatibility => 'ความเข้ากันได้';

  @override
  String get unifiedScoreLabel => 'คะแนนรวม';

  @override
  String get ashtakoot => 'Ashtakoot';

  @override
  String get probability => 'ความน่าจะเป็น';

  @override
  String get hdrAshtakootSummary => 'สรุป Ashtakoot';

  @override
  String get hdrGunBreakdown => 'รายละเอียด 8 Gun';

  @override
  String get hdrMangalDosh => 'Mangal Dosh';

  @override
  String get hdrD9CrossChart => 'การไขว้ดวง D-9';

  @override
  String get d9Compatibility => 'ความเข้ากันได้ D-9';

  @override
  String get hdrDomainCompatibility => 'ความเข้ากันได้แยกตามด้าน';

  @override
  String get emotional => 'ด้านอารมณ์';

  @override
  String get intellectual => 'ด้านสติปัญญา';

  @override
  String get spiritual => 'ด้านจิตวิญญาณ';

  @override
  String get financial => 'ด้านการเงิน';

  @override
  String get domestic => 'ด้านครอบครัว';

  @override
  String get communicationWord => 'การสื่อสาร';

  @override
  String get sharedDharma => 'ธรรมะร่วมกัน';

  @override
  String get familyCreation => 'การสร้างครอบครัว';

  @override
  String get hdrMarriageTiming => 'จังหวะเวลาการแต่งงาน';

  @override
  String get jointMarriageWindows => 'ช่วงเวลาการแต่งงานร่วมกัน';

  @override
  String get engagementWindows => 'ช่วงเวลาการหมั้น';

  @override
  String get recommendedLabel => 'แนะนำ';

  @override
  String get hdrKeyRisks => 'ความเสี่ยงสำคัญ';

  @override
  String get hdrFinalVerdict => 'บทสรุปสุดท้าย';

  @override
  String get marriageVerdict => 'บทสรุปการแต่งงาน';

  @override
  String get educationWord => 'การศึกษา';

  @override
  String get learningSuffix => 'และการเรียนรู้';

  @override
  String get coreEducationScores => 'คะแนนการศึกษาหลัก';

  @override
  String get academicSuccess => 'ความสำเร็จทางวิชาการ';

  @override
  String get learningCapacity => 'ความสามารถในการเรียนรู้';

  @override
  String get memory => 'ความจำ';

  @override
  String get intelligence => 'สติปัญญา';

  @override
  String get research => 'การวิจัย';

  @override
  String get hdrIntellectualProfile => 'โปรไฟล์ทางสติปัญญา';

  @override
  String get learningSignature => 'ลายเซ็นการเรียนรู้';

  @override
  String get hdrSubjectKaraka => 'Karaka วิชาเรียน';

  @override
  String get hdrHouseFoundations => 'รากฐานของเรือน';

  @override
  String get hdrMercuryJupiter => 'Mercury และ Jupiter';

  @override
  String get hdrEducationYogas => 'Yoga ด้านการศึกษา';

  @override
  String get hdrDivisionalValidation => 'การยืนยันด้วยดวงแบ่งภาค';

  @override
  String get standing => 'สถานะ';

  @override
  String get hdrSubjectRanking => 'การจัดอันดับวิชา';

  @override
  String get hdrDegreeLikelihood => 'โอกาสด้านปริญญา';

  @override
  String get hdrStudyPeriods => 'ช่วงเวลาการศึกษา';

  @override
  String get earlySchooling => 'การศึกษาช่วงต้น';

  @override
  String get higherEducation => 'การศึกษาระดับสูง';

  @override
  String get postgradResearch => 'ปริญญาโท · การวิจัย';

  @override
  String get hdrLearningPreferences => 'ความชอบด้านการเรียนรู้';

  @override
  String get hdrChallengesGifts => 'ความท้าทายและพรสวรรค์';

  @override
  String get challenges => 'ความท้าทาย';

  @override
  String get cognitiveGifts => 'พรสวรรค์ด้านสติปัญญา';

  @override
  String get naturalAbilities => 'ความสามารถโดยธรรมชาติ';

  @override
  String get hdrSaraswatiRemedies => 'แนวทางแก้ไขแบบ Saraswati';

  @override
  String get studentVerdict => 'บทสรุปสำหรับนักเรียน';

  @override
  String get educationCareerLinkage => 'การศึกษา → ความเชื่อมโยงกับอาชีพ';

  @override
  String get startupSuffix => 'และสตาร์ทอัพ';

  @override
  String get coreBusinessScores => 'คะแนนธุรกิจหลัก';

  @override
  String get overallBusiness => 'ธุรกิจโดยรวม';

  @override
  String get ventureSuccess => 'ความสำเร็จของกิจการ';

  @override
  String get eleventhHouse => 'เรือนที่ 11';

  @override
  String get gains => 'ผลได้';

  @override
  String get investor => 'นักลงทุน';

  @override
  String get hdrFounderArchetype => 'ต้นแบบผู้ก่อตั้ง';

  @override
  String get hdrTenthEleventhHouses => 'เรือนที่ 10 และ 11';

  @override
  String get hdrBusinessYogas => 'Yoga ด้านธุรกิจ';

  @override
  String get hdrRecommendedDomains => 'สาขาที่แนะนำ';

  @override
  String get hdrBusinessStyle => 'รูปแบบธุรกิจ';

  @override
  String get hdrFounderSkills => 'ทักษะของผู้ก่อตั้ง';

  @override
  String get hdrFundingProfile => 'โปรไฟล์การระดมทุน';

  @override
  String get recommendedPath => 'แนวทางที่แนะนำ';

  @override
  String get investorAttract => 'ความน่าสนใจสำหรับนักลงทุน';

  @override
  String get familyBacking => 'การสนับสนุนจากครอบครัว';

  @override
  String get hybridViability => 'ความเป็นไปได้แบบผสมผสาน';

  @override
  String get launchWindow => 'ช่วงเวลาเปิดตัว';

  @override
  String get scaleWindow => 'ช่วงเวลาการขยายกิจการ';

  @override
  String get hdrBusinessRisks => 'ความเสี่ยงทางธุรกิจ';

  @override
  String get recoveryCapacity => 'ศักยภาพการฟื้นตัว';

  @override
  String get hdrRemediesSolutions => 'แนวทางแก้ไขและวิธีการ';

  @override
  String get aiConnectionLost => 'การเชื่อมต่อขาดหาย กรุณาลองอีกครั้ง';

  @override
  String get aiSomethingWrong => 'เกิดข้อผิดพลาดบางอย่าง';

  @override
  String get aiNoResponse => 'ไม่มีการตอบกลับ';

  @override
  String get aiConnectionError =>
      'เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาลองอีกครั้ง';

  @override
  String get aiAutoDetect => 'ตรวจจับอัตโนมัติ';

  @override
  String aiAutoArrow(String lang) {
    return 'อัตโนมัติ → $lang';
  }

  @override
  String aiLanguageLabel(String lang) {
    return 'ภาษา: $lang';
  }

  @override
  String get aiNoBirthCharts => 'ไม่พบดวงกำเนิด';

  @override
  String get aiCreateChartFirst => 'สร้างดวงกำเนิดก่อนเพื่อแชทกับ AI';

  @override
  String get aiSelectChartBegin => 'เลือกดวงกำเนิดเพื่อเริ่มการวิเคราะห์';

  @override
  String aiAnalyzingName(String name) {
    return 'กำลังวิเคราะห์: $name';
  }

  @override
  String get aiChange => 'เปลี่ยน';

  @override
  String get aiAnalyzingChart => 'กำลังวิเคราะห์ดวงชะตาของคุณ...';

  @override
  String get aiAskStarsHint => 'ถามดวงดาวอะไรก็ได้...';

  @override
  String get aiSuggestedFollowups => 'คำถามแนะนำ';

  @override
  String get aiThinking => 'กำลังคิด...';

  @override
  String get aiThanks => 'ขอบคุณ!';

  @override
  String get aiFeedbackNoted => 'บันทึกความคิดเห็นแล้ว';

  @override
  String get svcAll => 'ทั้งหมด';

  @override
  String get svcNoServices => 'ไม่มีบริการที่พร้อมใช้งาน';

  @override
  String get svcFree => 'ฟรี';

  @override
  String get astroFailedStartCall => 'ไม่สามารถเริ่มการโทรได้';

  @override
  String get astroFailedStartChat => 'ไม่สามารถเริ่มแชทได้';

  @override
  String astroErrorDetail(String error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get astroExperience => 'ประสบการณ์';

  @override
  String get astroSessions => 'จำนวนครั้งให้คำปรึกษา';

  @override
  String get astroMinutes => 'นาที';

  @override
  String get astroAbout => 'เกี่ยวกับ';

  @override
  String get astroLanguages => 'ภาษา';

  @override
  String get astroRateCard => 'อัตราค่าบริการ';

  @override
  String get astroVoice => 'เสียง';

  @override
  String astroReviews(int count) {
    return 'รีวิว ($count)';
  }

  @override
  String get astroNoReviews => 'ยังไม่มีรีวิว';

  @override
  String get astroAnonymous => 'ไม่ระบุชื่อ';

  @override
  String get forgotPasswordSubtitle =>
      'กรอกอีเมลของคุณ แล้วเราจะส่ง\nลิงก์สำหรับตั้งรหัสผ่านใหม่ให้คุณ';

  @override
  String get emailHint => 'your@email.com';

  @override
  String get resendLink => 'ส่งลิงก์อีกครั้ง';

  @override
  String get appName => 'Nakshatralogy';

  @override
  String get cosmicJourneyAwaits => 'การเดินทางแห่งจักรวาลของคุณกำลังรอคอย';

  @override
  String get home => 'หน้าแรก';

  @override
  String get astrologers => 'นักโหราศาสตร์';

  @override
  String get services => 'บริการ';

  @override
  String get wallet => 'กระเป๋าเงิน';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get live => 'ไลฟ์';

  @override
  String get kundli => 'Kundli';

  @override
  String get chat => 'แชท';

  @override
  String get call => 'โทร';

  @override
  String get video => 'วิดีโอ';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get createAccount => 'สร้างบัญชี';

  @override
  String get email => 'อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get fullName => 'ชื่อ-นามสกุล';

  @override
  String get phone => 'เบอร์โทรศัพท์';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get sendResetLink => 'ส่งลิงก์รีเซ็ตรหัสผ่าน';

  @override
  String get backToSignIn => 'กลับไปหน้าเข้าสู่ระบบ';

  @override
  String get dontHaveAccount => 'ยังไม่มีบัญชี?';

  @override
  String get alreadyHaveAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get continueGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get required => 'จำเป็นต้องกรอก';

  @override
  String get minSixChars => 'อย่างน้อย 6 ตัวอักษร';

  @override
  String get passwordsMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get validEmailRequired => 'กรุณากรอกอีเมลที่ถูกต้อง';

  @override
  String get loginFailed => 'เข้าสู่ระบบไม่สำเร็จ';

  @override
  String get signupFailed => 'สมัครสมาชิกไม่สำเร็จ';

  @override
  String get welcomeBack => 'ยินดีต้อนรับกลับมา';

  @override
  String get todaysHoroscope => 'ดวงประจำวันนี้';

  @override
  String get todaysRashi => 'ราศีวันนี้';

  @override
  String get tapDetails => 'แตะเพื่อดูรายละเอียด';

  @override
  String get allServices => 'บริการทั้งหมด';

  @override
  String get seeAll => 'ดูทั้งหมด';

  @override
  String get topAstrologers => 'นักโหราศาสตร์ยอดนิยม';

  @override
  String get onlineExperts => 'ผู้เชี่ยวชาญออนไลน์พร้อมให้คำปรึกษา';

  @override
  String get searchAstrologers => 'ค้นหานักโหราศาสตร์...';

  @override
  String get noAstrologersFound => 'ไม่พบนักโหราศาสตร์';

  @override
  String get online => 'ออนไลน์';

  @override
  String get offline => 'ออฟไลน์';

  @override
  String get busy => 'ไม่ว่าง';

  @override
  String get perMin => '/นาที';

  @override
  String get noCharts => 'ยังไม่มีดวงกำเนิด';

  @override
  String get createFirst => 'สร้าง Janam Kundli แรกของคุณ';

  @override
  String get createChart => 'สร้างดวงชะตา';

  @override
  String get newBirthChart => 'ดวงกำเนิดใหม่';

  @override
  String get clientName => 'ชื่อลูกค้า';

  @override
  String get gender => 'เพศ';

  @override
  String get male => 'ชาย';

  @override
  String get female => 'หญิง';

  @override
  String get other => 'อื่นๆ';

  @override
  String get dateOfBirth => 'วันเกิด';

  @override
  String get timeOfBirth => 'เวลาเกิด';

  @override
  String get birthPlace => 'สถานที่เกิด';

  @override
  String get birthPlaceHint => 'พิมพ์ชื่อเมืองเพื่อค้นหา...';

  @override
  String get generateKundli => 'สร้าง Kundli';

  @override
  String get birthChartCreated => 'สร้างดวงกำเนิดสำเร็จ!';

  @override
  String get deleteChart => 'ลบดวงชะตา?';

  @override
  String get cannotUndo => 'การกระทำนี้ไม่สามารถย้อนกลับได้';

  @override
  String get primary => 'หลัก';

  @override
  String get viewKundli => 'ดู Kundli';

  @override
  String get completeBirthChart => 'ดวงกำเนิดฉบับสมบูรณ์';

  @override
  String get birthDetails => 'รายละเอียดการเกิด';

  @override
  String get name => 'ชื่อ';

  @override
  String get dob => 'วันเกิด';

  @override
  String get tob => 'เวลาเกิด';

  @override
  String get place => 'สถานที่';

  @override
  String get summary => 'สรุป';

  @override
  String get planets => 'ดาวเคราะห์';

  @override
  String get divisions => 'ดวงแบ่งภาค';

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
  String get aspects => 'มุมมอง';

  @override
  String get lifeAreas => 'ด้านต่างๆ ของชีวิต';

  @override
  String get bhava => 'Bhava';

  @override
  String get chakras => 'จักระ';

  @override
  String get dashaActive => 'Dasha ที่กำลังทำงาน';

  @override
  String get lagna => 'Lagna';

  @override
  String get moon => 'Moon';

  @override
  String get sun => 'Sun';

  @override
  String get premiumSection => 'ส่วนพรีเมียม';

  @override
  String get unlockReading => 'ปลดล็อกการอ่านนี้เพื่อดูการวิเคราะห์โดยละเอียด';

  @override
  String get unlock => 'ปลดล็อก';

  @override
  String get retrograde => 'ดาวพักร์';

  @override
  String get combust => 'ถูกเผาไหม้';

  @override
  String get vargottama => 'Vargottama';

  @override
  String get exalted => 'ราศีอุจจ์';

  @override
  String get debilitated => 'ราศีนิจ';

  @override
  String get addBalance => 'เติมยอดคงเหลือ';

  @override
  String get amount => 'จำนวนเงิน';

  @override
  String get walletBalance => 'ยอดคงเหลือในกระเป๋าเงิน';

  @override
  String get recharge => 'เติมเงิน';

  @override
  String get bonus => 'โบนัส';

  @override
  String get serviceLabel => 'บริการ';

  @override
  String get refund => 'คืนเงิน';

  @override
  String get noTransactions => 'ไม่มีรายการธุรกรรม';

  @override
  String get editProfile => 'แก้ไขโปรไฟล์';

  @override
  String get savedAstrologers => 'นักโหราศาสตร์ที่บันทึกไว้';

  @override
  String get noSavedAstrologers => 'ยังไม่มีนักโหราศาสตร์ที่บันทึกไว้';

  @override
  String get myOrders => 'คำสั่งซื้อของฉัน';

  @override
  String get communicationHistory => 'ประวัติการติดต่อสื่อสาร';

  @override
  String get chatHistory => 'ประวัติการแชท';

  @override
  String get callHistory => 'ประวัติการโทร';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get chatMessages => 'ข้อความแชท';

  @override
  String get typeMessage => 'พิมพ์ข้อความ...';

  @override
  String get sessionEnded => 'สิ้นสุดเซสชันแล้ว';

  @override
  String get endChat => 'จบการแชท?';

  @override
  String get endChatConfirm => 'คุณแน่ใจหรือไม่ว่าต้องการจบเซสชันแชทนี้?';

  @override
  String get sendPhoto => 'ส่งรูปภาพ';

  @override
  String get sendPDF => 'ส่ง PDF';

  @override
  String get upload => 'อัปโหลด';

  @override
  String get fileNotFound => 'ไม่พบไฟล์';

  @override
  String get voiceCall => 'โทรด้วยเสียง';

  @override
  String get videoCall => 'วิดีโอคอล';

  @override
  String get ringing => 'กำลังโทร...';

  @override
  String get connected => 'เชื่อมต่อแล้ว';

  @override
  String get endCall => 'วางสาย';

  @override
  String get mute => 'ปิดเสียง';

  @override
  String get unmute => 'เปิดเสียง';

  @override
  String get speaker => 'ลำโพง';

  @override
  String get camera => 'กล้อง';

  @override
  String get flip => 'สลับกล้อง';

  @override
  String get liveStreams => 'ไลฟ์สตรีม';

  @override
  String get noLiveStreams => 'ขณะนี้ไม่มีไลฟ์สตรีม';

  @override
  String get astrologerUnavailable =>
      'นักโหราศาสตร์ไม่พร้อมใช้งาน กำลังจบสตรีม';

  @override
  String get streamEnded => 'สตรีมสิ้นสุดแล้ว';

  @override
  String get superChat => 'ซูเปอร์แชท';

  @override
  String get sendGift => 'ส่งของขวัญ';

  @override
  String get goBack => 'ย้อนกลับ';

  @override
  String get appPermissions => 'สิทธิ์การเข้าถึงแอป';

  @override
  String get grantPermissions => 'อนุญาตสิทธิ์การเข้าถึง';

  @override
  String get skipForNow => 'ข้ามไปก่อน';

  @override
  String get microphone => 'ไมโครโฟน';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get storage => 'พื้นที่จัดเก็บ';

  @override
  String get ok => 'ตกลง';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get edit => 'แก้ไข';

  @override
  String get delete => 'ลบ';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get send => 'ส่ง';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get noData => 'ไม่มีข้อมูล';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get success => 'สำเร็จ';

  @override
  String get selectLanguage => 'เลือกภาษา';

  @override
  String get language => 'ภาษา';

  @override
  String get english => 'English';

  @override
  String get myDetails => 'ข้อมูลของฉัน';

  @override
  String get myKundlis => 'Kundli ของฉัน';

  @override
  String get walletRecharge => 'กระเป๋าเงินและเติมเงิน';

  @override
  String get consultationHistory => 'ประวัติการปรึกษา';

  @override
  String get helpSupport => 'ช่วยเหลือและสนับสนุน';

  @override
  String get biometricLogin => 'เข้าสู่ระบบด้วยไบโอเมตริก';

  @override
  String get pastVoiceConsultations => 'การปรึกษาด้วยเสียงในอดีต';

  @override
  String get pastTextConversations => 'บทสนทนาข้อความในอดีต';

  @override
  String get comingSoon => 'เร็วๆ นี้';

  @override
  String get totalCredit => 'ยอดเครดิตรวม';

  @override
  String get totalDebit => 'ยอดหักรวม';

  @override
  String get statement => 'รายการเดินบัญชี';

  @override
  String get allTypes => 'ทุกประเภท';

  @override
  String get prev => 'ก่อนหน้า';

  @override
  String get next => 'ถัดไป';

  @override
  String get allInsights => 'ข้อมูลเชิงลึกทั้งหมด';

  @override
  String get yourCompleteReading => 'การอ่านดวงฉบับสมบูรณ์ของคุณ';

  @override
  String get expertEngines => 'เอนจินผู้เชี่ยวชาญ';

  @override
  String get eachInsightConsultation =>
      'แต่ละข้อมูลเชิงลึกคือการปรึกษาแบบสมบูรณ์';

  @override
  String get engines => 'เอนจิน';

  @override
  String get dataPoints => 'จุดข้อมูล';

  @override
  String get singleChart => 'ดวงเดียว';

  @override
  String get careerPurpose => 'อาชีพและเป้าหมาย';

  @override
  String get wealthAssets => 'ความมั่งคั่งและทรัพย์สิน';

  @override
  String get loveRelationships => 'ความรักและความสัมพันธ์';

  @override
  String get healthWellness => 'สุขภาพและสุขภาวะ';

  @override
  String get soulKarma => 'จิตวิญญาณและกรรม';

  @override
  String get specialistReports => 'รายงานผู้เชี่ยวชาญ';

  @override
  String get searchByNameSpeciality => 'ค้นหาด้วยชื่อ ความเชี่ยวชาญ...';

  @override
  String get sortedByRating => 'เรียงตามคะแนน';

  @override
  String get initiatingChat => 'กำลังเริ่มแชท...';

  @override
  String get startingCall => 'กำลังเริ่มการโทร...';

  @override
  String get yrs => 'ปี';

  @override
  String get chatWithAISpecialist => 'แชทกับ AI ผู้เชี่ยวชาญ';

  @override
  String get tapToStart => 'แตะเพื่อเริ่ม';

  @override
  String get astrologer => 'นักโหราศาสตร์';

  @override
  String get reports => 'รายงาน';

  @override
  String get milan => 'Milan';

  @override
  String get forecast => 'พยากรณ์';

  @override
  String get rashi => 'Rashi';

  @override
  String get jupiterFavorsBold => 'Jupiter สนับสนุนการตัดสินใจที่กล้าหาญ';

  @override
  String get careerIlluminated =>
      'ด้านอาชีพของคุณสว่างไสว — จงเชื่อสัญชาตญาณของคุณ';

  @override
  String get todaysForecast => 'พยากรณ์วันนี้';

  @override
  String get engCareer => 'อาชีพและการงาน';

  @override
  String get engBusiness => 'ธุรกิจและสตาร์ทอัพ';

  @override
  String get engEducation => 'การศึกษาและการเรียนรู้';

  @override
  String get engLifePath => 'เส้นทางชีวิตและโชคลาภ';

  @override
  String get engWealth => 'ความมั่งคั่งและการเงิน';

  @override
  String get engDebt => 'หนี้สินและการฟื้นตัว';

  @override
  String get engProperty => 'ทรัพย์สินและอสังหาริมทรัพย์';

  @override
  String get engLegal => 'กฎหมายและข้อพิพาท';

  @override
  String get engLove => 'ความรักและโรแมนติก';

  @override
  String get engMarriage => 'การแต่งงานและครอบครัว';

  @override
  String get engKundliMilan => 'Kundli Milan';

  @override
  String get engRelationship => 'วิเคราะห์ความสัมพันธ์';

  @override
  String get engLoveCompat => 'ความเข้ากันได้ด้านความรัก';

  @override
  String get engChildProb => 'ความน่าจะเป็นเรื่องบุตร';

  @override
  String get engHealth => 'สุขภาพและสุขภาวะ';

  @override
  String get engMental => 'จิตใจและความเครียด';

  @override
  String get engCharacter => 'การวิเคราะห์บุคลิกภาพ';

  @override
  String get engPastLife => 'ชาติที่แล้วและกรรม';

  @override
  String get engKarmaLink => 'ความเชื่อมโยงทางกรรม';

  @override
  String get noChatSessions => 'ยังไม่มีเซสชันแชท';

  @override
  String get chatAppearHere => 'บทสนทนาของคุณกับนักโหราศาสตร์จะปรากฏที่นี่';

  @override
  String get noCallsYet => 'ยังไม่มีการโทร';

  @override
  String get callAppearHere =>
      'ประวัติการโทรของคุณกับนักโหราศาสตร์จะปรากฏที่นี่';

  @override
  String get chatWith => 'แชทกับ';

  @override
  String get msgs => 'ข้อความ';

  @override
  String get voiceCallLabel => 'โทรด้วยเสียง';

  @override
  String get videoCallLabel => 'วิดีโอคอล';

  @override
  String get pullToRefresh => 'ดึงลงเพื่อรีเฟรช';

  @override
  String get sessionExpired => 'เซสชันหมดอายุ';

  @override
  String get connectionFailed => 'การเชื่อมต่อล้มเหลว';

  @override
  String get callActive => 'กำลังโทรอยู่';

  @override
  String get lessThanOneMin => 'เหลือเวลาน้อยกว่า 1 นาที';

  @override
  String get noMessages => 'ไม่มีข้อความในเซสชันนี้';

  @override
  String get gocharForAllSigns => 'Gochar วันนี้สำหรับทั้ง 12 ราศี';

  @override
  String get selectChart => 'เลือกดวงชะตาที่ต้องการวิเคราะห์';

  @override
  String get selectTwoCharts => 'เลือกดวงชะตาสองดวง';

  @override
  String get analyzing => 'กำลังวิเคราะห์...';

  @override
  String get browseAstrologers => 'เลือกดูนักโหราศาสตร์';

  @override
  String get probableNumber => 'จำนวนที่น่าจะเป็น';

  @override
  String get genderTendency => 'แนวโน้มเพศ';

  @override
  String get son => 'บุตรชาย';

  @override
  String get daughter => 'บุตรสาว';

  @override
  String get occupants => 'ดาวที่สถิตอยู่';

  @override
  String get beneficAspects => 'มุมมองมงคล';

  @override
  String get maleficAspects => 'มุมมองอัปมงคล';

  @override
  String get nextFavorableWindow => 'ช่วงเวลาที่เอื้ออำนวยถัดไป';

  @override
  String get totalDoshaPenalty => 'คะแนนหักรวมจาก Dosha';

  @override
  String get cancellationFactors => 'ปัจจัยการยกเลิก';

  @override
  String get combinedFertility => 'ตัวชี้วัดภาวะเจริญพันธุ์รวม';

  @override
  String get planetPositions => 'ตำแหน่งดาวเคราะห์';

  @override
  String get bestWindows => 'ช่วงเวลาที่ดีที่สุด';

  @override
  String get worstWindows => 'ช่วงเวลาที่แย่ที่สุด';

  @override
  String get scoreComponents => 'องค์ประกอบคะแนน';

  @override
  String get topOpportunities => 'โอกาสอันดับต้น';

  @override
  String get topRisks => 'ความเสี่ยงอันดับต้น';

  @override
  String get remedies => 'แนวทางแก้ไข';

  @override
  String get keyInsights => 'ข้อมูลเชิงลึกสำคัญ';

  @override
  String get overallVerdict => 'บทสรุปโดยรวม';

  @override
  String get venusContacts => 'การประสาน Venus ข้ามดวง';

  @override
  String get contact => 'การประสาน';

  @override
  String get effect => 'ผลกระทบ';

  @override
  String get moonSignCompat => 'ความเข้ากันได้ของราศี Moon';

  @override
  String get hisMoon => 'Moon ของฝ่ายชาย';

  @override
  String get herMoon => 'Moon ของฝ่ายหญิง';

  @override
  String get nakshatraCompat => 'ความเข้ากันได้ของ Nakshatra';

  @override
  String get ketuContacts => 'การประสานของ Ketu';

  @override
  String get rahuContacts => 'การประสานของ Rahu';

  @override
  String get pastLifeIndication => 'ตัวชี้วัดชาติที่แล้ว';

  @override
  String get totalChallengePenalty => 'คะแนนหักรวมจากความท้าทาย';

  @override
  String get manifestation => 'การปรากฏผล';

  @override
  String get cancellation => 'การยกเลิก';

  @override
  String get navigation => 'แนวทางฝ่าฟัน';

  @override
  String get potentialStrengths => 'จุดแข็งที่มีศักยภาพ';

  @override
  String get areasToNurture => 'ด้านที่ควรบ่มเพาะ';

  @override
  String get relationshipGuidance => 'คำแนะนำด้านความสัมพันธ์';

  @override
  String get detailedSummary => 'สรุปโดยละเอียด';

  @override
  String get discussWithAI => 'พูดคุยกับ AI';

  @override
  String get planet => 'ดาวเคราะห์';

  @override
  String get sign => 'ราศี';

  @override
  String get house => 'เรือน';

  @override
  String get strength => 'ความแข็งแกร่ง';

  @override
  String get copy => 'คัดลอก';

  @override
  String get confidence => 'ความเชื่อมั่น';

  @override
  String get d7Saptamsa => 'D7 Saptamsa';

  @override
  String get numberExplanation => 'คำอธิบายจำนวน';

  @override
  String get genderExplanation => 'คำอธิบายเรื่องเพศ';

  @override
  String get inFifth => 'อยู่ในเรือนที่ 5?';

  @override
  String get primaryArchetype => 'ต้นแบบหลัก';

  @override
  String get mitigation => 'การบรรเทา';

  @override
  String get soulCareerAlign => 'ความสอดคล้องระหว่างจิตวิญญาณกับอาชีพ';

  @override
  String get favorablePeriods => 'ช่วงเวลาที่เอื้ออำนวย';

  @override
  String get challengingPeriods => 'ช่วงเวลาที่ท้าทาย';

  @override
  String get keyHouses => 'เรือนสำคัญ';

  @override
  String get keyPlanets => 'ดาวสำคัญ';

  @override
  String get characterOverview => 'ภาพรวมบุคลิกภาพ';

  @override
  String get noYogasActive => 'ขณะนี้ไม่มี Yoga ที่กำลังทำงานในดวงชะตานี้';

  @override
  String get basedOnPlanetStrengths =>
      'อ้างอิงจากความแข็งแกร่งของดาวเคราะห์และตำแหน่งเรือน';

  @override
  String get basedOnTransits => 'อ้างอิงจากการโคจรผ่านของดาวเคราะห์ในปัจจุบัน';

  @override
  String get currentPlanetPositions =>
      'ตำแหน่งดาวเคราะห์ปัจจุบัน โดยใช้ราศีของคุณเป็นเรือนที่ 1';

  @override
  String get favorablePeriodAdvice =>
      'ช่วงเวลาที่เอื้ออำนวย — เน้นการเติบโตทางอาชีพและความสัมพันธ์';

  @override
  String get noClassicalYogas =>
      'หากไม่มี Yoga การเรียนรู้แบบคลาสสิก ความสำเร็จจะมาจากความพยายามที่สม่ำเสมอ';

  @override
  String get walletDeduction => 'จำนวนเงินจะถูกหักจากกระเป๋าเงินของคุณ';

  @override
  String get bhakootAxis => 'แกน Bhakoot';

  @override
  String get basis => 'พื้นฐาน';

  @override
  String get selectChartsForMilan =>
      'เลือกดวงชะตา 2 ดวงสำหรับการวิเคราะห์ Milan';

  @override
  String get selectMultiCharts => 'เลือกดวงชะตา 2–5 ดวง';

  @override
  String get running => 'กำลังทำงาน';

  @override
  String get past => 'ผ่านมาแล้ว';

  @override
  String get topActiveDoshas => 'Dosha ที่กำลังทำงานอันดับต้น';

  @override
  String get allDoshas => 'Dosha ทั้งหมด';

  @override
  String get activeYogas => 'Yoga ที่กำลังทำงาน';

  @override
  String get activeDoshas => 'Dosha ที่กำลังทำงาน';

  @override
  String get yogaAnalysis => 'การวิเคราะห์ Yoga';

  @override
  String get factors => 'ปัจจัย';

  @override
  String get dominantPlanet => 'ดาวเด่น';

  @override
  String get startSession => 'เริ่มเซสชัน';

  @override
  String get notesSaved => 'บันทึกโน้ตแล้ว';

  @override
  String get unlocked => 'ปลดล็อกแล้ว! ขอให้สนุกกับการอ่านดวงของคุณ';

  @override
  String get todaysGochar => 'Gochar วันนี้';

  @override
  String get todaysTransitChart => 'ดวง Transit วันนี้';

  @override
  String get lifeAreaPredictions => 'การทำนายด้านต่างๆ ของชีวิต';

  @override
  String get strengths => 'จุดแข็ง';

  @override
  String get weaknesses => 'จุดอ่อน';

  @override
  String get ruledBy => 'ปกครองโดย';

  @override
  String get kundliMilan => 'Kundli Milan';

  @override
  String get startKundliMilan => 'เริ่ม Kundli Milan';

  @override
  String get recommendations => 'คำแนะนำ';

  @override
  String get cancellations => 'การยกเลิก';

  @override
  String get dashaSync => 'ความสอดคล้องของ Dasha';

  @override
  String get transitMarriageWindows => 'ช่วงเวลาการแต่งงานจาก Transit';

  @override
  String get overlappingWindows => 'ช่วงเวลาการแต่งงานที่ทับซ้อนกัน';

  @override
  String get overallStrength => 'ความแข็งแกร่งโดยรวม';

  @override
  String get stability => 'ความมั่นคง';

  @override
  String get growth => 'การเติบโต';

  @override
  String get clarity => 'ความชัดเจน';

  @override
  String get recognition => 'การได้รับการยอมรับ';

  @override
  String get satisfaction => 'ความพึงพอใจ';

  @override
  String get verdict => 'บทสรุป';

  @override
  String get topRoles => 'บทบาทอันดับต้น';

  @override
  String get areasForGrowth => 'ด้านที่ควรพัฒนา';

  @override
  String get bestIndustries => 'อุตสาหกรรมที่เหมาะที่สุด';

  @override
  String get employment => 'การเป็นลูกจ้าง';

  @override
  String get entrepreneurship => 'การเป็นผู้ประกอบการ';

  @override
  String get freelance => 'ฟรีแลนซ์';

  @override
  String get portfolio => 'แบบผสมผสาน';

  @override
  String get burnoutRisk => 'ความเสี่ยงภาวะหมดไฟ';

  @override
  String get careerStagnation => 'ความซบเซาทางอาชีพ';

  @override
  String get workplaceConflict => 'ความขัดแย้งในที่ทำงาน';

  @override
  String get positioning => 'การวางตำแหน่ง';

  @override
  String get skillDevelopment => 'การพัฒนาทักษะ';

  @override
  String get network => 'เครือข่าย';

  @override
  String get visibility => 'การมองเห็น';

  @override
  String get lagnaLord => 'เจ้าเรือนลัคนา';

  @override
  String get tenthLord => 'เจ้าเรือนที่ 10';

  @override
  String get lord => 'เจ้าเรือน';

  @override
  String get lordPlacedIn => 'เจ้าเรือนอยู่ที่';

  @override
  String get lordDignity => 'ศักดิ์ของเจ้าเรือน';

  @override
  String get d9Dignity => 'ศักดิ์ใน D9';

  @override
  String get careerAnalysis => 'การวิเคราะห์อาชีพ';

  @override
  String get launchWindows => 'ช่วงเวลาเปิดตัว';

  @override
  String get peakWindows => 'ช่วงเวลาสูงสุด';

  @override
  String get promotionWindows => 'ช่วงเวลาเลื่อนตำแหน่ง';

  @override
  String get riskWindows => 'ช่วงเวลาเสี่ยง';

  @override
  String get timingWindows => 'ช่วงเวลา';

  @override
  String get careerRisks => 'ความเสี่ยงทางอาชีพ';

  @override
  String get astrologicalRemedies => 'แนวทางแก้ไขทางโหราศาสตร์';

  @override
  String get practicalSolutions => 'วิธีแก้ไขเชิงปฏิบัติ';

  @override
  String get analysisConfidence => 'ความเชื่อมั่นของการวิเคราะห์';

  @override
  String get careerArchetype => 'ต้นแบบอาชีพ';

  @override
  String get workStructure => 'โครงสร้างการทำงาน';

  @override
  String get teamLeadership => 'ความเป็นผู้นำทีม';

  @override
  String get idealEnvironment => 'สภาพแวดล้อมในอุดมคติ';

  @override
  String get idealOrgSize => 'ขนาดองค์กรในอุดมคติ';

  @override
  String get fitScore => 'คะแนนความเหมาะสม';

  @override
  String get recommended => 'แนะนำ';

  @override
  String get divisionalValidation => 'การยืนยันด้วยดวงแบ่งภาค';

  @override
  String get houseAnalysis => 'การวิเคราะห์เรือน';

  @override
  String get jaiminiKarakas => 'Karaka แบบ Jaimini';

  @override
  String get copyFullReport => 'คัดลอกข้อมูลรายงานฉบับเต็ม';

  @override
  String get reportCopied => 'คัดลอกข้อมูลรายงานแล้ว!';

  @override
  String get biometricNotAvailable => 'ไม่มีระบบไบโอเมตริกซ์ในอุปกรณ์นี้';

  @override
  String biometricErrorMsg(Object error) {
    return 'ข้อผิดพลาดไบโอเมตริกซ์: $error';
  }

  @override
  String get biometricVerifyReason =>
      'ยืนยันเพื่อเปิดใช้การเข้าสู่ระบบด้วยไบโอเมตริกซ์';

  @override
  String get dobFormatLabel => 'วันเกิด (DD/MM/YYYY)';

  @override
  String get tobFormatLabel => 'เวลาเกิด (HH:MM)';

  @override
  String get phoneLabel => 'โทรศัพท์';

  @override
  String get activeBadge => 'ใช้งานอยู่';

  @override
  String get chartCategoryLabel => 'หมวดหมู่';

  @override
  String get freePrimaryDescription =>
      'หลักฟรี — ใช้สำหรับดูดวงประจำวันและบริการแผนภูมิเดี่ยวฟรี';

  @override
  String get searchChartsHint => 'ค้นหาด้วยชื่อหรือวันเกิด...';

  @override
  String unlockPriceLabel(Object price) {
    return 'ปลดล็อกด้วย $price';
  }

  @override
  String unlockAiSpecialistIntl(Object price) {
    return 'ปลดล็อกผู้เชี่ยวชาญ AI นี้ด้วย $price (ครั้งเดียว) ซื้ออย่างปลอดภัยผ่านแอปสโตร์';
  }

  @override
  String unlockAiSpecialistWallet(Object price) {
    return 'ปลดล็อกผู้เชี่ยวชาญ AI นี้ด้วย $price (ครั้งเดียว) จำนวนเงินจะถูกหักจากกระเป๋าเงินของคุณ';
  }

  @override
  String get specialistNotAvailablePurchase =>
      'ผู้เชี่ยวชาญนี้ยังไม่พร้อมให้ซื้อ';

  @override
  String get couldNotCompletePurchase =>
      'ไม่สามารถทำการซื้อให้เสร็จสมบูรณ์ได้ กรุณาลองอีกครั้ง';

  @override
  String get couldNotUnlockWalletBalance =>
      'ไม่สามารถปลดล็อกได้ (ตรวจสอบยอดเงินในกระเป๋าเงิน)';

  @override
  String get freeBadge => 'ฟรี';

  @override
  String activeSessionInProgress(Object kind) {
    return 'คุณมี $kind ที่กำลังดำเนินอยู่';
  }

  @override
  String get returnLabel => 'กลับไป';

  @override
  String get enableNotificationsForAlerts =>
      'เปิดใช้การแจ้งเตือนเพื่อรับการแจ้งเตือนการปรึกษาและข้อเสนอ';

  @override
  String get enableLabel => 'เปิดใช้งาน';

  @override
  String get notificationsEnabled => 'เปิดใช้การแจ้งเตือนแล้ว';

  @override
  String get couldNotEnableNotifications =>
      'ไม่สามารถเปิดใช้งานได้ — อนุญาตการแจ้งเตือนในเบราว์เซอร์ของคุณ';

  @override
  String get amountInrLabel => 'จำนวน (₹)';

  @override
  String get noteOptionalLabel => 'บันทึก (ไม่บังคับ)';

  @override
  String get txnDate => 'วันที่';

  @override
  String get txnDescription => 'รายละเอียด';

  @override
  String get txnType => 'ประเภท';

  @override
  String get txnAmount => 'จำนวน';

  @override
  String get txnBalance => 'ยอดคงเหลือ';

  @override
  String get credit => 'เครดิต';

  @override
  String get debit => 'เดบิต';

  @override
  String get razorpayStripeNote =>
      '💳 ในระบบจริงจะถูกเปลี่ยนเส้นทางไปยัง Razorpay/Stripe';

  @override
  String get downloadPdf => 'ดาวน์โหลด PDF';

  @override
  String get chatWithAiCta => 'แชทกับ AI';

  @override
  String get pdfServiceUnavailable =>
      'บริการ PDF ไม่พร้อมใช้งานชั่วคราว กรุณาลองใหม่อีกครั้งในภายหลัง';

  @override
  String get pleaseUnlockFirst => 'กรุณาปลดล็อกสิ่งนี้ก่อน';

  @override
  String get couldNotGeneratePdf => 'ไม่สามารถสร้าง PDF ได้ กรุณาลองอีกครั้ง';

  @override
  String get statConsults => 'การปรึกษา';

  @override
  String get statCharts => 'แผนภูมิ';

  @override
  String get statWallet => 'กระเป๋าเงิน';

  @override
  String get firstChartPrimaryInfo =>
      'แผนภูมิแรกของคุณคือแผนภูมิหลักฟรี แผนภูมิเพิ่มเติมจะปลดล็อกบริการแยกกัน';

  @override
  String get tryDifferentFilter => 'ลองใช้ตัวกรองอื่น';

  @override
  String get defaultChartName => 'แผนภูมิ';

  @override
  String get balAbbr => 'คงเหลือ';

  @override
  String get aiTimePassTitle => 'เลือกเวลาแชท';

  @override
  String get aiTimePassHint => 'ชำระจากวอลเล็ต เวลาเริ่มนับทันที — ซื้อเพิ่มจะบวกกับเวลาที่เหลือ';

  @override
  String aiTimePlanMinutes(Object minutes) {
    return '$minutes นาที';
  }

  @override
  String aiTimePassPay(Object price) {
    return 'ชำระ $price';
  }

  @override
  String aiTimeLeft(Object minutes) {
    return 'เหลือ $minutes นาที';
  }
}
