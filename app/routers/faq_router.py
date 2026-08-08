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

# Pre-translated sets keyed by canonical language. English is the source.
_DEFAULT_FAQ_TRANSLATIONS = {"hindi": _DEFAULT_FAQ_HI}


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
