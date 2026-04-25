"""
Seed AI question bank + answer templates.
30 questions (en+hi) across 12 domains + 10 answer templates.
Idempotent — uses question code-based dedup.

Run: python -m app.seeds.seed_questions
"""

import logging
from app.core.database import SessionLocal
from app.models.model import (
    AiQuestion, AiQuestionTranslation,
    AiAnswerTemplate, AiTemplateTranslation,
)

logger = logging.getLogger("seed_questions")

QUESTIONS = [
    # ── Career (5) ──
    {"domain": "career_job", "sub": "promotion", "qtype": "timing", "kw": ["promotion","when","kab","timing"],
     "en": "When will I get a promotion?", "hi": "मेरी प्रमोशन कब होगी?", "label": "Promotion timing"},
    {"domain": "career_job", "sub": "job_change", "qtype": "yes_no", "kw": ["job change","switch","new job","naukri"],
     "en": "Should I change my job?", "hi": "क्या मुझे नौकरी बदलनी चाहिए?", "label": "Job change"},
    {"domain": "career_job", "sub": "job_stability", "qtype": "prediction", "kw": ["job","stable","security","safe"],
     "en": "Is my job stable right now?", "hi": "क्या मेरी नौकरी अभी सुरक्षित है?", "label": "Job stability"},
    {"domain": "career_job", "sub": "interview", "qtype": "timing", "kw": ["interview","selection","placement","hire"],
     "en": "Will I clear the interview?", "hi": "क्या मेरा इंटरव्यू क्लियर होगा?", "label": "Interview success"},
    {"domain": "career_job", "sub": None, "qtype": "explanation", "kw": ["career","path","direction","future"],
     "en": "What does my career path look like?", "hi": "मेरा करियर कैसा रहेगा?", "label": "Career overview"},

    # ── Marriage (4) ──
    {"domain": "marriage_family", "sub": "marriage_timing", "qtype": "timing", "kw": ["marriage","when","shaadi","kab","wedding"],
     "en": "When will I get married?", "hi": "मेरी शादी कब होगी?", "label": "Marriage timing"},
    {"domain": "marriage_family", "sub": "spouse_nature", "qtype": "explanation", "kw": ["spouse","partner","husband","wife","nature"],
     "en": "What will my spouse be like?", "hi": "मेरा जीवनसाथी कैसा होगा?", "label": "Spouse nature"},
    {"domain": "marriage_family", "sub": "divorce", "qtype": "prediction", "kw": ["divorce","separation","problem","conflict"],
     "en": "Is there any divorce risk in my chart?", "hi": "क्या मेरी कुंडली में तलाक का योग है?", "label": "Divorce risk"},
    {"domain": "marriage_family", "sub": "children", "qtype": "timing", "kw": ["children","baby","kids","pregnancy","santaan"],
     "en": "When will I have children?", "hi": "मुझे संतान कब होगी?", "label": "Children timing"},

    # ── Wealth (3) ──
    {"domain": "money_wealth", "sub": None, "qtype": "prediction", "kw": ["rich","wealthy","money","dhan","paisa"],
     "en": "Will I become wealthy?", "hi": "क्या मैं अमीर बनूंगा?", "label": "Wealth prediction"},
    {"domain": "money_wealth", "sub": None, "qtype": "timing", "kw": ["income","increase","growth","salary","earning"],
     "en": "When will my income increase?", "hi": "मेरी आय कब बढ़ेगी?", "label": "Income growth"},
    {"domain": "money_wealth", "sub": None, "qtype": "remedy", "kw": ["wealth","remedy","upay","mantra","dhan"],
     "en": "What remedies for wealth growth?", "hi": "धन वृद्धि के लिए क्या उपाय करें?", "label": "Wealth remedy"},

    # ── Health (3) ──
    {"domain": "health_wellness", "sub": "disease", "qtype": "prediction", "kw": ["health","disease","illness","bimari","problem"],
     "en": "Are there health problems in my chart?", "hi": "क्या मेरी कुंडली में स्वास्थ्य समस्या है?", "label": "Health overview"},
    {"domain": "health_wellness", "sub": None, "qtype": "explanation", "kw": ["body","constitution","prakriti","type"],
     "en": "What is my body constitution?", "hi": "मेरी शारीरिक प्रकृति क्या है?", "label": "Constitution"},
    {"domain": "health_wellness", "sub": "chronic", "qtype": "timing", "kw": ["chronic","long","recover","healing","theek"],
     "en": "When will my health improve?", "hi": "मेरी सेहत कब सुधरेगी?", "label": "Recovery timing"},

    # ── Love (2) ──
    {"domain": "love_relationship", "sub": "new_relationship", "qtype": "timing", "kw": ["love","find","partner","relationship","pyaar"],
     "en": "When will I find love?", "hi": "मुझे प्यार कब मिलेगा?", "label": "Love timing"},
    {"domain": "love_relationship", "sub": "relationship_problem", "qtype": "reason", "kw": ["breakup","fight","conflict","problem","issue"],
     "en": "Why do my relationships fail?", "hi": "मेरे रिश्ते क्यों टूटते हैं?", "label": "Relationship issues"},

    # ── Business (2) ──
    {"domain": "business_startup", "sub": None, "qtype": "yes_no", "kw": ["business","start","startup","company","own"],
     "en": "Should I start my own business?", "hi": "क्या मुझे खुद का बिज़नेस शुरू करना चाहिए?", "label": "Start business"},
    {"domain": "business_startup", "sub": None, "qtype": "timing", "kw": ["business","profit","success","growth","safal"],
     "en": "When will my business succeed?", "hi": "मेरा बिज़नेस कब सफल होगा?", "label": "Business success"},

    # ── Education (2) ──
    {"domain": "education_career", "sub": "exam_result", "qtype": "prediction", "kw": ["exam","result","pass","clear","competitive"],
     "en": "Will I pass my exams?", "hi": "क्या मैं परीक्षा पास करूंगा?", "label": "Exam result"},
    {"domain": "education_career", "sub": "abroad_study", "qtype": "prediction", "kw": ["abroad","foreign","study","overseas","videsh"],
     "en": "Will I go abroad for studies?", "hi": "क्या मैं विदेश पढ़ने जाऊंगा?", "label": "Foreign study"},

    # ── Mental (2) ──
    {"domain": "mental_stress", "sub": "anxiety", "qtype": "reason", "kw": ["anxiety","stress","tension","worried","chinta"],
     "en": "Why am I always anxious?", "hi": "मुझे हमेशा चिंता क्यों रहती है?", "label": "Anxiety cause"},
    {"domain": "mental_stress", "sub": "sleep_issue", "qtype": "remedy", "kw": ["sleep","insomnia","neend","rest"],
     "en": "Remedies for sleep issues?", "hi": "नींद की समस्या का उपाय?", "label": "Sleep remedy"},

    # ── Property (1) ──
    {"domain": "property_assets", "sub": "buy_timing", "qtype": "timing", "kw": ["property","buy","house","ghar","flat","land"],
     "en": "When should I buy property?", "hi": "प्रॉपर्टी कब खरीदनी चाहिए?", "label": "Buy timing"},

    # ── Legal (1) ──
    {"domain": "legal_dispute", "sub": "case_outcome", "qtype": "prediction", "kw": ["court","case","legal","win","jeet"],
     "en": "Will I win my court case?", "hi": "क्या मैं कोर्ट केस जीतूंगा?", "label": "Case outcome"},

    # ── Debt (1) ──
    {"domain": "debt_recovery", "sub": None, "qtype": "timing", "kw": ["debt","loan","karz","clear","free"],
     "en": "When will I be debt-free?", "hi": "मैं कर्ज़ मुक्त कब होऊंगा?", "label": "Debt freedom"},

    # ── Life Path (2) ──
    {"domain": "life_path_luck", "sub": "purpose", "qtype": "explanation", "kw": ["purpose","life","destiny","bhagya","path"],
     "en": "What is my life purpose?", "hi": "मेरे जीवन का उद्देश्य क्या है?", "label": "Life purpose"},
    {"domain": "life_path_luck", "sub": None, "qtype": "prediction", "kw": ["luck","fortune","rajyog","lucky","kismat"],
     "en": "Do I have Rajyog in my chart?", "hi": "क्या मेरी कुंडली में राजयोग है?", "label": "Rajyog check"},
]

TEMPLATES = [
    # ── Career promotion (conditional on probability band) ──
    {"domain": "career_job", "cond_key": "band", "cond_op": "==", "cond_val": "Very High",
     "priority": 10,
     "en": "Your career shows exceptional strength at {probability}% ({band}). The {label} analysis indicates strong planetary support. Current dasha period is highly favorable for advancement. Active yogas: {active_yogas}. This is an excellent window for pushing for promotion or new opportunities.",
     "hi": "आपका करियर {probability}% ({band}) पर असाधारण मजबूती दिखाता है। वर्तमान दशा काल पदोन्नति के लिए अत्यंत अनुकूल है। सक्रिय योग: {active_yogas}।"},
    {"domain": "career_job", "cond_key": "band", "cond_op": "==", "cond_val": "Low",
     "priority": 10,
     "en": "Your career probability is currently at {probability}% ({band}). Active doshas: {active_doshas}. This is a consolidation period — focus on skill-building and avoid major career risks. The dasha will shift in your favor soon.",
     "hi": "आपकी करियर संभावना वर्तमान में {probability}% ({band}) है। सक्रिय दोष: {active_doshas}। यह समेकन का समय है — कौशल विकास पर ध्यान दें।"},

    # ── Marriage timing (high probability) ──
    {"domain": "marriage_family", "cond_key": "probability", "cond_op": ">=", "cond_val": 65,
     "priority": 8,
     "en": "Marriage indicators in your chart are strong at {probability}% ({band}). Venus and Jupiter positions support matrimonial happiness. Active yogas: {active_yogas}. The current dasha window is favorable for marriage-related decisions.",
     "hi": "आपकी कुंडली में विवाह के संकेत {probability}% ({band}) पर मजबूत हैं। शुक्र और बृहस्पति की स्थिति वैवाहिक सुख का समर्थन करती है।"},

    # ── Health warning (low score) ──
    {"domain": "health_wellness", "cond_key": "probability", "cond_op": "<=", "cond_val": 35,
     "priority": 9,
     "en": "Health indicators require attention — your chart shows {probability}% ({band}). Active doshas: {active_doshas}. Focus on preventive care, regular check-ups, and stress management. Please consult a qualified doctor for any medical concerns — astrology complements, never replaces, medical advice.",
     "hi": "स्वास्थ्य संकेतकों पर ध्यान देने की आवश्यकता है — आपकी कुंडली {probability}% ({band}) दिखाती है। कृपया किसी योग्य चिकित्सक से परामर्श करें।"},

    # ── Wealth strong ──
    {"domain": "money_wealth", "cond_key": "band", "cond_op": "in", "cond_val": ["Very High", "High"],
     "priority": 8,
     "en": "Your wealth potential is strong at {probability}% ({band}). The 2nd and 11th house configuration supports income growth. Active yogas: {active_yogas}. Current planetary period favors financial expansion — this is a good time for investments and income negotiations.",
     "hi": "आपकी धन क्षमता {probability}% ({band}) पर मजबूत है। दूसरे और ग्यारहवें भाव की स्थिति आय वृद्धि का समर्थन करती है।"},

    # ── Mental stress high ──
    {"domain": "mental_stress", "cond_key": "probability", "cond_op": "<=", "cond_val": 40,
     "priority": 9,
     "en": "Your chart shows mental stress indicators at {probability}% ({band}). Moon and 4th house need attention. Active doshas: {active_doshas}. Meditation, pranayama, and Moon-strengthening remedies (pearl, white foods, Monday fasting) can help. If feelings persist, please reach out to a qualified mental-health professional.",
     "hi": "आपकी कुंडली में मानसिक तनाव के संकेत {probability}% ({band}) हैं। ध्यान, प्राणायाम और चंद्र-सशक्तिकरण उपाय सहायक हो सकते हैं। गंभीर स्थिति में मानसिक स्वास्थ्य विशेषज्ञ से संपर्क करें।"},

    # ── Love positive ──
    {"domain": "love_relationship", "cond_key": "probability", "cond_op": ">=", "cond_val": 60,
     "priority": 7,
     "en": "Love and relationship indicators are positive at {probability}% ({band}). Venus placement supports romantic fulfillment. Active yogas: {active_yogas}. The current period is favorable for new connections or deepening existing bonds.",
     "hi": "प्रेम और रिश्ते के संकेत {probability}% ({band}) पर सकारात्मक हैं। शुक्र की स्थिति रोमांटिक संतुष्टि का समर्थन करती है।"},

    # ── Legal caution ──
    {"domain": "legal_dispute", "cond_key": "probability", "cond_op": "<=", "cond_val": 45,
     "priority": 8,
     "en": "Legal matters show challenges at {probability}% ({band}). The 6th-7th house axis requires careful navigation. Active doshas: {active_doshas}. Consider settlement over prolonged litigation during this dasha period. Saturn-related remedies may help.",
     "hi": "कानूनी मामले {probability}% ({band}) पर चुनौतियां दिखाते हैं। इस दशा काल में लंबी मुकदमेबाजी की बजाय समझौते पर विचार करें।"},

    # ── Life path rajyog ──
    {"domain": "life_path_luck", "cond_key": "band", "cond_op": "in", "cond_val": ["Very High", "High"],
     "priority": 8,
     "en": "Your chart reveals strong Rajyog indicators at {probability}% ({band})! Active yogas: {active_yogas}. Jupiter and Sun positions illuminate your dharmic path. This is a powerful period for pursuing your higher purpose and making bold life decisions.",
     "hi": "आपकी कुंडली {probability}% ({band}) पर मजबूत राजयोग संकेत दिखाती है! सक्रिय योग: {active_yogas}। यह आपके उच्च उद्देश्य को आगे बढ़ाने का शक्तिशाली समय है।"},

    # ── Debt recovery hope ──
    {"domain": "debt_recovery", "cond_key": "probability", "cond_op": ">=", "cond_val": 50,
     "priority": 7,
     "en": "Debt recovery capacity is moderate-to-good at {probability}% ({band}). The 6th house configuration shows recovery potential. Active yogas: {active_yogas}. Vipreet Raj Yoga, if present, can turn financial hardship into eventual gain. Focus on systematic repayment during favorable dasha windows.",
     "hi": "कर्ज वसूली क्षमता {probability}% ({band}) पर मध्यम से अच्छी है। व्यवस्थित पुनर्भुगतान पर ध्यान दें।"},
]


def seed_questions(db):
    count = 0
    for i, q in enumerate(QUESTIONS):
        existing = db.query(AiQuestion).filter(
            AiQuestion.domain_key == q["domain"],
            AiQuestion.sub_domain == q.get("sub"),
            AiQuestion.question_type == q["qtype"],
        ).first()

        if not existing:
            aq = AiQuestion(
                domain_key=q["domain"],
                sub_domain=q.get("sub"),
                question_type=q["qtype"],
                keywords=q["kw"],
                sort_order=i + 1,
            )
            db.add(aq)
            db.flush()

            db.add(AiQuestionTranslation(
                question_id=aq.id, lang_code="english",
                text=q["en"], short_label=q.get("label", q["en"][:50]),
            ))
            if q.get("hi"):
                db.add(AiQuestionTranslation(
                    question_id=aq.id, lang_code="hindi",
                    text=q["hi"], short_label=q.get("label", q["hi"][:50]),
                ))
            count += 1

    db.commit()
    logger.info("Seeded %d new questions (skipped existing)", count)


def seed_templates(db):
    count = 0
    for t in TEMPLATES:
        existing = db.query(AiAnswerTemplate).filter(
            AiAnswerTemplate.domain_key == t["domain"],
            AiAnswerTemplate.condition_key == t.get("cond_key"),
            AiAnswerTemplate.condition_op == t.get("cond_op"),
        ).first()

        if not existing:
            at = AiAnswerTemplate(
                domain_key=t["domain"],
                condition_key=t.get("cond_key"),
                condition_op=t.get("cond_op"),
                condition_val=t.get("cond_val"),
                priority=t.get("priority", 0),
            )
            db.add(at)
            db.flush()

            db.add(AiTemplateTranslation(
                template_id=at.id, lang_code="english",
                body=t["en"],
                placeholders=["probability", "band", "active_yogas", "active_doshas", "label"],
            ))
            if t.get("hi"):
                db.add(AiTemplateTranslation(
                    template_id=at.id, lang_code="hindi",
                    body=t["hi"],
                    placeholders=["probability", "band", "active_yogas", "active_doshas", "label"],
                ))
            count += 1

    db.commit()
    logger.info("Seeded %d new templates (skipped existing)", count)


def run():
    logging.basicConfig(level=logging.INFO)
    db = SessionLocal()
    try:
        seed_questions(db)
        seed_templates(db)
        logger.info("Question + template seed complete")
    finally:
        db.close()


if __name__ == "__main__":
    run()
