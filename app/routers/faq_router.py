"""FAQ — admin-managed help content shown in the apps' Customer Support screen.

Public:
  GET  /faq?audience=user|astrologer        — active FAQ for that audience
Admin (require_role admin):
  GET    /faq/admin                          — all FAQ (any audience/status)
  POST   /faq/admin                          — create
  PUT    /faq/admin/{id}                      — update
  DELETE /faq/admin/{id}                      — delete
"""

from typing import Optional, List

from fastapi import APIRouter, Body, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import require_role
from app.core.i18n import get_lang, normalize_lang, SUPPORTED_LANGUAGES
from app.models.model import FaqItem

router = APIRouter()


def _canon(code: Optional[str]) -> str:
    """Normalize any FAQ language code/label to the canonical full word
    ("en"/"hi" → "english"/"hindi") so admin-stored codes and app requests
    always match. Empty → english."""
    return normalize_lang(code or "english")


class FaqCreate(BaseModel):
    audience: str = Field("user", pattern=r'^(user|astrologer|both)$')
    lang: str = Field("en", max_length=8)
    category: Optional[str] = None
    question: str = Field(..., min_length=1)
    answer: str = Field(..., min_length=1)
    sort_order: int = 0
    is_active: bool = True


class FaqUpdate(BaseModel):
    audience: Optional[str] = Field(None, pattern=r'^(user|astrologer|both)$')
    lang: Optional[str] = Field(None, max_length=8)
    category: Optional[str] = None
    question: Optional[str] = None
    answer: Optional[str] = None
    sort_order: Optional[int] = None
    is_active: Optional[bool] = None


def _serialize(f: FaqItem) -> dict:
    return {
        "id": f.id, "audience": f.audience, "lang": getattr(f, "lang", "en") or "en",
        "category": f.category,
        "question": f.question, "answer": f.answer,
        "sort_order": f.sort_order, "is_active": f.is_active,
        "created_at": str(f.created_at) if f.created_at else None,
        "updated_at": str(f.updated_at) if f.updated_at else None,
    }


@router.get("")
def list_faq(
    audience: str = Query("user", pattern=r'^(user|astrologer)$'),
    lang: Optional[str] = None,
    db: Session = Depends(get_db),
    header_lang: str = Depends(get_lang),
):
    """Public: active FAQ for an audience (audience match OR 'both'), in the
    requested language. `lang` query param wins; otherwise the Accept-Language
    header is used. Falls back to English when there are no entries in that
    language."""
    want = _canon(lang or header_lang)

    def _fetch(code: str):
        return db.query(FaqItem).filter(
            FaqItem.is_active == True,
            FaqItem.audience.in_((audience, "both")),
            FaqItem.lang == code,
        ).order_by(FaqItem.sort_order.asc(), FaqItem.created_at.asc()).all()

    rows = _fetch(want)
    if not rows and want != "english":
        rows = _fetch("english")
    return {"items": [_serialize(f) for f in rows], "lang": want}


@router.get("/admin")
def admin_list_faq(
    audience: Optional[str] = None,
    lang: Optional[str] = None,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(FaqItem)
    if audience:
        q = q.filter(FaqItem.audience == audience)
    if lang:
        q = q.filter(FaqItem.lang == _canon(lang))
    rows = q.order_by(FaqItem.lang.asc(), FaqItem.audience.asc(), FaqItem.sort_order.asc()).all()
    return {"items": [_serialize(f) for f in rows]}


@router.post("/admin")
def admin_create_faq(
    req: FaqCreate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    f = FaqItem(
        audience=req.audience, lang=_canon(req.lang), category=req.category,
        question=req.question, answer=req.answer,
        sort_order=req.sort_order, is_active=req.is_active,
    )
    db.add(f)
    db.commit()
    db.refresh(f)
    return _serialize(f)


@router.put("/admin/{faq_id}")
def admin_update_faq(
    faq_id: str,
    req: FaqUpdate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    f = db.query(FaqItem).filter(FaqItem.id == faq_id).first()
    if not f:
        raise HTTPException(status_code=404, detail="FAQ not found")
    for k, v in req.dict(exclude_unset=True).items():
        if k == "lang":
            v = _canon(v)
        setattr(f, k, v)
    db.commit()
    db.refresh(f)
    return _serialize(f)


@router.delete("/admin/{faq_id}")
def admin_delete_faq(
    faq_id: str,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    f = db.query(FaqItem).filter(FaqItem.id == faq_id).first()
    if not f:
        raise HTTPException(status_code=404, detail="FAQ not found")
    db.delete(f)
    db.commit()
    return {"status": "ok", "deleted": faq_id}


# Recommended default FAQ set (audience, category, question, answer).
_DEFAULT_FAQ = [
    # ── User app ──────────────────────────────────────────────────────
    ("user", "Getting Started", "How do I start a consultation with an astrologer?",
     "Open the Astrologers tab, pick an astrologer who is Online, and choose Chat, Call, or Video. Make sure your wallet has enough balance for at least a few minutes — the rate is shown on each astrologer's card before you start."),
    ("user", "Wallet & Payments", "How does wallet billing work?",
     "You add money to your wallet, and consultations are charged from it. For per-minute services an amount is briefly blocked at the start and the exact charge is settled when the session ends. Any unused blocked amount is released back automatically."),
    ("user", "Wallet & Payments", "Money was deducted but the session didn't start",
     "Blocked amounts are released automatically if a session never starts (e.g. the astrologer didn't answer). If the balance doesn't return within a few minutes, raise a support ticket with the date and time and we'll check it."),
    ("user", "Wallet & Payments", "How do I add money to my wallet?",
     "Go to the Wallet tab and tap Add Money, choose an amount, and complete the payment. Your balance updates instantly once the payment succeeds."),
    ("user", "Consultations", "My call is not connecting",
     "Check your internet connection and that the app has microphone and camera permission. On the web app, allow mic/camera when the browser asks. If the astrologer doesn't answer within 60 seconds the call auto-cancels and you are not charged."),
    ("user", "Consultations", "Can I get a refund for a bad consultation?",
     "If a session had a genuine technical problem (call didn't connect, astrologer didn't respond), raise a support ticket with the details and our team will review it. See our Refund Policy in Profile → About & Legal."),
    ("user", "Notifications", "I'm not receiving notifications",
     "Open Profile → Notifications and make sure they're enabled. On the web app, allow notifications in your browser (on iPhone, add the app to your Home Screen first). If you recently logged out and back in, toggling notifications once refreshes your device."),
    ("user", "Kundli & Reports", "How accurate are the Kundli and reports?",
     "Charts and reports are generated from precise Vedic astronomical calculations using your exact birth date, time, and place — so please enter your birth details as accurately as possible for the best results."),
    ("user", "Live", "How do gifts and super-chats work in live streams?",
     "During a live stream you can send gifts or a paid super-chat to the astrologer; the amount is deducted from your wallet. Super-chats are pinned so the astrologer sees them prominently."),
    ("user", "Account", "How do I change my birth details?",
     "Open your Kundli/profile, edit the birth date, time, and place, and save — your charts and reports will recalculate automatically."),

    # ── Astrologer app ────────────────────────────────────────────────
    ("astrologer", "Onboarding", "How long does approval take?",
     "After you complete your personal details, professional details, and KYC, our team reviews your application. You'll get a notification and email once you're approved or if anything needs correction."),
    ("astrologer", "Onboarding", "My application was rejected — what do I do?",
     "Open the app: the dashboard shows exactly which section needs correction (KYC, personal, or professional details). Fix the flagged section and resubmit — editing your profile automatically sends it back for review."),
    ("astrologer", "KYC", "Which documents do I need for KYC?",
     "Upload a clear, valid government ID (and any professional certificate if requested). Make sure the photo isn't blurry, the details match your profile, and the document isn't expired."),
    ("astrologer", "Requests", "I'm not receiving call/chat requests",
     "Make sure you're set to Online using the dashboard toggle and that notifications are enabled in Profile. Keep the app open, or install the web app to your Home Screen, for reliable delivery. New requests also appear under the bell icon."),
    ("astrologer", "Earnings", "How and when do I get paid?",
     "Your earnings from each consultation are credited to your wallet after the platform commission. You can withdraw to your bank from the Wallet screen; settlement to your bank follows your payment provider's timelines."),
    ("astrologer", "Earnings", "My withdrawal succeeded but I don't see the amount in my bank",
     "Bank settlement can take some time depending on your provider. Your wallet ledger shows the debit immediately; if the ledger doesn't reflect it, raise a support ticket with the reference and time."),
    ("astrologer", "Live", "How do I start a live stream?",
     "From the dashboard tap Go Live. On the web app you'll tap Start Camera first (your browser will ask for camera access), then Go Live. You can reply to viewers, pin a question you're answering, and set a gifting goal."),
    ("astrologer", "Ratings", "How is my rating calculated?",
     "Your rating is the average of the star ratings users leave after chat, call, and video sessions. Consistently helpful, on-time consultations improve your rating and visibility."),

    # ── Both apps ─────────────────────────────────────────────────────
    ("both", "Account", "How do I update my profile photo?",
     "Go to Profile and tap your avatar to upload a new photo. If you signed in with Google, your Google photo is used automatically until you upload your own."),
    ("both", "Support", "How do I contact support?",
     "Open Profile → Customer Support. Check the FAQ first, and if it doesn't help, tap Raise Ticket to send us the details (you can attach up to 2 screenshots). You can track the status and replies under My Tickets."),
    ("both", "Account", "How do I change the app language?",
     "Open Profile → Language and pick your preferred language. The app updates immediately."),
    ("both", "Privacy", "Where can I read the privacy, terms, and refund policies?",
     "They're in Profile → About & Legal, which links to the Privacy Policy, Terms & Conditions, and Refund Policy on nakshatralogy.com."),
]


# Hand-authored Hindi translations of the default set, in the SAME order as
# `_DEFAULT_FAQ` (each entry is (question, answer)). English + Hindi are always
# seeded reliably; the remaining supported languages are auto-translated at
# seed time via the app's existing translation engine (best-effort).
_DEFAULT_FAQ_HI = [
    ("मैं ज्योतिषी से परामर्श कैसे शुरू करूँ?",
     "ज्योतिषी टैब खोलें, ‘ऑनलाइन’ दिख रहे किसी ज्योतिषी को चुनें और चैट, कॉल या वीडियो चुनें। शुरू करने से पहले सुनिश्चित करें कि आपके वॉलेट में कम से कम कुछ मिनटों के लिए पर्याप्त बैलेंस है — दर हर ज्योतिषी के कार्ड पर पहले से दिखती है।"),
    ("वॉलेट बिलिंग कैसे काम करती है?",
     "आप अपने वॉलेट में पैसे जोड़ते हैं और परामर्श का शुल्क उसी से कटता है। प्रति-मिनट सेवाओं के लिए शुरुआत में एक राशि अस्थायी रूप से रोक ली जाती है और सत्र समाप्त होने पर सही शुल्क तय होता है। बिना उपयोग की रोकी गई राशि अपने आप वापस छोड़ दी जाती है।"),
    ("पैसे कट गए पर सत्र शुरू नहीं हुआ",
     "यदि सत्र शुरू ही नहीं होता (जैसे ज्योतिषी ने उत्तर नहीं दिया) तो रोकी गई राशि अपने आप वापस हो जाती है। अगर कुछ मिनटों में बैलेंस वापस न आए, तो तारीख और समय के साथ सपोर्ट टिकट बनाएं, हम जाँच करेंगे।"),
    ("मैं वॉलेट में पैसे कैसे जोड़ूँ?",
     "वॉलेट टैब में जाएँ, ‘पैसे जोड़ें’ पर टैप करें, राशि चुनें और भुगतान पूरा करें। भुगतान सफल होते ही आपका बैलेंस तुरंत अपडेट हो जाता है।"),
    ("मेरी कॉल कनेक्ट नहीं हो रही",
     "अपना इंटरनेट कनेक्शन जाँचें और सुनिश्चित करें कि ऐप को माइक्रोफोन और कैमरा की अनुमति है। वेब ऐप पर, ब्राउज़र पूछे तो माइक/कैमरा की अनुमति दें। यदि ज्योतिषी 60 सेकंड में उत्तर नहीं देता तो कॉल स्वतः रद्द हो जाती है और आपसे शुल्क नहीं लिया जाता।"),
    ("खराब परामर्श के लिए क्या मुझे रिफंड मिल सकता है?",
     "यदि सत्र में वास्तविक तकनीकी समस्या थी (कॉल कनेक्ट नहीं हुई, ज्योतिषी ने उत्तर नहीं दिया), तो विवरण के साथ सपोर्ट टिकट बनाएं और हमारी टीम उसकी समीक्षा करेगी। रिफंड नीति ‘प्रोफ़ाइल → About & Legal’ में देखें।"),
    ("मुझे सूचनाएँ नहीं मिल रहीं",
     "‘प्रोफ़ाइल → सूचनाएँ’ खोलें और सुनिश्चित करें कि वे चालू हैं। वेब ऐप पर अपने ब्राउज़र में सूचनाओं की अनुमति दें (iPhone पर पहले ऐप को होम स्क्रीन पर जोड़ें)। यदि आपने हाल ही में लॉगआउट कर फिर लॉगिन किया है, तो सूचनाओं को एक बार टॉगल करने से आपका डिवाइस रिफ्रेश हो जाता है।"),
    ("कुंडली और रिपोर्ट कितनी सटीक हैं?",
     "कुंडली और रिपोर्ट आपकी सटीक जन्म तिथि, समय और स्थान का उपयोग करते हुए सूक्ष्म वैदिक खगोलीय गणनाओं से बनाई जाती हैं — इसलिए सर्वोत्तम परिणाम के लिए कृपया अपने जन्म विवरण यथासंभव सटीक भरें।"),
    ("लाइव स्ट्रीम में गिफ्ट और सुपर-चैट कैसे काम करते हैं?",
     "लाइव स्ट्रीम के दौरान आप ज्योतिषी को गिफ्ट या पेड सुपर-चैट भेज सकते हैं; राशि आपके वॉलेट से कटती है। सुपर-चैट पिन हो जाते हैं ताकि ज्योतिषी उन्हें प्रमुखता से देख सके।"),
    ("मैं अपने जन्म विवरण कैसे बदलूँ?",
     "अपनी कुंडली/प्रोफ़ाइल खोलें, जन्म तिथि, समय और स्थान संपादित करें और सहेजें — आपकी कुंडली और रिपोर्ट अपने आप फिर से गणना हो जाएँगी।"),
    ("स्वीकृति में कितना समय लगता है?",
     "आपके व्यक्तिगत विवरण, व्यावसायिक विवरण और KYC पूरा करने के बाद हमारी टीम आपके आवेदन की समीक्षा करती है। स्वीकृति मिलने पर या किसी सुधार की आवश्यकता होने पर आपको सूचना और ईमेल मिलेगा।"),
    ("मेरा आवेदन अस्वीकृत हो गया — मैं क्या करूँ?",
     "ऐप खोलें: डैशबोर्ड बताता है कि किस भाग में सुधार चाहिए (KYC, व्यक्तिगत या व्यावसायिक विवरण)। चिह्नित भाग ठीक करें और फिर से सबमिट करें — प्रोफ़ाइल संपादित करते ही वह पुनः समीक्षा के लिए भेज दी जाती है।"),
    ("KYC के लिए मुझे कौन-से दस्तावेज़ चाहिए?",
     "एक स्पष्ट, वैध सरकारी पहचान पत्र अपलोड करें (और माँगे जाने पर कोई व्यावसायिक प्रमाणपत्र)। सुनिश्चित करें कि फोटो धुंधली न हो, विवरण आपकी प्रोफ़ाइल से मेल खाएँ और दस्तावेज़ की अवधि समाप्त न हो।"),
    ("मुझे कॉल/चैट अनुरोध नहीं मिल रहे",
     "डैशबोर्ड टॉगल से खुद को ‘ऑनलाइन’ रखें और सुनिश्चित करें कि प्रोफ़ाइल में सूचनाएँ चालू हैं। विश्वसनीय डिलीवरी के लिए ऐप खुला रखें या वेब ऐप को होम स्क्रीन पर इंस्टॉल करें। नए अनुरोध बेल आइकन के नीचे भी दिखते हैं।"),
    ("मुझे भुगतान कैसे और कब मिलता है?",
     "प्रत्येक परामर्श से आपकी कमाई प्लेटफ़ॉर्म कमीशन के बाद आपके वॉलेट में जमा होती है। आप वॉलेट स्क्रीन से अपने बैंक में निकासी कर सकते हैं; बैंक में सेटलमेंट आपके भुगतान प्रदाता की समय-सीमा के अनुसार होता है।"),
    ("निकासी सफल रही पर राशि मेरे बैंक में नहीं दिख रही",
     "बैंक सेटलमेंट में आपके प्रदाता के अनुसार कुछ समय लग सकता है। आपका वॉलेट लेज़र डेबिट तुरंत दिखाता है; यदि लेज़र में यह न दिखे, तो संदर्भ और समय के साथ सपोर्ट टिकट बनाएं।"),
    ("मैं लाइव स्ट्रीम कैसे शुरू करूँ?",
     "डैशबोर्ड से ‘Go Live’ टैप करें। वेब ऐप पर पहले ‘Start Camera’ टैप करें (ब्राउज़र कैमरा एक्सेस माँगेगा), फिर ‘Go Live’। आप दर्शकों को उत्तर दे सकते हैं, जिस प्रश्न का उत्तर दे रहे हैं उसे पिन कर सकते हैं और गिफ्टिंग लक्ष्य तय कर सकते हैं।"),
    ("मेरी रेटिंग कैसे तय होती है?",
     "आपकी रेटिंग चैट, कॉल और वीडियो सत्रों के बाद उपयोगकर्ताओं द्वारा दी गई स्टार रेटिंग का औसत है। लगातार सहायक और समय पर परामर्श आपकी रेटिंग और दृश्यता बढ़ाते हैं।"),
    ("मैं अपनी प्रोफ़ाइल फोटो कैसे अपडेट करूँ?",
     "प्रोफ़ाइल में जाएँ और नई फोटो अपलोड करने के लिए अपने अवतार पर टैप करें। यदि आपने Google से साइन इन किया है, तो जब तक आप अपनी फोटो अपलोड नहीं करते, आपकी Google फोटो अपने आप उपयोग होती है।"),
    ("मैं सपोर्ट से कैसे संपर्क करूँ?",
     "‘प्रोफ़ाइल → Customer Support’ खोलें। पहले FAQ देखें, और अगर उससे मदद न मिले तो ‘Raise Ticket’ पर टैप कर हमें विवरण भेजें (आप 2 स्क्रीनशॉट तक जोड़ सकते हैं)। स्थिति और उत्तर ‘My Tickets’ के नीचे देख सकते हैं।"),
    ("मैं ऐप की भाषा कैसे बदलूँ?",
     "‘प्रोफ़ाइल → भाषा’ खोलें और अपनी पसंदीदा भाषा चुनें। ऐप तुरंत अपडेट हो जाता है।"),
    ("मैं प्राइवेसी, नियम और रिफंड नीति कहाँ पढ़ूँ?",
     "ये ‘प्रोफ़ाइल → About & Legal’ में हैं, जो nakshatralogy.com पर प्राइवेसी पॉलिसी, नियम व शर्तें और रिफंड नीति से लिंक करता है।"),
]

# Hand-authored Hinglish (Hindi in Latin script, code-mixed) translations.
_DEFAULT_FAQ_HINGLISH = [
    ("Astrologer ke saath consultation kaise start karu?",
     "Astrologers tab kholo, jo astrologer Online dikh raha ho use choose karo, aur Chat, Call, ya Video mein se koi ek select karo. Shuru karne se pehle check kar lo ki wallet mein kam se kam kuch minutes ke liye balance ho — rate har astrologer ke card par pehle se dikhta hai."),
    ("Wallet billing kaise kaam karti hai?",
     "Aap apne wallet mein paise add karte ho, aur consultation ka charge wahi se katta hai. Per-minute services ke liye shuru mein thodi amount block ho jaati hai aur session khatam hone par exact charge settle hota hai. Jo amount use nahi hui wo apne aap wapas release ho jaati hai."),
    ("Paise cut ho gaye lekin session start nahi hua",
     "Agar session kabhi start hi nahi hota (jaise astrologer ne answer nahi kiya) to blocked amount apne aap wapas ho jaati hai. Agar balance kuch minutes mein wapas na aaye, to date aur time ke saath support ticket raise karo, hum check karenge."),
    ("Wallet mein paise kaise add karu?",
     "Wallet tab mein jao aur 'Add Money' par tap karo, amount choose karo aur payment complete karo. Payment successful hote hi aapka balance turant update ho jaata hai."),
    ("Meri call connect nahi ho rahi",
     "Apna internet connection check karo aur dekho ki app ko microphone aur camera ki permission di hai ya nahi. Web app par, browser jab pooche to mic/camera allow kar do. Agar astrologer 60 seconds mein answer nahi karta to call apne aap cancel ho jaati hai aur aapse koi charge nahi liya jaata."),
    ("Kharab consultation ke liye kya mujhe refund mil sakta hai?",
     "Agar session mein genuine technical problem thi (call connect nahi hui, astrologer ne respond nahi kiya), to details ke saath support ticket raise karo, hamari team usko review karegi. Refund Policy Profile → About & Legal mein dekho."),
    ("Mujhe notifications nahi aa rahe",
     "Profile → Notifications kholo aur check karo ki wo enabled hain. Web app par apne browser mein notifications allow karo (iPhone par pehle app ko Home Screen par add karo). Agar aapne recently logout karke phir login kiya hai, to notifications ko ek baar toggle karne se device refresh ho jaata hai."),
    ("Kundli aur reports kitni accurate hain?",
     "Charts aur reports aapki exact birth date, time aur place use karke precise Vedic astronomical calculations se banaye jaate hain — isliye best result ke liye apni birth details jitni ho sake accurately bharein."),
    ("Live streams mein gifts aur super-chats kaise kaam karte hain?",
     "Live stream ke dauran aap astrologer ko gift ya paid super-chat bhej sakte ho; amount aapke wallet se katti hai. Super-chats pin ho jaate hain taaki astrologer unhe achhi tarah dekh sake."),
    ("Main apni birth details kaise change karu?",
     "Apni Kundli/profile kholo, birth date, time aur place edit karo aur save karo — aapke charts aur reports apne aap recalculate ho jaayenge."),
    ("Approval hone mein kitna time lagta hai?",
     "Aapke personal details, professional details aur KYC complete karne ke baad hamari team aapki application review karti hai. Approve hone par ya kisi correction ki zaroorat hone par aapko notification aur email milega."),
    ("Meri application reject ho gayi — ab main kya karu?",
     "App kholo: dashboard exactly dikhata hai ki kis section mein correction chahiye (KYC, personal, ya professional details). Us flagged section ko theek karo aur resubmit karo — profile edit karte hi wo apne aap review ke liye chali jaati hai."),
    ("KYC ke liye mujhe kaunse documents chahiye?",
     "Ek clear, valid government ID upload karo (aur agar maanga jaaye to koi professional certificate). Dekh lo ki photo blurry na ho, details profile se match karein aur document expired na ho."),
    ("Mujhe call/chat requests nahi mil rahi",
     "Dashboard toggle se apne aap ko Online set karo aur Profile mein notifications enabled rakho. Reliable delivery ke liye app ko open rakho, ya web app ko Home Screen par install karo. New requests bell icon ke neeche bhi dikhti hain."),
    ("Mujhe payment kaise aur kab milta hai?",
     "Har consultation se aapki earning platform commission katne ke baad aapke wallet mein credit hoti hai. Aap Wallet screen se apne bank mein withdraw kar sakte ho; bank mein settlement aapke payment provider ki timeline ke hisab se hota hai."),
    ("Withdrawal successful hua lekin amount mere bank mein nahi dikh raha",
     "Bank settlement mein provider ke hisab se kuch time lag sakta hai. Aapka wallet ledger debit turant dikhata hai; agar ledger mein wo reflect na ho, to reference aur time ke saath support ticket raise karo."),
    ("Main live stream kaise start karu?",
     "Dashboard se 'Go Live' par tap karo. Web app par pehle 'Start Camera' tap karoge (browser camera access maangega), phir 'Go Live'. Aap viewers ko reply kar sakte ho, jis question ka answer de rahe ho use pin kar sakte ho, aur gifting goal set kar sakte ho."),
    ("Meri rating kaise calculate hoti hai?",
     "Aapki rating chat, call aur video sessions ke baad users dwara di gayi star ratings ka average hoti hai. Consistently helpful aur time par diye gaye consultations aapki rating aur visibility badhaate hain."),
    ("Main apni profile photo kaise update karu?",
     "Profile mein jao aur nayi photo upload karne ke liye apne avatar par tap karo. Agar aapne Google se sign in kiya hai, to jab tak aap apni photo upload nahi karte, aapki Google photo apne aap use hoti hai."),
    ("Main support se kaise contact karu?",
     "Profile → Customer Support kholo. Pehle FAQ check karo, aur agar usse madad na mile to 'Raise Ticket' par tap karke humein details bhejo (aap 2 screenshots tak attach kar sakte ho). Status aur replies aap 'My Tickets' ke neeche track kar sakte ho."),
    ("Main app ki language kaise change karu?",
     "Profile → Language kholo aur apni preferred language choose karo. App turant update ho jaata hai."),
    ("Privacy, terms aur refund policies main kahan padh sakta hoon?",
     "Ye Profile → About & Legal mein hain, jo nakshatralogy.com par Privacy Policy, Terms & Conditions aur Refund Policy se link karta hai."),
]

# Hand-authored Bengali translations.
_DEFAULT_FAQ_BN = [
    ("আমি কীভাবে একজন জ্যোতিষীর সাথে পরামর্শ শুরু করব?",
     "Astrologers ট্যাব খুলুন, যিনি Online আছেন এমন একজন জ্যোতিষী বেছে নিন এবং Chat, Call বা Video-এর মধ্যে যেকোনো একটি বেছে নিন। শুরু করার আগে নিশ্চিত করুন যে আপনার ওয়ালেটে অন্তত কয়েক মিনিটের জন্য পর্যাপ্ত ব্যালেন্স আছে — রেট প্রতিটি জ্যোতিষীর কার্ডে আগেই দেখানো থাকে।"),
    ("ওয়ালেট বিলিং কীভাবে কাজ করে?",
     "আপনি আপনার ওয়ালেটে টাকা যোগ করেন, এবং পরামর্শের খরচ সেখান থেকেই কাটা হয়। প্রতি-মিনিট পরিষেবার জন্য শুরুতে একটি পরিমাণ সাময়িকভাবে ব্লক করা হয় এবং সেশন শেষ হলে সঠিক চার্জ নির্ধারিত হয়। ব্যবহার না হওয়া ব্লক করা টাকা স্বয়ংক্রিয়ভাবে ফেরত দেওয়া হয়।"),
    ("টাকা কাটা হয়েছে কিন্তু সেশন শুরু হয়নি",
     "সেশন যদি কখনো শুরুই না হয় (যেমন জ্যোতিষী উত্তর দেননি), তাহলে ব্লক করা টাকা স্বয়ংক্রিয়ভাবে ফেরত দেওয়া হয়। কয়েক মিনিটের মধ্যে ব্যালেন্স ফেরত না এলে, তারিখ ও সময় উল্লেখ করে একটি সাপোর্ট টিকিট তুলুন, আমরা তা যাচাই করব।"),
    ("আমি কীভাবে আমার ওয়ালেটে টাকা যোগ করব?",
     "Wallet ট্যাবে গিয়ে Add Money-তে ট্যাপ করুন, একটি পরিমাণ বেছে নিন এবং পেমেন্ট সম্পূর্ণ করুন। পেমেন্ট সফল হওয়ার সাথে সাথেই আপনার ব্যালেন্স আপডেট হয়ে যাবে।"),
    ("আমার কল কানেক্ট হচ্ছে না",
     "আপনার ইন্টারনেট সংযোগ পরীক্ষা করুন এবং দেখুন অ্যাপের মাইক্রোফোন ও ক্যামেরার অনুমতি আছে কিনা। ওয়েব অ্যাপে ব্রাউজার জিজ্ঞাসা করলে মাইক/ক্যামেরার অনুমতি দিন। জ্যোতিষী ৬০ সেকেন্ডের মধ্যে উত্তর না দিলে কলটি নিজে থেকেই বাতিল হয়ে যায় এবং আপনার কাছ থেকে কোনো চার্জ নেওয়া হয় না।"),
    ("খারাপ পরামর্শের জন্য কি আমি রিফান্ড পেতে পারি?",
     "সেশনে যদি সত্যিকারের প্রযুক্তিগত সমস্যা হয়ে থাকে (কল কানেক্ট হয়নি, জ্যোতিষী সাড়া দেননি), তাহলে বিস্তারিত সহ একটি সাপোর্ট টিকিট তুলুন, আমাদের টিম তা পর্যালোচনা করবে। আমাদের রিফান্ড পলিসি দেখুন Profile → About & Legal-এ।"),
    ("আমি নোটিফিকেশন পাচ্ছি না",
     "Profile → Notifications খুলুন এবং নিশ্চিত করুন সেগুলো চালু আছে। ওয়েব অ্যাপে আপনার ব্রাউজারে নোটিফিকেশন অনুমতি দিন (আইফোনে প্রথমে অ্যাপটি Home Screen-এ যোগ করুন)। সম্প্রতি লগ-আউট করে আবার লগ-ইন করে থাকলে, নোটিফিকেশন একবার টগল করলে আপনার ডিভাইস রিফ্রেশ হয়ে যায়।"),
    ("কুণ্ডলী এবং রিপোর্ট কতটা সঠিক?",
     "চার্ট ও রিপোর্ট আপনার সঠিক জন্ম তারিখ, সময় ও স্থান ব্যবহার করে সূক্ষ্ম বৈদিক জ্যোতির্বিজ্ঞানগত হিসাব থেকে তৈরি হয় — তাই সেরা ফলাফলের জন্য অনুগ্রহ করে আপনার জন্ম বিবরণ যতটা সম্ভব সঠিকভাবে দিন।"),
    ("লাইভ স্ট্রিমে গিফট এবং সুপার-চ্যাট কীভাবে কাজ করে?",
     "লাইভ স্ট্রিমের সময় আপনি জ্যোতিষীকে গিফট বা পেইড সুপার-চ্যাট পাঠাতে পারেন; পরিমাণ আপনার ওয়ালেট থেকে কাটা হয়। সুপার-চ্যাট পিন করা হয় যাতে জ্যোতিষী তা স্পষ্টভাবে দেখতে পান।"),
    ("আমি কীভাবে আমার জন্ম বিবরণ পরিবর্তন করব?",
     "আপনার Kundli/প্রোফাইল খুলুন, জন্ম তারিখ, সময় ও স্থান সম্পাদনা করে সেভ করুন — আপনার চার্ট ও রিপোর্ট স্বয়ংক্রিয়ভাবে পুনরায় হিসাব হয়ে যাবে।"),
    ("অনুমোদন পেতে কত সময় লাগে?",
     "আপনার ব্যক্তিগত তথ্য, পেশাগত তথ্য এবং KYC সম্পূর্ণ করার পর আমাদের টিম আপনার আবেদন পর্যালোচনা করে। অনুমোদন পেলে বা কোনো সংশোধন প্রয়োজন হলে আপনি নোটিফিকেশন ও ইমেল পাবেন।"),
    ("আমার আবেদন প্রত্যাখ্যাত হয়েছে — এখন আমি কী করব?",
     "অ্যাপটি খুলুন: ড্যাশবোর্ডে ঠিক কোন অংশে সংশোধন দরকার তা দেখানো হয় (KYC, ব্যক্তিগত, বা পেশাগত তথ্য)। চিহ্নিত অংশটি ঠিক করে পুনরায় জমা দিন — প্রোফাইল সম্পাদনা করলেই তা স্বয়ংক্রিয়ভাবে পুনরায় পর্যালোচনার জন্য চলে যায়।"),
    ("KYC-এর জন্য আমার কোন নথিগুলো দরকার?",
     "একটি স্পষ্ট, বৈধ সরকারি পরিচয়পত্র আপলোড করুন (এবং চাওয়া হলে যেকোনো পেশাগত সার্টিফিকেট)। নিশ্চিত করুন ছবিটি ঝাপসা নয়, তথ্য আপনার প্রোফাইলের সাথে মিলছে এবং নথির মেয়াদ শেষ হয়নি।"),
    ("আমি কল/চ্যাট রিকোয়েস্ট পাচ্ছি না",
     "ড্যাশবোর্ডের টগল ব্যবহার করে নিজেকে Online সেট করুন এবং Profile-এ নোটিফিকেশন চালু আছে তা নিশ্চিত করুন। নির্ভরযোগ্য ডেলিভারির জন্য অ্যাপটি খোলা রাখুন, অথবা ওয়েব অ্যাপটি Home Screen-এ ইনস্টল করুন। নতুন রিকোয়েস্ট বেল আইকনের নিচেও দেখা যায়।"),
    ("আমি কীভাবে এবং কখন পেমেন্ট পাব?",
     "প্রতিটি পরামর্শ থেকে আপনার আয় প্ল্যাটফর্ম কমিশন বাদ দিয়ে আপনার ওয়ালেটে জমা হয়। আপনি Wallet স্ক্রিন থেকে আপনার ব্যাংকে উইথড্র করতে পারেন; ব্যাংকে সেটেলমেন্ট আপনার পেমেন্ট প্রোভাইডারের সময়সীমা অনুযায়ী হয়।"),
    ("আমার উইথড্রয়াল সফল হয়েছে কিন্তু আমার ব্যাংকে টাকা দেখাচ্ছে না",
     "প্রোভাইডারের উপর নির্ভর করে ব্যাংক সেটেলমেন্টে কিছুটা সময় লাগতে পারে। আপনার ওয়ালেট লেজার ডেবিট সাথে সাথে দেখায়; যদি লেজারে তা প্রতিফলিত না হয়, তাহলে রেফারেন্স ও সময় সহ একটি সাপোর্ট টিকিট তুলুন।"),
    ("আমি কীভাবে লাইভ স্ট্রিম শুরু করব?",
     "ড্যাশবোর্ড থেকে Go Live-এ ট্যাপ করুন। ওয়েব অ্যাপে প্রথমে Start Camera ট্যাপ করবেন (ব্রাউজার ক্যামেরা অ্যাক্সেস চাইবে), তারপর Go Live। আপনি দর্শকদের উত্তর দিতে পারেন, যে প্রশ্নের উত্তর দিচ্ছেন তা পিন করতে পারেন এবং একটি গিফটিং লক্ষ্য নির্ধারণ করতে পারেন।"),
    ("আমার রেটিং কীভাবে হিসাব করা হয়?",
     "চ্যাট, কল এবং ভিডিও সেশনের পর ব্যবহারকারীদের দেওয়া স্টার রেটিংয়ের গড়ই আপনার রেটিং। ধারাবাহিকভাবে সহায়ক ও সময়মতো পরামর্শ আপনার রেটিং ও দৃশ্যমানতা বাড়ায়।"),
    ("আমি কীভাবে আমার প্রোফাইল ছবি আপডেট করব?",
     "Profile-এ গিয়ে নতুন ছবি আপলোড করতে আপনার অ্যাভাটারে ট্যাপ করুন। আপনি যদি Google দিয়ে সাইন ইন করে থাকেন, তাহলে আপনি নিজের ছবি আপলোড না করা পর্যন্ত আপনার Google ছবি স্বয়ংক্রিয়ভাবে ব্যবহৃত হবে।"),
    ("আমি কীভাবে সাপোর্টের সাথে যোগাযোগ করব?",
     "Profile → Customer Support খুলুন। প্রথমে FAQ দেখুন, আর তাতে সাহায্য না হলে Raise Ticket-এ ট্যাপ করে আমাদের বিস্তারিত পাঠান (আপনি ২টি পর্যন্ত স্ক্রিনশট যুক্ত করতে পারেন)। স্ট্যাটাস ও রিপ্লাই My Tickets-এ ট্র্যাক করতে পারবেন।"),
    ("আমি কীভাবে অ্যাপের ভাষা পরিবর্তন করব?",
     "Profile → Language খুলুন এবং আপনার পছন্দের ভাষা বেছে নিন। অ্যাপটি তৎক্ষণাৎ আপডেট হয়ে যায়।"),
    ("আমি কোথায় প্রাইভেসি, শর্তাবলী এবং রিফান্ড নীতিগুলো পড়তে পারি?",
     "এগুলো Profile → About & Legal-এ আছে, যা nakshatralogy.com-এর Privacy Policy, Terms & Conditions এবং Refund Policy-এর সাথে লিঙ্ক করে।"),
]

# Hand-authored Tamil translations.
_DEFAULT_FAQ_TA = [
    ("ஜோதிடருடன் ஆலோசனையை நான் எப்படித் தொடங்குவது?",
     "Astrologers தாவலைத் திறந்து, Online-ல் இருக்கும் ஒரு ஜோதிடரைத் தேர்ந்தெடுத்து, Chat, Call அல்லது Video-வில் ஒன்றைத் தேர்வு செய்யுங்கள். தொடங்குவதற்கு முன் உங்கள் wallet-இல் குறைந்தபட்சம் சில நிமிடங்களுக்கு போதுமான balance இருப்பதை உறுதிசெய்யுங்கள் — கட்டணம் ஒவ்வொரு ஜோதிடரின் கார்டிலும் முன்பே காட்டப்படும்."),
    ("Wallet பில்லிங் எப்படி வேலை செய்கிறது?",
     "நீங்கள் உங்கள் wallet-க்கு பணம் சேர்க்கிறீர்கள், ஆலோசனைகளுக்கான கட்டணம் அதிலிருந்தே கழிக்கப்படும். நிமிடத்திற்கான சேவைகளுக்கு தொடக்கத்தில் ஒரு தொகை தற்காலிகமாக block செய்யப்பட்டு, session முடிந்தவுடன் சரியான கட்டணம் தீர்மானிக்கப்படும். பயன்படுத்தாத block தொகை தானாகவே திரும்ப வழங்கப்படும்."),
    ("பணம் கழிக்கப்பட்டது ஆனால் session தொடங்கவில்லை",
     "Session ஒருபோதும் தொடங்கவில்லை என்றால் (எடுத்துக்காட்டாக ஜோதிடர் பதிலளிக்கவில்லை), block செய்யப்பட்ட தொகை தானாகவே திரும்ப வழங்கப்படும். சில நிமிடங்களில் balance திரும்பவில்லை என்றால், தேதி மற்றும் நேரத்துடன் ஒரு support ticket-ஐ எழுப்புங்கள், நாங்கள் அதைச் சரிபார்ப்போம்."),
    ("என் wallet-க்கு பணத்தை நான் எப்படிச் சேர்ப்பது?",
     "Wallet தாவலுக்குச் சென்று Add Money-ஐத் தட்டி, ஒரு தொகையைத் தேர்ந்தெடுத்து பணம் செலுத்துவதை முடிக்கவும். பணம் செலுத்தியவுடன் உங்கள் balance உடனடியாக புதுப்பிக்கப்படும்."),
    ("என் அழைப்பு இணைக்கப்படவில்லை",
     "உங்கள் இணைய இணைப்பை சரிபார்த்து, app-க்கு microphone மற்றும் camera அனுமதி உள்ளதா என்பதை உறுதிசெய்யுங்கள். Web app-இல், browser கேட்கும்போது mic/camera அனுமதி வழங்குங்கள். ஜோதிடர் 60 விநாடிகளுக்குள் பதிலளிக்காவிட்டால் அழைப்பு தானாக ரத்தாகி விடும், உங்களிடம் கட்டணம் வசூலிக்கப்படாது."),
    ("மோசமான ஆலோசனைக்கு எனக்கு refund கிடைக்குமா?",
     "Session-இல் உண்மையான தொழில்நுட்பக் கோளாறு இருந்தால் (அழைப்பு இணையவில்லை, ஜோதிடர் பதிலளிக்கவில்லை), விவரங்களுடன் ஒரு support ticket-ஐ எழுப்புங்கள், எங்கள் குழு அதை ஆய்வு செய்யும். Profile → About & Legal-இல் எங்கள் Refund Policy-ஐப் பாருங்கள்."),
    ("எனக்கு notifications வரவில்லை",
     "Profile → Notifications-ஐத் திறந்து அவை இயக்கப்பட்டுள்ளதா என்பதை உறுதிசெய்யுங்கள். Web app-இல், உங்கள் browser-இல் notifications-ஐ அனுமதிக்கவும் (iPhone-இல் முதலில் app-ஐ Home Screen-க்குச் சேர்க்கவும்). நீங்கள் சமீபத்தில் logout செய்து மீண்டும் login செய்திருந்தால், notifications-ஐ ஒருமுறை toggle செய்வது உங்கள் device-ஐ புதுப்பிக்கும்."),
    ("Kundli மற்றும் reports எவ்வளவு துல்லியமானவை?",
     "Charts மற்றும் reports உங்கள் சரியான பிறந்த தேதி, நேரம் மற்றும் இடத்தைப் பயன்படுத்தி துல்லியமான வேத ஜோதிட கணக்கீடுகளால் உருவாக்கப்படுகின்றன — எனவே சிறந்த முடிவுகளுக்கு உங்கள் பிறப்பு விவரங்களை முடிந்தவரை துல்லியமாக உள்ளிடவும்."),
    ("Live streams-இல் gifts மற்றும் super-chats எப்படி வேலை செய்கின்றன?",
     "Live stream-இன் போது நீங்கள் ஜோதிடருக்கு gifts அல்லது paid super-chat அனுப்பலாம்; தொகை உங்கள் wallet-இலிருந்து கழிக்கப்படும். Super-chats pin செய்யப்படும், அதனால் ஜோதிடர் அவற்றை தெளிவாகக் காண முடியும்."),
    ("என் பிறப்பு விவரங்களை நான் எப்படி மாற்றுவது?",
     "உங்கள் Kundli/profile-ஐத் திறந்து, பிறந்த தேதி, நேரம் மற்றும் இடத்தைத் திருத்தி சேமிக்கவும் — உங்கள் charts மற்றும் reports தானாகவே மீண்டும் கணக்கிடப்படும்."),
    ("ஒப்புதல் பெற எவ்வளவு நேரம் ஆகும்?",
     "உங்கள் தனிப்பட்ட விவரங்கள், தொழில்முறை விவரங்கள் மற்றும் KYC-ஐ முடித்த பிறகு, எங்கள் குழு உங்கள் விண்ணப்பத்தை ஆய்வு செய்யும். ஒப்புதல் அளிக்கப்பட்டவுடன் அல்லது ஏதேனும் திருத்தம் தேவைப்பட்டால் உங்களுக்கு notification மற்றும் email வரும்."),
    ("என் விண்ணப்பம் நிராகரிக்கப்பட்டது — நான் என்ன செய்வது?",
     "App-ஐத் திறங்கள்: எந்தப் பகுதியில் திருத்தம் தேவை (KYC, தனிப்பட்ட, அல்லது தொழில்முறை விவரங்கள்) என்பதை dashboard துல்லியமாகக் காட்டும். குறிக்கப்பட்ட பகுதியைச் சரிசெய்து மீண்டும் சமர்ப்பிக்கவும் — profile-ஐத் திருத்தியவுடன் அது தானாகவே மறு ஆய்வுக்கு அனுப்பப்படும்."),
    ("KYC-க்கு எனக்கு என்ன ஆவணங்கள் தேவை?",
     "தெளிவான, செல்லுபடியாகும் அரசு அடையாள அட்டையை பதிவேற்றவும் (கேட்கப்பட்டால் ஏதேனும் தொழில்முறை சான்றிதழையும்). புகைப்படம் மங்கலாக இல்லாமல், விவரங்கள் உங்கள் profile-உடன் பொருந்துவதையும், ஆவணத்தின் காலாவதி முடியாததையும் உறுதிசெய்யுங்கள்."),
    ("எனக்கு call/chat requests வரவில்லை",
     "Dashboard toggle மூலம் உங்களை Online என அமைத்து, Profile-இல் notifications இயக்கப்பட்டுள்ளதை உறுதிசெய்யுங்கள். நம்பகமான டெலிவரிக்கு app-ஐத் திறந்து வையுங்கள் அல்லது web app-ஐ Home Screen-இல் நிறுவவும். புதிய requests bell ஐகானுக்கு அடியிலும் தோன்றும்."),
    ("எனக்கு எப்படி, எப்போது பணம் கிடைக்கும்?",
     "ஒவ்வொரு ஆலோசனையிலிருந்தும் உங்கள் வருமானம் platform commission கழிக்கப்பட்ட பிறகு உங்கள் wallet-க்கு வரவு வைக்கப்படும். Wallet திரையிலிருந்து உங்கள் வங்கிக்கு withdraw செய்யலாம்; வங்கியில் settlement உங்கள் payment provider-இன் காலவரையறையைப் பின்பற்றும்."),
    ("என் withdrawal வெற்றிகரமாக இருந்தது ஆனால் தொகை என் வங்கியில் தெரியவில்லை",
     "வங்கி settlement உங்கள் provider-ஐப் பொறுத்து சிறிது நேரம் ஆகலாம். உங்கள் wallet ledger debit-ஐ உடனடியாகக் காட்டும்; அது ledger-இல் பிரதிபலிக்கவில்லை என்றால், reference மற்றும் நேரத்துடன் support ticket-ஐ எழுப்புங்கள்."),
    ("நான் எப்படி live stream தொடங்குவது?",
     "Dashboard-இலிருந்து Go Live-ஐத் தட்டவும். Web app-இல் முதலில் Start Camera-ஐத் தட்டுவீர்கள் (browser camera அணுகலைக் கேட்கும்), பிறகு Go Live. நீங்கள் பார்வையாளர்களுக்குப் பதிலளிக்கலாம், நீங்கள் பதில் சொல்லும் கேள்வியை pin செய்யலாம், மற்றும் gifting இலக்கை அமைக்கலாம்."),
    ("என் rating எப்படிக் கணக்கிடப்படுகிறது?",
     "Chat, call மற்றும் video sessions-க்குப் பிறகு பயனர்கள் அளிக்கும் star ratings-இன் சராசரியே உங்கள் rating. தொடர்ச்சியாக உதவிகரமான, சரியான நேரத்தில் நடக்கும் ஆலோசனைகள் உங்கள் rating மற்றும் visibility-ஐ மேம்படுத்தும்."),
    ("என் profile புகைப்படத்தை நான் எப்படிப் புதுப்பிப்பது?",
     "Profile-க்குச் சென்று புதிய புகைப்படத்தைப் பதிவேற்ற உங்கள் avatar-ஐத் தட்டவும். நீங்கள் Google மூலம் sign in செய்திருந்தால், நீங்கள் உங்கள் சொந்த புகைப்படத்தைப் பதிவேற்றும் வரை உங்கள் Google புகைப்படம் தானாகவே பயன்படுத்தப்படும்."),
    ("Support-ஐ நான் எப்படித் தொடர்பு கொள்வது?",
     "Profile → Customer Support-ஐத் திறங்கள். முதலில் FAQ-ஐப் பாருங்கள், அது உதவவில்லை என்றால் Raise Ticket-ஐத் தட்டி விவரங்களை எங்களுக்கு அனுப்புங்கள் (2 screenshots வரை இணைக்கலாம்). நிலை மற்றும் பதில்களை My Tickets-இன் கீழ் கண்காணிக்கலாம்."),
    ("App மொழியை நான் எப்படி மாற்றுவது?",
     "Profile → Language-ஐத் திறந்து உங்களுக்கு விருப்பமான மொழியைத் தேர்ந்தெடுங்கள். App உடனடியாக புதுப்பிக்கப்படும்."),
    ("Privacy, terms மற்றும் refund policies-ஐ நான் எங்கு படிக்கலாம்?",
     "அவை Profile → About & Legal-இல் உள்ளன, இது nakshatralogy.com-இல் உள்ள Privacy Policy, Terms & Conditions மற்றும் Refund Policy-க்கு இணைக்கிறது."),
]

# Hand-authored Telugu translations.
_DEFAULT_FAQ_TE = [
    ("జ్యోతిష్కుడితో సంప్రదింపులు నేను ఎలా ప్రారంభించాలి?",
     "Astrologers ట్యాబ్ తెరిచి, Online లో ఉన్న జ్యోతిష్కుడిని ఎంచుకుని, Chat, Call లేదా Video లో ఒకటి ఎంచుకోండి. ప్రారంభించే ముందు మీ wallet లో కనీసం కొన్ని నిమిషాలకు సరిపడా balance ఉందని నిర్ధారించుకోండి — రేటు ప్రతి జ్యోతిష్కుడి కార్డుపై ముందుగానే చూపబడుతుంది."),
    ("Wallet billing ఎలా పనిచేస్తుంది?",
     "మీరు మీ wallet కు డబ్బు జోడిస్తారు, సంప్రదింపుల ఖర్చు దాని నుండి తీసుకోబడుతుంది. నిమిషానికి సేవల కోసం ప్రారంభంలో కొంత మొత్తం తాత్కాలికంగా block చేయబడుతుంది, సెషన్ ముగిసినప్పుడు ఖచ్చితమైన ఛార్జ్ నిర్ణయించబడుతుంది. ఉపయోగించని block మొత్తం స్వయంచాలకంగా తిరిగి విడుదల చేయబడుతుంది."),
    ("డబ్బు తీసివేయబడింది కానీ సెషన్ ప్రారంభం కాలేదు",
     "సెషన్ ఎప్పుడూ ప్రారంభం కాకపోతే (ఉదా. జ్యోతిష్కుడు స్పందించలేదు), block చేసిన మొత్తం స్వయంచాలకంగా తిరిగి ఇవ్వబడుతుంది. కొన్ని నిమిషాల్లో balance తిరిగి రాకపోతే, తేదీ మరియు సమయంతో సపోర్ట్ టికెట్ లేవనెత్తండి, మేము దాన్ని పరిశీలిస్తాము."),
    ("నేను నా wallet కు డబ్బు ఎలా జోడించాలి?",
     "Wallet ట్యాబ్ కు వెళ్లి Add Money పై ట్యాప్ చేసి, ఒక మొత్తాన్ని ఎంచుకుని చెల్లింపు పూర్తి చేయండి. చెల్లింపు విజయవంతమైన వెంటనే మీ balance తక్షణమే అప్‌డేట్ అవుతుంది."),
    ("నా కాల్ కనెక్ట్ కావడం లేదు",
     "మీ ఇంటర్నెట్ కనెక్షన్‌ని తనిఖీ చేయండి మరియు యాప్‌కు మైక్రోఫోన్, కెమెరా అనుమతులు ఉన్నాయో లేదో చూడండి. వెబ్ యాప్‌లో, బ్రౌజర్ అడిగినప్పుడు మైక్/కెమెరాను అనుమతించండి. జ్యోతిష్కుడు 60 సెకన్లలో స్పందించకపోతే కాల్ స్వయంచాలకంగా రద్దవుతుంది, మీ నుండి ఛార్జ్ తీసుకోబడదు."),
    ("చెడు సంప్రదింపు కోసం నాకు రిఫండ్ వస్తుందా?",
     "సెషన్‌లో నిజమైన సాంకేతిక సమస్య ఉంటే (కాల్ కనెక్ట్ కాలేదు, జ్యోతిష్కుడు స్పందించలేదు), వివరాలతో సపోర్ట్ టికెట్ లేవనెత్తండి, మా బృందం దాన్ని సమీక్షిస్తుంది. మా Refund Policy ని Profile → About & Legal లో చూడండి."),
    ("నాకు నోటిఫికేషన్లు రావడం లేదు",
     "Profile → Notifications తెరిచి అవి ప్రారంభించబడ్డాయో లేదో నిర్ధారించుకోండి. వెబ్ యాప్‌లో, మీ బ్రౌజర్‌లో నోటిఫికేషన్లను అనుమతించండి (iPhone లో ముందుగా యాప్‌ను Home Screen కు జోడించండి). మీరు ఇటీవల లాగ్అవుట్ అయ్యి మళ్లీ లాగిన్ అయి ఉంటే, నోటిఫికేషన్లను ఒకసారి టోగుల్ చేయడం మీ పరికరాన్ని రిఫ్రెష్ చేస్తుంది."),
    ("కుండలి మరియు రిపోర్టులు ఎంత ఖచ్చితమైనవి?",
     "చార్టులు మరియు రిపోర్టులు మీ ఖచ్చితమైన పుట్టిన తేదీ, సమయం మరియు స్థలాన్ని ఉపయోగించి కచ్చితమైన వేద ఖగోళ గణనల నుండి రూపొందించబడతాయి — కాబట్టి ఉత్తమ ఫలితాల కోసం దయచేసి మీ పుట్టిన వివరాలను వీలైనంత ఖచ్చితంగా నమోదు చేయండి."),
    ("Live streams లో gifts మరియు super-chats ఎలా పనిచేస్తాయి?",
     "Live stream సమయంలో మీరు జ్యోతిష్కుడికి gifts లేదా paid super-chat పంపవచ్చు; మొత్తం మీ wallet నుండి తీసివేయబడుతుంది. Super-chats పిన్ చేయబడతాయి కాబట్టి జ్యోతిష్కుడు వాటిని ప్రముఖంగా చూడగలరు."),
    ("నా పుట్టిన వివరాలను నేను ఎలా మార్చాలి?",
     "మీ Kundli/profile తెరిచి, పుట్టిన తేదీ, సమయం మరియు స్థలాన్ని సవరించి సేవ్ చేయండి — మీ చార్టులు మరియు రిపోర్టులు స్వయంచాలకంగా మళ్లీ లెక్కించబడతాయి."),
    ("ఆమోదం పొందడానికి ఎంత సమయం పడుతుంది?",
     "మీ వ్యక్తిగత వివరాలు, వృత్తిపరమైన వివరాలు మరియు KYC పూర్తి చేసిన తర్వాత, మా బృందం మీ దరఖాస్తును సమీక్షిస్తుంది. మీరు ఆమోదించబడినప్పుడు లేదా ఏదైనా సరిదిద్దాల్సి వచ్చినప్పుడు మీకు నోటిఫికేషన్ మరియు ఇమెయిల్ వస్తుంది."),
    ("నా దరఖాస్తు తిరస్కరించబడింది — నేను ఏమి చేయాలి?",
     "యాప్ తెరవండి: ఏ విభాగంలో సరిదిద్దాల్సిన అవసరం ఉందో (KYC, వ్యక్తిగత, లేదా వృత్తిపరమైన వివరాలు) డాష్‌బోర్డ్ ఖచ్చితంగా చూపిస్తుంది. గుర్తించిన విభాగాన్ని సరిదిద్ది మళ్లీ సమర్పించండి — ప్రొఫైల్‌ను సవరించిన వెంటనే అది స్వయంచాలకంగా మళ్లీ సమీక్ష కోసం వెళుతుంది."),
    ("KYC కోసం నాకు ఏ పత్రాలు కావాలి?",
     "స్పష్టమైన, చెల్లుబాటు అయ్యే ప్రభుత్వ గుర్తింపు కార్డును అప్‌లోడ్ చేయండి (అడిగితే ఏదైనా వృత్తిపరమైన సర్టిఫికేట్‌ను కూడా). ఫోటో అస్పష్టంగా లేకుండా, వివరాలు మీ ప్రొఫైల్‌తో సరిపోలుతున్నాయని మరియు పత్రం గడువు ముగియలేదని నిర్ధారించుకోండి."),
    ("నాకు call/chat requests రావడం లేదు",
     "డాష్‌బోర్డ్ టోగుల్ ఉపయోగించి మిమ్మల్ని Online గా సెట్ చేసుకోండి మరియు Profile లో నోటిఫికేషన్లు ప్రారంభించబడ్డాయని నిర్ధారించుకోండి. నమ్మదగిన డెలివరీ కోసం యాప్‌ను తెరిచి ఉంచండి, లేదా వెబ్ యాప్‌ను Home Screen కు ఇన్‌స్టాల్ చేయండి. కొత్త రిక్వెస్ట్‌లు బెల్ ఐకాన్ కింద కూడా కనిపిస్తాయి."),
    ("నాకు ఎలా మరియు ఎప్పుడు చెల్లింపు వస్తుంది?",
     "ప్రతి సంప్రదింపు నుండి మీ ఆదాయం ప్లాట్‌ఫారమ్ కమిషన్ తీసివేసిన తర్వాత మీ wallet కు జమ చేయబడుతుంది. మీరు Wallet స్క్రీన్ నుండి మీ బ్యాంకుకు విత్‌డ్రా చేయవచ్చు; బ్యాంకుకు సెటిల్‌మెంట్ మీ చెల్లింపు ప్రొవైడర్ యొక్క కాలవ్యవధిని అనుసరిస్తుంది."),
    ("నా విత్‌డ్రాయల్ విజయవంతమైంది కానీ మొత్తం నా బ్యాంకులో కనిపించడం లేదు",
     "మీ ప్రొవైడర్‌ను బట్టి బ్యాంక్ సెటిల్‌మెంట్‌కు కొంత సమయం పట్టవచ్చు. మీ wallet లెడ్జర్ డెబిట్‌ని వెంటనే చూపిస్తుంది; అది లెడ్జర్‌లో ప్రతిబింబించకపోతే, రిఫరెన్స్ మరియు సమయంతో సపోర్ట్ టికెట్ లేవనెత్తండి."),
    ("నేను live stream ఎలా ప్రారంభించాలి?",
     "డాష్‌బోర్డ్ నుండి Go Live పై ట్యాప్ చేయండి. వెబ్ యాప్‌లో మీరు మొదట Start Camera ట్యాప్ చేస్తారు (బ్రౌజర్ కెమెరా యాక్సెస్ అడుగుతుంది), తర్వాత Go Live. మీరు వీక్షకులకు స్పందించవచ్చు, మీరు సమాధానం ఇస్తున్న ప్రశ్నను పిన్ చేయవచ్చు మరియు గిఫ్టింగ్ లక్ష్యాన్ని సెట్ చేయవచ్చు."),
    ("నా రేటింగ్ ఎలా లెక్కించబడుతుంది?",
     "Chat, call మరియు video సెషన్ల తర్వాత వినియోగదారులు ఇచ్చే స్టార్ రేటింగ్‌ల సగటే మీ రేటింగ్. స్థిరంగా సహాయకరమైన, సమయపాలన గల సంప్రదింపులు మీ రేటింగ్ మరియు విజిబిలిటీని మెరుగుపరుస్తాయి."),
    ("నా ప్రొఫైల్ ఫోటోను నేను ఎలా అప్‌డేట్ చేయాలి?",
     "Profile కు వెళ్లి కొత్త ఫోటోను అప్‌లోడ్ చేయడానికి మీ అవతార్‌పై ట్యాప్ చేయండి. మీరు Google తో సైన్ ఇన్ చేసి ఉంటే, మీరు మీ స్వంత ఫోటోను అప్‌లోడ్ చేసే వరకు మీ Google ఫోటో స్వయంచాలకంగా ఉపయోగించబడుతుంది."),
    ("నేను సపోర్ట్‌ను ఎలా సంప్రదించాలి?",
     "Profile → Customer Support తెరవండి. ముందుగా FAQ చూడండి, అది సహాయపడకపోతే వివరాలను మాకు పంపడానికి Raise Ticket పై ట్యాప్ చేయండి (మీరు 2 స్క్రీన్‌షాట్‌ల వరకు జోడించవచ్చు). స్థితి మరియు రిప్లైలను My Tickets కింద ట్రాక్ చేయవచ్చు."),
    ("యాప్ భాషను నేను ఎలా మార్చాలి?",
     "Profile → Language తెరిచి మీకు నచ్చిన భాషను ఎంచుకోండి. యాప్ వెంటనే అప్‌డేట్ అవుతుంది."),
    ("గోప్యత, నిబంధనలు మరియు రిఫండ్ విధానాలను నేను ఎక్కడ చదవగలను?",
     "అవి Profile → About & Legal లో ఉన్నాయి, ఇది nakshatralogy.com లో Privacy Policy, Terms & Conditions మరియు Refund Policy కు లింక్ చేస్తుంది."),
]

# Hand-authored Kannada translations.
_DEFAULT_FAQ_KN = [
    ("ಜ್ಯೋತಿಷಿಯೊಂದಿಗೆ ಸಮಾಲೋಚನೆ ಪ್ರಾರಂಭಿಸುವುದು ಹೇಗೆ?",
     "Astrologers ಟ್ಯಾಬ್ ತೆರೆಯಿರಿ, Online ಇರುವ ಜ್ಯೋತಿಷಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ, ಮತ್ತು Chat, Call ಅಥವಾ Video ಆಯ್ಕೆಮಾಡಿ. ಪ್ರಾರಂಭಿಸುವ ಮೊದಲು ನಿಮ್ಮ wallet ನಲ್ಲಿ ಕನಿಷ್ಠ ಕೆಲವು ನಿಮಿಷಗಳಿಗೆ ಸಾಕಷ್ಟು balance ಇದೆ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ — ದರವನ್ನು ಪ್ರತಿ ಜ್ಯೋತಿಷಿಯ ಕಾರ್ಡ್‌ನಲ್ಲಿ ಮೊದಲೇ ತೋರಿಸಲಾಗುತ್ತದೆ."),
    ("Wallet billing ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತದೆ?",
     "ನೀವು ನಿಮ್ಮ wallet ಗೆ ಹಣ ಸೇರಿಸುತ್ತೀರಿ, ಮತ್ತು ಸಮಾಲೋಚನೆಗಳ ಶುಲ್ಕವನ್ನು ಅದರಿಂದ ಕಡಿತಗೊಳಿಸಲಾಗುತ್ತದೆ. ನಿಮಿಷಕ್ಕೊಂದು ಸೇವೆಗಳಿಗೆ ಪ್ರಾರಂಭದಲ್ಲಿ ಒಂದು ಮೊತ್ತವನ್ನು ತಾತ್ಕಾಲಿಕವಾಗಿ block ಮಾಡಲಾಗುತ್ತದೆ ಮತ್ತು session ಮುಗಿದಾಗ ನಿಖರವಾದ ಶುಲ್ಕವನ್ನು ನಿರ್ಧರಿಸಲಾಗುತ್ತದೆ. ಬಳಸದ block ಮೊತ್ತವನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಹಿಂತಿರುಗಿಸಲಾಗುತ್ತದೆ."),
    ("ಹಣ ಕಡಿತವಾಯಿತು ಆದರೆ session ಪ್ರಾರಂಭವಾಗಲಿಲ್ಲ",
     "Session ಎಂದಿಗೂ ಪ್ರಾರಂಭವಾಗದಿದ್ದರೆ (ಉದಾ. ಜ್ಯೋತಿಷಿ ಉತ್ತರಿಸಲಿಲ್ಲ), block ಮಾಡಿದ ಮೊತ್ತವನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಹಿಂತಿರುಗಿಸಲಾಗುತ್ತದೆ. ಕೆಲವು ನಿಮಿಷಗಳಲ್ಲಿ balance ಹಿಂತಿರುಗದಿದ್ದರೆ, ದಿನಾಂಕ ಮತ್ತು ಸಮಯದೊಂದಿಗೆ support ticket ಎತ್ತಿ, ನಾವು ಪರಿಶೀಲಿಸುತ್ತೇವೆ."),
    ("ನನ್ನ wallet ಗೆ ಹಣ ಸೇರಿಸುವುದು ಹೇಗೆ?",
     "Wallet ಟ್ಯಾಬ್‌ಗೆ ಹೋಗಿ Add Money ಟ್ಯಾಪ್ ಮಾಡಿ, ಒಂದು ಮೊತ್ತವನ್ನು ಆಯ್ಕೆಮಾಡಿ ಮತ್ತು ಪಾವತಿ ಪೂರ್ಣಗೊಳಿಸಿ. ಪಾವತಿ ಯಶಸ್ವಿಯಾದ ತಕ್ಷಣ ನಿಮ್ಮ balance ತಕ್ಷಣ ನವೀಕರಿಸಲ್ಪಡುತ್ತದೆ."),
    ("ನನ್ನ ಕರೆ ಸಂಪರ್ಕಗೊಳ್ಳುತ್ತಿಲ್ಲ",
     "ನಿಮ್ಮ ಇಂಟರ್ನೆಟ್ ಸಂಪರ್ಕವನ್ನು ಪರಿಶೀಲಿಸಿ ಮತ್ತು app ಗೆ microphone ಮತ್ತು camera ಅನುಮತಿ ಇದೆಯೇ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ. Web app ನಲ್ಲಿ, browser ಕೇಳಿದಾಗ mic/camera ಅನುಮತಿಸಿ. ಜ್ಯೋತಿಷಿ 60 ಸೆಕೆಂಡುಗಳಲ್ಲಿ ಉತ್ತರಿಸದಿದ್ದರೆ ಕರೆ ಸ್ವಯಂಚಾಲಿತವಾಗಿ ರದ್ದಾಗುತ್ತದೆ ಮತ್ತು ನಿಮಗೆ ಶುಲ್ಕ ವಿಧಿಸಲಾಗುವುದಿಲ್ಲ."),
    ("ಕೆಟ್ಟ ಸಮಾಲೋಚನೆಗೆ ನನಗೆ refund ಸಿಗಬಹುದೇ?",
     "Session ನಲ್ಲಿ ನಿಜವಾದ ತಾಂತ್ರಿಕ ಸಮಸ್ಯೆ ಇದ್ದರೆ (ಕರೆ ಸಂಪರ್ಕಗೊಳ್ಳಲಿಲ್ಲ, ಜ್ಯೋತಿಷಿ ಪ್ರತಿಕ್ರಿಯಿಸಲಿಲ್ಲ), ವಿವರಗಳೊಂದಿಗೆ support ticket ಎತ್ತಿ, ನಮ್ಮ ತಂಡ ಅದನ್ನು ಪರಿಶೀಲಿಸುತ್ತದೆ. ನಮ್ಮ Refund Policy ಅನ್ನು Profile → About & Legal ನಲ್ಲಿ ನೋಡಿ."),
    ("ನನಗೆ notifications ಬರುತ್ತಿಲ್ಲ",
     "Profile → Notifications ತೆರೆದು ಅವು ಸಕ್ರಿಯವಾಗಿವೆ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ. Web app ನಲ್ಲಿ, ನಿಮ್ಮ browser ನಲ್ಲಿ notifications ಅನುಮತಿಸಿ (iPhone ನಲ್ಲಿ ಮೊದಲು app ಅನ್ನು Home Screen ಗೆ ಸೇರಿಸಿ). ನೀವು ಇತ್ತೀಚೆಗೆ logout ಮಾಡಿ ಮತ್ತೆ login ಮಾಡಿದ್ದರೆ, notifications ಅನ್ನು ಒಮ್ಮೆ toggle ಮಾಡುವುದು ನಿಮ್ಮ ಸಾಧನವನ್ನು ರಿಫ್ರೆಶ್ ಮಾಡುತ್ತದೆ."),
    ("ಕುಂಡಲಿ ಮತ್ತು ವರದಿಗಳು ಎಷ್ಟು ನಿಖರವಾಗಿವೆ?",
     "Charts ಮತ್ತು reports ಗಳನ್ನು ನಿಮ್ಮ ನಿಖರವಾದ ಜನ್ಮ ದಿನಾಂಕ, ಸಮಯ ಮತ್ತು ಸ್ಥಳವನ್ನು ಬಳಸಿ ನಿಖರವಾದ ವೈದಿಕ ಖಗೋಳ ಲೆಕ್ಕಾಚಾರಗಳಿಂದ ರಚಿಸಲಾಗುತ್ತದೆ — ಆದ್ದರಿಂದ ಉತ್ತಮ ಫಲಿತಾಂಶಗಳಿಗಾಗಿ ದಯವಿಟ್ಟು ನಿಮ್ಮ ಜನ್ಮ ವಿವರಗಳನ್ನು ಸಾಧ್ಯವಾದಷ್ಟು ನಿಖರವಾಗಿ ನಮೂದಿಸಿ."),
    ("Live streams ನಲ್ಲಿ gifts ಮತ್ತು super-chats ಹೇಗೆ ಕೆಲಸ ಮಾಡುತ್ತವೆ?",
     "Live stream ಸಮಯದಲ್ಲಿ ನೀವು ಜ್ಯೋತಿಷಿಗೆ gifts ಅಥವಾ paid super-chat ಕಳುಹಿಸಬಹುದು; ಮೊತ್ತವನ್ನು ನಿಮ್ಮ wallet ನಿಂದ ಕಡಿತಗೊಳಿಸಲಾಗುತ್ತದೆ. Super-chats ಅನ್ನು pin ಮಾಡಲಾಗುತ್ತದೆ ಆದ್ದರಿಂದ ಜ್ಯೋತಿಷಿ ಅವುಗಳನ್ನು ಎದ್ದುಕಾಣುವಂತೆ ನೋಡುತ್ತಾರೆ."),
    ("ನನ್ನ ಜನ್ಮ ವಿವರಗಳನ್ನು ನಾನು ಹೇಗೆ ಬದಲಾಯಿಸುವುದು?",
     "ನಿಮ್ಮ Kundli/profile ತೆರೆಯಿರಿ, ಜನ್ಮ ದಿನಾಂಕ, ಸಮಯ ಮತ್ತು ಸ್ಥಳವನ್ನು ಸಂಪಾದಿಸಿ ಉಳಿಸಿ — ನಿಮ್ಮ charts ಮತ್ತು reports ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಮರುಲೆಕ್ಕಾಚಾರಗೊಳ್ಳುತ್ತವೆ."),
    ("ಅನುಮೋದನೆ ಪಡೆಯಲು ಎಷ್ಟು ಸಮಯ ಬೇಕು?",
     "ನಿಮ್ಮ ವೈಯಕ್ತಿಕ ವಿವರಗಳು, ವೃತ್ತಿಪರ ವಿವರಗಳು ಮತ್ತು KYC ಪೂರ್ಣಗೊಳಿಸಿದ ನಂತರ, ನಮ್ಮ ತಂಡ ನಿಮ್ಮ ಅರ್ಜಿಯನ್ನು ಪರಿಶೀಲಿಸುತ್ತದೆ. ನೀವು ಅನುಮೋದನೆ ಪಡೆದಾಗ ಅಥವಾ ಏನಾದರೂ ತಿದ್ದುಪಡಿ ಅಗತ್ಯವಿದ್ದಾಗ ನಿಮಗೆ notification ಮತ್ತು email ಬರುತ್ತದೆ."),
    ("ನನ್ನ ಅರ್ಜಿ ತಿರಸ್ಕರಿಸಲ್ಪಟ್ಟಿದೆ — ನಾನು ಏನು ಮಾಡಬೇಕು?",
     "App ತೆರೆಯಿರಿ: ಯಾವ ವಿಭಾಗದಲ್ಲಿ ತಿದ್ದುಪಡಿ ಬೇಕು (KYC, ವೈಯಕ್ತಿಕ, ಅಥವಾ ವೃತ್ತಿಪರ ವಿವರಗಳು) ಎಂಬುದನ್ನು dashboard ನಿಖರವಾಗಿ ತೋರಿಸುತ್ತದೆ. ಗುರುತಿಸಿದ ವಿಭಾಗವನ್ನು ಸರಿಪಡಿಸಿ ಮತ್ತೆ ಸಲ್ಲಿಸಿ — profile ಸಂಪಾದಿಸಿದ ತಕ್ಷಣ ಅದು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಮರುಪರಿಶೀಲನೆಗೆ ಹೋಗುತ್ತದೆ."),
    ("KYC ಗಾಗಿ ನನಗೆ ಯಾವ ದಾಖಲೆಗಳು ಬೇಕು?",
     "ಸ್ಪಷ್ಟ, ಮಾನ್ಯವಾದ ಸರ್ಕಾರಿ ಗುರುತಿನ ಚೀಟಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ (ಕೇಳಿದರೆ ಯಾವುದೇ ವೃತ್ತಿಪರ ಪ್ರಮಾಣಪತ್ರವನ್ನೂ ಸಹ). ಫೋಟೋ ಮಂಜಾಗಿಲ್ಲ, ವಿವರಗಳು ನಿಮ್ಮ profile ಗೆ ಹೊಂದಿಕೆಯಾಗುತ್ತವೆ ಮತ್ತು ದಾಖಲೆಯ ಅವಧಿ ಮುಗಿದಿಲ್ಲ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ."),
    ("ನನಗೆ call/chat requests ಬರುತ್ತಿಲ್ಲ",
     "Dashboard toggle ಬಳಸಿ ನಿಮ್ಮನ್ನು Online ಎಂದು ಹೊಂದಿಸಿ ಮತ್ತು Profile ನಲ್ಲಿ notifications ಸಕ್ರಿಯವಾಗಿವೆ ಎಂದು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳಿ. ವಿಶ್ವಾಸಾರ್ಹ ಡೆಲಿವರಿಗಾಗಿ app ಅನ್ನು ತೆರೆದಿಡಿ, ಅಥವಾ web app ಅನ್ನು Home Screen ಗೆ install ಮಾಡಿ. ಹೊಸ requests ಬೆಲ್ ಐಕಾನ್ ಅಡಿಯಲ್ಲಿಯೂ ಕಾಣಿಸುತ್ತವೆ."),
    ("ನನಗೆ ಹೇಗೆ ಮತ್ತು ಯಾವಾಗ ಪಾವತಿ ಸಿಗುತ್ತದೆ?",
     "ಪ್ರತಿ ಸಮಾಲೋಚನೆಯಿಂದ ನಿಮ್ಮ ಗಳಿಕೆಯನ್ನು ಪ್ಲಾಟ್‌ಫಾರ್ಮ್ ಕಮಿಷನ್ ಕಡಿತಗೊಳಿಸಿದ ನಂತರ ನಿಮ್ಮ wallet ಗೆ ಜಮಾ ಮಾಡಲಾಗುತ್ತದೆ. Wallet ಪರದೆಯಿಂದ ನೀವು ನಿಮ್ಮ ಬ್ಯಾಂಕ್‌ಗೆ withdraw ಮಾಡಬಹುದು; ಬ್ಯಾಂಕ್‌ಗೆ settlement ನಿಮ್ಮ payment provider ನ ಕಾಲಮಿತಿಯನ್ನು ಅನುಸರಿಸುತ್ತದೆ."),
    ("ನನ್ನ withdrawal ಯಶಸ್ವಿಯಾಗಿದೆ ಆದರೆ ಮೊತ್ತ ನನ್ನ ಬ್ಯಾಂಕ್‌ನಲ್ಲಿ ಕಾಣಿಸುತ್ತಿಲ್ಲ",
     "ನಿಮ್ಮ provider ಅನ್ನು ಅವಲಂಬಿಸಿ ಬ್ಯಾಂಕ್ settlement ಸ್ವಲ್ಪ ಸಮಯ ತೆಗೆದುಕೊಳ್ಳಬಹುದು. ನಿಮ್ಮ wallet ledger debit ಅನ್ನು ತಕ್ಷಣ ತೋರಿಸುತ್ತದೆ; ಅದು ledger ನಲ್ಲಿ ಪ್ರತಿಫಲಿಸದಿದ್ದರೆ, reference ಮತ್ತು ಸಮಯದೊಂದಿಗೆ support ticket ಎತ್ತಿ."),
    ("ನಾನು live stream ಹೇಗೆ ಪ್ರಾರಂಭಿಸುವುದು?",
     "Dashboard ನಿಂದ Go Live ಟ್ಯಾಪ್ ಮಾಡಿ. Web app ನಲ್ಲಿ ನೀವು ಮೊದಲು Start Camera ಟ್ಯಾಪ್ ಮಾಡುತ್ತೀರಿ (browser camera ಪ್ರವೇಶ ಕೇಳುತ್ತದೆ), ನಂತರ Go Live. ನೀವು ವೀಕ್ಷಕರಿಗೆ ಪ್ರತಿಕ್ರಿಯಿಸಬಹುದು, ನೀವು ಉತ್ತರಿಸುತ್ತಿರುವ ಪ್ರಶ್ನೆಯನ್ನು pin ಮಾಡಬಹುದು, ಮತ್ತು ಗಿಫ್ಟಿಂಗ್ ಗುರಿಯನ್ನು ಹೊಂದಿಸಬಹುದು."),
    ("ನನ್ನ rating ಹೇಗೆ ಲೆಕ್ಕಹಾಕಲಾಗುತ್ತದೆ?",
     "Chat, call ಮತ್ತು video sessions ನಂತರ ಬಳಕೆದಾರರು ನೀಡುವ star ratings ನ ಸರಾಸರಿಯೇ ನಿಮ್ಮ rating. ಸ್ಥಿರವಾಗಿ ಸಹಾಯಕವಾದ, ಸಮಯಪಾಲನೆಯ ಸಮಾಲೋಚನೆಗಳು ನಿಮ್ಮ rating ಮತ್ತು visibility ಅನ್ನು ಸುಧಾರಿಸುತ್ತವೆ."),
    ("ನನ್ನ profile ಫೋಟೋವನ್ನು ನಾನು ಹೇಗೆ ನವೀಕರಿಸುವುದು?",
     "Profile ಗೆ ಹೋಗಿ ಹೊಸ ಫೋಟೋವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ನಿಮ್ಮ avatar ಅನ್ನು ಟ್ಯಾಪ್ ಮಾಡಿ. ನೀವು Google ನೊಂದಿಗೆ sign in ಮಾಡಿದ್ದರೆ, ನೀವು ನಿಮ್ಮ ಸ್ವಂತ ಫೋಟೋವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡುವವರೆಗೆ ನಿಮ್ಮ Google ಫೋಟೋವನ್ನು ಸ್ವಯಂಚಾಲಿತವಾಗಿ ಬಳಸಲಾಗುತ್ತದೆ."),
    ("ನಾನು support ಅನ್ನು ಹೇಗೆ ಸಂಪರ್ಕಿಸುವುದು?",
     "Profile → Customer Support ತೆರೆಯಿರಿ. ಮೊದಲು FAQ ಅನ್ನು ಪರಿಶೀಲಿಸಿ, ಅದು ಸಹಾಯ ಮಾಡದಿದ್ದರೆ ವಿವರಗಳನ್ನು ನಮಗೆ ಕಳುಹಿಸಲು Raise Ticket ಟ್ಯಾಪ್ ಮಾಡಿ (ನೀವು 2 ಸ್ಕ್ರೀನ್‌ಶಾಟ್‌ಗಳವರೆಗೆ ಲಗತ್ತಿಸಬಹುದು). ಸ್ಥಿತಿ ಮತ್ತು ಪ್ರತ್ಯುತ್ತರಗಳನ್ನು My Tickets ಅಡಿಯಲ್ಲಿ ಟ್ರ್ಯಾಕ್ ಮಾಡಬಹುದು."),
    ("App ಭಾಷೆಯನ್ನು ನಾನು ಹೇಗೆ ಬದಲಾಯಿಸುವುದು?",
     "Profile → Language ತೆರೆದು ನಿಮ್ಮ ಆದ್ಯತೆಯ ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ. App ತಕ್ಷಣ ನವೀಕರಿಸಲ್ಪಡುತ್ತದೆ."),
    ("ಗೌಪ್ಯತೆ, ನಿಯಮಗಳು ಮತ್ತು ಮರುಪಾವತಿ ನೀತಿಗಳನ್ನು ನಾನು ಎಲ್ಲಿ ಓದಬಹುದು?",
     "ಅವು Profile → About & Legal ನಲ್ಲಿ ಇವೆ, ಇದು nakshatralogy.com ನಲ್ಲಿ Privacy Policy, Terms & Conditions ಮತ್ತು Refund Policy ಗೆ ಲಿಂಕ್ ಮಾಡುತ್ತದೆ."),
]

# Hand-authored Malayalam translations.
_DEFAULT_FAQ_ML = [
    ("ജ്യോതിഷിയുമായി കൺസൾട്ടേഷൻ എങ്ങനെ തുടങ്ങാം?",
     "Astrologers ടാബ് തുറന്ന്, Online ആയിരിക്കുന്ന ഒരു ജ്യോതിഷിയെ തിരഞ്ഞെടുത്ത്, Chat, Call അല്ലെങ്കിൽ Video എന്നിവയിൽ ഒന്ന് തിരഞ്ഞെടുക്കുക. തുടങ്ങുന്നതിന് മുൻപ് നിങ്ങളുടെ wallet ൽ കുറഞ്ഞത് കുറച്ച് മിനിറ്റുകൾക്കെങ്കിലും മതിയായ balance ഉണ്ടെന്ന് ഉറപ്പാക്കുക — നിരക്ക് ഓരോ ജ്യോതിഷിയുടെയും കാർഡിൽ മുൻകൂട്ടി കാണിക്കും."),
    ("Wallet billing എങ്ങനെ പ്രവർത്തിക്കുന്നു?",
     "നിങ്ങൾ നിങ്ങളുടെ wallet ലേക്ക് പണം ചേർക്കുന്നു, കൺസൾട്ടേഷനുകൾക്കുള്ള ചാർജ് അതിൽ നിന്നാണ് ഈടാക്കുന്നത്. മിനിറ്റ് അടിസ്ഥാനത്തിലുള്ള സേവനങ്ങൾക്ക് തുടക്കത്തിൽ ഒരു തുക താൽക്കാലികമായി block ചെയ്യപ്പെടും, സെഷൻ അവസാനിക്കുമ്പോൾ കൃത്യമായ ചാർജ് നിശ്ചയിക്കപ്പെടും. ഉപയോഗിക്കാത്ത block തുക സ്വയമേവ തിരികെ നൽകും."),
    ("പണം കുറഞ്ഞു പക്ഷേ സെഷൻ തുടങ്ങിയില്ല",
     "സെഷൻ ഒരിക്കലും ആരംഭിക്കാതിരുന്നാൽ (ഉദാ. ജ്യോതിഷി മറുപടി നൽകിയില്ല), block ചെയ്ത തുക സ്വയമേവ തിരികെ നൽകും. കുറച്ച് മിനിറ്റുകൾക്കുള്ളിൽ balance തിരികെ വന്നില്ലെങ്കിൽ, തീയതിയും സമയവും സഹിതം ഒരു സപ്പോർട്ട് ടിക്കറ്റ് ഉയർത്തുക, ഞങ്ങൾ അത് പരിശോധിക്കും."),
    ("എന്റെ wallet ലേക്ക് പണം എങ്ങനെ ചേർക്കാം?",
     "Wallet ടാബിലേക്ക് പോയി Add Money ടാപ്പ് ചെയ്ത്, ഒരു തുക തിരഞ്ഞെടുത്ത് പേയ്‌മെന്റ് പൂർത്തിയാക്കുക. പേയ്‌മെന്റ് വിജയിച്ചാൽ ഉടൻ നിങ്ങളുടെ balance അപ്‌ഡേറ്റ് ആകും."),
    ("എന്റെ കോൾ കണക്ട് ആകുന്നില്ല",
     "നിങ്ങളുടെ ഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിക്കുകയും ആപ്പിന് microphone, camera അനുമതികൾ ഉണ്ടോ എന്ന് ഉറപ്പാക്കുകയും ചെയ്യുക. Web app ൽ, ബ്രൗസർ ചോദിക്കുമ്പോൾ mic/camera അനുവദിക്കുക. ജ്യോതിഷി 60 സെക്കൻഡിനുള്ളിൽ മറുപടി നൽകിയില്ലെങ്കിൽ കോൾ സ്വയമേവ റദ്ദാകും, നിങ്ങളിൽ നിന്ന് ചാർജ് ഈടാക്കില്ല."),
    ("മോശം കൺസൾട്ടേഷന് എനിക്ക് റീഫണ്ട് ലഭിക്കുമോ?",
     "സെഷനിൽ യഥാർത്ഥ സാങ്കേതിക പ്രശ്നം ഉണ്ടായിരുന്നെങ്കിൽ (കോൾ കണക്ട് ആയില്ല, ജ്യോതിഷി പ്രതികരിച്ചില്ല), വിശദാംശങ്ങളോടെ ഒരു സപ്പോർട്ട് ടിക്കറ്റ് ഉയർത്തുക, ഞങ്ങളുടെ ടീം അത് അവലോകനം ചെയ്യും. ഞങ്ങളുടെ Refund Policy Profile → About & Legal ൽ കാണുക."),
    ("എനിക്ക് നോട്ടിഫിക്കേഷനുകൾ ലഭിക്കുന്നില്ല",
     "Profile → Notifications തുറന്ന് അവ പ്രവർത്തനക്ഷമമാണെന്ന് ഉറപ്പാക്കുക. Web app ൽ, നിങ്ങളുടെ ബ്രൗസറിൽ നോട്ടിഫിക്കേഷനുകൾ അനുവദിക്കുക (iPhone ൽ ആദ്യം ആപ്പ് Home Screen ലേക്ക് ചേർക്കുക). നിങ്ങൾ അടുത്തിടെ ലോഗൗട്ട് ചെയ്ത് വീണ്ടും ലോഗിൻ ചെയ്തിട്ടുണ്ടെങ്കിൽ, നോട്ടിഫിക്കേഷനുകൾ ഒരിക്കൽ ടോഗിൾ ചെയ്യുന്നത് നിങ്ങളുടെ ഉപകരണം റിഫ്രഷ് ചെയ്യും."),
    ("കുണ്ഡലിയും റിപ്പോർട്ടുകളും എത്ര കൃത്യമാണ്?",
     "ചാർട്ടുകളും റിപ്പോർട്ടുകളും നിങ്ങളുടെ കൃത്യമായ ജനന തീയതി, സമയം, സ്ഥലം എന്നിവ ഉപയോഗിച്ച് കൃത്യമായ വൈദിക ജ്യോതിശാസ്ത്ര കണക്കുകൂട്ടലുകളിൽ നിന്നാണ് ഉണ്ടാക്കുന്നത് — അതിനാൽ മികച്ച ഫലങ്ങൾക്കായി നിങ്ങളുടെ ജനന വിവരങ്ങൾ കഴിയുന്നത്ര കൃത്യമായി നൽകുക."),
    ("Live streams ൽ gifts ഉം super-chats ഉം എങ്ങനെ പ്രവർത്തിക്കുന്നു?",
     "Live stream സമയത്ത് നിങ്ങൾക്ക് ജ്യോതിഷിക്ക് gifts അല്ലെങ്കിൽ paid super-chat അയക്കാം; തുക നിങ്ങളുടെ wallet ൽ നിന്ന് കുറയ്ക്കും. Super-chats പിൻ ചെയ്യപ്പെടും, അതിനാൽ ജ്യോതിഷിക്ക് അവ പ്രാധാന്യത്തോടെ കാണാം."),
    ("എന്റെ ജനന വിവരങ്ങൾ ഞാൻ എങ്ങനെ മാറ്റാം?",
     "നിങ്ങളുടെ Kundli/profile തുറന്ന്, ജനന തീയതി, സമയം, സ്ഥലം എന്നിവ എഡിറ്റ് ചെയ്ത് സേവ് ചെയ്യുക — നിങ്ങളുടെ ചാർട്ടുകളും റിപ്പോർട്ടുകളും സ്വയമേവ വീണ്ടും കണക്കാക്കപ്പെടും."),
    ("അപ്രൂവൽ ലഭിക്കാൻ എത്ര സമയമെടുക്കും?",
     "നിങ്ങളുടെ വ്യക്തിഗത വിവരങ്ങൾ, പ്രൊഫഷണൽ വിവരങ്ങൾ, KYC എന്നിവ പൂർത്തിയാക്കിയ ശേഷം, ഞങ്ങളുടെ ടീം നിങ്ങളുടെ അപേക്ഷ അവലോകനം ചെയ്യും. നിങ്ങൾ അംഗീകരിക്കപ്പെടുമ്പോൾ അല്ലെങ്കിൽ എന്തെങ്കിലും തിരുത്തൽ ആവശ്യമുള്ളപ്പോൾ നിങ്ങൾക്ക് അറിയിപ്പും ഇമെയിലും ലഭിക്കും."),
    ("എന്റെ അപേക്ഷ നിരസിക്കപ്പെട്ടു — ഞാൻ എന്ത് ചെയ്യണം?",
     "ആപ്പ് തുറക്കുക: ഏത് വിഭാഗത്തിലാണ് തിരുത്തൽ വേണ്ടത് (KYC, വ്യക്തിഗതം, അല്ലെങ്കിൽ പ്രൊഫഷണൽ വിവരങ്ങൾ) എന്ന് ഡാഷ്ബോർഡ് കൃത്യമായി കാണിക്കുന്നു. അടയാളപ്പെടുത്തിയ വിഭാഗം ശരിയാക്കി വീണ്ടും സമർപ്പിക്കുക — പ്രൊഫൈൽ എഡിറ്റ് ചെയ്യുന്ന ഉടൻ അത് സ്വയമേവ വീണ്ടും അവലോകനത്തിന് പോകും."),
    ("KYC ക്ക് എനിക്ക് എന്തൊക്കെ രേഖകൾ വേണം?",
     "വ്യക്തവും സാധുതയുള്ളതുമായ ഒരു സർക്കാർ ഐഡി അപ്‌ലോഡ് ചെയ്യുക (ആവശ്യപ്പെട്ടാൽ ഏതെങ്കിലും പ്രൊഫഷണൽ സർട്ടിഫിക്കറ്റും). ഫോട്ടോ മങ്ങിയതല്ലെന്നും, വിവരങ്ങൾ നിങ്ങളുടെ പ്രൊഫൈലുമായി പൊരുത്തപ്പെടുന്നുവെന്നും, രേഖയുടെ കാലാവധി കഴിഞ്ഞിട്ടില്ലെന്നും ഉറപ്പാക്കുക."),
    ("എനിക്ക് call/chat requests ലഭിക്കുന്നില്ല",
     "ഡാഷ്ബോർഡ് ടോഗിൾ ഉപയോഗിച്ച് നിങ്ങളെ Online ആയി സെറ്റ് ചെയ്യുകയും Profile ൽ നോട്ടിഫിക്കേഷനുകൾ പ്രവർത്തനക്ഷമമാണെന്ന് ഉറപ്പാക്കുകയും ചെയ്യുക. വിശ്വസനീയമായ ഡെലിവറിക്ക് ആപ്പ് തുറന്നിടുക, അല്ലെങ്കിൽ web app നിങ്ങളുടെ Home Screen ൽ ഇൻസ്റ്റാൾ ചെയ്യുക. പുതിയ requests ബെൽ ഐക്കണിന് താഴെയും കാണാം."),
    ("എനിക്ക് എങ്ങനെ, എപ്പോൾ പേയ്‌മെന്റ് ലഭിക്കും?",
     "ഓരോ കൺസൾട്ടേഷനിൽ നിന്നുമുള്ള നിങ്ങളുടെ വരുമാനം പ്ലാറ്റ്ഫോം കമ്മീഷൻ കുറച്ചതിന് ശേഷം നിങ്ങളുടെ wallet ലേക്ക് ക്രെഡിറ്റ് ചെയ്യും. Wallet സ്ക്രീനിൽ നിന്ന് നിങ്ങളുടെ ബാങ്കിലേക്ക് withdraw ചെയ്യാം; ബാങ്കിലേക്കുള്ള സെറ്റിൽമെന്റ് നിങ്ങളുടെ പേയ്‌മെന്റ് പ്രൊവൈഡറുടെ സമയക്രമം അനുസരിച്ചാണ്."),
    ("എന്റെ withdrawal വിജയകരമായി, പക്ഷേ തുക എന്റെ ബാങ്കിൽ കാണുന്നില്ല",
     "നിങ്ങളുടെ പ്രൊവൈഡറെ ആശ്രയിച്ച് ബാങ്ക് സെറ്റിൽമെന്റിന് കുറച്ച് സമയമെടുക്കാം. നിങ്ങളുടെ wallet ledger ഡെബിറ്റ് ഉടനടി കാണിക്കും; ledger ൽ അത് പ്രതിഫലിക്കുന്നില്ലെങ്കിൽ, റഫറൻസും സമയവും സഹിതം ഒരു സപ്പോർട്ട് ടിക്കറ്റ് ഉയർത്തുക."),
    ("ഞാൻ എങ്ങനെ ലൈവ് സ്ട്രീം തുടങ്ങാം?",
     "ഡാഷ്ബോർഡിൽ നിന്ന് Go Live ടാപ്പ് ചെയ്യുക. Web app ൽ നിങ്ങൾ ആദ്യം Start Camera ടാപ്പ് ചെയ്യും (ബ്രൗസർ ക്യാമറ ആക്‌സസ് ചോദിക്കും), പിന്നീട് Go Live. നിങ്ങൾക്ക് കാഴ്ചക്കാർക്ക് മറുപടി നൽകാം, നിങ്ങൾ ഉത്തരം നൽകുന്ന ചോദ്യം പിൻ ചെയ്യാം, ഗിഫ്റ്റിംഗ് ലക്ഷ്യം സെറ്റ് ചെയ്യാം."),
    ("എന്റെ റേറ്റിംഗ് എങ്ങനെ കണക്കാക്കുന്നു?",
     "Chat, call, video സെഷനുകൾക്ക് ശേഷം ഉപയോക്താക്കൾ നൽകുന്ന സ്റ്റാർ റേറ്റിംഗുകളുടെ ശരാശരിയാണ് നിങ്ങളുടെ റേറ്റിംഗ്. സ്ഥിരമായി സഹായകരവും കൃത്യസമയത്തുള്ളതുമായ കൺസൾട്ടേഷനുകൾ നിങ്ങളുടെ റേറ്റിംഗും ദൃശ്യതയും മെച്ചപ്പെടുത്തുന്നു."),
    ("എന്റെ പ്രൊഫൈൽ ഫോട്ടോ ഞാൻ എങ്ങനെ അപ്‌ഡേറ്റ് ചെയ്യാം?",
     "Profile ലേക്ക് പോയി പുതിയ ഫോട്ടോ അപ്‌ലോഡ് ചെയ്യാൻ നിങ്ങളുടെ അവതാറിൽ ടാപ്പ് ചെയ്യുക. നിങ്ങൾ Google ഉപയോഗിച്ച് സൈൻ ഇൻ ചെയ്തിട്ടുണ്ടെങ്കിൽ, നിങ്ങൾ സ്വന്തം ഫോട്ടോ അപ്‌ലോഡ് ചെയ്യുന്നത് വരെ നിങ്ങളുടെ Google ഫോട്ടോ സ്വയമേവ ഉപയോഗിക്കപ്പെടും."),
    ("ഞാൻ എങ്ങനെ സപ്പോർട്ടിനെ ബന്ധപ്പെടാം?",
     "Profile → Customer Support തുറക്കുക. ആദ്യം FAQ പരിശോധിക്കുക, അത് സഹായകമല്ലെങ്കിൽ വിശദാംശങ്ങൾ ഞങ്ങൾക്ക് അയക്കാൻ Raise Ticket ടാപ്പ് ചെയ്യുക (2 സ്ക്രീൻഷോട്ടുകൾ വരെ അറ്റാച്ച് ചെയ്യാം). സ്റ്റാറ്റസും മറുപടികളും My Tickets ൽ ട്രാക്ക് ചെയ്യാം."),
    ("ആപ്പ് ഭാഷ ഞാൻ എങ്ങനെ മാറ്റാം?",
     "Profile → Language തുറന്ന് നിങ്ങൾക്ക് ഇഷ്ടമുള്ള ഭാഷ തിരഞ്ഞെടുക്കുക. ആപ്പ് ഉടനടി അപ്‌ഡേറ്റ് ആകും."),
    ("സ്വകാര്യത, നിബന്ധനകൾ, റീഫണ്ട് നയങ്ങൾ എവിടെ വായിക്കാം?",
     "അവ Profile → About & Legal ൽ ഉണ്ട്, അത് nakshatralogy.com ലെ Privacy Policy, Terms & Conditions, Refund Policy എന്നിവയിലേക്ക് ലിങ്ക് ചെയ്യുന്നു."),
]

# Hand-authored Gujarati translations.
_DEFAULT_FAQ_GU = [
    ("જ્યોતિષી સાથે પરામર્શ કેવી રીતે શરૂ કરવો?",
     "Astrologers ટેબ ખોલો, Online હોય તેવા જ્યોતિષીને પસંદ કરો, અને Chat, Call અથવા Video માંથી કોઈ એક પસંદ કરો. શરૂ કરતા પહેલા ખાતરી કરો કે તમારા wallet માં ઓછામાં ઓછા થોડી મિનિટો માટે પૂરતું balance છે — દર દરેક જ્યોતિષીના કાર્ડ પર પહેલેથી બતાવવામાં આવે છે."),
    ("Wallet billing કેવી રીતે કામ કરે છે?",
     "તમે તમારા wallet માં પૈસા ઉમેરો છો, અને પરામર્શનો ચાર્જ તેમાંથી લેવામાં આવે છે. પ્રતિ-મિનિટ સેવાઓ માટે શરૂઆતમાં એક રકમ થોડા સમય માટે block કરવામાં આવે છે અને session પૂરું થાય ત્યારે ચોક્કસ ચાર્જ નક્કી થાય છે. ઉપયોગ ન થયેલ block રકમ આપોઆપ પાછી આપવામાં આવે છે."),
    ("પૈસા કપાયા પણ session શરૂ ન થયું",
     "જો session ક્યારેય શરૂ જ ન થાય (દા.ત. જ્યોતિષીએ જવાબ ન આપ્યો), તો block કરેલી રકમ આપોઆપ પાછી આપવામાં આવે છે. જો થોડી મિનિટોમાં balance પાછું ન આવે, તો તારીખ અને સમય સાથે support ticket ઉઠાવો, અમે તેની તપાસ કરીશું."),
    ("હું મારા wallet માં પૈસા કેવી રીતે ઉમેરું?",
     "Wallet ટેબ પર જાઓ અને Add Money પર ટેપ કરો, રકમ પસંદ કરો અને payment પૂર્ણ કરો. Payment સફળ થતાં જ તમારું balance તરત જ update થાય છે."),
    ("મારો call connect થતો નથી",
     "તમારું internet connection તપાસો અને ખાતરી કરો કે app ને microphone અને camera ની પરવાનગી છે. Web app પર, browser પૂછે ત્યારે mic/camera ને મંજૂરી આપો. જો જ્યોતિષી 60 સેકન્ડમાં જવાબ ન આપે તો call આપોઆપ રદ થાય છે અને તમારી પાસેથી ચાર્જ લેવામાં આવતો નથી."),
    ("ખરાબ પરામર્શ માટે શું મને refund મળી શકે?",
     "જો session માં ખરેખર technical સમસ્યા હતી (call connect ન થયો, જ્યોતિષીએ જવાબ ન આપ્યો), તો વિગતો સાથે support ticket ઉઠાવો, અમારી ટીમ તેની સમીક્ષા કરશે. અમારી Refund Policy Profile → About & Legal માં જુઓ."),
    ("મને notifications મળતા નથી",
     "Profile → Notifications ખોલો અને ખાતરી કરો કે તે enabled છે. Web app પર, તમારા browser માં notifications ને મંજૂરી આપો (iPhone પર પહેલા app ને Home Screen પર ઉમેરો). જો તમે તાજેતરમાં logout કરીને ફરી login કર્યું હોય, તો notifications ને એકવાર toggle કરવાથી તમારું device refresh થાય છે."),
    ("કુંડળી અને રિપોર્ટ કેટલા સચોટ છે?",
     "Charts અને reports તમારી ચોક્કસ જન્મ તારીખ, સમય અને સ્થળનો ઉપયોગ કરીને ચોકસાઈભરી વૈદિક ખગોળીય ગણતરીઓથી બનાવવામાં આવે છે — તેથી શ્રેષ્ઠ પરિણામો માટે કૃપા કરીને તમારી જન્મ વિગતો શક્ય તેટલી ચોકસાઈથી ભરો."),
    ("Live streams માં gifts અને super-chats કેવી રીતે કામ કરે છે?",
     "Live stream દરમિયાન તમે જ્યોતિષીને gifts અથવા paid super-chat મોકલી શકો છો; રકમ તમારા wallet માંથી કપાય છે. Super-chats pin થાય છે જેથી જ્યોતિષી તેમને સ્પષ્ટ રીતે જોઈ શકે."),
    ("હું મારી જન્મ વિગતો કેવી રીતે બદલું?",
     "તમારી Kundli/profile ખોલો, જન્મ તારીખ, સમય અને સ્થળ edit કરો અને save કરો — તમારા charts અને reports આપોઆપ ફરીથી ગણતરી થશે."),
    ("મંજૂરી મળવામાં કેટલો સમય લાગે છે?",
     "તમારી વ્યક્તિગત વિગતો, વ્યાવસાયિક વિગતો અને KYC પૂર્ણ કર્યા પછી, અમારી ટીમ તમારી અરજીની સમીક્ષા કરે છે. મંજૂરી મળે અથવા કોઈ સુધારો જરૂરી હોય ત્યારે તમને notification અને email મળશે."),
    ("મારી અરજી નકારવામાં આવી — હવે મારે શું કરવું?",
     "App ખોલો: dashboard બરાબર બતાવે છે કે કયા વિભાગમાં સુધારો જરૂરી છે (KYC, વ્યક્તિગત, અથવા વ્યાવસાયિક વિગતો). ચિહ્નિત વિભાગ સુધારો અને ફરીથી submit કરો — profile edit કરતાં જ તે આપોઆપ ફરીથી સમીક્ષા માટે જાય છે."),
    ("KYC માટે મારે કયા દસ્તાવેજોની જરૂર છે?",
     "સ્પષ્ટ, માન્ય સરકારી ID અપલોડ કરો (અને જો માંગવામાં આવે તો કોઈપણ વ્યાવસાયિક પ્રમાણપત્ર). ખાતરી કરો કે photo ઝાંખો ન હોય, વિગતો તમારી profile સાથે મેળ ખાય અને દસ્તાવેજની મુદત પૂરી ન થઈ હોય."),
    ("મને call/chat requests મળતા નથી",
     "Dashboard toggle વડે તમારી જાતને Online set કરો અને Profile માં notifications enabled છે તેની ખાતરી કરો. વિશ્વસનીય delivery માટે app ને ખુલ્લી રાખો, અથવા web app ને Home Screen પર install કરો. નવી requests bell icon નીચે પણ દેખાય છે."),
    ("મને કેવી રીતે અને ક્યારે payment મળે છે?",
     "દરેક પરામર્શમાંથી તમારી કમાણી platform commission કપાયા પછી તમારા wallet માં જમા થાય છે. તમે Wallet screen પરથી તમારી bank માં withdraw કરી શકો છો; bank માં settlement તમારા payment provider ના સમયપત્રક પ્રમાણે થાય છે."),
    ("મારો withdrawal સફળ થયો પણ રકમ મારી bank માં દેખાતી નથી",
     "તમારા provider પર આધાર રાખીને bank settlement માં થોડો સમય લાગી શકે છે. તમારું wallet ledger debit તરત જ બતાવે છે; જો ledger માં તે ન દેખાય, તો reference અને સમય સાથે support ticket ઉઠાવો."),
    ("હું live stream કેવી રીતે શરૂ કરું?",
     "Dashboard પરથી Go Live પર ટેપ કરો. Web app પર તમે પહેલા Start Camera ટેપ કરશો (browser camera access માંગશે), પછી Go Live. તમે viewers ને જવાબ આપી શકો છો, જે પ્રશ્નનો જવાબ આપી રહ્યા છો તેને pin કરી શકો છો, અને gifting goal સેટ કરી શકો છો."),
    ("મારું rating કેવી રીતે ગણવામાં આવે છે?",
     "Chat, call અને video sessions પછી users દ્વારા આપવામાં આવેલ star ratings ની સરેરાશ એ તમારું rating છે. સતત મદદરૂપ, સમયસર પરામર્શ તમારા rating અને visibility ને સુધારે છે."),
    ("હું મારો profile photo કેવી રીતે update કરું?",
     "Profile પર જાઓ અને નવો photo upload કરવા માટે તમારા avatar પર ટેપ કરો. જો તમે Google થી sign in કર્યું હોય, તો તમે તમારો પોતાનો photo upload ન કરો ત્યાં સુધી તમારો Google photo આપોઆપ વપરાય છે."),
    ("હું support નો સંપર્ક કેવી રીતે કરું?",
     "Profile → Customer Support ખોલો. પહેલા FAQ તપાસો, અને જો તેનાથી મદદ ન મળે તો વિગતો મોકલવા માટે Raise Ticket પર ટેપ કરો (તમે 2 screenshots સુધી attach કરી શકો છો). Status અને replies તમે My Tickets હેઠળ track કરી શકો છો."),
    ("હું app ની ભાષા કેવી રીતે બદલું?",
     "Profile → Language ખોલો અને તમારી પસંદગીની ભાષા પસંદ કરો. App તરત જ update થાય છે."),
    ("Privacy, terms અને refund policies હું ક્યાં વાંચી શકું?",
     "તે Profile → About & Legal માં છે, જે nakshatralogy.com પર Privacy Policy, Terms & Conditions અને Refund Policy સાથે લિંક કરે છે."),
]

# Hand-authored Marathi translations.
_DEFAULT_FAQ_MR = [
    ("ज्योतिषाशी सल्लामसलत मी कशी सुरू करू?",
     "Astrologers टॅब उघडा, जो ज्योतिषी Online आहे त्याला निवडा आणि Chat, Call किंवा Video यापैकी एक निवडा. सुरू करण्यापूर्वी खात्री करा की तुमच्या wallet मध्ये किमान काही मिनिटांसाठी पुरेसे balance आहे — दर प्रत्येक ज्योतिषाच्या कार्डवर आधीच दाखवलेला असतो."),
    ("Wallet billing कसे काम करते?",
     "तुम्ही तुमच्या wallet मध्ये पैसे टाकता, आणि सल्लामसलतीचा खर्च त्यातून घेतला जातो. प्रति-मिनिट सेवांसाठी सुरुवातीला काही रक्कम तात्पुरती block केली जाते आणि session संपल्यावर नेमका खर्च ठरतो. न वापरलेली block रक्कम आपोआप परत केली जाते."),
    ("पैसे कापले गेले पण session सुरू झाले नाही",
     "session कधीच सुरू न झाल्यास (उदा. ज्योतिषाने उत्तर दिले नाही), block केलेली रक्कम आपोआप परत मिळते. काही मिनिटांत balance परत न आल्यास, तारीख आणि वेळेसह support ticket उघडा, आम्ही तपासू."),
    ("मी माझ्या wallet मध्ये पैसे कसे टाकू?",
     "Wallet टॅबमध्ये जा आणि Add Money वर टॅप करा, रक्कम निवडा आणि payment पूर्ण करा. payment यशस्वी होताच तुमचे balance लगेच update होते."),
    ("माझा call connect होत नाही",
     "तुमचे internet connection तपासा आणि app ला microphone व camera ची परवानगी आहे का ते पहा. web app वर, browser विचारल्यावर mic/camera ला परवानगी द्या. ज्योतिषाने 60 सेकंदांत उत्तर न दिल्यास call आपोआप रद्द होते आणि तुमच्याकडून शुल्क आकारले जात नाही."),
    ("वाईट सल्लामसलतीसाठी मला refund मिळू शकतो का?",
     "session मध्ये खरोखर तांत्रिक अडचण असल्यास (call connect झाला नाही, ज्योतिषाने प्रतिसाद दिला नाही), तपशीलांसह support ticket उघडा, आमची टीम त्याचे पुनरावलोकन करेल. आमची Refund Policy Profile → About & Legal मध्ये पहा."),
    ("मला notifications मिळत नाहीत",
     "Profile → Notifications उघडा आणि ते enabled आहेत याची खात्री करा. web app वर, तुमच्या browser मध्ये notifications ला परवानगी द्या (iPhone वर आधी app ला Home Screen वर जोडा). तुम्ही अलीकडेच logout करून पुन्हा login केले असल्यास, notifications एकदा toggle केल्याने तुमचे device refresh होते."),
    ("कुंडली आणि अहवाल किती अचूक आहेत?",
     "charts आणि reports तुमची अचूक जन्मतारीख, वेळ आणि ठिकाण वापरून सूक्ष्म वैदिक खगोलशास्त्रीय गणनांमधून तयार होतात — त्यामुळे उत्तम निकालांसाठी कृपया तुमचे जन्म तपशील शक्य तितके अचूक भरा."),
    ("Live streams मध्ये gifts आणि super-chats कसे काम करतात?",
     "Live stream च्या दरम्यान तुम्ही ज्योतिषाला gifts किंवा paid super-chat पाठवू शकता; रक्कम तुमच्या wallet मधून कापली जाते. super-chats pin केले जातात जेणेकरून ज्योतिषाला ते ठळकपणे दिसतील."),
    ("मी माझे जन्म तपशील कसे बदलू?",
     "तुमची Kundli/profile उघडा, जन्मतारीख, वेळ आणि ठिकाण edit करा आणि save करा — तुमचे charts आणि reports आपोआप पुन्हा गणले जातील."),
    ("मंजुरीला किती वेळ लागतो?",
     "तुमचे वैयक्तिक तपशील, व्यावसायिक तपशील आणि KYC पूर्ण केल्यानंतर, आमची टीम तुमच्या अर्जाचे पुनरावलोकन करते. मंजुरी मिळाल्यावर किंवा काही सुधारणा आवश्यक असल्यास तुम्हाला notification आणि email मिळेल."),
    ("माझा अर्ज नाकारला गेला — मी काय करावे?",
     "app उघडा: dashboard नेमके दाखवतो की कोणत्या विभागात सुधारणा हवी आहे (KYC, वैयक्तिक, किंवा व्यावसायिक तपशील). चिन्हांकित विभाग दुरुस्त करा आणि पुन्हा सबमिट करा — profile edit करताच ते आपोआप पुन्हा पुनरावलोकनासाठी जाते."),
    ("KYC साठी मला कोणती कागदपत्रे लागतील?",
     "स्पष्ट, वैध सरकारी ओळखपत्र अपलोड करा (आणि विनंती केल्यास कोणतेही व्यावसायिक प्रमाणपत्र). फोटो अस्पष्ट नसावा, तपशील तुमच्या profile शी जुळावेत आणि कागदपत्राची मुदत संपलेली नसावी याची खात्री करा."),
    ("मला call/chat requests मिळत नाहीत",
     "dashboard toggle वापरून स्वतःला Online सेट करा आणि Profile मध्ये notifications enabled असल्याची खात्री करा. विश्वासार्ह delivery साठी app उघडे ठेवा, किंवा web app Home Screen वर install करा. नवीन requests bell icon खालीही दिसतात."),
    ("मला payment कसे आणि कधी मिळते?",
     "प्रत्येक सल्लामसलतीतून तुमची कमाई platform commission वजा केल्यानंतर तुमच्या wallet मध्ये जमा होते. तुम्ही Wallet screen वरून तुमच्या bank मध्ये withdraw करू शकता; bank मध्ये settlement तुमच्या payment provider च्या वेळापत्रकानुसार होते."),
    ("माझा withdrawal यशस्वी झाला पण रक्कम माझ्या bank मध्ये दिसत नाही",
     "तुमच्या provider नुसार bank settlement ला थोडा वेळ लागू शकतो. तुमचे wallet ledger debit लगेच दाखवते; ते ledger मध्ये न दिसल्यास, reference आणि वेळेसह support ticket उघडा."),
    ("मी live stream कसा सुरू करू?",
     "dashboard वरून Go Live वर टॅप करा. web app वर तुम्ही आधी Start Camera टॅप कराल (browser camera access मागेल), नंतर Go Live. तुम्ही viewers ला उत्तर देऊ शकता, ज्या प्रश्नाचे उत्तर देत आहात तो pin करू शकता आणि gifting goal सेट करू शकता."),
    ("माझे rating कसे मोजले जाते?",
     "chat, call आणि video sessions नंतर users नी दिलेल्या star ratings ची सरासरी म्हणजे तुमचे rating. सातत्याने उपयुक्त, वेळेवर सल्लामसलत तुमचे rating आणि visibility वाढवते."),
    ("मी माझा profile photo कसा update करू?",
     "Profile वर जा आणि नवीन फोटो अपलोड करण्यासाठी तुमच्या avatar वर टॅप करा. तुम्ही Google ने sign in केले असल्यास, तुम्ही स्वतःचा फोटो अपलोड करेपर्यंत तुमचा Google फोटो आपोआप वापरला जातो."),
    ("मी support शी संपर्क कसा करू?",
     "Profile → Customer Support उघडा. आधी FAQ पहा, आणि त्याने मदत न झाल्यास तपशील पाठवण्यासाठी Raise Ticket वर टॅप करा (तुम्ही 2 screenshots पर्यंत जोडू शकता). status आणि replies तुम्ही My Tickets खाली track करू शकता."),
    ("मी app ची भाषा कशी बदलू?",
     "Profile → Language उघडा आणि तुमची आवडती भाषा निवडा. app लगेच update होते."),
    ("Privacy, terms आणि refund policies मी कुठे वाचू शकतो?",
     "त्या Profile → About & Legal मध्ये आहेत, जे nakshatralogy.com वरील Privacy Policy, Terms & Conditions आणि Refund Policy शी लिंक करते."),
]

# Hand-authored Punjabi (Gurmukhi) translations.
_DEFAULT_FAQ_PA = [
    ("ਜੋਤਸ਼ੀ ਨਾਲ ਸਲਾਹ-ਮਸ਼ਵਰਾ ਮੈਂ ਕਿਵੇਂ ਸ਼ੁਰੂ ਕਰਾਂ?",
     "Astrologers ਟੈਬ ਖੋਲ੍ਹੋ, Online ਦਿਸ ਰਹੇ ਕਿਸੇ ਜੋਤਸ਼ੀ ਨੂੰ ਚੁਣੋ, ਅਤੇ Chat, Call ਜਾਂ Video ਵਿੱਚੋਂ ਕੋਈ ਇੱਕ ਚੁਣੋ। ਸ਼ੁਰੂ ਕਰਨ ਤੋਂ ਪਹਿਲਾਂ ਯਕੀਨੀ ਬਣਾਓ ਕਿ ਤੁਹਾਡੇ wallet ਵਿੱਚ ਘੱਟੋ-ਘੱਟ ਕੁਝ ਮਿੰਟਾਂ ਲਈ ਕਾਫ਼ੀ balance ਹੈ — ਰੇਟ ਹਰ ਜੋਤਸ਼ੀ ਦੇ ਕਾਰਡ ਉੱਤੇ ਪਹਿਲਾਂ ਹੀ ਦਿਖਾਇਆ ਜਾਂਦਾ ਹੈ।"),
    ("Wallet billing ਕਿਵੇਂ ਕੰਮ ਕਰਦੀ ਹੈ?",
     "ਤੁਸੀਂ ਆਪਣੇ wallet ਵਿੱਚ ਪੈਸੇ ਪਾਉਂਦੇ ਹੋ, ਅਤੇ ਸਲਾਹ-ਮਸ਼ਵਰੇ ਦਾ ਖਰਚਾ ਉਸ ਵਿੱਚੋਂ ਲਿਆ ਜਾਂਦਾ ਹੈ। ਪ੍ਰਤੀ-ਮਿੰਟ ਸੇਵਾਵਾਂ ਲਈ ਸ਼ੁਰੂ ਵਿੱਚ ਥੋੜ੍ਹੀ ਰਕਮ ਥੋੜ੍ਹੇ ਸਮੇਂ ਲਈ block ਕੀਤੀ ਜਾਂਦੀ ਹੈ ਅਤੇ session ਖਤਮ ਹੋਣ 'ਤੇ ਸਹੀ ਚਾਰਜ ਤੈਅ ਹੁੰਦਾ ਹੈ। ਵਰਤੀ ਨਾ ਗਈ block ਰਕਮ ਆਪਣੇ ਆਪ ਵਾਪਸ ਹੋ ਜਾਂਦੀ ਹੈ।"),
    ("ਪੈਸੇ ਕੱਟੇ ਗਏ ਪਰ session ਸ਼ੁਰੂ ਨਹੀਂ ਹੋਇਆ",
     "ਜੇ session ਕਦੇ ਸ਼ੁਰੂ ਹੀ ਨਹੀਂ ਹੁੰਦਾ (ਜਿਵੇਂ ਜੋਤਸ਼ੀ ਨੇ ਜਵਾਬ ਨਹੀਂ ਦਿੱਤਾ), ਤਾਂ block ਕੀਤੀ ਰਕਮ ਆਪਣੇ ਆਪ ਵਾਪਸ ਹੋ ਜਾਂਦੀ ਹੈ। ਜੇ ਕੁਝ ਮਿੰਟਾਂ ਵਿੱਚ balance ਵਾਪਸ ਨਾ ਆਵੇ, ਤਾਂ ਤਾਰੀਖ ਅਤੇ ਸਮੇਂ ਨਾਲ support ticket ਬਣਾਓ, ਅਸੀਂ ਜਾਂਚ ਕਰਾਂਗੇ।"),
    ("ਮੈਂ ਆਪਣੇ wallet ਵਿੱਚ ਪੈਸੇ ਕਿਵੇਂ ਪਾਵਾਂ?",
     "Wallet ਟੈਬ ਵਿੱਚ ਜਾਓ ਅਤੇ Add Money 'ਤੇ ਟੈਪ ਕਰੋ, ਰਕਮ ਚੁਣੋ ਅਤੇ payment ਪੂਰਾ ਕਰੋ। payment ਸਫਲ ਹੁੰਦੇ ਹੀ ਤੁਹਾਡਾ balance ਤੁਰੰਤ update ਹੋ ਜਾਂਦਾ ਹੈ।"),
    ("ਮੇਰੀ call connect ਨਹੀਂ ਹੋ ਰਹੀ",
     "ਆਪਣਾ internet connection ਚੈੱਕ ਕਰੋ ਅਤੇ ਯਕੀਨੀ ਬਣਾਓ ਕਿ app ਨੂੰ microphone ਅਤੇ camera ਦੀ ਇਜਾਜ਼ਤ ਹੈ। web app 'ਤੇ, browser ਪੁੱਛੇ ਤਾਂ mic/camera ਦੀ ਇਜਾਜ਼ਤ ਦਿਓ। ਜੇ ਜੋਤਸ਼ੀ 60 ਸਕਿੰਟਾਂ ਵਿੱਚ ਜਵਾਬ ਨਹੀਂ ਦਿੰਦਾ ਤਾਂ call ਆਪਣੇ ਆਪ ਰੱਦ ਹੋ ਜਾਂਦੀ ਹੈ ਅਤੇ ਤੁਹਾਡੇ ਤੋਂ ਕੋਈ ਚਾਰਜ ਨਹੀਂ ਲਿਆ ਜਾਂਦਾ।"),
    ("ਖਰਾਬ ਸਲਾਹ-ਮਸ਼ਵਰੇ ਲਈ ਕੀ ਮੈਨੂੰ refund ਮਿਲ ਸਕਦਾ ਹੈ?",
     "ਜੇ session ਵਿੱਚ ਅਸਲੀ ਤਕਨੀਕੀ ਸਮੱਸਿਆ ਸੀ (call connect ਨਹੀਂ ਹੋਈ, ਜੋਤਸ਼ੀ ਨੇ ਜਵਾਬ ਨਹੀਂ ਦਿੱਤਾ), ਤਾਂ ਵੇਰਵਿਆਂ ਨਾਲ support ticket ਬਣਾਓ, ਸਾਡੀ ਟੀਮ ਇਸਦੀ ਸਮੀਖਿਆ ਕਰੇਗੀ। ਸਾਡੀ Refund Policy Profile → About & Legal ਵਿੱਚ ਦੇਖੋ।"),
    ("ਮੈਨੂੰ notifications ਨਹੀਂ ਮਿਲ ਰਹੇ",
     "Profile → Notifications ਖੋਲ੍ਹੋ ਅਤੇ ਯਕੀਨੀ ਬਣਾਓ ਕਿ ਉਹ enabled ਹਨ। web app 'ਤੇ, ਆਪਣੇ browser ਵਿੱਚ notifications ਦੀ ਇਜਾਜ਼ਤ ਦਿਓ (iPhone 'ਤੇ ਪਹਿਲਾਂ app ਨੂੰ Home Screen 'ਤੇ ਜੋੜੋ)। ਜੇ ਤੁਸੀਂ ਹਾਲ ਹੀ ਵਿੱਚ logout ਕਰਕੇ ਦੁਬਾਰਾ login ਕੀਤਾ ਹੈ, ਤਾਂ notifications ਨੂੰ ਇੱਕ ਵਾਰ toggle ਕਰਨ ਨਾਲ ਤੁਹਾਡਾ device refresh ਹੋ ਜਾਂਦਾ ਹੈ।"),
    ("ਕੁੰਡਲੀ ਅਤੇ ਰਿਪੋਰਟਾਂ ਕਿੰਨੀਆਂ ਸਹੀ ਹਨ?",
     "charts ਅਤੇ reports ਤੁਹਾਡੀ ਸਹੀ ਜਨਮ ਮਿਤੀ, ਸਮੇਂ ਅਤੇ ਸਥਾਨ ਦੀ ਵਰਤੋਂ ਕਰਕੇ ਸਟੀਕ ਵੈਦਿਕ ਖਗੋਲੀ ਗਣਨਾਵਾਂ ਤੋਂ ਬਣਾਏ ਜਾਂਦੇ ਹਨ — ਇਸ ਲਈ ਬਿਹਤਰੀਨ ਨਤੀਜਿਆਂ ਲਈ ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੇ ਜਨਮ ਵੇਰਵੇ ਜਿੰਨਾ ਹੋ ਸਕੇ ਸਹੀ ਭਰੋ।"),
    ("Live streams ਵਿੱਚ gifts ਅਤੇ super-chats ਕਿਵੇਂ ਕੰਮ ਕਰਦੇ ਹਨ?",
     "Live stream ਦੌਰਾਨ ਤੁਸੀਂ ਜੋਤਸ਼ੀ ਨੂੰ gifts ਜਾਂ paid super-chat ਭੇਜ ਸਕਦੇ ਹੋ; ਰਕਮ ਤੁਹਾਡੇ wallet ਵਿੱਚੋਂ ਕੱਟੀ ਜਾਂਦੀ ਹੈ। super-chats pin ਹੋ ਜਾਂਦੇ ਹਨ ਤਾਂ ਜੋ ਜੋਤਸ਼ੀ ਉਹਨਾਂ ਨੂੰ ਸਪੱਸ਼ਟ ਤੌਰ 'ਤੇ ਦੇਖ ਸਕੇ।"),
    ("ਮੈਂ ਆਪਣੇ ਜਨਮ ਵੇਰਵੇ ਕਿਵੇਂ ਬਦਲਾਂ?",
     "ਆਪਣੀ Kundli/profile ਖੋਲ੍ਹੋ, ਜਨਮ ਮਿਤੀ, ਸਮਾਂ ਅਤੇ ਸਥਾਨ edit ਕਰੋ ਅਤੇ save ਕਰੋ — ਤੁਹਾਡੇ charts ਅਤੇ reports ਆਪਣੇ ਆਪ ਦੁਬਾਰਾ ਗਿਣੇ ਜਾਣਗੇ।"),
    ("ਮਨਜ਼ੂਰੀ ਮਿਲਣ ਵਿੱਚ ਕਿੰਨਾ ਸਮਾਂ ਲੱਗਦਾ ਹੈ?",
     "ਤੁਹਾਡੇ ਨਿੱਜੀ ਵੇਰਵੇ, ਪੇਸ਼ੇਵਰ ਵੇਰਵੇ ਅਤੇ KYC ਪੂਰਾ ਕਰਨ ਤੋਂ ਬਾਅਦ, ਸਾਡੀ ਟੀਮ ਤੁਹਾਡੀ ਅਰਜ਼ੀ ਦੀ ਸਮੀਖਿਆ ਕਰਦੀ ਹੈ। ਮਨਜ਼ੂਰੀ ਮਿਲਣ 'ਤੇ ਜਾਂ ਕਿਸੇ ਸੁਧਾਰ ਦੀ ਲੋੜ ਹੋਣ 'ਤੇ ਤੁਹਾਨੂੰ notification ਅਤੇ email ਮਿਲੇਗਾ।"),
    ("ਮੇਰੀ ਅਰਜ਼ੀ ਰੱਦ ਹੋ ਗਈ — ਹੁਣ ਮੈਂ ਕੀ ਕਰਾਂ?",
     "app ਖੋਲ੍ਹੋ: dashboard ਸਹੀ-ਸਹੀ ਦਿਖਾਉਂਦਾ ਹੈ ਕਿ ਕਿਹੜੇ ਹਿੱਸੇ ਵਿੱਚ ਸੁਧਾਰ ਦੀ ਲੋੜ ਹੈ (KYC, ਨਿੱਜੀ, ਜਾਂ ਪੇਸ਼ੇਵਰ ਵੇਰਵੇ)। ਨਿਸ਼ਾਨਬੱਧ ਹਿੱਸੇ ਨੂੰ ਠੀਕ ਕਰੋ ਅਤੇ ਦੁਬਾਰਾ submit ਕਰੋ — profile edit ਕਰਦੇ ਹੀ ਇਹ ਆਪਣੇ ਆਪ ਦੁਬਾਰਾ ਸਮੀਖਿਆ ਲਈ ਚਲੀ ਜਾਂਦੀ ਹੈ।"),
    ("KYC ਲਈ ਮੈਨੂੰ ਕਿਹੜੇ ਦਸਤਾਵੇਜ਼ ਚਾਹੀਦੇ ਹਨ?",
     "ਇੱਕ ਸਾਫ਼, ਵੈਧ ਸਰਕਾਰੀ ID ਅੱਪਲੋਡ ਕਰੋ (ਅਤੇ ਮੰਗੇ ਜਾਣ 'ਤੇ ਕੋਈ ਪੇਸ਼ੇਵਰ ਸਰਟੀਫਿਕੇਟ ਵੀ)। ਯਕੀਨੀ ਬਣਾਓ ਕਿ ਫੋਟੋ ਧੁੰਦਲੀ ਨਾ ਹੋਵੇ, ਵੇਰਵੇ ਤੁਹਾਡੀ profile ਨਾਲ ਮੇਲ ਖਾਣ ਅਤੇ ਦਸਤਾਵੇਜ਼ ਦੀ ਮਿਆਦ ਖਤਮ ਨਾ ਹੋਈ ਹੋਵੇ।"),
    ("ਮੈਨੂੰ call/chat requests ਨਹੀਂ ਮਿਲ ਰਹੀਆਂ",
     "dashboard toggle ਨਾਲ ਆਪਣੇ ਆਪ ਨੂੰ Online set ਕਰੋ ਅਤੇ Profile ਵਿੱਚ notifications enabled ਹੋਣ ਦੀ ਪੁਸ਼ਟੀ ਕਰੋ। ਭਰੋਸੇਯੋਗ delivery ਲਈ app ਖੁੱਲ੍ਹਾ ਰੱਖੋ, ਜਾਂ web app ਨੂੰ Home Screen 'ਤੇ install ਕਰੋ। ਨਵੀਆਂ requests ਬੈੱਲ ਆਈਕਨ ਹੇਠਾਂ ਵੀ ਦਿਖਦੀਆਂ ਹਨ।"),
    ("ਮੈਨੂੰ ਭੁਗਤਾਨ ਕਿਵੇਂ ਅਤੇ ਕਦੋਂ ਮਿਲਦਾ ਹੈ?",
     "ਹਰ ਸਲਾਹ-ਮਸ਼ਵਰੇ ਤੋਂ ਤੁਹਾਡੀ ਕਮਾਈ platform commission ਕੱਟਣ ਤੋਂ ਬਾਅਦ ਤੁਹਾਡੇ wallet ਵਿੱਚ ਜਮ੍ਹਾ ਹੁੰਦੀ ਹੈ। ਤੁਸੀਂ Wallet screen ਤੋਂ ਆਪਣੇ ਬੈਂਕ ਵਿੱਚ withdraw ਕਰ ਸਕਦੇ ਹੋ; ਬੈਂਕ ਵਿੱਚ settlement ਤੁਹਾਡੇ payment provider ਦੀ ਸਮਾਂ-ਸੀਮਾ ਅਨੁਸਾਰ ਹੁੰਦਾ ਹੈ।"),
    ("ਮੇਰਾ withdrawal ਸਫਲ ਰਿਹਾ ਪਰ ਰਕਮ ਮੇਰੇ ਬੈਂਕ ਵਿੱਚ ਨਹੀਂ ਦਿਖ ਰਹੀ",
     "ਤੁਹਾਡੇ provider ਅਨੁਸਾਰ ਬੈਂਕ settlement ਵਿੱਚ ਕੁਝ ਸਮਾਂ ਲੱਗ ਸਕਦਾ ਹੈ। ਤੁਹਾਡਾ wallet ledger debit ਤੁਰੰਤ ਦਿਖਾਉਂਦਾ ਹੈ; ਜੇ ਇਹ ledger ਵਿੱਚ ਨਾ ਦਿਖੇ, ਤਾਂ reference ਅਤੇ ਸਮੇਂ ਨਾਲ support ticket ਬਣਾਓ।"),
    ("ਮੈਂ live stream ਕਿਵੇਂ ਸ਼ੁਰੂ ਕਰਾਂ?",
     "dashboard ਤੋਂ Go Live 'ਤੇ ਟੈਪ ਕਰੋ। web app 'ਤੇ ਤੁਸੀਂ ਪਹਿਲਾਂ Start Camera ਟੈਪ ਕਰੋਗੇ (browser camera access ਮੰਗੇਗਾ), ਫਿਰ Go Live। ਤੁਸੀਂ ਦਰਸ਼ਕਾਂ ਨੂੰ ਜਵਾਬ ਦੇ ਸਕਦੇ ਹੋ, ਜਿਸ ਸਵਾਲ ਦਾ ਜਵਾਬ ਦੇ ਰਹੇ ਹੋ ਉਸਨੂੰ pin ਕਰ ਸਕਦੇ ਹੋ, ਅਤੇ gifting goal set ਕਰ ਸਕਦੇ ਹੋ।"),
    ("ਮੇਰੀ rating ਕਿਵੇਂ ਗਿਣੀ ਜਾਂਦੀ ਹੈ?",
     "chat, call ਅਤੇ video sessions ਤੋਂ ਬਾਅਦ users ਵੱਲੋਂ ਦਿੱਤੀਆਂ star ratings ਦਾ ਔਸਤ ਹੀ ਤੁਹਾਡੀ rating ਹੈ। ਲਗਾਤਾਰ ਮਦਦਗਾਰ, ਸਮੇਂ ਸਿਰ ਸਲਾਹ-ਮਸ਼ਵਰੇ ਤੁਹਾਡੀ rating ਅਤੇ visibility ਵਧਾਉਂਦੇ ਹਨ।"),
    ("ਮੈਂ ਆਪਣੀ profile photo ਕਿਵੇਂ update ਕਰਾਂ?",
     "Profile 'ਤੇ ਜਾਓ ਅਤੇ ਨਵੀਂ photo upload ਕਰਨ ਲਈ ਆਪਣੇ avatar 'ਤੇ ਟੈਪ ਕਰੋ। ਜੇ ਤੁਸੀਂ Google ਨਾਲ sign in ਕੀਤਾ ਹੈ, ਤਾਂ ਜਦੋਂ ਤੱਕ ਤੁਸੀਂ ਆਪਣੀ ਖੁਦ ਦੀ photo upload ਨਹੀਂ ਕਰਦੇ, ਤੁਹਾਡੀ Google photo ਆਪਣੇ ਆਪ ਵਰਤੀ ਜਾਂਦੀ ਹੈ।"),
    ("ਮੈਂ support ਨਾਲ ਸੰਪਰਕ ਕਿਵੇਂ ਕਰਾਂ?",
     "Profile → Customer Support ਖੋਲ੍ਹੋ। ਪਹਿਲਾਂ FAQ ਦੇਖੋ, ਅਤੇ ਜੇ ਉਸ ਨਾਲ ਮਦਦ ਨਾ ਮਿਲੇ ਤਾਂ ਵੇਰਵੇ ਭੇਜਣ ਲਈ Raise Ticket 'ਤੇ ਟੈਪ ਕਰੋ (ਤੁਸੀਂ 2 screenshots ਤੱਕ ਜੋੜ ਸਕਦੇ ਹੋ)। status ਅਤੇ replies ਤੁਸੀਂ My Tickets ਹੇਠਾਂ track ਕਰ ਸਕਦੇ ਹੋ।"),
    ("ਮੈਂ app ਦੀ ਭਾਸ਼ਾ ਕਿਵੇਂ ਬਦਲਾਂ?",
     "Profile → Language ਖੋਲ੍ਹੋ ਅਤੇ ਆਪਣੀ ਪਸੰਦੀਦਾ ਭਾਸ਼ਾ ਚੁਣੋ। app ਤੁਰੰਤ update ਹੋ ਜਾਂਦੀ ਹੈ।"),
    ("ਪਰਦੇਦਾਰੀ, ਸ਼ਰਤਾਂ ਅਤੇ refund policies ਮੈਂ ਕਿੱਥੇ ਪੜ੍ਹ ਸਕਦਾ ਹਾਂ?",
     "ਇਹ Profile → About & Legal ਵਿੱਚ ਹਨ, ਜੋ nakshatralogy.com 'ਤੇ Privacy Policy, Terms & Conditions ਅਤੇ Refund Policy ਨਾਲ ਲਿੰਕ ਕਰਦਾ ਹੈ।"),
]

# Hand-authored Odia translations.
_DEFAULT_FAQ_OR = [
    ("ମୁଁ ଜଣେ ଜ୍ୟୋତିଷୀଙ୍କ ସହ ପରାମର୍ଶ କିପରି ଆରମ୍ଭ କରିବି?",
     "Astrologers ଟାବ୍ ଖୋଲନ୍ତୁ, Online ଥିବା ଜଣେ ଜ୍ୟୋତିଷୀଙ୍କୁ ବାଛନ୍ତୁ, ଏବଂ Chat, Call କିମ୍ବା Video ମଧ୍ୟରୁ ଗୋଟିଏ ବାଛନ୍ତୁ। ଆରମ୍ଭ କରିବା ପୂର୍ବରୁ ନିଶ୍ଚିତ କରନ୍ତୁ ଯେ ଆପଣଙ୍କ wallet ରେ ଅତି କମରେ କିଛି ମିନିଟ୍ ପାଇଁ ଯଥେଷ୍ଟ balance ଅଛି — ହାର ପ୍ରତ୍ୟେକ ଜ୍ୟୋତିଷୀଙ୍କ କାର୍ଡରେ ଆଗରୁ ଦେଖାଯାଏ।"),
    ("Wallet billing କିପରି କାମ କରେ?",
     "ଆପଣ ଆପଣଙ୍କ wallet ରେ ଟଙ୍କା ଯୋଡ଼ନ୍ତି, ଏବଂ ପରାମର୍ଶର ଖର୍ଚ୍ଚ ତାହାରୁ କଟାଯାଏ। ପ୍ରତି-ମିନିଟ୍ ସେବା ପାଇଁ ଆରମ୍ଭରେ କିଛି ପରିମାଣ ସାମୟିକ ଭାବେ block ହୁଏ ଏବଂ session ସମାପ୍ତ ହେଲେ ସଠିକ୍ ଚାର୍ଜ ସ୍ଥିର ହୁଏ। ବ୍ୟବହାର ହୋଇନଥିବା block ପରିମାଣ ସ୍ୱୟଂଚାଳିତ ଭାବେ ଫେରସ୍ତ ହୁଏ।"),
    ("ଟଙ୍କା କଟିଗଲା କିନ୍ତୁ session ଆରମ୍ଭ ହେଲା ନାହିଁ",
     "ଯଦି session କେବେ ହେଁ ଆରମ୍ଭ ହୁଏ ନାହିଁ (ଯେମିତି ଜ୍ୟୋତିଷୀ ଉତ୍ତର ଦେଲେ ନାହିଁ), ତେବେ block ହୋଇଥିବା ପରିମାଣ ସ୍ୱୟଂଚାଳିତ ଭାବେ ଫେରସ୍ତ ହୁଏ। ଯଦି କିଛି ମିନିଟ୍ ମଧ୍ୟରେ balance ଫେରି ନ ଆସେ, ତାରିଖ ଓ ସମୟ ସହିତ ଏକ support ticket ଉଠାନ୍ତୁ, ଆମେ ଯାଞ୍ଚ କରିବୁ।"),
    ("ମୁଁ ମୋ wallet ରେ ଟଙ୍କା କିପରି ଯୋଡ଼ିବି?",
     "Wallet ଟାବ୍‌କୁ ଯାଇ Add Money ଉପରେ ଟାପ୍ କରନ୍ତୁ, ଏକ ପରିମାଣ ବାଛନ୍ତୁ ଏବଂ ପେମେଣ୍ଟ ସମ୍ପୂର୍ଣ୍ଣ କରନ୍ତୁ। ପେମେଣ୍ଟ ସଫଳ ହେବା ମାତ୍ରେ ଆପଣଙ୍କ balance ତୁରନ୍ତ update ହୋଇଯାଏ।"),
    ("ମୋର call connect ହେଉନାହିଁ",
     "ଆପଣଙ୍କ internet connection ଯାଞ୍ଚ କରନ୍ତୁ ଏବଂ app କୁ microphone ଓ camera ଅନୁମତି ଅଛି କି ନାହିଁ ଦେଖନ୍ତୁ। web app ରେ, browser ପଚାରିଲେ mic/camera ଅନୁମତି ଦିଅନ୍ତୁ। ଜ୍ୟୋତିଷୀ 60 ସେକେଣ୍ଡ ମଧ୍ୟରେ ଉତ୍ତର ନ ଦେଲେ call ସ୍ୱୟଂଚାଳିତ ଭାବେ ବାତିଲ ହୋଇଯାଏ ଏବଂ ଆପଣଙ୍କଠାରୁ କୌଣସି ଚାର୍ଜ ନିଆଯାଏ ନାହିଁ।"),
    ("ଖରାପ ପରାମର୍ଶ ପାଇଁ ମୋତେ refund ମିଳିପାରିବ କି?",
     "ଯଦି session ରେ ପ୍ରକୃତ ଟେକ୍ନିକାଲ ସମସ୍ୟା ଥିଲା (call connect ହେଲା ନାହିଁ, ଜ୍ୟୋତିଷୀ ଉତ୍ତର ଦେଲେ ନାହିଁ), ତେବେ ବିବରଣୀ ସହିତ ଏକ support ticket ଉଠାନ୍ତୁ, ଆମ ଟିମ୍ ଏହାକୁ ସମୀକ୍ଷା କରିବେ। ଆମର Refund Policy Profile → About & Legal ରେ ଦେଖନ୍ତୁ।"),
    ("ମୋତେ notifications ମିଳୁନାହିଁ",
     "Profile → Notifications ଖୋଲନ୍ତୁ ଏବଂ ନିଶ୍ଚିତ କରନ୍ତୁ ସେଗୁଡ଼ିକ enabled ଅଛି। web app ରେ, ଆପଣଙ୍କ browser ରେ notifications ଅନୁମତି ଦିଅନ୍ତୁ (iPhone ରେ ପ୍ରଥମେ app କୁ Home Screen ରେ ଯୋଡ଼ନ୍ତୁ)। ଯଦି ଆପଣ ସମ୍ପ୍ରତି logout କରି ପୁଣି login କରିଛନ୍ତି, notifications କୁ ଥରେ toggle କରିବା ଆପଣଙ୍କ device କୁ refresh କରିଦିଏ।"),
    ("କୁଣ୍ଡଳୀ ଏବଂ ରିପୋର୍ଟ କେତେ ସଠିକ୍?",
     "charts ଏବଂ reports ଆପଣଙ୍କ ସଠିକ୍ ଜନ୍ମ ତାରିଖ, ସମୟ ଏବଂ ସ୍ଥାନ ବ୍ୟବହାର କରି ସୂକ୍ଷ୍ମ ବୈଦିକ ଜ୍ୟୋତିର୍ବିଜ୍ଞାନ ଗଣନାରୁ ତିଆରି ହୁଏ — ତେଣୁ ସର୍ବୋତ୍ତମ ଫଳାଫଳ ପାଇଁ ଦୟାକରି ଆପଣଙ୍କ ଜନ୍ମ ବିବରଣୀ ଯଥାସମ୍ଭବ ସଠିକ୍ ଭାବେ ଦିଅନ୍ତୁ।"),
    ("Live streams ରେ gifts ଏବଂ super-chats କିପରି କାମ କରନ୍ତି?",
     "Live stream ସମୟରେ ଆପଣ ଜ୍ୟୋତିଷୀଙ୍କୁ gifts କିମ୍ବା paid super-chat ପଠାଇପାରିବେ; ପରିମାଣ ଆପଣଙ୍କ wallet ରୁ କଟାଯାଏ। super-chats pin ହୋଇଯାଏ ଯାହା ଫଳରେ ଜ୍ୟୋତିଷୀ ସେଗୁଡ଼ିକୁ ସ୍ପଷ୍ଟ ଭାବେ ଦେଖିପାରନ୍ତି।"),
    ("ମୁଁ ମୋର ଜନ୍ମ ବିବରଣୀ କିପରି ପରିବର୍ତ୍ତନ କରିବି?",
     "ଆପଣଙ୍କ Kundli/profile ଖୋଲନ୍ତୁ, ଜନ୍ମ ତାରିଖ, ସମୟ ଏବଂ ସ୍ଥାନ edit କରି save କରନ୍ତୁ — ଆପଣଙ୍କ charts ଏବଂ reports ସ୍ୱୟଂଚାଳିତ ଭାବେ ପୁନଃ ଗଣନା ହେବ।"),
    ("ଅନୁମୋଦନ ପାଇବାକୁ କେତେ ସମୟ ଲାଗେ?",
     "ଆପଣଙ୍କ ବ୍ୟକ୍ତିଗତ ବିବରଣୀ, ବୃତ୍ତିଗତ ବିବରଣୀ ଏବଂ KYC ସମ୍ପୂର୍ଣ୍ଣ କରିବା ପରେ, ଆମ ଟିମ୍ ଆପଣଙ୍କ ଆବେଦନକୁ ସମୀକ୍ଷା କରନ୍ତି। ଅନୁମୋଦିତ ହେଲେ କିମ୍ବା କୌଣସି ସଂଶୋଧନ ଆବଶ୍ୟକ ହେଲେ ଆପଣ notification ଏବଂ email ପାଇବେ।"),
    ("ମୋର ଆବେଦନ ପ୍ରତ୍ୟାଖ୍ୟାନ ହେଲା — ମୁଁ କଣ କରିବି?",
     "app ଖୋଲନ୍ତୁ: dashboard ଠିକ୍ ଭାବେ ଦେଖାଏ କେଉଁ ଅଂଶରେ ସଂଶୋଧନ ଦରକାର (KYC, ବ୍ୟକ୍ତିଗତ, କିମ୍ବା ବୃତ୍ତିଗତ ବିବରଣୀ)। ଚିହ୍ନିତ ଅଂଶକୁ ଠିକ୍ କରି ପୁଣି submit କରନ୍ତୁ — profile edit କରିବା ମାତ୍ରେ ଏହା ସ୍ୱୟଂଚାଳିତ ଭାବେ ପୁନଃ ସମୀକ୍ଷା ପାଇଁ ଚାଲିଯାଏ।"),
    ("KYC ପାଇଁ ମୋତେ କେଉଁ ଡକ୍ୟୁମେଣ୍ଟ ଦରକାର?",
     "ଏକ ସ୍ପଷ୍ଟ, ବୈଧ ସରକାରୀ ID ଅପଲୋଡ୍ କରନ୍ତୁ (ଏବଂ ଅନୁରୋଧ କରାଗଲେ କୌଣସି ବୃତ୍ତିଗତ ସାର୍ଟିଫିକେଟ୍)। ନିଶ୍ଚିତ କରନ୍ତୁ ଫଟୋ ଅସ୍ପଷ୍ଟ ନାହିଁ, ବିବରଣୀ ଆପଣଙ୍କ profile ସହ ମେଳ ଖାଉଛି ଏବଂ ଡକ୍ୟୁମେଣ୍ଟର ମିଆଦ ସରିନାହିଁ।"),
    ("ମୋତେ call/chat requests ମିଳୁନାହିଁ",
     "dashboard toggle ବ୍ୟବହାର କରି ନିଜକୁ Online set କରନ୍ତୁ ଏବଂ Profile ରେ notifications enabled ଥିବା ନିଶ୍ଚିତ କରନ୍ତୁ। ବିଶ୍ୱାସନୀୟ delivery ପାଇଁ app ଖୋଲା ରଖନ୍ତୁ, କିମ୍ବା web app କୁ Home Screen ରେ install କରନ୍ତୁ। ନୂଆ requests bell icon ତଳେ ମଧ୍ୟ ଦେଖାଯାଏ।"),
    ("ମୋତେ କିପରି ଏବଂ କେବେ ଦେୟ ମିଳେ?",
     "ପ୍ରତ୍ୟେକ ପରାମର୍ଶରୁ ଆପଣଙ୍କ ରୋଜଗାର platform commission କଟିବା ପରେ ଆପଣଙ୍କ wallet ରେ ଜମା ହୁଏ। ଆପଣ Wallet screen ରୁ ଆପଣଙ୍କ ବ୍ୟାଙ୍କକୁ withdraw କରିପାରିବେ; ବ୍ୟାଙ୍କରେ settlement ଆପଣଙ୍କ payment provider ର ସମୟସୀମା ଅନୁସାରେ ହୁଏ।"),
    ("ମୋର withdrawal ସଫଳ ହେଲା କିନ୍ତୁ ପରିମାଣ ମୋ ବ୍ୟାଙ୍କରେ ଦେଖାଉନାହିଁ",
     "ଆପଣଙ୍କ provider ଅନୁସାରେ ବ୍ୟାଙ୍କ settlement କିଛି ସମୟ ନେଇପାରେ। ଆପଣଙ୍କ wallet ledger debit ତୁରନ୍ତ ଦେଖାଏ; ଯଦି ଏହା ledger ରେ ପ୍ରତିଫଳିତ ନ ହୁଏ, reference ଏବଂ ସମୟ ସହିତ support ticket ଉଠାନ୍ତୁ।"),
    ("ମୁଁ live stream କିପରି ଆରମ୍ଭ କରିବି?",
     "dashboard ରୁ Go Live ଉପରେ ଟାପ୍ କରନ୍ତୁ। web app ରେ ଆପଣ ପ୍ରଥମେ Start Camera ଟାପ୍ କରିବେ (browser camera access ମାଗିବ), ତାପରେ Go Live। ଆପଣ ଦର୍ଶକମାନଙ୍କୁ ଉତ୍ତର ଦେଇପାରିବେ, ଯେଉଁ ପ୍ରଶ୍ନର ଉତ୍ତର ଦେଉଛନ୍ତି ତାହାକୁ pin କରିପାରିବେ, ଏବଂ gifting goal ସେଟ୍ କରିପାରିବେ।"),
    ("ମୋର rating କିପରି ଗଣନା ହୁଏ?",
     "chat, call ଏବଂ video sessions ପରେ users ଙ୍କ ଦ୍ୱାରା ଦିଆଯାଇଥିବା star ratings ର ହାରାହାରି ହିଁ ଆପଣଙ୍କ rating। ଲଗାତାର ସହାୟକ, ସମୟାନୁବର୍ତ୍ତୀ ପରାମର୍ଶ ଆପଣଙ୍କ rating ଏବଂ visibility ବଢ଼ାଏ।"),
    ("ମୁଁ ମୋର profile photo କିପରି update କରିବି?",
     "Profile କୁ ଯାଇ ନୂଆ ଫଟୋ upload କରିବାକୁ ଆପଣଙ୍କ avatar ଉପରେ ଟାପ୍ କରନ୍ତୁ। ଯଦି ଆପଣ Google ସହ sign in କରିଛନ୍ତି, ତେବେ ଆପଣ ନିଜର ଫଟୋ upload ନ କରିବା ପର୍ଯ୍ୟନ୍ତ ଆପଣଙ୍କ Google ଫଟୋ ସ୍ୱୟଂଚାଳିତ ଭାବେ ବ୍ୟବହୃତ ହୁଏ।"),
    ("ମୁଁ support ସହ କିପରି ଯୋଗାଯୋଗ କରିବି?",
     "Profile → Customer Support ଖୋଲନ୍ତୁ। ପ୍ରଥମେ FAQ ଦେଖନ୍ତୁ, ଏବଂ ତାହା ସାହାଯ୍ୟ ନ କଲେ ବିବରଣୀ ପଠାଇବାକୁ Raise Ticket ଉପରେ ଟାପ୍ କରନ୍ତୁ (ଆପଣ 2 screenshots ପର୍ଯ୍ୟନ୍ତ ଯୋଡ଼ିପାରିବେ)। status ଏବଂ replies ଆପଣ My Tickets ତଳେ track କରିପାରିବେ।"),
    ("ମୁଁ app ର ଭାଷା କିପରି ପରିବର୍ତ୍ତନ କରିବି?",
     "Profile → Language ଖୋଲନ୍ତୁ ଏବଂ ଆପଣଙ୍କ ପସନ୍ଦର ଭାଷା ବାଛନ୍ତୁ। app ତୁରନ୍ତ update ହୋଇଯାଏ।"),
    ("ପ୍ରାଇଭେସୀ, ସର୍ତ୍ତାବଳୀ ଏବଂ refund policies ମୁଁ କେଉଁଠି ପଢ଼ିପାରିବି?",
     "ସେଗୁଡ଼ିକ Profile → About & Legal ରେ ଅଛି, ଯାହା nakshatralogy.com ରେ ଥିବା Privacy Policy, Terms & Conditions ଏବଂ Refund Policy ସହ ଲିଙ୍କ କରେ।"),
]

# Hand-authored French translations.
_DEFAULT_FAQ_FR = [
    ("Comment démarrer une consultation avec un astrologue ?",
     "Ouvrez l'onglet Astrologers, choisissez un astrologue en ligne (Online), puis sélectionnez Chat, Call ou Video. Avant de commencer, assurez-vous que votre wallet contient assez de solde pour au moins quelques minutes — le tarif est affiché sur la fiche de chaque astrologue avant que vous ne commenciez."),
    ("Comment fonctionne la facturation du wallet ?",
     "Vous ajoutez de l'argent à votre wallet, et les consultations y sont débitées. Pour les services facturés à la minute, un montant est brièvement bloqué au début et le montant exact est prélevé à la fin de la session. Tout montant bloqué non utilisé est automatiquement libéré."),
    ("De l'argent a été débité mais la session n'a pas démarré",
     "Les montants bloqués sont libérés automatiquement si une session ne démarre jamais (par exemple si l'astrologue n'a pas répondu). Si le solde ne revient pas en quelques minutes, ouvrez un ticket de support avec la date et l'heure, et nous vérifierons."),
    ("Comment ajouter de l'argent à mon wallet ?",
     "Allez dans l'onglet Wallet, appuyez sur Add Money, choisissez un montant et finalisez le paiement. Votre solde est mis à jour instantanément dès que le paiement réussit."),
    ("Mon appel ne se connecte pas",
     "Vérifiez votre connexion internet et assurez-vous que l'application dispose des autorisations micro et caméra. Sur l'application web, autorisez le micro/la caméra lorsque le navigateur le demande. Si l'astrologue ne répond pas dans les 60 secondes, l'appel est automatiquement annulé et vous n'êtes pas facturé."),
    ("Puis-je être remboursé pour une mauvaise consultation ?",
     "Si une session a rencontré un véritable problème technique (appel non connecté, astrologue n'ayant pas répondu), ouvrez un ticket de support avec les détails et notre équipe l'examinera. Consultez notre politique de remboursement dans Profile → About & Legal."),
    ("Je ne reçois pas de notifications",
     "Ouvrez Profile → Notifications et assurez-vous qu'elles sont activées. Sur l'application web, autorisez les notifications dans votre navigateur (sur iPhone, ajoutez d'abord l'application à l'écran d'accueil). Si vous vous êtes récemment déconnecté puis reconnecté, activer/désactiver une fois les notifications rafraîchit votre appareil."),
    ("Quelle est la précision du Kundli et des rapports ?",
     "Les cartes et rapports sont générés à partir de calculs astronomiques védiques précis, en utilisant votre date, heure et lieu de naissance exacts — merci donc de saisir vos informations de naissance aussi précisément que possible pour de meilleurs résultats."),
    ("Comment fonctionnent les cadeaux et les super-chats en direct ?",
     "Pendant un live, vous pouvez envoyer des cadeaux ou un super-chat payant à l'astrologue ; le montant est débité de votre wallet. Les super-chats sont épinglés afin que l'astrologue les voie bien en évidence."),
    ("Comment changer mes informations de naissance ?",
     "Ouvrez votre Kundli/profil, modifiez la date, l'heure et le lieu de naissance, puis enregistrez — vos cartes et rapports seront recalculés automatiquement."),
    ("Combien de temps prend l'approbation ?",
     "Une fois vos informations personnelles, professionnelles et votre KYC complétés, notre équipe examine votre candidature. Vous recevrez une notification et un e-mail dès que vous serez approuvé ou si une correction est nécessaire."),
    ("Ma candidature a été rejetée — que dois-je faire ?",
     "Ouvrez l'application : le tableau de bord indique précisément quelle section nécessite une correction (KYC, informations personnelles ou professionnelles). Corrigez la section signalée et soumettez à nouveau — modifier votre profil l'envoie automatiquement en révision."),
    ("De quels documents ai-je besoin pour le KYC ?",
     "Téléchargez une pièce d'identité gouvernementale claire et valide (et tout certificat professionnel demandé). Assurez-vous que la photo n'est pas floue, que les informations correspondent à votre profil et que le document n'est pas expiré."),
    ("Je ne reçois pas de demandes d'appel/chat",
     "Assurez-vous d'être en statut Online via le bouton du tableau de bord et que les notifications sont activées dans Profile. Gardez l'application ouverte, ou installez l'application web sur votre écran d'accueil, pour une livraison fiable. Les nouvelles demandes apparaissent aussi sous l'icône cloche."),
    ("Comment et quand suis-je payé ?",
     "Vos gains de chaque consultation sont crédités sur votre wallet après la commission de la plateforme. Vous pouvez retirer vers votre banque depuis l'écran Wallet ; le règlement bancaire suit les délais de votre prestataire de paiement."),
    ("Mon retrait a réussi mais je ne vois pas le montant sur mon compte bancaire",
     "Le règlement bancaire peut prendre un certain temps selon votre prestataire. Votre registre de wallet affiche le débit immédiatement ; si le registre ne le reflète pas, ouvrez un ticket de support avec la référence et l'heure."),
    ("Comment démarrer un live ?",
     "Depuis le tableau de bord, appuyez sur Go Live. Sur l'application web, vous appuierez d'abord sur Start Camera (le navigateur demandera l'accès à la caméra), puis sur Go Live. Vous pouvez répondre aux spectateurs, épingler la question à laquelle vous répondez, et définir un objectif de cadeaux."),
    ("Comment ma note est-elle calculée ?",
     "Votre note est la moyenne des évaluations en étoiles laissées par les utilisateurs après les sessions de chat, d'appel et de vidéo. Des consultations utiles et ponctuelles de manière constante améliorent votre note et votre visibilité."),
    ("Comment mettre à jour ma photo de profil ?",
     "Allez dans Profile et appuyez sur votre avatar pour télécharger une nouvelle photo. Si vous vous êtes connecté avec Google, votre photo Google est utilisée automatiquement jusqu'à ce que vous téléchargiez la vôtre."),
    ("Comment contacter le support ?",
     "Ouvrez Profile → Customer Support. Consultez d'abord la FAQ, et si cela ne vous aide pas, appuyez sur Raise Ticket pour nous envoyer les détails (vous pouvez joindre jusqu'à 2 captures d'écran). Vous pouvez suivre le statut et les réponses sous My Tickets."),
    ("Comment changer la langue de l'application ?",
     "Ouvrez Profile → Language et choisissez votre langue préférée. L'application se met à jour immédiatement."),
    ("Où puis-je lire les politiques de confidentialité, les conditions générales et de remboursement ?",
     "Elles se trouvent dans Profile → About & Legal, qui renvoie vers la politique de confidentialité, les conditions générales et la politique de remboursement sur nakshatralogy.com."),
]

# Hand-authored Chinese (Simplified) translations.
_DEFAULT_FAQ_ZH = [
    ("我如何开始与占星师的咨询？",
     "打开 Astrologers 标签页，选择一位显示 Online 的占星师，然后选择 Chat、Call 或 Video。开始之前，请确保您的 wallet 中至少有几分钟的余额 — 费率会在每位占星师的卡片上提前显示。"),
    ("Wallet 计费是如何运作的？",
     "您向 wallet 中充值，咨询费用会从中扣除。对于按分钟计费的服务，开始时会短暂冻结一定金额，会话结束时结算准确费用。未使用的冻结金额会自动退还。"),
    ("扣款了但会话没有开始",
     "如果会话从未开始（例如占星师没有应答），冻结的金额会自动退还。如果几分钟内余额没有恢复，请提交包含日期和时间的支持工单，我们会进行核查。"),
    ("我如何给我的 wallet 充值？",
     "进入 Wallet 标签页，点击 Add Money，选择金额并完成支付。支付成功后您的余额会立即更新。"),
    ("我的通话无法连接",
     "请检查您的网络连接，并确认应用已获得麦克风和摄像头权限。在网页版应用中，当浏览器询问时请允许麦克风/摄像头权限。如果占星师在 60 秒内未应答，通话会自动取消，您不会被扣费。"),
    ("咨询体验不好，我能获得退款吗？",
     "如果会话确实存在技术问题（通话未连接、占星师未响应），请提交包含详情的支持工单，我们的团队会进行审核。请在 Profile → About & Legal 中查看我们的退款政策。"),
    ("我收不到通知",
     "打开 Profile → Notifications 并确认已启用。在网页版应用中，请在浏览器中允许通知（在 iPhone 上，请先将应用添加到主屏幕）。如果您最近注销后重新登录，切换一次通知开关可以刷新您的设备。"),
    ("Kundli 和报告的准确性如何？",
     "图表和报告是根据您准确的出生日期、时间和地点，通过精确的吠陀天文计算生成的 — 因此为了获得最佳结果，请尽可能准确地填写您的出生信息。"),
    ("直播中的礼物和 super-chat 是如何运作的？",
     "在直播期间，您可以向占星师发送礼物或付费 super-chat；金额会从您的 wallet 中扣除。Super-chat 会被置顶，方便占星师醒目地看到。"),
    ("我如何更改我的出生信息？",
     "打开您的 Kundli/个人资料，编辑出生日期、时间和地点并保存 — 您的图表和报告将自动重新计算。"),
    ("审核批准需要多长时间？",
     "在您完成个人信息、专业信息和 KYC 后，我们的团队会审核您的申请。一旦获得批准或需要更正，您将收到通知和电子邮件。"),
    ("我的申请被拒绝了，我该怎么办？",
     "打开应用：仪表盘会准确显示哪个部分需要更正（KYC、个人信息或专业信息）。修正标记的部分并重新提交 — 编辑资料后会自动重新提交审核。"),
    ("KYC 需要哪些文件？",
     "请上传一份清晰、有效的政府身份证件（如有要求，还需提供专业证书）。请确保照片不模糊，信息与您的资料一致，且证件未过期。"),
    ("我收不到通话/聊天请求",
     "请使用仪表盘上的开关将自己设为 Online，并确保 Profile 中的通知已启用。为确保可靠送达，请保持应用开启，或将网页版应用安装到主屏幕。新请求也会出现在铃铛图标下方。"),
    ("我如何以及何时获得付款？",
     "每次咨询的收入在扣除平台佣金后会存入您的 wallet。您可以从 Wallet 界面提现到银行；银行到账时间取决于您的支付服务商的时间安排。"),
    ("提现成功了，但我的银行账户没有看到金额",
     "银行到账可能需要一些时间，具体取决于您的服务商。您的 wallet 账本会立即显示扣款；如果账本中未反映，请提交包含参考号和时间的支持工单。"),
    ("我如何开始直播？",
     "从仪表盘点击 Go Live。在网页版应用中，您需要先点击 Start Camera（浏览器会请求摄像头权限），然后点击 Go Live。您可以回复观众，置顶您正在回答的问题，并设置送礼目标。"),
    ("我的评分是如何计算的？",
     "您的评分是用户在聊天、通话和视频会话后给出的星级评分的平均值。持续提供有帮助且准时的咨询会提高您的评分和曝光度。"),
    ("我如何更新我的个人资料照片？",
     "进入 Profile，点击您的头像上传新照片。如果您使用 Google 登录，在您上传自己的照片之前，会自动使用您的 Google 照片。"),
    ("我如何联系客服？",
     "打开 Profile → Customer Support。请先查看 FAQ，如果没有帮助，点击 Raise Ticket 将详情发送给我们（最多可附加 2 张截图）。您可以在 My Tickets 中跟踪状态和回复。"),
    ("我如何更改应用语言？",
     "打开 Profile → Language 并选择您偏好的语言。应用会立即更新。"),
    ("我在哪里可以阅读隐私政策、条款和退款政策？",
     "它们都在 Profile → About & Legal 中，会链接到 nakshatralogy.com 上的隐私政策、条款与条件以及退款政策。"),
]

# Hand-authored Thai translations.
_DEFAULT_FAQ_TH = [
    ("ฉันจะเริ่มปรึกษานักโหราศาสตร์ได้อย่างไร?",
     "เปิดแท็บ Astrologers เลือกนักโหราศาสตร์ที่แสดงสถานะ Online แล้วเลือก Chat, Call หรือ Video ก่อนเริ่มต้น โปรดตรวจสอบให้แน่ใจว่า wallet ของคุณมียอดคงเหลือเพียงพอสำหรับอย่างน้อยสองสามนาที — อัตราค่าบริการจะแสดงไว้ล่วงหน้าบนการ์ดของนักโหราศาสตร์แต่ละคน"),
    ("การเรียกเก็บเงินจาก wallet ทำงานอย่างไร?",
     "คุณเติมเงินเข้า wallet และค่าปรึกษาจะถูกหักจากยอดนั้น สำหรับบริการที่คิดค่าบริการต่อนาที จะมีการกันเงินจำนวนหนึ่งไว้ชั่วคราวตอนเริ่มต้น และจะคิดค่าใช้จ่ายที่แท้จริงเมื่อ session สิ้นสุดลง จำนวนเงินที่ถูกกันไว้แต่ไม่ได้ใช้จะถูกปล่อยคืนโดยอัตโนมัติ"),
    ("เงินถูกหักแต่ session ไม่ได้เริ่มต้น",
     "หาก session ไม่เคยเริ่มต้นเลย (เช่น นักโหราศาสตร์ไม่ตอบรับ) จำนวนเงินที่ถูกกันไว้จะถูกคืนโดยอัตโนมัติ หากยอดเงินไม่กลับคืนภายในไม่กี่นาที ให้แจ้ง support ticket พร้อมวันที่และเวลา เราจะตรวจสอบให้"),
    ("ฉันจะเติมเงินเข้า wallet ได้อย่างไร?",
     "ไปที่แท็บ Wallet แตะ Add Money เลือกจำนวนเงิน แล้วทำการชำระเงินให้เสร็จสิ้น ยอดคงเหลือของคุณจะอัปเดตทันทีเมื่อการชำระเงินสำเร็จ"),
    ("การโทรของฉันเชื่อมต่อไม่ได้",
     "ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตของคุณ และตรวจสอบว่าแอปได้รับสิทธิ์เข้าถึงไมโครโฟนและกล้อง บนเว็บแอป ให้อนุญาตไมค์/กล้องเมื่อเบราว์เซอร์ถาม หากนักโหราศาสตร์ไม่ตอบรับภายใน 60 วินาที การโทรจะถูกยกเลิกโดยอัตโนมัติและคุณจะไม่ถูกเรียกเก็บเงิน"),
    ("ฉันจะได้รับเงินคืนสำหรับการปรึกษาที่ไม่ดีหรือไม่?",
     "หาก session มีปัญหาทางเทคนิคจริง (การโทรไม่เชื่อมต่อ นักโหราศาสตร์ไม่ตอบสนอง) ให้แจ้ง support ticket พร้อมรายละเอียด ทีมงานของเราจะตรวจสอบ ดูนโยบายการคืนเงินของเราได้ที่ Profile → About & Legal"),
    ("ฉันไม่ได้รับการแจ้งเตือน",
     "เปิด Profile → Notifications และตรวจสอบว่าเปิดใช้งานอยู่ บนเว็บแอป ให้อนุญาตการแจ้งเตือนในเบราว์เซอร์ของคุณ (บน iPhone ให้เพิ่มแอปไปที่หน้าจอหลักก่อน) หากคุณเพิ่งออกจากระบบแล้วเข้าสู่ระบบใหม่ การสลับการแจ้งเตือนครั้งเดียวจะรีเฟรชอุปกรณ์ของคุณ"),
    ("Kundli และรายงานมีความแม่นยำแค่ไหน?",
     "แผนภูมิและรายงานถูกสร้างขึ้นจากการคำนวณทางโหราศาสตร์เวทที่แม่นยำ โดยใช้วันเกิด เวลา และสถานที่เกิดที่ถูกต้องของคุณ — ดังนั้นโปรดกรอกข้อมูลการเกิดของคุณให้แม่นยำที่สุดเพื่อผลลัพธ์ที่ดีที่สุด"),
    ("ของขวัญและ super-chat ใน live stream ทำงานอย่างไร?",
     "ระหว่างการไลฟ์สตรีม คุณสามารถส่งของขวัญหรือ super-chat แบบชำระเงินให้กับนักโหราศาสตร์ได้ จำนวนเงินจะถูกหักจาก wallet ของคุณ super-chat จะถูกปักหมุดไว้เพื่อให้นักโหราศาสตร์เห็นได้อย่างชัดเจน"),
    ("ฉันจะเปลี่ยนรายละเอียดวันเกิดของฉันได้อย่างไร?",
     "เปิด Kundli/โปรไฟล์ของคุณ แก้ไขวันเกิด เวลา และสถานที่ แล้วบันทึก — แผนภูมิและรายงานของคุณจะคำนวณใหม่โดยอัตโนมัติ"),
    ("การอนุมัติใช้เวลานานเท่าไหร่?",
     "หลังจากที่คุณกรอกข้อมูลส่วนตัว ข้อมูลอาชีพ และ KYC ครบถ้วนแล้ว ทีมงานของเราจะตรวจสอบใบสมัครของคุณ คุณจะได้รับการแจ้งเตือนและอีเมลเมื่อได้รับการอนุมัติหรือหากต้องมีการแก้ไข"),
    ("ใบสมัครของฉันถูกปฏิเสธ — ฉันควรทำอย่างไร?",
     "เปิดแอป: แดชบอร์ดจะแสดงอย่างชัดเจนว่าส่วนใดต้องแก้ไข (KYC ข้อมูลส่วนตัว หรือข้อมูลอาชีพ) แก้ไขส่วนที่ถูกทำเครื่องหมายแล้วส่งใหม่ — การแก้ไขโปรไฟล์จะส่งกลับไปตรวจสอบใหม่โดยอัตโนมัติ"),
    ("ฉันต้องใช้เอกสารอะไรบ้างสำหรับ KYC?",
     "อัปโหลดบัตรประจำตัวประชาชนที่ออกโดยรัฐบาลที่ชัดเจนและยังไม่หมดอายุ (และใบรับรองวิชาชีพใดๆ หากมีการร้องขอ) ตรวจสอบให้แน่ใจว่ารูปภาพไม่เบลอ รายละเอียดตรงกับโปรไฟล์ของคุณ และเอกสารยังไม่หมดอายุ"),
    ("ฉันไม่ได้รับคำขอโทร/แชท",
     "ตรวจสอบให้แน่ใจว่าคุณตั้งค่าเป็น Online โดยใช้ปุ่มสลับในแดชบอร์ด และเปิดใช้งานการแจ้งเตือนใน Profile เปิดแอปทิ้งไว้ หรือติดตั้งเว็บแอปไปที่หน้าจอหลักเพื่อให้ได้รับข้อมูลอย่างน่าเชื่อถือ คำขอใหม่จะปรากฏใต้ไอคอนกระดิ่งด้วย"),
    ("ฉันจะได้รับเงินอย่างไรและเมื่อไหร่?",
     "รายได้ของคุณจากการปรึกษาแต่ละครั้งจะถูกโอนเข้า wallet ของคุณหลังจากหักค่าคอมมิชชันของแพลตฟอร์มแล้ว คุณสามารถถอนเงินเข้าธนาคารได้จากหน้าจอ Wallet การโอนเข้าธนาคารจะเป็นไปตามกำหนดเวลาของผู้ให้บริการชำระเงินของคุณ"),
    ("การถอนเงินของฉันสำเร็จแล้วแต่ฉันไม่เห็นยอดเงินในบัญชีธนาคาร",
     "การโอนเข้าธนาคารอาจใช้เวลาสักครู่ขึ้นอยู่กับผู้ให้บริการของคุณ บัญชี wallet ของคุณจะแสดงรายการหักบัญชีทันที หากไม่ปรากฏในบัญชี ให้แจ้ง support ticket พร้อมหมายเลขอ้างอิงและเวลา"),
    ("ฉันจะเริ่มไลฟ์สตรีมได้อย่างไร?",
     "จากแดชบอร์ด แตะ Go Live บนเว็บแอป คุณจะแตะ Start Camera ก่อน (เบราว์เซอร์จะขอสิทธิ์เข้าถึงกล้อง) จากนั้นแตะ Go Live คุณสามารถตอบกลับผู้ชม ปักหมุดคำถามที่คุณกำลังตอบ และตั้งเป้าหมายการรับของขวัญได้"),
    ("คะแนนของฉันคำนวณอย่างไร?",
     "คะแนนของคุณคือค่าเฉลี่ยของคะแนนดาวที่ผู้ใช้ให้หลังจาก session แชท โทร และวิดีโอ การให้คำปรึกษาที่เป็นประโยชน์และตรงเวลาอย่างสม่ำเสมอจะช่วยเพิ่มคะแนนและการมองเห็นของคุณ"),
    ("ฉันจะอัปเดตรูปโปรไฟล์ของฉันได้อย่างไร?",
     "ไปที่ Profile แล้วแตะที่อวาตาร์ของคุณเพื่ออัปโหลดรูปใหม่ หากคุณลงชื่อเข้าใช้ด้วย Google รูปภาพ Google ของคุณจะถูกใช้โดยอัตโนมัติจนกว่าคุณจะอัปโหลดรูปของคุณเอง"),
    ("ฉันจะติดต่อฝ่ายสนับสนุนได้อย่างไร?",
     "เปิด Profile → Customer Support ตรวจสอบ FAQ ก่อน และหากไม่ช่วยแก้ปัญหา ให้แตะ Raise Ticket เพื่อส่งรายละเอียดถึงเรา (คุณสามารถแนบภาพหน้าจอได้สูงสุด 2 ภาพ) คุณสามารถติดตามสถานะและการตอบกลับได้ที่ My Tickets"),
    ("ฉันจะเปลี่ยนภาษาของแอปได้อย่างไร?",
     "เปิด Profile → Language แล้วเลือกภาษาที่คุณต้องการ แอปจะอัปเดตทันที"),
    ("ฉันจะอ่านนโยบายความเป็นส่วนตัว ข้อกำหนด และนโยบายการคืนเงินได้ที่ไหน?",
     "อยู่ใน Profile → About & Legal ซึ่งเชื่อมโยงไปยังนโยบายความเป็นส่วนตัว ข้อกำหนดและเงื่อนไข และนโยบายการคืนเงินบน nakshatralogy.com"),
]

# Pre-translated sets keyed by canonical language. English is the source.
_DEFAULT_FAQ_ES = [
    ("¿Cómo empiezo una consulta con un astrólogo?",
     "Abre la pestaña Astrologers, elige un astrólogo que esté Online y selecciona Chat, Call o Video. Antes de comenzar, asegúrate de que tu wallet tenga saldo suficiente para al menos unos minutos — la tarifa se muestra en la tarjeta de cada astrólogo antes de empezar."),
    ("¿Cómo funciona la facturación del wallet?",
     "Agregas dinero a tu wallet y las consultas se cobran de ahí. En los servicios por minuto se bloquea brevemente un monto al inicio y el cargo exacto se calcula cuando termina la sesión. Cualquier monto bloqueado que no se use se libera automáticamente."),
    ("Se descontó dinero pero la sesión no comenzó",
     "Los montos bloqueados se liberan automáticamente si una sesión nunca llega a comenzar (por ejemplo, si el astrólogo no respondió). Si el saldo no regresa en unos minutos, abre un ticket de soporte con la fecha y la hora y lo revisaremos."),
    ("¿Cómo agrego dinero a mi wallet?",
     "Ve a la pestaña Wallet, toca Add Money, elige un monto y completa el pago. Tu saldo se actualiza al instante en cuanto el pago se realiza con éxito."),
    ("Mi llamada no se conecta",
     "Revisa tu conexión a internet y asegúrate de que la app tenga permisos de micrófono y cámara. En la web app, permite el micrófono/cámara cuando el navegador lo solicite. Si el astrólogo no responde en 60 segundos, la llamada se cancela automáticamente y no se te cobra nada."),
    ("¿Puedo obtener un reembolso por una mala consulta?",
     "Si una sesión tuvo un problema técnico real (la llamada no se conectó, el astrólogo no respondió), abre un ticket de soporte con los detalles y nuestro equipo lo revisará. Consulta nuestra política de reembolsos en Profile → About & Legal."),
    ("No estoy recibiendo notificaciones",
     "Abre Profile → Notifications y asegúrate de que estén activadas. En la web app, permite las notificaciones en tu navegador (en iPhone, primero agrega la app a la pantalla de inicio). Si cerraste sesión y volviste a entrar hace poco, activar y desactivar las notificaciones una vez actualiza tu dispositivo."),
    ("¿Qué tan precisos son el Kundli y los informes?",
     "Las cartas y los informes se generan a partir de cálculos astronómicos védicos precisos usando tu fecha, hora y lugar de nacimiento exactos — así que ingresa tus datos de nacimiento con la mayor precisión posible para obtener los mejores resultados."),
    ("¿Cómo funcionan los regalos y los super-chats en las transmisiones en vivo?",
     "Durante una transmisión en vivo puedes enviar regalos o un super-chat de pago al astrólogo; el monto se descuenta de tu wallet. Los super-chats se fijan (pin) para que el astrólogo los vea de forma destacada."),
    ("¿Cómo cambio mis datos de nacimiento?",
     "Abre tu Kundli/perfil, edita la fecha, hora y lugar de nacimiento, y guarda — tus cartas e informes se recalcularán automáticamente."),
    ("¿Cuánto tarda la aprobación?",
     "Después de completar tus datos personales, datos profesionales y el KYC, nuestro equipo revisa tu solicitud. Recibirás una notificación y un correo en cuanto seas aprobado o si algo necesita corrección."),
    ("Mi solicitud fue rechazada, ¿qué hago?",
     "Abre la app: el panel muestra exactamente qué sección necesita corrección (KYC, datos personales o profesionales). Corrige la sección marcada y vuelve a enviarla — al editar tu perfil se reenvía automáticamente para revisión."),
    ("¿Qué documentos necesito para el KYC?",
     "Sube una identificación oficial vigente y legible (y algún certificado profesional si se solicita). Asegúrate de que la foto no esté borrosa, de que los datos coincidan con tu perfil y de que el documento no esté vencido."),
    ("No estoy recibiendo solicitudes de llamada/chat",
     "Asegúrate de estar en estado Online usando el interruptor del panel y de tener las notificaciones activadas en Profile. Mantén la app abierta, o instala la web app en tu pantalla de inicio, para una entrega confiable. Las nuevas solicitudes también aparecen bajo el ícono de campana."),
    ("¿Cómo y cuándo me pagan?",
     "Tus ganancias de cada consulta se acreditan en tu wallet después de la comisión de la plataforma. Puedes retirar a tu banco desde la pantalla Wallet; la liquidación bancaria sigue los tiempos de tu proveedor de pagos."),
    ("Mi retiro fue exitoso pero no veo el monto en mi banco",
     "La liquidación bancaria puede tardar algo de tiempo según tu proveedor. El registro de tu wallet muestra el débito de inmediato; si el registro no lo refleja, abre un ticket de soporte con la referencia y la hora."),
    ("¿Cómo inicio una transmisión en vivo?",
     "Desde el panel, toca Go Live. En la web app primero tocarás Start Camera (tu navegador pedirá acceso a la cámara) y luego Go Live. Puedes responder a los espectadores, fijar una pregunta que estés contestando y establecer una meta de regalos."),
    ("¿Cómo se calcula mi calificación?",
     "Tu calificación es el promedio de las estrellas que los usuarios dejan después de las sesiones de chat, llamada y video. Las consultas útiles y puntuales de forma constante mejoran tu calificación y tu visibilidad."),
    ("¿Cómo actualizo mi foto de perfil?",
     "Ve a Profile y toca tu avatar para subir una nueva foto. Si iniciaste sesión con Google, tu foto de Google se usa automáticamente hasta que subas la tuya."),
    ("¿Cómo contacto a soporte?",
     "Abre Profile → Customer Support. Revisa primero las FAQ, y si no te ayudan, toca Raise Ticket para enviarnos los detalles (puedes adjuntar hasta 2 capturas de pantalla). Puedes seguir el estado y las respuestas en My Tickets."),
    ("¿Cómo cambio el idioma de la app?",
     "Abre Profile → Language y elige tu idioma preferido. La app se actualiza de inmediato."),
    ("¿Dónde puedo leer las políticas de privacidad, términos y reembolsos?",
     "Están en Profile → About & Legal, que enlaza a la Política de Privacidad, los Términos y Condiciones, y la Política de Reembolsos en nakshatralogy.com."),
]

_DEFAULT_FAQ_PT = [
    ("Como eu começo uma consulta com um astrólogo?",
     "Abra a aba Astrologers, escolha um astrólogo que esteja Online e selecione Chat, Call ou Video. Antes de começar, garanta que sua wallet tenha saldo suficiente para pelo menos alguns minutos — a tarifa é mostrada no card de cada astrólogo antes de você iniciar."),
    ("Como funciona a cobrança da wallet?",
     "Você adiciona dinheiro à sua wallet, e as consultas são cobradas a partir dela. Nos serviços por minuto, um valor fica bloqueado por pouco tempo no início e a cobrança exata é feita quando a sessão termina. Qualquer valor bloqueado não utilizado é liberado automaticamente."),
    ("O dinheiro foi debitado, mas a sessão não começou",
     "Os valores bloqueados são liberados automaticamente se uma sessão nunca chega a começar (por exemplo, o astrólogo não atendeu). Se o saldo não voltar em alguns minutos, abra um chamado de suporte com a data e o horário e vamos verificar."),
    ("Como adiciono dinheiro à minha wallet?",
     "Vá até a aba Wallet, toque em Add Money, escolha um valor e finalize o pagamento. Seu saldo é atualizado instantaneamente assim que o pagamento é aprovado."),
    ("Minha chamada não está conectando",
     "Verifique sua conexão com a internet e confirme se o app tem permissão de microfone e câmera. No web app, permita o microfone/câmera quando o navegador solicitar. Se o astrólogo não atender em 60 segundos, a chamada é cancelada automaticamente e você não é cobrado."),
    ("Posso receber reembolso por uma consulta ruim?",
     "Se uma sessão teve um problema técnico real (a chamada não conectou, o astrólogo não respondeu), abra um chamado de suporte com os detalhes e nossa equipe vai analisar. Confira nossa Política de Reembolso em Profile → About & Legal."),
    ("Não estou recebendo notificações",
     "Abra Profile → Notifications e confirme se estão ativadas. No web app, permita as notificações no seu navegador (no iPhone, primeiro adicione o app à tela de início). Se você saiu e entrou novamente na conta há pouco tempo, ativar e desativar as notificações uma vez atualiza o seu dispositivo."),
    ("Quão precisos são o Kundli e os relatórios?",
     "Os mapas e relatórios são gerados a partir de cálculos astronômicos védicos precisos, usando sua data, horário e local de nascimento exatos — por isso, informe seus dados de nascimento da forma mais precisa possível para obter os melhores resultados."),
    ("Como funcionam os presentes e os super-chats nas transmissões ao vivo?",
     "Durante uma transmissão ao vivo, você pode enviar presentes ou um super-chat pago ao astrólogo; o valor é debitado da sua wallet. Os super-chats ficam fixados para que o astrólogo os veja com destaque."),
    ("Como eu altero meus dados de nascimento?",
     "Abra seu Kundli/perfil, edite a data, o horário e o local de nascimento, e salve — seus mapas e relatórios serão recalculados automaticamente."),
    ("Quanto tempo leva a aprovação?",
     "Depois que você completa seus dados pessoais, dados profissionais e o KYC, nossa equipe analisa sua candidatura. Você receberá uma notificação e um e-mail assim que for aprovado ou se algo precisar ser corrigido."),
    ("Minha candidatura foi rejeitada — o que eu faço?",
     "Abra o app: o painel mostra exatamente qual seção precisa de correção (KYC, dados pessoais ou profissionais). Corrija a seção sinalizada e reenvie — ao editar seu perfil, ele é enviado automaticamente de volta para análise."),
    ("Quais documentos eu preciso para o KYC?",
     "Envie um documento de identidade oficial válido e nítido (e algum certificado profissional, se solicitado). Confirme que a foto não está borrada, que os dados batem com seu perfil e que o documento não está vencido."),
    ("Não estou recebendo pedidos de chamada/chat",
     "Confirme que você está com o status Online no painel e que as notificações estão ativadas em Profile. Mantenha o app aberto, ou instale o web app na tela de início, para garantir o recebimento. Novos pedidos também aparecem no ícone de sino."),
    ("Como e quando eu recebo meus pagamentos?",
     "Seus ganhos de cada consulta são creditados na sua wallet depois da comissão da plataforma. Você pode sacar para o seu banco pela tela Wallet; a liquidação bancária segue os prazos do seu provedor de pagamento."),
    ("Meu saque foi concluído, mas não vejo o valor no meu banco",
     "A liquidação bancária pode levar algum tempo, dependendo do seu provedor. O extrato da sua wallet mostra o débito imediatamente; se o extrato não refletir isso, abra um chamado de suporte com a referência e o horário."),
    ("Como eu inicio uma transmissão ao vivo?",
     "No painel, toque em Go Live. No web app, você vai tocar primeiro em Start Camera (o navegador vai pedir acesso à câmera) e depois em Go Live. Você pode responder aos espectadores, fixar a pergunta que está respondendo e definir uma meta de presentes."),
    ("Como minha avaliação é calculada?",
     "Sua avaliação é a média das notas em estrelas que os usuários deixam depois das sessões de chat, chamada e vídeo. Consultas úteis e pontuais de forma constante melhoram sua avaliação e sua visibilidade."),
    ("Como eu atualizo minha foto de perfil?",
     "Vá em Profile e toque no seu avatar para enviar uma nova foto. Se você entrou com o Google, sua foto do Google é usada automaticamente até que você envie a sua própria."),
    ("Como eu entro em contato com o suporte?",
     "Abra Profile → Customer Support. Confira primeiro as FAQ e, se não resolver, toque em Raise Ticket para nos enviar os detalhes (você pode anexar até 2 capturas de tela). Você pode acompanhar o status e as respostas em My Tickets."),
    ("Como eu mudo o idioma do app?",
     "Abra Profile → Language e escolha seu idioma preferido. O app é atualizado imediatamente."),
    ("Onde posso ler as políticas de privacidade, termos e reembolso?",
     "Elas estão em Profile → About & Legal, que leva à Política de Privacidade, aos Termos e Condições, e à Política de Reembolso em nakshatralogy.com."),
]

_DEFAULT_FAQ_DE = [
    ("Wie starte ich eine Beratung mit einem Astrologen?",
     "Öffnen Sie den Tab Astrologers, wählen Sie einen Astrologen, der als Online angezeigt wird, und wählen Sie Chat, Call oder Video. Stellen Sie vor dem Start sicher, dass Ihr Wallet genügend Guthaben für mindestens ein paar Minuten hat — der Preis wird auf der Karte jedes Astrologen angezeigt, bevor Sie beginnen."),
    ("Wie funktioniert die Abrechnung über das Wallet?",
     "Sie laden Ihr Wallet auf, und Beratungen werden davon abgebucht. Bei Diensten mit Abrechnung pro Minute wird zu Beginn kurz ein Betrag reserviert, und die genaue Gebühr wird am Ende der Sitzung abgerechnet. Nicht genutzte reservierte Beträge werden automatisch wieder freigegeben."),
    ("Es wurde Geld abgebucht, aber die Sitzung hat nicht begonnen",
     "Reservierte Beträge werden automatisch freigegeben, wenn eine Sitzung nie startet (z. B. wenn der Astrologe nicht geantwortet hat). Falls das Guthaben nicht innerhalb weniger Minuten zurückkommt, erstellen Sie ein Support-Ticket mit Datum und Uhrzeit, und wir prüfen es."),
    ("Wie lade ich Geld in mein Wallet?",
     "Gehen Sie zum Tab Wallet, tippen Sie auf Add Money, wählen Sie einen Betrag und schließen Sie die Zahlung ab. Ihr Guthaben wird sofort aktualisiert, sobald die Zahlung erfolgreich war."),
    ("Mein Anruf verbindet sich nicht",
     "Überprüfen Sie Ihre Internetverbindung und stellen Sie sicher, dass die App Zugriff auf Mikrofon und Kamera hat. In der Web-App erlauben Sie Mikrofon/Kamera, wenn der Browser danach fragt. Antwortet der Astrologe nicht innerhalb von 60 Sekunden, wird der Anruf automatisch abgebrochen, und es wird Ihnen nichts berechnet."),
    ("Kann ich eine Rückerstattung für eine schlechte Beratung erhalten?",
     "Gab es bei einer Sitzung ein echtes technisches Problem (Anruf kam nicht zustande, Astrologe hat nicht geantwortet), erstellen Sie ein Support-Ticket mit den Details, und unser Team prüft den Fall. Unsere Rückerstattungsrichtlinie finden Sie unter Profile → About & Legal."),
    ("Ich erhalte keine Benachrichtigungen",
     "Öffnen Sie Profile → Notifications und stellen Sie sicher, dass sie aktiviert sind. In der Web-App erlauben Sie Benachrichtigungen in Ihrem Browser (fügen Sie auf dem iPhone die App zuerst zum Home-Bildschirm hinzu). Wenn Sie sich kürzlich ab- und wieder angemeldet haben, aktualisiert einmaliges Ein- und Ausschalten der Benachrichtigungen Ihr Gerät."),
    ("Wie genau sind das Kundli und die Berichte?",
     "Karten und Berichte werden anhand präziser vedisch-astronomischer Berechnungen erstellt, basierend auf Ihrem genauen Geburtsdatum, Ihrer Geburtszeit und Ihrem Geburtsort — geben Sie Ihre Geburtsdaten daher bitte so genau wie möglich ein, um die besten Ergebnisse zu erzielen."),
    ("Wie funktionieren Geschenke und Super-Chats in Livestreams?",
     "Während eines Livestreams können Sie dem Astrologen Geschenke oder einen kostenpflichtigen Super-Chat senden; der Betrag wird von Ihrem Wallet abgebucht. Super-Chats werden angepinnt, damit der Astrologe sie deutlich sichtbar sieht."),
    ("Wie ändere ich meine Geburtsdaten?",
     "Öffnen Sie Ihr Kundli/Profil, bearbeiten Sie Geburtsdatum, -zeit und -ort und speichern Sie — Ihre Karten und Berichte werden automatisch neu berechnet."),
    ("Wie lange dauert die Genehmigung?",
     "Nachdem Sie Ihre persönlichen Daten, beruflichen Angaben und KYC vervollständigt haben, prüft unser Team Ihren Antrag. Sie erhalten eine Benachrichtigung und eine E-Mail, sobald Sie genehmigt wurden oder falls etwas korrigiert werden muss."),
    ("Mein Antrag wurde abgelehnt — was soll ich tun?",
     "Öffnen Sie die App: Das Dashboard zeigt genau an, welcher Bereich korrigiert werden muss (KYC, persönliche oder berufliche Angaben). Korrigieren Sie den markierten Bereich und reichen Sie ihn erneut ein — durch das Bearbeiten Ihres Profils wird es automatisch erneut zur Prüfung gesendet."),
    ("Welche Dokumente benötige ich für KYC?",
     "Laden Sie einen klaren, gültigen amtlichen Ausweis hoch (und gegebenenfalls ein berufliches Zertifikat, falls angefordert). Achten Sie darauf, dass das Foto nicht unscharf ist, die Angaben mit Ihrem Profil übereinstimmen und das Dokument nicht abgelaufen ist."),
    ("Ich erhalte keine Anruf-/Chat-Anfragen",
     "Stellen Sie sicher, dass Sie über den Schalter im Dashboard auf Online gesetzt sind und dass Benachrichtigungen in Profile aktiviert sind. Halten Sie die App geöffnet, oder installieren Sie die Web-App auf Ihrem Home-Bildschirm, um eine zuverlässige Zustellung zu gewährleisten. Neue Anfragen erscheinen außerdem unter dem Glockensymbol."),
    ("Wie und wann werde ich bezahlt?",
     "Ihre Einnahmen aus jeder Beratung werden nach Abzug der Plattformprovision Ihrem Wallet gutgeschrieben. Sie können vom Wallet-Bildschirm aus auf Ihr Bankkonto abheben; die Gutschrift auf Ihrem Konto erfolgt gemäß den Fristen Ihres Zahlungsanbieters."),
    ("Meine Auszahlung war erfolgreich, aber der Betrag erscheint nicht auf meinem Bankkonto",
     "Die Gutschrift auf dem Bankkonto kann je nach Anbieter etwas dauern. Ihr Wallet-Kontoauszug zeigt die Abbuchung sofort an; sollte dies dort nicht erscheinen, erstellen Sie ein Support-Ticket mit Referenznummer und Uhrzeit."),
    ("Wie starte ich einen Livestream?",
     "Tippen Sie im Dashboard auf Go Live. In der Web-App tippen Sie zuerst auf Start Camera (Ihr Browser fragt nach Kamerazugriff), dann auf Go Live. Sie können Zuschauern antworten, eine Frage anpinnen, die Sie gerade beantworten, und ein Geschenkeziel festlegen."),
    ("Wie wird meine Bewertung berechnet?",
     "Ihre Bewertung ist der Durchschnitt der Sternebewertungen, die Nutzer nach Chat-, Anruf- und Videositzungen abgeben. Durchgängig hilfreiche, pünktliche Beratungen verbessern Ihre Bewertung und Sichtbarkeit."),
    ("Wie aktualisiere ich mein Profilfoto?",
     "Gehen Sie zu Profile und tippen Sie auf Ihren Avatar, um ein neues Foto hochzuladen. Wenn Sie sich mit Google angemeldet haben, wird automatisch Ihr Google-Foto verwendet, bis Sie Ihr eigenes hochladen."),
    ("Wie kontaktiere ich den Support?",
     "Öffnen Sie Profile → Customer Support. Schauen Sie zuerst in die FAQ, und falls diese nicht weiterhilft, tippen Sie auf Raise Ticket, um uns die Details zu senden (Sie können bis zu 2 Screenshots anhängen). Den Status und Antworten können Sie unter My Tickets verfolgen."),
    ("Wie ändere ich die Sprache der App?",
     "Öffnen Sie Profile → Language und wählen Sie Ihre bevorzugte Sprache. Die App wird sofort aktualisiert."),
    ("Wo kann ich die Datenschutz-, Nutzungs- und Rückerstattungsrichtlinien lesen?",
     "Sie finden diese unter Profile → About & Legal, das zur Datenschutzrichtlinie, den Allgemeinen Geschäftsbedingungen und der Rückerstattungsrichtlinie auf nakshatralogy.com führt."),
]

_DEFAULT_FAQ_IT = [
    ("Come posso iniziare una consulenza con un astrologo?",
     "Apri la scheda Astrologers, scegli un astrologo che risulta Online, quindi seleziona Chat, Call o Video. Prima di iniziare, assicurati che il tuo Wallet abbia credito sufficiente per almeno qualche minuto — la tariffa è indicata sulla scheda di ogni astrologo prima che tu inizi."),
    ("Come funziona la fatturazione del Wallet?",
     "Aggiungi denaro al tuo Wallet e le consulenze vengono addebitate da lì. Per i servizi a consumo al minuto, all'inizio viene bloccato brevemente un importo e l'addebito esatto viene calcolato alla fine della sessione. Qualsiasi importo bloccato e non utilizzato viene rilasciato automaticamente."),
    ("I soldi sono stati addebitati ma la sessione non è iniziata",
     "Gli importi bloccati vengono rilasciati automaticamente se una sessione non parte mai (ad esempio se l'astrologo non risponde). Se il saldo non torna entro pochi minuti, apri un ticket di assistenza indicando data e ora e verificheremo."),
    ("Come aggiungo denaro al mio Wallet?",
     "Vai alla scheda Wallet, tocca Add Money, scegli un importo e completa il pagamento. Il tuo saldo si aggiorna istantaneamente non appena il pagamento va a buon fine."),
    ("La mia chiamata non si connette",
     "Controlla la tua connessione internet e assicurati che l'app abbia i permessi per microfono e fotocamera. Sulla web app, consenti l'accesso a microfono/fotocamera quando il browser lo richiede. Se l'astrologo non risponde entro 60 secondi, la chiamata si annulla automaticamente e non ti viene addebitato nulla."),
    ("Posso ottenere un rimborso per una consulenza insoddisfacente?",
     "Se una sessione ha avuto un problema tecnico reale (chiamata non connessa, astrologo che non ha risposto), apri un ticket di assistenza con i dettagli e il nostro team lo esaminerà. Consulta la nostra politica di rimborso in Profile → About & Legal."),
    ("Non ricevo notifiche",
     "Apri Profile → Notifications e assicurati che siano attive. Sulla web app, consenti le notifiche nel tuo browser (su iPhone, aggiungi prima l'app alla schermata Home). Se di recente hai effettuato il logout e poi il login, disattivare e riattivare una volta le notifiche aggiorna il tuo dispositivo."),
    ("Quanto sono precisi il Kundli e i report?",
     "Le carte natali e i report vengono generati tramite calcoli astronomici vedici precisi, utilizzando la tua data, ora e luogo di nascita esatti — inserisci quindi i tuoi dati di nascita nel modo più accurato possibile per ottenere i risultati migliori."),
    ("Come funzionano i regali e le super-chat nelle dirette?",
     "Durante una diretta puoi inviare regali o una super-chat a pagamento all'astrologo; l'importo viene addebitato dal tuo Wallet. Le super-chat vengono fissate in alto così l'astrologo le nota in modo evidente."),
    ("Come cambio i miei dati di nascita?",
     "Apri il tuo Kundli/profilo, modifica data, ora e luogo di nascita e salva — le tue carte natali e i report verranno ricalcolati automaticamente."),
    ("Quanto tempo richiede l'approvazione?",
     "Dopo aver completato i tuoi dati personali, i dettagli professionali e il KYC, il nostro team esamina la tua candidatura. Riceverai una notifica e un'email non appena sarai approvato, o se qualcosa richiede una correzione."),
    ("La mia candidatura è stata rifiutata — cosa devo fare?",
     "Apri l'app: la dashboard mostra esattamente quale sezione necessita di correzioni (KYC, dati personali o professionali). Correggi la sezione segnalata e invia di nuovo — modificare il tuo profilo lo rimanda automaticamente in revisione."),
    ("Quali documenti mi servono per il KYC?",
     "Carica un documento d'identità governativo chiaro e valido (e un eventuale certificato professionale, se richiesto). Assicurati che la foto non sia sfocata, che i dati corrispondano al tuo profilo e che il documento non sia scaduto."),
    ("Non ricevo richieste di chiamata/chat",
     "Assicurati di essere impostato su Online tramite l'interruttore nella dashboard e che le notifiche siano attive in Profile. Tieni l'app aperta, oppure installa la web app sulla schermata Home, per una consegna affidabile. Le nuove richieste appaiono anche sotto l'icona della campanella."),
    ("Come e quando vengo pagato?",
     "I tuoi guadagni da ogni consulenza vengono accreditati sul tuo Wallet dopo la commissione della piattaforma. Puoi prelevare sul tuo conto bancario dalla schermata Wallet; l'accredito in banca segue le tempistiche del tuo fornitore di pagamenti."),
    ("Il mio prelievo è andato a buon fine ma non vedo l'importo in banca",
     "L'accredito bancario può richiedere del tempo a seconda del fornitore. Il registro del tuo Wallet mostra subito l'addebito; se il registro non lo riflette, apri un ticket di assistenza con il riferimento e l'orario."),
    ("Come avvio una diretta?",
     "Dalla dashboard tocca Go Live. Sulla web app dovrai prima toccare Start Camera (il browser chiederà l'accesso alla fotocamera), poi Go Live. Puoi rispondere agli spettatori, fissare in alto la domanda a cui stai rispondendo e impostare un obiettivo di regali."),
    ("Come viene calcolata la mia valutazione?",
     "La tua valutazione è la media delle valutazioni a stelle lasciate dagli utenti dopo le sessioni di chat, chiamata e video. Consulenze costantemente utili e puntuali migliorano la tua valutazione e la tua visibilità."),
    ("Come aggiorno la mia foto profilo?",
     "Vai su Profile e tocca il tuo avatar per caricare una nuova foto. Se hai effettuato l'accesso con Google, la tua foto Google viene usata automaticamente finché non carichi la tua."),
    ("Come contatto l'assistenza?",
     "Apri Profile → Customer Support. Controlla prima le FAQ e, se non risolvono il problema, tocca Raise Ticket per inviarci i dettagli (puoi allegare fino a 2 screenshot). Puoi seguire lo stato e le risposte in My Tickets."),
    ("Come cambio la lingua dell'app?",
     "Apri Profile → Language e scegli la lingua che preferisci. L'app si aggiorna immediatamente."),
    ("Dove posso leggere le politiche sulla privacy, i termini e i rimborsi?",
     "Si trovano in Profile → About & Legal, che rimanda all'Informativa sulla privacy, ai Termini e condizioni e alla Politica di rimborso su nakshatralogy.com."),
]

_DEFAULT_FAQ_RU = [
    ("Как начать консультацию с астрологом?",
     "Откройте вкладку Astrologers, выберите астролога со статусом Online и выберите Chat, Call или Video. Перед началом убедитесь, что на вашем wallet достаточно средств хотя бы на несколько минут — тариф указан на карточке каждого астролога ещё до начала сеанса."),
    ("Как работает списание средств с wallet?",
     "Вы пополняете свой wallet, и оплата консультаций списывается с него. Для услуг с поминутной оплатой в начале сеанса на короткое время блокируется определённая сумма, а точная сумма списывается по окончании сеанса. Неиспользованная заблокированная сумма автоматически возвращается на баланс."),
    ("Деньги списаны, но сеанс не начался",
     "Если сеанс так и не начался (например, астролог не ответил), заблокированная сумма возвращается автоматически. Если баланс не восстановился в течение нескольких минут, создайте обращение в поддержку с указанием даты и времени — мы всё проверим."),
    ("Как пополнить wallet?",
     "Перейдите во вкладку Wallet, нажмите Add Money, выберите сумму и завершите оплату. Как только платёж пройдёт успешно, баланс обновится мгновенно."),
    ("Мой звонок не подключается",
     "Проверьте подключение к интернету и убедитесь, что приложению предоставлен доступ к микрофону и камере. В веб-версии разрешите доступ к микрофону/камере, когда браузер об этом попросит. Если астролог не отвечает в течение 60 секунд, звонок автоматически отменяется, и плата с вас не взимается."),
    ("Могу ли я получить возврат средств за неудачную консультацию?",
     "Если во время сеанса возникла реальная техническая проблема (звонок не подключился, астролог не ответил), создайте обращение в поддержку с описанием ситуации, и наша команда рассмотрит его. Ознакомьтесь с нашей политикой возврата средств в разделе Profile → About & Legal."),
    ("Я не получаю уведомления",
     "Откройте Profile → Notifications и убедитесь, что они включены. В веб-версии разрешите уведомления в браузере (на iPhone сначала добавьте приложение на главный экран). Если вы недавно вышли из аккаунта и снова вошли, однократное переключение уведомлений обновит настройки на вашем устройстве."),
    ("Насколько точны Kundli и отчёты?",
     "Карты и отчёты формируются на основе точных ведических астрономических расчётов с использованием вашей точной даты, времени и места рождения — поэтому, пожалуйста, вводите данные о рождении максимально точно для наилучшего результата."),
    ("Как работают подарки и super-chat в прямых эфирах?",
     "Во время прямого эфира вы можете отправить астрологу подарок или платный super-chat; сумма списывается с вашего wallet. Super-chat закрепляются наверху, чтобы астролог обязательно их заметил."),
    ("Как изменить данные о рождении?",
     "Откройте свой Kundli/профиль, отредактируйте дату, время и место рождения и сохраните изменения — ваши карты и отчёты будут пересчитаны автоматически."),
    ("Сколько времени занимает одобрение заявки?",
     "После того как вы заполните личные данные, профессиональные данные и пройдёте KYC, наша команда рассмотрит вашу заявку. Вы получите уведомление и письмо на почту, как только заявка будет одобрена или если потребуются исправления."),
    ("Моя заявка отклонена — что делать?",
     "Откройте приложение: на панели управления точно указано, какой раздел требует исправления (KYC, личные или профессиональные данные). Исправьте отмеченный раздел и отправьте заявку повторно — при редактировании профиля она автоматически отправляется на повторную проверку."),
    ("Какие документы нужны для KYC?",
     "Загрузите чёткое, действительное удостоверение личности государственного образца (и при необходимости — профессиональный сертификат). Убедитесь, что фото не размыто, данные совпадают с вашим профилем, а срок действия документа не истёк."),
    ("Я не получаю запросы на звонок/чат",
     "Убедитесь, что у вас установлен статус Online с помощью переключателя на панели управления и что уведомления включены в разделе Profile. Для надёжной доставки держите приложение открытым или установите веб-приложение на главный экран. Новые запросы также отображаются под значком колокольчика."),
    ("Как и когда я получаю оплату?",
     "Ваш доход от каждой консультации зачисляется на wallet за вычетом комиссии платформы. Вы можете вывести средства на банковский счёт с экрана Wallet; сроки поступления средств на счёт зависят от вашего платёжного провайдера."),
    ("Вывод средств прошёл успешно, но на моём банковском счёте нет суммы",
     "Зачисление средств банком может занять некоторое время в зависимости от вашего провайдера. В журнале вашего wallet списание отображается сразу же; если оно не отражено, создайте обращение в поддержку с указанием номера операции и времени."),
    ("Как начать прямой эфир?",
     "На панели управления нажмите Go Live. В веб-версии сначала нажмите Start Camera (браузер запросит доступ к камере), затем Go Live. Вы можете отвечать зрителям, закреплять вопрос, на который отвечаете, и устанавливать цель по подаркам."),
    ("Как рассчитывается мой рейтинг?",
     "Ваш рейтинг — это среднее значение оценок в звёздах, которые пользователи оставляют после сеансов чата, звонка и видео. Стабильно полезные и своевременные консультации повышают ваш рейтинг и видимость."),
    ("Как обновить фото профиля?",
     "Перейдите в Profile и нажмите на аватар, чтобы загрузить новое фото. Если вы вошли через Google, ваше фото из Google будет использоваться автоматически, пока вы не загрузите собственное."),
    ("Как связаться со службой поддержки?",
     "Откройте Profile → Customer Support. Сначала посмотрите FAQ, и если это не помогло, нажмите Raise Ticket, чтобы отправить нам подробности (можно приложить до 2 скриншотов). Статус и ответы можно отслеживать в разделе My Tickets."),
    ("Как изменить язык приложения?",
     "Откройте Profile → Language и выберите предпочитаемый язык. Приложение обновится сразу же."),
    ("Где можно ознакомиться с политикой конфиденциальности, условиями использования и политикой возврата средств?",
     "Они находятся в разделе Profile → About & Legal, откуда есть ссылки на Политику конфиденциальности, Условия использования и Политику возврата средств на сайте nakshatralogy.com."),
]

_DEFAULT_FAQ_AR = [
    ("كيف أبدأ استشارة مع منجّم؟",
     "افتح تبويب Astrologers، واختر منجّمًا يظهر بحالة Online، ثم اختر Chat أو Call أو Video. تأكد من أن رصيد wallet الخاص بك يكفي لبضع دقائق على الأقل — يظهر السعر على بطاقة كل منجّم قبل أن تبدأ."),
    ("كيف تعمل عملية الفوترة من wallet؟",
     "تقوم بإضافة أموال إلى wallet الخاص بك، ويتم خصم تكلفة الاستشارات منه. بالنسبة للخدمات التي تُحتسب بالدقيقة، يتم حجز مبلغ مؤقتًا في البداية، ثم يتم تسوية المبلغ الدقيق عند انتهاء الجلسة. أي مبلغ محجوز غير مستخدم يُعاد تلقائيًا إلى رصيدك."),
    ("تم خصم المبلغ لكن الجلسة لم تبدأ",
     "يتم تحرير المبالغ المحجوزة تلقائيًا إذا لم تبدأ الجلسة أبدًا (مثلًا إذا لم يرد المنجّم). إذا لم يعد الرصيد خلال بضع دقائق، يُرجى فتح تذكرة دعم مع ذكر التاريخ والوقت، وسنقوم بالتحقق من الأمر."),
    ("كيف أضيف أموالًا إلى wallet الخاص بي؟",
     "انتقل إلى تبويب Wallet واضغط على Add Money، ثم اختر المبلغ وأكمل عملية الدفع. يتم تحديث رصيدك فورًا بمجرد نجاح عملية الدفع."),
    ("مكالمتي لا تتصل",
     "تحقق من اتصالك بالإنترنت وتأكد من أن التطبيق يملك إذن الوصول إلى الميكروفون والكاميرا. في تطبيق الويب، اسمح بالوصول إلى الميكروفون/الكاميرا عندما يطلب المتصفح ذلك. إذا لم يرد المنجّم خلال 60 ثانية، تُلغى المكالمة تلقائيًا ولا يتم خصم أي مبلغ منك."),
    ("هل يمكنني استرداد المبلغ في حال كانت الاستشارة سيئة؟",
     "إذا واجهت الجلسة مشكلة تقنية حقيقية (لم تتصل المكالمة، أو لم يرد المنجّم)، يُرجى فتح تذكرة دعم مع ذكر التفاصيل، وسيقوم فريقنا بمراجعتها. يمكنك الاطلاع على سياسة الاسترداد لدينا في Profile → About & Legal."),
    ("لا تصلني الإشعارات",
     "افتح Profile → Notifications وتأكد من أنها مفعّلة. في تطبيق الويب، اسمح بالإشعارات من متصفحك (على iPhone، أضف التطبيق أولًا إلى الشاشة الرئيسية). إذا قمت مؤخرًا بتسجيل الخروج ثم تسجيل الدخول مجددًا، فإن تبديل الإشعارات مرة واحدة يعيد تحديث جهازك."),
    ("ما مدى دقة Kundli والتقارير؟",
     "يتم إنشاء الخرائط والتقارير بناءً على حسابات فلكية فيدية دقيقة تعتمد على تاريخ ووقت ومكان ميلادك بالضبط — لذا يُرجى إدخال بيانات ميلادك بأكبر قدر ممكن من الدقة للحصول على أفضل النتائج."),
    ("كيف تعمل الهدايا ورسائل super-chat في البث المباشر؟",
     "خلال البث المباشر، يمكنك إرسال هدايا أو super-chat مدفوعة إلى المنجّم؛ ويُخصم المبلغ من wallet الخاص بك. يتم تثبيت رسائل super-chat حتى يراها المنجّم بشكل واضح."),
    ("كيف أغيّر بيانات ميلادي؟",
     "افتح Kundli/الملف الشخصي الخاص بك، وعدّل تاريخ ووقت ومكان الميلاد، ثم احفظ التغييرات — ستُعاد حساب خرائطك وتقاريرك تلقائيًا."),
    ("كم يستغرق قبول الطلب؟",
     "بعد إكمال بياناتك الشخصية والمهنية وإجراء KYC، يقوم فريقنا بمراجعة طلبك. ستصلك رسالة إشعار وبريد إلكتروني بمجرد الموافقة على طلبك أو إذا كان هناك ما يحتاج إلى تصحيح."),
    ("تم رفض طلبي — ماذا أفعل؟",
     "افتح التطبيق: تُظهر لوحة التحكم بدقة القسم الذي يحتاج إلى تصحيح (KYC، أو البيانات الشخصية، أو البيانات المهنية). صحّح القسم المشار إليه وأعد الإرسال — تعديل ملفك الشخصي يرسله تلقائيًا للمراجعة مرة أخرى."),
    ("ما المستندات التي أحتاجها لـ KYC؟",
     "قم برفع بطاقة هوية حكومية واضحة وسارية المفعول (وأي شهادة مهنية إذا طُلب ذلك). تأكد من أن الصورة ليست ضبابية، وأن البيانات مطابقة لملفك الشخصي، وأن المستند غير منتهي الصلاحية."),
    ("لا تصلني طلبات مكالمات/محادثات",
     "تأكد من أنك بحالة Online باستخدام مفتاح التبديل في لوحة التحكم، وأن الإشعارات مفعّلة في Profile. حافظ على فتح التطبيق، أو ثبّت تطبيق الويب على الشاشة الرئيسية لضمان وصول الطلبات بشكل موثوق. تظهر الطلبات الجديدة أيضًا أسفل أيقونة الجرس."),
    ("كيف ومتى أحصل على أرباحي؟",
     "تُضاف أرباحك من كل استشارة إلى wallet الخاص بك بعد خصم عمولة المنصة. يمكنك سحب الأموال إلى حسابك المصرفي من شاشة Wallet؛ ويتبع وصول الأموال إلى حسابك المصرفي الجداول الزمنية الخاصة بمزوّد الدفع لديك."),
    ("نجحت عملية السحب لكنني لا أرى المبلغ في حسابي المصرفي",
     "قد تستغرق التسوية المصرفية بعض الوقت حسب مزوّد الخدمة لديك. يُظهر سجل wallet الخاص بك عملية الخصم فورًا؛ فإذا لم يظهر ذلك في السجل، يُرجى فتح تذكرة دعم مع ذكر الرقم المرجعي والوقت."),
    ("كيف أبدأ بثًا مباشرًا؟",
     "من لوحة التحكم، اضغط على Go Live. في تطبيق الويب، ستضغط أولًا على Start Camera (سيطلب المتصفح إذن الوصول إلى الكاميرا)، ثم على Go Live. يمكنك الرد على المشاهدين، وتثبيت السؤال الذي تجيب عنه، وتحديد هدف لجمع الهدايا."),
    ("كيف يُحسب تقييمي؟",
     "تقييمك هو متوسط تقييمات النجوم التي يتركها المستخدمون بعد جلسات المحادثة والمكالمة والفيديو. الاستشارات المفيدة والمنتظمة باستمرار تُحسّن تقييمك وظهورك."),
    ("كيف أحدّث صورة ملفي الشخصي؟",
     "اذهب إلى Profile واضغط على صورتك الرمزية لرفع صورة جديدة. إذا سجّلت الدخول عبر Google، فسيتم استخدام صورتك من Google تلقائيًا إلى أن تقوم برفع صورتك الخاصة."),
    ("كيف أتواصل مع الدعم؟",
     "افتح Profile → Customer Support. اطّلع أولًا على الأسئلة الشائعة (FAQ)، وإذا لم تساعدك، اضغط على Raise Ticket لإرسال التفاصيل إلينا (يمكنك إرفاق ما يصل إلى صورتين). يمكنك متابعة الحالة والردود ضمن My Tickets."),
    ("كيف أغيّر لغة التطبيق؟",
     "افتح Profile → Language واختر لغتك المفضلة. يتم تحديث التطبيق فورًا."),
    ("أين يمكنني الاطلاع على سياسة الخصوصية والشروط وسياسة الاسترداد؟",
     "يمكنك إيجادها في Profile → About & Legal، والتي تحتوي على روابط لسياسة الخصوصية والشروط والأحكام وسياسة الاسترداد على nakshatralogy.com."),
]

_DEFAULT_FAQ_ID = [
    ("Bagaimana cara memulai konsultasi dengan astrolog?",
     "Buka tab Astrologers, pilih astrolog yang berstatus Online, lalu pilih Chat, Call, atau Video. Pastikan saldo wallet Anda cukup untuk setidaknya beberapa menit — tarifnya sudah ditampilkan di kartu setiap astrolog sebelum Anda memulai."),
    ("Bagaimana cara kerja penagihan wallet?",
     "Anda menambahkan saldo ke wallet, dan biaya konsultasi akan dipotong dari sana. Untuk layanan per menit, sejumlah dana akan ditahan sementara di awal sesi, dan biaya yang sebenarnya akan diselesaikan saat sesi berakhir. Sisa dana yang tidak terpakai akan otomatis dikembalikan."),
    ("Saldo terpotong tapi sesi tidak dimulai",
     "Dana yang ditahan akan otomatis dikembalikan jika sesi tidak pernah dimulai (misalnya astrolog tidak menjawab). Jika saldo belum kembali dalam beberapa menit, ajukan tiket dukungan dengan mencantumkan tanggal dan waktu, dan kami akan memeriksanya."),
    ("Bagaimana cara menambah saldo wallet saya?",
     "Buka tab Wallet, ketuk Add Money, pilih nominal, lalu selesaikan pembayaran. Saldo Anda akan diperbarui secara instan setelah pembayaran berhasil."),
    ("Panggilan saya tidak bisa tersambung",
     "Periksa koneksi internet Anda dan pastikan aplikasi memiliki izin mikrofon dan kamera. Di aplikasi web, izinkan akses mikrofon/kamera saat browser memintanya. Jika astrolog tidak menjawab dalam 60 detik, panggilan akan otomatis dibatalkan dan Anda tidak akan dikenai biaya."),
    ("Bisakah saya mendapatkan pengembalian dana untuk konsultasi yang buruk?",
     "Jika sesi mengalami masalah teknis yang nyata (panggilan tidak tersambung, astrolog tidak merespons), ajukan tiket dukungan dengan detailnya dan tim kami akan meninjaunya. Lihat Kebijakan Pengembalian Dana kami di Profile → About & Legal."),
    ("Saya tidak menerima notifikasi",
     "Buka Profile → Notifications dan pastikan notifikasi diaktifkan. Di aplikasi web, izinkan notifikasi di browser Anda (di iPhone, tambahkan aplikasi ke Home Screen terlebih dahulu). Jika Anda baru saja logout lalu login kembali, mengaktifkan/menonaktifkan notifikasi sekali akan menyegarkan perangkat Anda."),
    ("Seberapa akurat Kundli dan laporannya?",
     "Chart dan laporan dibuat berdasarkan perhitungan astronomi Veda yang presisi menggunakan tanggal, waktu, dan tempat lahir Anda yang tepat — jadi mohon isi detail kelahiran Anda seakurat mungkin untuk hasil terbaik."),
    ("Bagaimana cara kerja hadiah dan super-chat di live stream?",
     "Selama live stream, Anda dapat mengirim hadiah atau super-chat berbayar kepada astrolog; nominalnya akan dipotong dari wallet Anda. Super-chat akan disematkan agar mudah terlihat oleh astrolog."),
    ("Bagaimana cara mengubah detail kelahiran saya?",
     "Buka Kundli/profil Anda, ubah tanggal, waktu, dan tempat lahir, lalu simpan — chart dan laporan Anda akan otomatis dihitung ulang."),
    ("Berapa lama proses persetujuan berlangsung?",
     "Setelah Anda melengkapi detail pribadi, detail profesional, dan KYC, tim kami akan meninjau pengajuan Anda. Anda akan menerima notifikasi dan email begitu disetujui atau jika ada yang perlu diperbaiki."),
    ("Pengajuan saya ditolak — apa yang harus saya lakukan?",
     "Buka aplikasi: dashboard akan menunjukkan dengan tepat bagian mana yang perlu diperbaiki (KYC, data pribadi, atau data profesional). Perbaiki bagian yang ditandai dan ajukan ulang — mengedit profil Anda akan otomatis mengirimkannya kembali untuk ditinjau."),
    ("Dokumen apa yang saya perlukan untuk KYC?",
     "Unggah identitas resmi pemerintah yang jelas dan masih berlaku (beserta sertifikat profesional jika diminta). Pastikan fotonya tidak buram, detailnya sesuai dengan profil Anda, dan dokumennya belum kedaluwarsa."),
    ("Saya tidak menerima permintaan panggilan/chat",
     "Pastikan status Anda diatur ke Online melalui toggle di dashboard dan notifikasi diaktifkan di Profile. Biarkan aplikasi tetap terbuka, atau pasang aplikasi web ke Home Screen, agar pengiriman lebih andal. Permintaan baru juga muncul di bawah ikon lonceng."),
    ("Bagaimana dan kapan saya menerima pembayaran?",
     "Penghasilan Anda dari setiap konsultasi akan dikreditkan ke wallet Anda setelah dipotong komisi platform. Anda dapat menarik dana ke rekening bank dari layar Wallet; pencairan ke bank mengikuti jadwal penyedia pembayaran Anda."),
    ("Penarikan saya berhasil tapi jumlahnya tidak muncul di rekening bank saya",
     "Pencairan ke bank bisa memakan waktu tergantung penyedia layanan Anda. Buku besar wallet Anda akan langsung menunjukkan pemotongannya; jika buku besar tidak mencerminkannya, ajukan tiket dukungan dengan menyertakan nomor referensi dan waktu."),
    ("Bagaimana cara memulai live stream?",
     "Dari dashboard, ketuk Go Live. Di aplikasi web, Anda akan mengetuk Start Camera terlebih dahulu (browser akan meminta akses kamera), lalu Go Live. Anda dapat membalas penonton, menyematkan pertanyaan yang sedang Anda jawab, dan menetapkan target hadiah."),
    ("Bagaimana rating saya dihitung?",
     "Rating Anda adalah rata-rata dari penilaian bintang yang diberikan pengguna setelah sesi chat, call, dan video. Konsultasi yang konsisten membantu dan tepat waktu akan meningkatkan rating dan visibilitas Anda."),
    ("Bagaimana cara memperbarui foto profil saya?",
     "Buka Profile dan ketuk avatar Anda untuk mengunggah foto baru. Jika Anda masuk menggunakan Google, foto Google Anda akan digunakan secara otomatis hingga Anda mengunggah foto Anda sendiri."),
    ("Bagaimana cara menghubungi dukungan pelanggan?",
     "Buka Profile → Customer Support. Periksa dulu FAQ, dan jika belum membantu, ketuk Raise Ticket untuk mengirimkan detailnya kepada kami (Anda dapat melampirkan hingga 2 tangkapan layar). Anda dapat memantau status dan balasannya di My Tickets."),
    ("Bagaimana cara mengubah bahasa aplikasi?",
     "Buka Profile → Language dan pilih bahasa yang Anda inginkan. Aplikasi akan langsung diperbarui."),
    ("Di mana saya bisa membaca kebijakan privasi, ketentuan, dan pengembalian dana?",
     "Semuanya ada di Profile → About & Legal, yang menautkan ke Privacy Policy, Terms & Conditions, dan Refund Policy di nakshatralogy.com."),
]

_DEFAULT_FAQ_JA = [
    ("占星術師との相談はどうやって始めればいいですか？",
     "Astrologersタブを開き、Online表示になっている占星術師を選んで、Chat、Call、Videoのいずれかを選択してください。開始前に、少なくとも数分間分の残高がwalletにあることを確認してください — 料金は各占星術師のカードに事前に表示されています。"),
    ("walletの課金はどのような仕組みですか？",
     "walletにお金をチャージすると、相談料金はそこから引き落とされます。分単位のサービスでは、開始時に一時的に一定額がブロックされ、セッション終了時に正確な料金が確定します。使われなかったブロック分の金額は自動的に解放され、残高に戻ります。"),
    ("料金が引かれたのにセッションが始まりませんでした",
     "セッションが一度も開始しなかった場合（占星術師が応答しなかった場合など）、ブロックされた金額は自動的に返金されます。数分経っても残高が戻らない場合は、日時を添えてサポートチケットを発行してください。こちらで確認いたします。"),
    ("walletにお金を追加するにはどうすればいいですか？",
     "Walletタブを開いてAdd Moneyをタップし、金額を選んで支払いを完了してください。支払いが成功すると残高はすぐに更新されます。"),
    ("通話がつながりません",
     "インターネット接続を確認し、アプリにマイクとカメラの権限が許可されているか確認してください。ウェブアプリでは、ブラウザが確認を求めたらマイク/カメラを許可してください。占星術師が60秒以内に応答しない場合、通話は自動的にキャンセルされ、料金は発生しません。"),
    ("相談内容が悪かった場合、返金してもらえますか？",
     "通話が接続しなかった、占星術師が応答しなかったなど、実際の技術的な問題があった場合は、詳細を添えてサポートチケットを発行してください。当チームが内容を確認いたします。返金ポリシーはProfile → About & Legalでご確認いただけます。"),
    ("通知が届きません",
     "Profile → Notificationsを開き、通知がオンになっているか確認してください。ウェブアプリでは、ブラウザで通知を許可してください（iPhoneの場合は、まずアプリをホーム画面に追加してください）。最近ログアウトして再度ログインした場合は、通知を一度オン/オフに切り替えるとデバイスがリフレッシュされます。"),
    ("Kundliやレポートの精度はどのくらいですか？",
     "チャートとレポートは、正確な生年月日、出生時刻、出生地を用いた精密なヴェーダ占星術の天文計算に基づいて作成されます。最良の結果を得るために、出生情報はできるだけ正確に入力してください。"),
    ("ライブ配信のギフトやスーパーチャットはどのような仕組みですか？",
     "ライブ配信中は、占星術師にギフトや有料のスーパーチャットを送ることができます。金額はwalletから引き落とされます。スーパーチャットはピン留めされるため、占星術師が目立つ形で確認できます。"),
    ("出生情報を変更するにはどうすればいいですか？",
     "Kundli/プロフィールを開き、生年月日、出生時刻、出生地を編集して保存してください — チャートとレポートは自動的に再計算されます。"),
    ("承認にはどのくらい時間がかかりますか？",
     "個人情報、職務経歴、KYCの入力が完了すると、当チームが申請内容を審査します。承認された場合、または修正が必要な場合は、通知とメールでお知らせします。"),
    ("申請が却下されました — どうすればいいですか？",
     "アプリを開いてください。ダッシュボードに、どのセクション（KYC、個人情報、または職務情報）に修正が必要かが正確に表示されます。該当箇所を修正して再提出してください — プロフィールを編集すると自動的に再審査に送られます。"),
    ("KYCにはどの書類が必要ですか？",
     "鮮明で有効な政府発行の身分証明書をアップロードしてください（求められた場合は職業資格証明書も）。写真がぼやけていないこと、内容がプロフィールと一致していること、書類の有効期限が切れていないことを確認してください。"),
    ("通話/チャットのリクエストが届きません",
     "ダッシュボードのトグルでOnlineに設定し、Profileで通知が有効になっていることを確認してください。安定した受信のために、アプリを開いたままにするか、ウェブアプリをホーム画面にインストールしてください。新しいリクエストはベルアイコンの下にも表示されます。"),
    ("報酬はどのように、いつ受け取れますか？",
     "各相談の報酬は、プラットフォーム手数料を差し引いた後、walletに入金されます。Wallet画面から銀行口座への出金が可能です。銀行への着金は、決済プロバイダーのスケジュールに従います。"),
    ("出金は成功しましたが、銀行口座に金額が反映されません",
     "銀行への着金は、プロバイダーによって多少時間がかかる場合があります。walletの取引履歴には引き落としがすぐに表示されます。取引履歴に反映されない場合は、参照番号と時刻を添えてサポートチケットを発行してください。"),
    ("ライブ配信を始めるにはどうすればいいですか？",
     "ダッシュボードからGo Liveをタップしてください。ウェブアプリでは、まずStart Cameraをタップします（ブラウザがカメラへのアクセスを求めます）。その後Go Liveをタップしてください。視聴者への返信、回答中の質問のピン留め、ギフト目標の設定が可能です。"),
    ("評価はどのように計算されますか？",
     "評価は、チャット、通話、ビデオセッション後にユーザーが付ける星評価の平均値です。一貫して丁寧で時間厳守の相談対応は、評価と表示順位の向上につながります。"),
    ("プロフィール写真を更新するにはどうすればいいですか？",
     "Profileを開き、アバターをタップして新しい写真をアップロードしてください。Googleでサインインしている場合、ご自身の写真をアップロードするまではGoogleの写真が自動的に使用されます。"),
    ("サポートに問い合わせるにはどうすればいいですか？",
     "Profile → Customer Supportを開いてください。まずFAQをご確認いただき、解決しない場合はRaise Ticketをタップして詳細をお送りください（スクリーンショットは最大2枚添付できます）。ステータスと返信はMy Ticketsで確認できます。"),
    ("アプリの言語を変更するにはどうすればいいですか？",
     "Profile → Languageを開いて、希望する言語を選択してください。アプリはすぐに更新されます。"),
    ("プライバシーポリシー、利用規約、返金ポリシーはどこで確認できますか？",
     "これらはProfile → About & Legalにあり、nakshatralogy.comのPrivacy Policy、Terms & Conditions、Refund Policyにリンクしています。"),
]

_DEFAULT_FAQ_TRANSLATIONS = {
    "hindi": _DEFAULT_FAQ_HI,
    "hinglish": _DEFAULT_FAQ_HINGLISH,
    "bengali": _DEFAULT_FAQ_BN,
    "tamil": _DEFAULT_FAQ_TA,
    "telugu": _DEFAULT_FAQ_TE,
    "kannada": _DEFAULT_FAQ_KN,
    "malayalam": _DEFAULT_FAQ_ML,
    "gujarati": _DEFAULT_FAQ_GU,
    "marathi": _DEFAULT_FAQ_MR,
    "punjabi": _DEFAULT_FAQ_PA,
    "odia": _DEFAULT_FAQ_OR,
    "french": _DEFAULT_FAQ_FR,
    "chinese": _DEFAULT_FAQ_ZH,
    "thai": _DEFAULT_FAQ_TH,
    "spanish": _DEFAULT_FAQ_ES,
    "portuguese": _DEFAULT_FAQ_PT,
    "german": _DEFAULT_FAQ_DE,
    "italian": _DEFAULT_FAQ_IT,
    "russian": _DEFAULT_FAQ_RU,
    "arabic": _DEFAULT_FAQ_AR,
    "indonesian": _DEFAULT_FAQ_ID,
    "japanese": _DEFAULT_FAQ_JA,
}


def _pairs_for_lang(lang: str):
    """Return [(question, answer), ...] for `lang` in _DEFAULT_FAQ order, or None
    if unavailable. Uses hand sets for english/hindi; otherwise best-effort
    machine translation via the app's existing translation engine."""
    if lang == "english":
        return [(q, a) for (_aud, _cat, q, a) in _DEFAULT_FAQ]
    if lang in _DEFAULT_FAQ_TRANSLATIONS:
        return _DEFAULT_FAQ_TRANSLATIONS[lang]
    # Best-effort auto-translation (Groq/OpenRouter/Ollama, per the report engine).
    try:
        from app.services._llm_translate_backend import llm_translate_batch
    except Exception:
        return None
    texts = []
    for (_aud, _cat, q, a) in _DEFAULT_FAQ:
        texts.append(q)
        texts.append(a)
    try:
        mapping = llm_translate_batch(texts, lang) or {}
    except Exception:
        return None
    out, changed = [], False
    for (_aud, _cat, q, a) in _DEFAULT_FAQ:
        tq, ta = mapping.get(q) or q, mapping.get(a) or a
        if tq != q or ta != a:
            changed = True
        out.append((tq, ta))
    return out if changed else None


class FaqSeedRequest(BaseModel):
    # Canonical or short codes; None → every supported language.
    languages: Optional[List[str]] = None
    # Auto-translate languages without a hand set (english + hindi are always done).
    translate: bool = True


@router.post("/admin/seed")
def admin_seed_faq(
    req: FaqSeedRequest = Body(default_factory=FaqSeedRequest),
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Seed the recommended default FAQ set in every supported language.

    English + Hindi are always seeded from hand-written sets; the remaining
    supported languages are auto-translated via the app's translation engine
    (best-effort — skipped if the translator isn't configured, English still
    covers them at read time). Additive & idempotent: matched on
    (audience, language, question), safe to re-run. Also self-heals legacy rows
    whose language codes weren't canonical (e.g. 'en' → 'english')."""
    # Self-heal existing rows to canonical language codes.
    healed = 0
    for f in db.query(FaqItem).all():
        c = _canon(getattr(f, "lang", None))
        if (f.lang or "") != c:
            f.lang = c
            healed += 1
    if healed:
        db.commit()

    existing = {
        (f.audience, f.lang, (f.question or "").strip().lower())
        for f in db.query(FaqItem).all()
    }
    base = db.query(FaqItem).count()

    if req.languages:
        langs = [_canon(l) for l in req.languages]
    else:
        langs = list(SUPPORTED_LANGUAGES)
    # english + hindi first (guaranteed), then the rest, de-duplicated.
    langs = list(dict.fromkeys(["english", "hindi"] + langs))

    per_lang, order = {}, 0
    for lang in langs:
        if lang not in ("english", "hindi") and not req.translate:
            per_lang[lang] = 0
            continue
        pairs = _pairs_for_lang(lang)
        if not pairs:
            per_lang[lang] = 0
            continue
        added = 0
        for i, (aud, cat, _q, _a) in enumerate(_DEFAULT_FAQ):
            q, a = pairs[i]
            key = (aud, lang, (q or "").strip().lower())
            if key in existing:
                continue
            db.add(FaqItem(audience=aud, lang=lang, category=cat,
                           question=q, answer=a, sort_order=base + order))
            existing.add(key)
            order += 1
            added += 1
        # Commit per language so fast sets (english/hindi) persist immediately
        # and a slow/timed-out auto-translation still leaves earlier languages
        # saved; a re-run continues where it left off (idempotent).
        if added:
            db.commit()
        per_lang[lang] = added

    return {
        "status": "ok",
        "healed": healed,
        "total_added": order,
        "seeded_by_language": per_lang,
    }
