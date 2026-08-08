import 'package:flutter/widgets.dart';

/// Locale-keyed labels for the Profile menu tabs (Change Password, Customer
/// Support) and the About & Legal section. Mirrors [HomeLabels]: a per-locale
/// map with an English base that every locale falls back to, so these strings
/// render in the user's chosen language (Indian + international) without adding
/// new gen-l10n ARB keys.
///
/// Per-locale translations are merged in below (`_m`). English (`_en`) is the
/// canonical fallback; a missing locale or key resolves to English, never a
/// blank. Keys:
///   changePassword, changePasswordSub, customerSupport, customerSupportSub,
///   aboutLegal, privacyPolicy, termsConditions, refundPolicy, couldNotOpen.
class MenuLabels {
  static const _en = <String, String>{
    'changePassword': 'Change Password',
    'changePasswordSub': 'Update your password via email OTP',
    'customerSupport': 'Customer Support',
    'customerSupportSub': 'FAQ & raise a ticket',
    'aboutLegal': 'About & Legal',
    'privacyPolicy': 'Privacy Policy',
    'termsConditions': 'Terms & Conditions',
    'refundPolicy': 'Refund Policy',
    'couldNotOpen': 'Could not open the link',
    'invoices': 'Invoices',
    'invoicesSub': 'View & download your receipts',
  };

  // Per-locale overrides. Keyed by the same code scheme as HomeLabels
  // (languageCode, or languageCode_Latn for romanized scripts like Hinglish).
  static const _m = <String, Map<String, String>>{
    'ar': {'changePassword': 'تغيير كلمة المرور', 'changePasswordSub': 'حدّث كلمة المرور عبر رمز التحقق بالبريد الإلكتروني', 'customerSupport': 'دعم العملاء', 'customerSupportSub': 'الأسئلة الشائعة وإنشاء تذكرة', 'aboutLegal': 'حول وقانوني', 'privacyPolicy': 'سياسة الخصوصية', 'termsConditions': 'الشروط والأحكام', 'refundPolicy': 'سياسة الاسترداد', 'couldNotOpen': 'تعذر فتح الرابط', 'invoices': 'الفواتير', 'invoicesSub': 'عرض وتنزيل إيصالاتك'},
    'bn': {'changePassword': 'পাসওয়ার্ড পরিবর্তন করুন', 'changePasswordSub': 'ইমেল ওটিপির মাধ্যমে পাসওয়ার্ড আপডেট করুন', 'customerSupport': 'গ্রাহক সহায়তা', 'customerSupportSub': 'সাধারণ প্রশ্ন ও টিকিট তৈরি করুন', 'aboutLegal': 'সম্পর্কে ও আইনি', 'privacyPolicy': 'গোপনীয়তা নীতি', 'termsConditions': 'শর্তাবলী', 'refundPolicy': 'ফেরত নীতি', 'couldNotOpen': 'লিঙ্কটি খোলা যায়নি', 'invoices': 'চালান', 'invoicesSub': 'আপনার রসিদ দেখুন ও ডাউনলোড করুন'},
    'de': {'changePassword': 'Passwort ändern', 'changePasswordSub': 'Passwort per E-Mail-OTP aktualisieren', 'customerSupport': 'Kundensupport', 'customerSupportSub': 'FAQ & Ticket erstellen', 'aboutLegal': 'Über & Rechtliches', 'privacyPolicy': 'Datenschutzrichtlinie', 'termsConditions': 'Allgemeine Geschäftsbedingungen', 'refundPolicy': 'Rückerstattungsrichtlinie', 'couldNotOpen': 'Link konnte nicht geöffnet werden', 'invoices': 'Rechnungen', 'invoicesSub': 'Belege ansehen & herunterladen'},
    'es': {'changePassword': 'Cambiar Contraseña', 'changePasswordSub': 'Actualiza tu contraseña con OTP por correo', 'customerSupport': 'Atención al Cliente', 'customerSupportSub': 'Preguntas frecuentes y soporte', 'aboutLegal': 'Acerca de y Legal', 'privacyPolicy': 'Política de Privacidad', 'termsConditions': 'Términos y Condiciones', 'refundPolicy': 'Política de Reembolso', 'couldNotOpen': 'No se pudo abrir el enlace', 'invoices': 'Facturas', 'invoicesSub': 'Consulta y descarga tus recibos'},
    'fr': {'changePassword': 'Changer le mot de passe', 'changePasswordSub': 'Mettez à jour votre mot de passe via OTP par e-mail', 'customerSupport': 'Support client', 'customerSupportSub': 'FAQ et ouvrir un ticket', 'aboutLegal': 'À propos et mentions légales', 'privacyPolicy': 'Politique de confidentialité', 'termsConditions': 'Conditions générales', 'refundPolicy': 'Politique de remboursement', 'couldNotOpen': 'Impossible d\'ouvrir le lien', 'invoices': 'Factures', 'invoicesSub': 'Consultez et téléchargez vos reçus'},
    'gu': {'changePassword': 'પાસવર્ડ બદલો', 'changePasswordSub': 'ઈમેલ OTP દ્વારા તમારો પાસવર્ડ અપડેટ કરો', 'customerSupport': 'ગ્રાહક સપોર્ટ', 'customerSupportSub': 'FAQ & ટિકિટ ઉઠાવો', 'aboutLegal': 'વિશે & કાયદાકીય', 'privacyPolicy': 'ગોપનીયતા નીતિ', 'termsConditions': 'નિયમો & શરતો', 'refundPolicy': 'રિફંડ નીતિ', 'couldNotOpen': 'લિંક ખોલી શકાઈ નહીં', 'invoices': 'ઇનવોઈસ', 'invoicesSub': 'તમારી રસીદો જુઓ અને ડાઉનલોડ કરો'},
    'hi': {'changePassword': 'पासवर्ड बदलें', 'changePasswordSub': 'ईमेल ओटीपी से पासवर्ड अपडेट करें', 'customerSupport': 'ग्राहक सहायता', 'customerSupportSub': 'सामान्य प्रश्न और टिकट दर्ज करें', 'aboutLegal': 'जानकारी और कानूनी', 'privacyPolicy': 'गोपनीयता नीति', 'termsConditions': 'नियम व शर्तें', 'refundPolicy': 'धनवापसी नीति', 'couldNotOpen': 'लिंक नहीं खुल सका', 'invoices': 'इनवॉइस', 'invoicesSub': 'अपनी रसीदें देखें और डाउनलोड करें'},
    'hi_Latn': {'changePassword': 'Password Badlein', 'changePasswordSub': 'Email OTP se apna password update karein', 'customerSupport': 'Customer Support', 'customerSupportSub': 'FAQ aur ticket raise karein', 'aboutLegal': 'About aur Legal', 'privacyPolicy': 'Privacy Policy', 'termsConditions': 'Terms & Conditions', 'refundPolicy': 'Refund Policy', 'couldNotOpen': 'Link open nahi ho paaya', 'invoices': 'Invoices', 'invoicesSub': 'Apni receipts dekhein aur download karein'},
    'id': {'changePassword': 'Ubah Kata Sandi', 'changePasswordSub': 'Perbarui kata sandi via OTP email', 'customerSupport': 'Dukungan Pelanggan', 'customerSupportSub': 'FAQ & ajukan tiket', 'aboutLegal': 'Tentang & Hukum', 'privacyPolicy': 'Kebijakan Privasi', 'termsConditions': 'Syarat & Ketentuan', 'refundPolicy': 'Kebijakan Pengembalian Dana', 'couldNotOpen': 'Tidak dapat membuka tautan', 'invoices': 'Faktur', 'invoicesSub': 'Lihat & unduh tanda terima Anda'},
    'it': {'changePassword': 'Cambia Password', 'changePasswordSub': 'Aggiorna la password tramite OTP via email', 'customerSupport': 'Assistenza Clienti', 'customerSupportSub': 'FAQ e apri un ticket', 'aboutLegal': 'Info e Legale', 'privacyPolicy': 'Informativa sulla Privacy', 'termsConditions': 'Termini e Condizioni', 'refundPolicy': 'Politica di Rimborso', 'couldNotOpen': 'Impossibile aprire il link', 'invoices': 'Fatture', 'invoicesSub': 'Visualizza e scarica le tue ricevute'},
    'ja': {'changePassword': 'パスワード変更', 'changePasswordSub': 'メールOTPでパスワードを更新', 'customerSupport': 'カスタマーサポート', 'customerSupportSub': 'よくある質問・問い合わせ作成', 'aboutLegal': '概要・法的情報', 'privacyPolicy': 'プライバシーポリシー', 'termsConditions': '利用規約', 'refundPolicy': '返金ポリシー', 'couldNotOpen': 'リンクを開けませんでした', 'invoices': '請求書', 'invoicesSub': '領収書の閲覧とダウンロード'},
    'kn': {'changePassword': 'ಪಾಸ್‌ವರ್ಡ್ ಬದಲಾಯಿಸಿ', 'changePasswordSub': 'ಇಮೇಲ್ OTP ಮೂಲಕ ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ಅನ್ನು ನವೀಕರಿಸಿ', 'customerSupport': 'ಗ್ರಾಹಕ ಬೆಂಬಲ', 'customerSupportSub': 'FAQ & ಟಿಕೆಟ್ ರೈಸ್ ಮಾಡಿ', 'aboutLegal': 'ಬಗ್ಗೆ & ಕಾನೂನು', 'privacyPolicy': 'ಗೌಪ್ಯತಾ ನೀತಿ', 'termsConditions': 'ನಿಯಮಗಳು & ಷರತ್ತುಗಳು', 'refundPolicy': 'ಮರುಪಾವತಿ ನೀತಿ', 'couldNotOpen': 'ಲಿಂಕ್ ತೆರೆಯಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ', 'invoices': 'ಇನ್‌ವಾಯ್ಸ್‌ಗಳು', 'invoicesSub': 'ನಿಮ್ಮ ರಸೀದಿಗಳನ್ನು ವೀಕ್ಷಿಸಿ ಮತ್ತು ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ'},
    'ml': {'changePassword': 'പാസ്‌വേഡ് മാറ്റുക', 'changePasswordSub': 'ഇമെയിൽ OTP വഴി നിങ്ങളുടെ പാസ്‌വേഡ് അപ്ഡേറ്റ് ചെയ്യുക', 'customerSupport': 'കസ്റ്റമർ സപ്പോർട്ട്', 'customerSupportSub': 'പതിവ് ചോദ്യങ്ങൾ & ടിക്കറ്റ് ഉയർത്തുക', 'aboutLegal': 'വിവരങ്ങൾ & നിയമപരം', 'privacyPolicy': 'സ്വകാര്യതാ നയം', 'termsConditions': 'നിബന്ധനകളും വ്യവസ്ഥകളും', 'refundPolicy': 'റീഫണ്ട് നയം', 'couldNotOpen': 'ലിങ്ക് തുറക്കാൻ കഴിഞ്ഞില്ല', 'invoices': 'ഇൻവോയ്സുകൾ', 'invoicesSub': 'നിങ്ങളുടെ രസീതുകൾ കാണുകയും ഡൗൺലോഡ് ചെയ്യുകയും ചെയ്യുക'},
    'mr': {'changePassword': 'पासवर्ड बदला', 'changePasswordSub': 'ईमेल OTP द्वारे पासवर्ड अपडेट करा', 'customerSupport': 'ग्राहक सहाय्य', 'customerSupportSub': 'FAQ आणि तक्रार नोंदवा', 'aboutLegal': 'आमच्याबद्दल आणि कायदेशीर', 'privacyPolicy': 'गोपनीयता धोरण', 'termsConditions': 'अटी व शर्ती', 'refundPolicy': 'परतावा धोरण', 'couldNotOpen': 'लिंक उघडता आली नाही', 'invoices': 'इनव्हॉइस', 'invoicesSub': 'तुमच्या पावत्या पहा आणि डाउनलोड करा'},
    'or': {'changePassword': 'ପାସୱାର୍ଡ ପରିବର୍ତ୍ତନ କରନ୍ତୁ', 'changePasswordSub': 'ଇମେଲ OTP ମାଧ୍ୟମରେ ପାସୱାର୍ଡ ଅପଡେଟ୍ କରନ୍ତୁ', 'customerSupport': 'ଗ୍ରାହକ ସହାୟତା', 'customerSupportSub': 'FAQ ଏବଂ ଟିକେଟ୍ ଉଠାନ୍ତୁ', 'aboutLegal': 'ଆମ ବିଷୟରେ ଏବଂ ଆଇନଗତ', 'privacyPolicy': 'ଗୋପନୀୟତା ନୀତି', 'termsConditions': 'ସର୍ତ୍ତାବଳୀ', 'refundPolicy': 'ରିଫଣ୍ଡ ନୀତି', 'couldNotOpen': 'ଲିଙ୍କ ଖୋଲି ପାରିଲା ନାହିଁ', 'invoices': 'ଇନଭଏସ୍', 'invoicesSub': 'ଆପଣଙ୍କର ରସିଦ ଦେଖନ୍ତୁ ଏବଂ ଡାଉନଲୋଡ୍ କରନ୍ତୁ'},
    'pa': {'changePassword': 'ਪਾਸਵਰਡ ਬਦਲੋ', 'changePasswordSub': 'ਈਮੇਲ OTP ਰਾਹੀਂ ਪਾਸਵਰਡ ਅੱਪਡੇਟ ਕਰੋ', 'customerSupport': 'ਗਾਹਕ ਸਹਾਇਤਾ', 'customerSupportSub': 'FAQ ਅਤੇ ਸ਼ਿਕਾਇਤ ਦਰਜ ਕਰੋ', 'aboutLegal': 'ਸਾਡੇ ਬਾਰੇ ਅਤੇ ਕਾਨੂੰਨੀ', 'privacyPolicy': 'ਗੋਪਨੀਯਤਾ ਨੀਤੀ', 'termsConditions': 'ਨਿਯਮ ਅਤੇ ਸ਼ਰਤਾਂ', 'refundPolicy': 'ਰਿਫੰਡ ਨੀਤੀ', 'couldNotOpen': 'ਲਿੰਕ ਨਹੀਂ ਖੁੱਲ੍ਹ ਸਕਿਆ', 'invoices': 'ਇਨਵੌਇਸ', 'invoicesSub': 'ਆਪਣੀਆਂ ਰਸੀਦਾਂ ਵੇਖੋ ਅਤੇ ਡਾਊਨਲੋਡ ਕਰੋ'},
    'pt': {'changePassword': 'Alterar Senha', 'changePasswordSub': 'Atualize sua senha via OTP por e-mail', 'customerSupport': 'Suporte ao Cliente', 'customerSupportSub': 'Perguntas frequentes e chamados', 'aboutLegal': 'Sobre e Legal', 'privacyPolicy': 'Política de Privacidade', 'termsConditions': 'Termos e Condições', 'refundPolicy': 'Política de Reembolso', 'couldNotOpen': 'Não foi possível abrir o link', 'invoices': 'Faturas', 'invoicesSub': 'Veja e baixe seus recibos'},
    'ru': {'changePassword': 'Изменить Пароль', 'changePasswordSub': 'Обновите пароль через OTP по электронной почте', 'customerSupport': 'Поддержка Клиентов', 'customerSupportSub': 'Вопросы и создание тикета', 'aboutLegal': 'О нас и Правовая информация', 'privacyPolicy': 'Политика Конфиденциальности', 'termsConditions': 'Условия Использования', 'refundPolicy': 'Политика Возврата', 'couldNotOpen': 'Не удалось открыть ссылку', 'invoices': 'Счета', 'invoicesSub': 'Просмотр и загрузка квитанций'},
    'ta': {'changePassword': 'கடவுச்சொல்லை மாற்று', 'changePasswordSub': 'மின்னஞ்சல் OTP மூலம் கடவுச்சொல்லை புதுப்பிக்கவும்', 'customerSupport': 'வாடிக்கையாளர் ஆதரவு', 'customerSupportSub': 'அடிக்கடி கேட்கப்படும் கேள்விகள் & டிக்கெட் தொடங்கவும்', 'aboutLegal': 'எங்களை பற்றி & சட்டம்', 'privacyPolicy': 'தனியுரிமைக் கொள்கை', 'termsConditions': 'விதிமுறைகள் & நிபந்தனைகள்', 'refundPolicy': 'பணத்திருப்பு கொள்கை', 'couldNotOpen': 'இணைப்பை திறக்க முடியவில்லை', 'invoices': 'விலைப்பட்டியல்கள்', 'invoicesSub': 'உங்கள் ரசீதுகளைப் பார்க்கவும் பதிவிறக்கவும்'},
    'te': {'changePassword': 'పాస్‌వర్డ్ మార్చండి', 'changePasswordSub': 'ఇమెయిల్ OTP ద్వారా మీ పాస్‌వర్డ్‌ను అప్‌డేట్ చేయండి', 'customerSupport': 'కస్టమర్ సపోర్ట్', 'customerSupportSub': 'తరచుగా అడిగే ప్రశ్నలు & టికెట్ లేవనెత్తండి', 'aboutLegal': 'గురించి & చట్టపరమైనవి', 'privacyPolicy': 'గోప్యతా విధానం', 'termsConditions': 'నిబంధనలు & షరతులు', 'refundPolicy': 'వాపసు విధానం', 'couldNotOpen': 'లింక్‌ను తెరవడం సాధ్యం కాలేదు', 'invoices': 'ఇన్వాయిస్‌లు', 'invoicesSub': 'మీ రసీదులను చూడండి & డౌన్‌లోడ్ చేయండి'},
    'th': {'changePassword': 'เปลี่ยนรหัสผ่าน', 'changePasswordSub': 'อัปเดตรหัสผ่านผ่าน OTP ทางอีเมล', 'customerSupport': 'ฝ่ายสนับสนุนลูกค้า', 'customerSupportSub': 'คำถามที่พบบ่อยและแจ้งปัญหา', 'aboutLegal': 'เกี่ยวกับและกฎหมาย', 'privacyPolicy': 'นโยบายความเป็นส่วนตัว', 'termsConditions': 'ข้อกำหนดและเงื่อนไข', 'refundPolicy': 'นโยบายการคืนเงิน', 'couldNotOpen': 'ไม่สามารถเปิดลิงก์ได้', 'invoices': 'ใบแจ้งหนี้', 'invoicesSub': 'ดูและดาวน์โหลดใบเสร็จของคุณ'},
    'zh': {'changePassword': '修改密码', 'changePasswordSub': '通过邮箱验证码更新密码', 'customerSupport': '客户支持', 'customerSupportSub': '常见问题与提交工单', 'aboutLegal': '关于与法律', 'privacyPolicy': '隐私政策', 'termsConditions': '条款与条件', 'refundPolicy': '退款政策', 'couldNotOpen': '无法打开链接', 'invoices': '发票', 'invoicesSub': '查看并下载您的收据'},
  };

  static String _key(Locale l) =>
      l.scriptCode == 'Latn' ? '${l.languageCode}_${l.scriptCode}' : l.languageCode;

  /// Localized menu string for [key] in the current locale (English fallback).
  static String of(BuildContext context, String key) {
    final code = _key(Localizations.localeOf(context));
    return _m[code]?[key] ?? _en[key] ?? key;
  }
}
