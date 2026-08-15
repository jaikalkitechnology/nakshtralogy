"""
Specialist Report Translator
=============================
Post-processes specialist engine output to translate human-readable
labels and categories into the requested language.

Usage:
    from app.services.report_translator import translate_report
    translated = translate_report(result, lang="hi")
"""

# Key-value translations for common specialist output fields
TRANSLATIONS = {
    "hi": {
        # Career categories
        "leadership-executive": "नेतृत्व-कार्यकारी",
        "government-administration": "सरकारी-प्रशासन",
        "military-defense": "सैन्य-रक्षा",
        "technical-engineering": "तकनीकी-इंजीनियरिंग",
        "skilled-trade": "कुशल-व्यापार",
        "education-teaching": "शिक्षा-अध्यापन",
        "business-commerce": "व्यापार-वाणिज्य",
        "technology-software": "प्रौद्योगिकी-सॉफ्टवेयर",
        "spiritual-religious": "आध्यात्मिक-धार्मिक",
        "finance-banking": "वित्त-बैंकिंग",
        "media-communication": "मीडिया-संचार",
        "entertainment-performance": "मनोरंजन-प्रदर्शन",
        "creative-arts": "रचनात्मक-कला",
        "service-hospitality": "सेवा-आतिथ्य",
        "research-scientific": "अनुसंधान-वैज्ञानिक",
        "medical-healing": "चिकित्सा-उपचार",
        # Karaka roles
        "Soul significator": "आत्म कारक",
        "Career significator": "करियर कारक",
        "Partner significator": "साझीदार कारक",
        # Soul contracts
        "soul-contract of authority/leadership expression across lifetimes": "अधिकार/नेतृत्व अभिव्यक्ति का आत्म-अनुबंध",
        "soul-contract of public-service/caretaking/emotional-labor": "जन-सेवा/देखभाल/भावनात्मक-श्रम का आत्म-अनुबंध",
        "soul-contract of courage/protection/action-direction": "साहस/सुरक्षा/कर्म-दिशा का आत्म-अनुबंध",
        "soul-contract of intellect/communication/teaching": "बुद्धि/संचार/शिक्षण का आत्म-अनुबंध",
        "soul-contract of wisdom/teaching/dharmic-authority": "ज्ञान/शिक्षण/धार्मिक-अधिकार का आत्म-अनुबंध",
        "soul-contract of love/artistry/beauty-creation": "प्रेम/कला/सौंदर्य-सृजन का आत्म-अनुबंध",
        "soul-contract of service/discipline/endurance": "सेवा/अनुशासन/धैर्य का आत्म-अनुबंध",
        # AmK career directions
        "authority-driven / leadership / government / medicine": "अधिकार-चालित / नेतृत्व / सरकार / चिकित्सा",
        "public-service / caretaking / emotional-labor / hospitality": "जन-सेवा / देखभाल / भावनात्मक-श्रम / आतिथ्य",
        "action-driven / engineering / military / surgery / sports": "कर्म-चालित / इंजीनियरिंग / सैन्य / शल्य / खेल",
        "intellect-driven / IT / commerce / writing / analytics": "बुद्धि-चालित / आईटी / वाणिज्य / लेखन / विश्लेषण",
        "wisdom-driven / teaching / finance / legal / advisory": "ज्ञान-चालित / शिक्षण / वित्त / कानूनी / सलाहकार",
        "aesthetic-driven / arts / design / luxury / entertainment": "सौंदर्य-चालित / कला / डिज़ाइन / विलास / मनोरंजन",
        "structure-driven / research / infrastructure / manufacturing": "संरचना-चालित / अनुसंधान / अवसंरचना / विनिर्माण",
        # Dignity labels
        "Swakshetra 🏠": "स्वक्षेत्र 🏠",
        "Friend Sign": "मित्र राशि",
        "Enemy Sign": "शत्रु राशि",
        "Moolatrikona": "मूलत्रिकोण",
        # Grades
        "Very High": "बहुत उच्च",
        "High": "उच्च",
        "Moderate": "मध्यम",
        "Low": "निम्न",
        "Very Low": "बहुत निम्न",
        "Excellent": "उत्कृष्ट",
        "Good": "अच्छा",
        "Average": "औसत",
        "Below Average": "औसत से कम",
        "Poor": "कमजोर",
        "Strong": "मजबूत",
        "Weak": "कमजोर",
        "Challenged": "चुनौतीपूर्ण",
        # Planets
        "Sun": "सूर्य", "Moon": "चंद्र", "Mars": "मंगल",
        "Mercury": "बुध", "Jupiter": "बृहस्पति", "Venus": "शुक्र",
        "Saturn": "शनि", "Rahu": "राहु", "Ketu": "केतु",
        # Dignities
        "Exalted": "उच्च", "Debilitated": "नीच",
        "Own": "स्वगृही", "Friend": "मित्र", "Enemy": "शत्रु",
        "Neutral": "तटस्थ",
        # Signs
        "Aries": "मेष", "Taurus": "वृषभ", "Gemini": "मिथुन",
        "Cancer": "कर्क", "Leo": "सिंह", "Virgo": "कन्या",
        "Libra": "तुला", "Scorpio": "वृश्चिक", "Sagittarius": "धनु",
        "Capricorn": "मकर", "Aquarius": "कुंभ", "Pisces": "मीन",
        # Founder archetypes
        "Visionary-Leader-Founder": "दूरदर्शी-नेता-संस्थापक",
        "Wealth-Compounder-Founder": "धन-संवर्धक-संस्थापक",
        "Action-Driven-Founder": "कर्मशील-संस्थापक",
        "Tech-Innovator-Founder": "तकनीकी-नवप्रवर्तक-संस्थापक",
        "Advisory-Dharmic-Founder": "सलाहकार-धार्मिक-संस्थापक",
        "Brand-Aesthetic-Founder": "ब्रांड-सौंदर्य-संस्थापक",
        "Disciplined-Operator-Founder": "अनुशासित-संचालक-संस्थापक",
        "People-Facing-Founder": "जन-संपर्क-संस्थापक",
        "Research-Niche-Founder": "अनुसंधान-विशिष्ट-संस्थापक",
        "Generalist-Adaptive-Founder": "बहुमुखी-अनुकूलनीय-संस्थापक",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "प्राधिकरण-नेतृत्व उद्यम (सरकारी-संपर्क, चिकित्सा-अभ्यास, प्रशासनिक-परामर्श)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "जन-सेवा उद्यम (आतिथ्य, खुदरा, खाद्य-सेवा, मीडिया, पोषण-सेवाएं)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "कर्म-उन्मुख उद्यम (इंजीनियरिंग, रियल-एस्टेट, खेल, विनिर्माण, सुरक्षा)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "वाणिज्य-संचार उद्यम (आईटी, परामर्श, व्यापार, मीडिया, विश्लेषण, लेखन)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "सलाहकार-शैक्षिक उद्यम (शिक्षण, परामर्श, वित्त-सलाह, प्रकाशन, कानूनी)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "सौंदर्य-विलास उद्यम (डिज़ाइन, फैशन, मनोरंजन, आतिथ्य-विलास, सौंदर्य)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "अवसंरचना-सेवा उद्यम (विनिर्माण, रसद, संस्थागत-सेवाएं, अनुसंधान)",
        "balanced ventures": "संतुलित उद्यम",
        # Leadership styles
        "Authoritative Leader": "अधिकारपूर्ण नेता",
        "Innovative Disruptor": "नवीन विघ्नकर्ता",
        "Strategic Planner": "रणनीतिक योजनाकार",
        "Collaborative Builder": "सहयोगी निर्माता",
        "Visionary Pioneer": "दूरदर्शी अग्रणी",
        "Steady Operator": "स्थिर संचालक",
        # Swakshetra dignity
        "Swakshetra 🏠": "स्वगृही 🏠",
        "Normal": "सामान्य",
        # Education archetypes
        "classical-scholar": "शास्त्रीय-विद्वान",
        "intellect-with-authority": "प्रतिभा-सह-अधिकार",
        "researcher-investigator": "शोधकर्ता-जांचकर्ता",
        "modern-technologist": "आधुनिक-प्रौद्योगिकीविद",
        "wisdom-teacher": "ज्ञान-गुरु",
        "creative-artist": "सृजनात्मक-कलाकार",
        "patient-builder": "धैर्यवान-निर्माता",
        "generalist-learner": "बहुमुखी-शिक्षार्थी",
        # Education learning styles
        "quick-analytical-visual": "तेज-विश्लेषणात्मक-दृश्य",
        "deep-philosophical-synthesizing": "गहन-दार्शनिक-संश्लेषण",
        "intuitive-emotional-kinesthetic": "अंतर्ज्ञानी-भावनात्मक-गतिज",
        "action-experiential-competitive": "क्रियाशील-अनुभवात्मक-प्रतिस्पर्धी",
        "systematic-methodical-disciplined": "व्यवस्थित-पद्धतिगत-अनुशासित",
        "aesthetic-creative-associative": "सौंदर्यपरक-सृजनात्मक-साहचर्य",
        "unconventional-innovative-research-oriented": "अपरंपरागत-नवोन्मेषी-शोध-उन्मुख",
        "mixed-adaptive-balanced": "मिश्रित-अनुकूली-संतुलित",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "नेतृत्व/प्रशासन/राजनीति-विज्ञान/चिकित्सा/सरकारी-अध्ययन",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "मनोविज्ञान/नर्सिंग/आतिथ्य/खाद्य-विज्ञान/जनसंपर्क",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "इंजीनियरिंग/सैन्य-अध्ययन/शल्यचिकित्सा/खेल/रियल-एस्टेट/यांत्रिकी",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "वाणिज्य/आईटी/संचार/लेखा/लेखन/भाषा-विज्ञान/डेटा-विश्लेषण",
        "law/philosophy/education/finance/religion/advisory-studies": "कानून/दर्शन/शिक्षा/वित्त/धर्म/सलाहकार-अध्ययन",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "कला/डिज़ाइन/संगीत/विलास-ब्रांड/फैशन/मनोरंजन/सौंदर्य",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "अनुसंधान/इंजीनियरिंग/अवसंरचना/खनन/सेवा-उद्योग/श्रम-अध्ययन",
        # Wealth types
        "earned": "अर्जित", "inherited": "विरासत",
        "speculative": "सट्टा", "mixed": "मिश्रित",
        "professional": "पेशेवर", "business": "व्यापार",
        "passive": "निष्क्रिय",
        # Investment styles
        "accumulator": "संचयकर्ता", "trader": "व्यापारी",
        "speculator": "सट्टेबाज", "passive-holder": "निष्क्रिय-धारक",
        "balanced-investor": "संतुलित-निवेशक",
        # Wealth acquisition styles
        "effort-based": "प्रयास-आधारित",
        "relationship-based": "संबंध-आधारित",
        "balanced": "संतुलित",
        # Risk categories
        "high": "उच्च", "medium": "मध्यम", "low": "निम्न",
        # Love styles
        "romantic": "रोमांटिक", "cautious": "सतर्क",
        "slow-warmth": "धीमी-उष्णता", "magnetic": "चुंबकीय",
        "quick-falls": "तेज-प्रेम", "passionate": "भावुक",
        "steady": "स्थिर", "detached": "अलग",
        # Marriage archetypes
        "refined-partner": "परिष्कृत-साथी",
        "unconventional-partner": "अपरंपरागत-साथी",
        "service-oriented-partner": "सेवा-उन्मुख-साथी",
        # Health types
        "acute": "तीव्र", "psychosomatic": "मनोदैहिक",
        "chronic": "दीर्घकालिक", "structural": "संरचनात्मक",
        # Mental stress styles
        "open": "खुला", "measured": "संयमित",
        "suppressed": "दबा हुआ", "explosive": "विस्फोटक",
        "withdrawn": "अंतर्मुखी",
        # Property types
        "acquisitive": "अधिग्रहणकारी", "protective": "सुरक्षात्मक",
        "volatile": "अस्थिर", "minimal": "न्यूनतम",
        "luxury-car": "विलासिता-वाहन", "practical-sedan": "व्यावहारिक-सेडान",
        "utility-vehicle": "उपयोगी-वाहन",
        # Legal types
        "litigation-prone": "मुकदमा-प्रवण", "defensive-prone": "रक्षात्मक-प्रवण",
        "protracted-cases": "दीर्घ-मुकदमे", "settlement-prone": "समझौता-प्रवण",
        "quick-resolution": "त्वरित-समाधान",
        # Life path karma types
        "dharmic-continuation": "धार्मिक-निरंतरता",
        "mastery-completion": "निपुणता-पूर्णता",
        "karmic-resolution": "कर्म-समाधान",
        "wisdom-teaching": "ज्ञान-शिक्षण",
        "purification-focused": "शुद्धिकरण-केंद्रित",
        "service-karma": "सेवा-कर्म",
        "new-beginning": "नई-शुरुआत",
        # Past life
        "peaceful-natural": "शांत-प्राकृतिक",
        # Debt
        "secured": "सुरक्षित", "unsecured": "असुरक्षित",
    },
    "mr": {
        # Career categories
        "leadership-executive": "नेतृत्व-कार्यकारी",
        "government-administration": "सरकारी-प्रशासन",
        "military-defense": "लष्करी-संरक्षण",
        "technical-engineering": "तांत्रिक-अभियांत्रिकी",
        "skilled-trade": "कुशल-व्यवसाय",
        "education-teaching": "शिक्षण-अध्यापन",
        "business-commerce": "व्यापार-वाणिज्य",
        "technology-software": "तंत्रज्ञान-सॉफ्टवेअर",
        "spiritual-religious": "आध्यात्मिक-धार्मिक",
        "finance-banking": "वित्त-बँकिंग",
        "media-communication": "माध्यम-संवाद",
        "entertainment-performance": "मनोरंजन-सादरीकरण",
        "creative-arts": "सर्जनशील-कला",
        "service-hospitality": "सेवा-आदरातिथ्य",
        "research-scientific": "संशोधन-वैज्ञानिक",
        "medical-healing": "वैद्यकीय-उपचार",
        # Grades
        "Very High": "अतिशय उच्च", "High": "उच्च", "Moderate": "मध्यम",
        "Low": "कमी", "Very Low": "अतिशय कमी",
        "Excellent": "उत्कृष्ट",
        "Good": "चांगले",
        "Average": "सरासरी",
        "Below Average": "सरासरीपेक्षा कमी",
        "Poor": "कमकुवत",
        "Strong": "मजबूत",
        "Weak": "कमकुवत",
        "Challenged": "आव्हानात्मक",
        # Planets
        "Sun": "सूर्य", "Moon": "चंद्र", "Mars": "मंगळ",
        "Mercury": "बुध", "Jupiter": "गुरू", "Venus": "शुक्र",
        "Saturn": "शनी", "Rahu": "राहू", "Ketu": "केतू",
        # Dignities
        "Exalted": "उच्च", "Debilitated": "नीच",
        "Own": "स्वगृही", "Friend": "मित्र", "Enemy": "शत्रू",
        "Neutral": "तटस्थ",
        # Signs
        "Aries": "मेष", "Taurus": "वृषभ", "Gemini": "मिथुन",
        "Cancer": "कर्क", "Leo": "सिंह", "Virgo": "कन्या",
        "Libra": "तूळ", "Scorpio": "वृश्चिक", "Sagittarius": "धनू",
        "Capricorn": "मकर", "Aquarius": "कुंभ", "Pisces": "मीन",
        # Founder archetypes
        "Visionary-Leader-Founder": "दूरदर्शी-नेता-संस्थापक",
        "Wealth-Compounder-Founder": "धन-संवर्धक-संस्थापक",
        "Action-Driven-Founder": "कृतिशील-संस्थापक",
        "Tech-Innovator-Founder": "तंत्रज्ञान-नवनिर्माता-संस्थापक",
        "Advisory-Dharmic-Founder": "सल्लागार-धार्मिक-संस्थापक",
        "Brand-Aesthetic-Founder": "ब्रँड-सौंदर्य-संस्थापक",
        "Disciplined-Operator-Founder": "शिस्तबद्ध-संचालक-संस्थापक",
        "People-Facing-Founder": "जनसंपर्क-संस्थापक",
        "Research-Niche-Founder": "संशोधन-विशेष-संस्थापक",
        "Generalist-Adaptive-Founder": "बहुआयामी-अनुकूलनीय-संस्थापक",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "प्राधिकरण-नेतृत्व उद्यम (सरकारी-संपर्क, वैद्यकीय-व्यवसाय, प्रशासकीय-सल्ला)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "जनसेवा उद्यम (आदरातिथ्य, किरकोळ, खाद्य-सेवा, माध्यम, पोषण-सेवा)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "कृती-उन्मुख उद्यम (अभियांत्रिकी, रिअल-इस्टेट, क्रीडा, उत्पादन, सुरक्षा)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "वाणिज्य-संवाद उद्यम (आयटी, सल्ला, व्यापार, माध्यम, विश्लेषण, लेखन)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "सल्लागार-शैक्षणिक उद्यम (शिक्षण, समुपदेशन, वित्त-सल्ला, प्रकाशन, कायदेशीर)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "सौंदर्य-विलास उद्यम (रचना, फॅशन, मनोरंजन, आदरातिथ्य-विलास, सौंदर्य)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "पायाभूत-सेवा उद्यम (उत्पादन, रसद, संस्थात्मक-सेवा, संशोधन)",
        "balanced ventures": "संतुलित उद्यम",
        # Leadership styles
        "Authoritative Leader": "अधिकारशील नेता",
        "Innovative Disruptor": "नवनिर्माता विघ्नकर्ता",
        "Strategic Planner": "रणनीतिक नियोजक",
        "Collaborative Builder": "सहयोगी निर्माता",
        "Visionary Pioneer": "दूरदर्शी अग्रणी",
        "Steady Operator": "स्थिर संचालक",
        # Swakshetra dignity
        "Swakshetra 🏠": "स्वगृही 🏠",
        "Normal": "सामान्य",
        # Education archetypes
        "classical-scholar": "शास्त्रीय-विद्वान",
        "intellect-with-authority": "बुद्धिमत्ता-सह-अधिकार",
        "researcher-investigator": "संशोधक-तपासकर्ता",
        "modern-technologist": "आधुनिक-तंत्रज्ञ",
        "wisdom-teacher": "ज्ञान-गुरू",
        "creative-artist": "सर्जनशील-कलाकार",
        "patient-builder": "धीरगंभीर-निर्माता",
        "generalist-learner": "बहुआयामी-शिक्षार्थी",
        # Education learning styles
        "quick-analytical-visual": "जलद-विश्लेषणात्मक-दृश्य",
        "deep-philosophical-synthesizing": "गहन-तात्त्विक-संश्लेषण",
        "intuitive-emotional-kinesthetic": "अंतर्ज्ञानी-भावनिक-गतिज",
        "action-experiential-competitive": "कृतिशील-अनुभवात्मक-स्पर्धात्मक",
        "systematic-methodical-disciplined": "व्यवस्थित-पद्धतशीर-शिस्तबद्ध",
        "aesthetic-creative-associative": "सौंदर्यपरक-सर्जनशील-साहचर्य",
        "unconventional-innovative-research-oriented": "अपारंपरिक-नवनिर्माणशील-संशोधन-उन्मुख",
        "mixed-adaptive-balanced": "मिश्र-अनुकूली-संतुलित",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "नेतृत्व/प्रशासन/राज्यशास्त्र/वैद्यकशास्त्र/सरकारी-अध्ययन",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "मानसशास्त्र/परिचर्या/आदरातिथ्य/खाद्यशास्त्र/जनसंपर्क",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "अभियांत्रिकी/लष्करी-अध्ययन/शल्यचिकित्सा/क्रीडा/रिअल-इस्टेट/यांत्रिकी",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "वाणिज्य/आयटी/संवाद/लेखा/लेखन/भाषाशास्त्र/डेटा-विश्लेषण",
        "law/philosophy/education/finance/religion/advisory-studies": "कायदा/तत्त्वज्ञान/शिक्षण/वित्त/धर्म/सल्लागार-अध्ययन",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "कला/रचना/संगीत/विलास-ब्रँड/फॅशन/मनोरंजन/सौंदर्य",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "संशोधन/अभियांत्रिकी/पायाभूत/खाणकाम/सेवा-उद्योग/श्रम-अध्ययन",
        # Wealth types
        "earned": "कमावलेले", "inherited": "वारसा",
        "speculative": "सट्टा", "mixed": "मिश्र",
        "professional": "व्यावसायिक", "business": "व्यापार",
        "passive": "निष्क्रिय",
        # Investment styles
        "accumulator": "संचयकर्ता", "trader": "व्यापारी",
        "speculator": "सट्टेबाज", "passive-holder": "निष्क्रिय-धारक",
        "balanced-investor": "संतुलित-गुंतवणूकदार",
        # Wealth acquisition styles
        "effort-based": "प्रयत्न-आधारित",
        "relationship-based": "संबंध-आधारित",
        "balanced": "संतुलित",
        # Risk categories
        "high": "उच्च", "medium": "मध्यम", "low": "कमी",
        # Love styles
        "romantic": "रोमँटिक", "cautious": "सावध",
        "slow-warmth": "मंद-उष्णता", "magnetic": "चुंबकीय",
        "quick-falls": "जलद-प्रेम", "passionate": "उत्कट",
        "steady": "स्थिर", "detached": "अलिप्त",
        # Marriage archetypes
        "refined-partner": "परिष्कृत-जोडीदार",
        "unconventional-partner": "अपारंपरिक-जोडीदार",
        "service-oriented-partner": "सेवा-उन्मुख-जोडीदार",
        # Health types
        "acute": "तीव्र", "psychosomatic": "मनोदैहिक",
        "chronic": "दीर्घकालीन", "structural": "संरचनात्मक",
        # Mental stress styles
        "open": "खुला", "measured": "संयमित",
        "suppressed": "दाबलेला", "explosive": "स्फोटक",
        "withdrawn": "अंतर्मुख",
        # Property types
        "acquisitive": "अधिग्रहणकारी", "protective": "संरक्षणात्मक",
        "volatile": "अस्थिर", "minimal": "किमान",
        "luxury-car": "विलासिता-वाहन", "practical-sedan": "व्यावहारिक-सेडान",
        "utility-vehicle": "उपयोगी-वाहन",
        # Legal types
        "litigation-prone": "खटला-प्रवण", "defensive-prone": "बचावात्मक-प्रवण",
        "protracted-cases": "दीर्घ-खटले", "settlement-prone": "तडजोड-प्रवण",
        "quick-resolution": "जलद-निवारण",
        # Life path karma types
        "dharmic-continuation": "धार्मिक-निरंतरता",
        "mastery-completion": "प्रावीण्य-पूर्णता",
        "karmic-resolution": "कर्म-निवारण",
        "wisdom-teaching": "ज्ञान-शिक्षण",
        "purification-focused": "शुद्धीकरण-केंद्रित",
        "service-karma": "सेवा-कर्म",
        "new-beginning": "नवी-सुरुवात",
        # Past life
        "peaceful-natural": "शांत-नैसर्गिक",
        # Debt
        "secured": "सुरक्षित", "unsecured": "असुरक्षित",
    },
    "gu": {
        # Career categories
        "leadership-executive": "નેતૃત્વ-કાર્યકારી",
        "government-administration": "સરકારી-વહીવટ",
        "military-defense": "સૈન્ય-રક્ષા",
        "technical-engineering": "તકનીકી-ઇજનેરી",
        "skilled-trade": "કુશળ-વ્યાપાર",
        "education-teaching": "શિક્ષણ-અધ્યાપન",
        "business-commerce": "વ્યાપાર-વાણિજ્ય",
        "technology-software": "ટેક્નોલોજી-સોફ્ટવેર",
        "spiritual-religious": "આધ્યાત્મિક-ધાર્મિક",
        "finance-banking": "નાણાં-બેંકિંગ",
        "media-communication": "મીડિયા-સંચાર",
        "entertainment-performance": "મનોરંજન-પ્રદર્શન",
        "creative-arts": "સર્જનાત્મક-કલા",
        "service-hospitality": "સેવા-આતિથ્ય",
        "research-scientific": "સંશોધન-વૈજ્ઞાનિક",
        "medical-healing": "તબીબી-ઉપચાર",
        # Grades
        "Very High": "ખૂબ ઊંચું", "High": "ઊંચું", "Moderate": "મધ્યમ",
        "Low": "નીચું", "Very Low": "ખૂબ નીચું",
        "Excellent": "ઉત્કૃષ્ટ",
        "Good": "સારું",
        "Average": "સરેરાશ",
        "Below Average": "સરેરાશથી ઓછું",
        "Poor": "નબળું",
        "Strong": "મજબૂત",
        "Weak": "નબળું",
        "Challenged": "પડકારજનક",
        # Planets
        "Sun": "સૂર્ય", "Moon": "ચંદ્ર", "Mars": "મંગળ",
        "Mercury": "બુધ", "Jupiter": "ગુરુ", "Venus": "શુક્ર",
        "Saturn": "શનિ", "Rahu": "રાહુ", "Ketu": "કેતુ",
        # Dignities
        "Exalted": "ઉચ્ચ", "Debilitated": "નીચ",
        "Own": "સ્વગૃહી", "Friend": "મિત્ર", "Enemy": "શત્રુ",
        "Neutral": "તટસ્થ",
        # Signs
        "Aries": "મેષ", "Taurus": "વૃષભ", "Gemini": "મિથુન",
        "Cancer": "કર્ક", "Leo": "સિંહ", "Virgo": "કન્યા",
        "Libra": "તુલા", "Scorpio": "વૃશ્ચિક", "Sagittarius": "ધનુ",
        "Capricorn": "મકર", "Aquarius": "કુંભ", "Pisces": "મીન",
        # Founder archetypes
        "Visionary-Leader-Founder": "દૂરંદેશી-નેતા-સંસ્થાપક",
        "Wealth-Compounder-Founder": "ધન-સંવર્ધક-સંસ્થાપક",
        "Action-Driven-Founder": "કર્મશીલ-સંસ્થાપક",
        "Tech-Innovator-Founder": "ટેક-નવપ્રવર્તક-સંસ્થાપક",
        "Advisory-Dharmic-Founder": "સલાહકાર-ધાર્મિક-સંસ્થાપક",
        "Brand-Aesthetic-Founder": "બ્રાન્ડ-સૌંદર્ય-સંસ્થાપક",
        "Disciplined-Operator-Founder": "શિસ્તબદ્ધ-સંચાલક-સંસ્થાપક",
        "People-Facing-Founder": "જનસંપર્ક-સંસ્થાપક",
        "Research-Niche-Founder": "સંશોધન-વિશિષ્ટ-સંસ્થાપક",
        "Generalist-Adaptive-Founder": "બહુમુખી-અનુકૂલનીય-સંસ્થાપક",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "સત્તા-નેતૃત્વ ઉદ્યમ (સરકારી-સંપર્ક, તબીબી-વ્યવસાય, વહીવટી-સલાહ)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "જનસેવા ઉદ્યમ (આતિથ્ય, છૂટક, ખાદ્ય-સેવા, મીડિયા, પોષણ-સેવા)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "કર્મ-લક્ષી ઉદ્યમ (ઇજનેરી, રિયલ-એસ્ટેટ, રમત, ઉત્પાદન, સુરક્ષા)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "વાણિજ્ય-સંચાર ઉદ્યમ (IT, સલાહ, વેપાર, મીડિયા, વિશ્લેષણ, લેખન)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "સલાહકાર-શૈક્ષણિક ઉદ્યમ (શિક્ષણ, પરામર્શ, નાણાં-સલાહ, પ્રકાશન, કાનૂની)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "સૌંદર્ય-વિલાસ ઉદ્યમ (ડિઝાઇન, ફેશન, મનોરંજન, આતિથ્ય-વિલાસ, સૌંદર્ય)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "માળખાકીય-સેવા ઉદ્યમ (ઉત્પાદન, રસદ, સંસ્થાકીય-સેવા, સંશોધન)",
        "balanced ventures": "સંતુલિત ઉદ્યમ",
        # Leadership styles
        "Authoritative Leader": "અધિકારયુક્ત નેતા",
        "Innovative Disruptor": "નવીન વિઘ્નકર્તા",
        "Strategic Planner": "રણનીતિક આયોજક",
        "Collaborative Builder": "સહયોગી નિર્માતા",
        "Visionary Pioneer": "દૂરંદેશી અગ્રણી",
        "Steady Operator": "સ્થિર સંચાલક",
        # Swakshetra dignity
        "Swakshetra 🏠": "સ્વગૃહી 🏠",
        "Normal": "સામાન્ય",
        # Education archetypes
        "classical-scholar": "શાસ્ત્રીય-વિદ્વાન",
        "intellect-with-authority": "બુદ્ધિ-સહ-અધિકાર",
        "researcher-investigator": "સંશોધક-તપાસકર્તા",
        "modern-technologist": "આધુનિક-ટેક્નોલોજિસ્ટ",
        "wisdom-teacher": "જ્ઞાન-ગુરુ",
        "creative-artist": "સર્જનાત્મક-કલાકાર",
        "patient-builder": "ધૈર્યવાન-નિર્માતા",
        "generalist-learner": "બહુમુખી-શિક્ષાર્થી",
        # Education learning styles
        "quick-analytical-visual": "ઝડપી-વિશ્લેષણાત્મક-દૃશ્ય",
        "deep-philosophical-synthesizing": "ગહન-દાર્શનિક-સંશ્લેષણ",
        "intuitive-emotional-kinesthetic": "અંતર્જ્ઞાની-ભાવનાત્મક-ગતિજ",
        "action-experiential-competitive": "ક્રિયાશીલ-અનુભવાત્મક-સ્પર્ધાત્મક",
        "systematic-methodical-disciplined": "વ્યવસ્થિત-પદ્ધતિસર-શિસ્તબદ્ધ",
        "aesthetic-creative-associative": "સૌંદર્યપરક-સર્જનાત્મક-સાહચર્ય",
        "unconventional-innovative-research-oriented": "અપરંપરાગત-નવીન-સંશોધન-લક્ષી",
        "mixed-adaptive-balanced": "મિશ્ર-અનુકૂલી-સંતુલિત",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "નેતૃત્વ/વહીવટ/રાજકીય-વિજ્ઞાન/તબીબી/સરકારી-અભ્યાસ",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "મનોવિજ્ઞાન/નર્સિંગ/આતિથ્ય/ખાદ્ય-વિજ્ઞાન/જનસંપર્ક",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "ઇજનેરી/સૈન્ય-અભ્યાસ/શસ્ત્રક્રિયા/રમત/રિયલ-એસ્ટેટ/યાંત્રિકી",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "વાણિજ્ય/IT/સંચાર/હિસાબ/લેખન/ભાષાવિજ્ઞાન/ડેટા-વિશ્લેષણ",
        "law/philosophy/education/finance/religion/advisory-studies": "કાનૂન/દર્શન/શિક્ષણ/નાણાં/ધર્મ/સલાહકાર-અભ્યાસ",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "કલા/ડિઝાઇન/સંગીત/વિલાસ-બ્રાન્ડ/ફેશન/મનોરંજન/સૌંદર્ય",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "સંશોધન/ઇજનેરી/માળખાકીય/ખાણકામ/સેવા-ઉદ્યોગ/શ્રમ-અભ્યાસ",
        # Wealth types
        "earned": "કમાયેલું", "inherited": "વારસાગત",
        "speculative": "સટ્ટાકીય", "mixed": "મિશ્ર",
        "professional": "વ્યાવસાયિક", "business": "વ્યાપાર",
        "passive": "નિષ્ક્રિય",
        # Investment styles
        "accumulator": "સંચયકર્તા", "trader": "વેપારી",
        "speculator": "સટ્ટાખોર", "passive-holder": "નિષ્ક્રિય-ધારક",
        "balanced-investor": "સંતુલિત-રોકાણકાર",
        # Wealth acquisition styles
        "effort-based": "પ્રયત્ન-આધારિત",
        "relationship-based": "સંબંધ-આધારિત",
        "balanced": "સંતુલિત",
        # Risk categories
        "high": "ઊંચું", "medium": "મધ્યમ", "low": "નીચું",
        # Love styles
        "romantic": "રોમેન્ટિક", "cautious": "સાવધ",
        "slow-warmth": "ધીમી-ઉષ્ણતા", "magnetic": "ચુંબકીય",
        "quick-falls": "ઝડપી-પ્રેમ", "passionate": "ઉત્કટ",
        "steady": "સ્થિર", "detached": "અલિપ્ત",
        # Marriage archetypes
        "refined-partner": "પરિષ્કૃત-સાથી",
        "unconventional-partner": "અપરંપરાગત-સાથી",
        "service-oriented-partner": "સેવા-લક્ષી-સાથી",
        # Health types
        "acute": "તીવ્ર", "psychosomatic": "મનોદૈહિક",
        "chronic": "દીર્ઘકાલીન", "structural": "માળખાકીય",
        # Mental stress styles
        "open": "ખુલ્લું", "measured": "સંયમિત",
        "suppressed": "દબાયેલું", "explosive": "વિસ્ફોટક",
        "withdrawn": "અંતર્મુખ",
        # Property types
        "acquisitive": "અધિગ્રહણકારી", "protective": "રક્ષણાત્મક",
        "volatile": "અસ્થિર", "minimal": "ન્યૂનતમ",
        "luxury-car": "વિલાસિતા-વાહન", "practical-sedan": "વ્યાવહારિક-સેડાન",
        "utility-vehicle": "ઉપયોગી-વાહન",
        # Legal types
        "litigation-prone": "મુકદ્દમા-પ્રવણ", "defensive-prone": "રક્ષણાત્મક-પ્રવણ",
        "protracted-cases": "દીર્ઘ-મુકદ્દમા", "settlement-prone": "સમાધાન-પ્રવણ",
        "quick-resolution": "ઝડપી-નિવારણ",
        # Life path karma types
        "dharmic-continuation": "ધાર્મિક-નિરંતરતા",
        "mastery-completion": "નિપુણતા-પૂર્ણતા",
        "karmic-resolution": "કર્મ-નિવારણ",
        "wisdom-teaching": "જ્ઞાન-શિક્ષણ",
        "purification-focused": "શુદ્ધિકરણ-કેન્દ્રિત",
        "service-karma": "સેવા-કર્મ",
        "new-beginning": "નવી-શરૂઆત",
        # Past life
        "peaceful-natural": "શાંત-પ્રાકૃતિક",
        # Debt
        "secured": "સુરક્ષિત", "unsecured": "અસુરક્ષિત",
    },
    "ta": {
        # Career categories
        "leadership-executive": "தலைமை-நிர்வாகி",
        "government-administration": "அரசு-நிர்வாகம்",
        "military-defense": "இராணுவம்-பாதுகாப்பு",
        "technical-engineering": "தொழில்நுட்ப-பொறியியல்",
        "skilled-trade": "திறன்-வணிகம்",
        "education-teaching": "கல்வி-கற்பித்தல்",
        "business-commerce": "வணிகம்-வர்த்தகம்",
        "technology-software": "தொழில்நுட்பம்-மென்பொருள்",
        "spiritual-religious": "ஆன்மிக-மத",
        "finance-banking": "நிதி-வங்கி",
        "media-communication": "ஊடகம்-தகவல்தொடர்பு",
        "entertainment-performance": "கேளிக்கை-நிகழ்ச்சி",
        "creative-arts": "படைப்பாற்றல்-கலை",
        "service-hospitality": "சேவை-விருந்தோம்பல்",
        "research-scientific": "ஆராய்ச்சி-அறிவியல்",
        "medical-healing": "மருத்துவம்-குணப்படுத்தல்",
        # Grades
        "Very High": "மிக உயர்ந்தது", "High": "உயர்ந்தது", "Moderate": "மிதமான",
        "Low": "குறைவு", "Very Low": "மிகக் குறைவு",
        "Excellent": "சிறப்பு",
        "Good": "நல்ல",
        "Average": "சராசரி",
        "Below Average": "சராசரிக்குக் கீழ்",
        "Poor": "மோசமான",
        "Strong": "வலுவான",
        "Weak": "பலவீனமான",
        "Challenged": "சவாலான",
        # Planets
        "Sun": "சூரியன்", "Moon": "சந்திரன்", "Mars": "செவ்வாய்",
        "Mercury": "புதன்", "Jupiter": "குரு", "Venus": "சுக்கிரன்",
        "Saturn": "சனி", "Rahu": "ராகு", "Ketu": "கேது",
        # Dignities
        "Exalted": "உச்சம்", "Debilitated": "நீசம்",
        "Own": "சொந்தம்", "Friend": "நட்பு", "Enemy": "பகை",
        "Neutral": "நடுநிலை",
        # Signs
        "Aries": "மேஷம்", "Taurus": "ரிஷபம்", "Gemini": "மிதுனம்",
        "Cancer": "கடகம்", "Leo": "சிம்மம்", "Virgo": "கன்னி",
        "Libra": "துலாம்", "Scorpio": "விருச்சிகம்", "Sagittarius": "தனுசு",
        "Capricorn": "மகரம்", "Aquarius": "கும்பம்", "Pisces": "மீனம்",
        # Founder archetypes
        "Visionary-Leader-Founder": "தொலைநோக்கு-தலைவர்-நிறுவனர்",
        "Wealth-Compounder-Founder": "செல்வ-பெருக்கி-நிறுவனர்",
        "Action-Driven-Founder": "செயல்சார்-நிறுவனர்",
        "Tech-Innovator-Founder": "தொழில்நுட்ப-புதுமையாளர்-நிறுவனர்",
        "Advisory-Dharmic-Founder": "ஆலோசனை-தர்ம-நிறுவனர்",
        "Brand-Aesthetic-Founder": "பிராண்ட்-அழகியல்-நிறுவனர்",
        "Disciplined-Operator-Founder": "ஒழுங்கான-இயக்குநர்-நிறுவனர்",
        "People-Facing-Founder": "மக்கள்தொடர்பு-நிறுவனர்",
        "Research-Niche-Founder": "ஆராய்ச்சி-சிறப்பு-நிறுவனர்",
        "Generalist-Adaptive-Founder": "பன்முக-தகவமைப்பு-நிறுவனர்",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "அதிகார-தலைமை முயற்சிகள் (அரசு-தொடர்பு, மருத்துவ-நடைமுறை, நிர்வாக-ஆலோசனை)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "மக்கள்சார் முயற்சிகள் (விருந்தோம்பல், சில்லறை, உணவு-சேவை, ஊடகம், பராமரிப்பு)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "செயல்சார் முயற்சிகள் (பொறியியல், ரியல்-எஸ்டேட், விளையாட்டு, உற்பத்தி, பாதுகாப்பு)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "வணிக-தகவல் முயற்சிகள் (IT, ஆலோசனை, வர்த்தகம், ஊடகம், பகுப்பாய்வு, எழுத்து)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "ஆலோசனை-கல்வி முயற்சிகள் (கற்பித்தல், ஆலோசனை, நிதி-ஆலோசனை, பதிப்பகம், சட்ட)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "அழகியல்-ஆடம்பர முயற்சிகள் (வடிவமைப்பு, நாகரிகம், கேளிக்கை, ஆடம்பர-விருந்தோம்பல், அழகு)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "உள்கட்டமைப்பு-சேவை முயற்சிகள் (உற்பத்தி, தளவாடம், நிறுவன-சேவை, ஆராய்ச்சி)",
        "balanced ventures": "சமநிலை முயற்சிகள்",
        # Leadership styles
        "Authoritative Leader": "அதிகாரமிக்க தலைவர்",
        "Innovative Disruptor": "புதுமையான மாற்றுமுகவர்",
        "Strategic Planner": "உத்தி திட்டமிடுபவர்",
        "Collaborative Builder": "கூட்டு நிர்மாணிப்பவர்",
        "Visionary Pioneer": "தொலைநோக்கு முன்னோடி",
        "Steady Operator": "நிலையான இயக்குநர்",
        # Swakshetra dignity
        "Swakshetra 🏠": "சொந்த வீடு 🏠",
        "Normal": "சாதாரண",
        # Education archetypes
        "classical-scholar": "சாஸ்திரிய-அறிஞர்",
        "intellect-with-authority": "அறிவு-அதிகாரம்",
        "researcher-investigator": "ஆராய்ச்சியாளர்-புலனாய்வாளர்",
        "modern-technologist": "நவீன-தொழில்நுட்பவியலாளர்",
        "wisdom-teacher": "ஞான-குரு",
        "creative-artist": "படைப்பாற்றல்-கலைஞர்",
        "patient-builder": "பொறுமையான-நிர்மாணிப்பவர்",
        "generalist-learner": "பன்முக-கற்பவர்",
        # Education learning styles
        "quick-analytical-visual": "விரைவான-பகுப்பாய்வு-காட்சி",
        "deep-philosophical-synthesizing": "ஆழமான-தத்துவ-தொகுப்பு",
        "intuitive-emotional-kinesthetic": "உள்ளுணர்வு-உணர்ச்சி-இயக்க",
        "action-experiential-competitive": "செயல்-அனுபவ-போட்டி",
        "systematic-methodical-disciplined": "முறையான-வழிமுறை-ஒழுங்கான",
        "aesthetic-creative-associative": "அழகியல்-படைப்பு-தொடர்பு",
        "unconventional-innovative-research-oriented": "வழக்கத்திற்கு-மாறான-புதுமை-ஆராய்ச்சிசார்",
        "mixed-adaptive-balanced": "கலவை-தகவமைப்பு-சமநிலை",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "தலைமை/நிர்வாகம்/அரசியல்-அறிவியல்/மருத்துவம்/அரசு-படிப்பு",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "உளவியல்/செவிலியம்/விருந்தோம்பல்/உணவு-அறிவியல்/மக்கள்தொடர்பு",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "பொறியியல்/இராணுவ-படிப்பு/அறுவை/விளையாட்டு/ரியல்-எஸ்டேட்/இயந்திரவியல்",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "வணிகம்/IT/தகவல்தொடர்பு/கணக்கியல்/எழுத்து/மொழியியல்/தரவு-பகுப்பாய்வு",
        "law/philosophy/education/finance/religion/advisory-studies": "சட்டம்/தத்துவம்/கல்வி/நிதி/மதம்/ஆலோசனை-படிப்பு",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "கலை/வடிவமைப்பு/இசை/ஆடம்பர-பிராண்ட்/நாகரிகம்/கேளிக்கை/அழகு",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "ஆராய்ச்சி/பொறியியல்/உள்கட்டமைப்பு/சுரங்கம்/சேவை-தொழில்/தொழிலாளர்-படிப்பு",
        # Wealth types
        "earned": "சம்பாதித்த", "inherited": "பரம்பரை",
        "speculative": "ஊக", "mixed": "கலவை",
        "professional": "தொழில்முறை", "business": "வணிகம்",
        "passive": "செயலற்ற",
        # Investment styles
        "accumulator": "சேகரிப்பாளர்", "trader": "வர்த்தகர்",
        "speculator": "ஊகவணிகர்", "passive-holder": "செயலற்ற-வைத்திருப்பவர்",
        "balanced-investor": "சமநிலை-முதலீட்டாளர்",
        # Wealth acquisition styles
        "effort-based": "முயற்சி-அடிப்படை",
        "relationship-based": "உறவு-அடிப்படை",
        "balanced": "சமநிலை",
        # Risk categories
        "high": "உயர்", "medium": "நடுத்தர", "low": "குறை",
        # Love styles
        "romantic": "காதல்வயப்பட்ட", "cautious": "எச்சரிக்கையான",
        "slow-warmth": "மெதுவான-அன்பு", "magnetic": "கவர்ச்சியான",
        "quick-falls": "விரைவு-காதல்", "passionate": "ஆர்வமிக்க",
        "steady": "நிலையான", "detached": "பற்றற்ற",
        # Marriage archetypes
        "refined-partner": "பண்பட்ட-துணை",
        "unconventional-partner": "வழக்கத்திற்கு-மாறான-துணை",
        "service-oriented-partner": "சேவை-நோக்கு-துணை",
        # Health types
        "acute": "கடுமையான", "psychosomatic": "மனோதைகிக",
        "chronic": "நாள்பட்ட", "structural": "கட்டமைப்பு",
        # Mental stress styles
        "open": "வெளிப்படையான", "measured": "கட்டுப்பாடான",
        "suppressed": "அடக்கப்பட்ட", "explosive": "வெடிப்பான",
        "withdrawn": "உள்முகமான",
        # Property types
        "acquisitive": "கையகப்படுத்தும்", "protective": "பாதுகாப்பான",
        "volatile": "நிலையற்ற", "minimal": "குறைந்தபட்ச",
        "luxury-car": "ஆடம்பர-வாகனம்", "practical-sedan": "நடைமுறை-செடான்",
        "utility-vehicle": "பயன்பாட்டு-வாகனம்",
        # Legal types
        "litigation-prone": "வழக்கு-எளிதான", "defensive-prone": "தற்காப்பு-எளிதான",
        "protracted-cases": "நீடித்த-வழக்குகள்", "settlement-prone": "தீர்வு-எளிதான",
        "quick-resolution": "விரைவு-தீர்வு",
        # Life path karma types
        "dharmic-continuation": "தர்ம-தொடர்ச்சி",
        "mastery-completion": "திறன்-நிறைவு",
        "karmic-resolution": "கர்ம-தீர்வு",
        "wisdom-teaching": "ஞான-கற்பித்தல்",
        "purification-focused": "சுத்திகரிப்பு-மையம்",
        "service-karma": "சேவை-கர்மா",
        "new-beginning": "புதிய-தொடக்கம்",
        # Past life
        "peaceful-natural": "அமைதியான-இயற்கையான",
        # Debt
        "secured": "உத்தரவாதமான", "unsecured": "உத்தரவாதமற்ற",
    },
    "te": {
        # Career categories
        "leadership-executive": "నాయకత్వం-కార్యనిర్వాహక",
        "government-administration": "ప్రభుత్వ-పరిపాలన",
        "military-defense": "సైనిక-రక్షణ",
        "technical-engineering": "సాంకేతిక-ఇంజనీరింగ్",
        "skilled-trade": "నైపుణ్య-వ్యాపారం",
        "education-teaching": "విద్య-బోధన",
        "business-commerce": "వ్యాపారం-వాణిజ్యం",
        "technology-software": "సాంకేతికత-సాఫ్ట్‌వేర్",
        "spiritual-religious": "ఆధ్యాత్మిక-మతపరమైన",
        "finance-banking": "ఆర్థిక-బ్యాంకింగ్",
        "media-communication": "మీడియా-సంభాషణ",
        "entertainment-performance": "వినోదం-ప్రదర్శన",
        "creative-arts": "సృజనాత్మక-కళ",
        "service-hospitality": "సేవ-ఆతిథ్యం",
        "research-scientific": "పరిశోధన-శాస్త్రీయ",
        "medical-healing": "వైద్య-చికిత్స",
        # Grades
        "Very High": "చాలా ఎక్కువ", "High": "ఎక్కువ", "Moderate": "మధ్యస్థం",
        "Low": "తక్కువ", "Very Low": "చాలా తక్కువ",
        "Excellent": "అద్భుతం",
        "Good": "మంచి",
        "Average": "సగటు",
        "Below Average": "సగటు కంటే తక్కువ",
        "Poor": "బలహీనం",
        "Strong": "బలమైన",
        "Weak": "బలహీనమైన",
        "Challenged": "సవాలైన",
        # Planets
        "Sun": "సూర్యుడు", "Moon": "చంద్రుడు", "Mars": "కుజుడు",
        "Mercury": "బుధుడు", "Jupiter": "గురుడు", "Venus": "శుక్రుడు",
        "Saturn": "శని", "Rahu": "రాహువు", "Ketu": "కేతువు",
        # Dignities
        "Exalted": "ఉచ్చ", "Debilitated": "నీచ",
        "Own": "స్వగృహ", "Friend": "మిత్ర", "Enemy": "శత్రు",
        "Neutral": "తటస్థ",
        # Signs
        "Aries": "మేషం", "Taurus": "వృషభం", "Gemini": "మిథునం",
        "Cancer": "కర్కాటకం", "Leo": "సింహం", "Virgo": "కన్య",
        "Libra": "తుల", "Scorpio": "వృశ్చికం", "Sagittarius": "ధనుస్సు",
        "Capricorn": "మకరం", "Aquarius": "కుంభం", "Pisces": "మీనం",
        # Founder archetypes
        "Visionary-Leader-Founder": "దూరదృష్టి-నాయకుడు-వ్యవస్థాపకుడు",
        "Wealth-Compounder-Founder": "సంపద-వృద్ధి-వ్యవస్థాపకుడు",
        "Action-Driven-Founder": "కర్మశీల-వ్యవస్థాపకుడు",
        "Tech-Innovator-Founder": "టెక్-ఆవిష్కర్త-వ్యవస్థాపకుడు",
        "Advisory-Dharmic-Founder": "సలహాదారు-ధార్మిక-వ్యవస్థాపకుడు",
        "Brand-Aesthetic-Founder": "బ్రాండ్-సౌందర్య-వ్యవస్థాపకుడు",
        "Disciplined-Operator-Founder": "క్రమశిక్షణ-నిర్వాహకుడు-వ్యవస్థాపకుడు",
        "People-Facing-Founder": "జనసంబంధ-వ్యవస్థాపకుడు",
        "Research-Niche-Founder": "పరిశోధన-ప్రత్యేక-వ్యవస్థాపకుడు",
        "Generalist-Adaptive-Founder": "బహుముఖ-అనుకూల-వ్యవస్థాపకుడు",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "అధికార-నాయకత్వ వ్యాపారాలు (ప్రభుత్వ-సంబంధం, వైద్య-అభ్యాసం, పరిపాలన-సలహా)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "ప్రజా-సేవ వ్యాపారాలు (ఆతిథ్యం, రిటైల్, ఆహార-సేవ, మీడియా, పోషణ-సేవలు)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "కార్య-ఆధారిత వ్యాపారాలు (ఇంజనీరింగ్, రియల్-ఎస్టేట్, క్రీడలు, తయారీ, భద్రత)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "వాణిజ్య-సంభాషణ వ్యాపారాలు (IT, సలహా, వర్తకం, మీడియా, విశ్లేషణ, రచన)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "సలహా-విద్యా వ్యాపారాలు (బోధన, కౌన్సెలింగ్, ఆర్థిక-సలహా, ప్రచురణ, న్యాయ)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "సౌందర్య-విలాస వ్యాపారాలు (డిజైన్, ఫ్యాషన్, వినోదం, విలాస-ఆతిథ్యం, అందం)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "మౌలిక-సేవ వ్యాపారాలు (తయారీ, రవాణా, సంస్థాగత-సేవలు, పరిశోధన)",
        "balanced ventures": "సమతుల్య వ్యాపారాలు",
        # Leadership styles
        "Authoritative Leader": "అధికార నాయకుడు",
        "Innovative Disruptor": "నూతన మార్పుకర్త",
        "Strategic Planner": "వ్యూహాత్మక ప్రణాళికాకర్త",
        "Collaborative Builder": "సహకార నిర్మాత",
        "Visionary Pioneer": "దూరదృష్టి ముందుచూపు",
        "Steady Operator": "స్థిర నిర్వాహకుడు",
        # Swakshetra dignity
        "Swakshetra 🏠": "స్వగృహ 🏠",
        "Normal": "సాధారణ",
        # Education archetypes
        "classical-scholar": "శాస్త్రీయ-పండితుడు",
        "intellect-with-authority": "మేధస్సు-అధికారం",
        "researcher-investigator": "పరిశోధకుడు-దర్యాప్తుదారుడు",
        "modern-technologist": "ఆధునిక-సాంకేతికవేత్త",
        "wisdom-teacher": "జ్ఞాన-గురువు",
        "creative-artist": "సృజనాత్మక-కళాకారుడు",
        "patient-builder": "ఓర్పుగల-నిర్మాత",
        "generalist-learner": "బహుముఖ-అభ్యాసకుడు",
        # Education learning styles
        "quick-analytical-visual": "వేగవంతమైన-విశ్లేషణ-దృశ్య",
        "deep-philosophical-synthesizing": "లోతైన-తాత్విక-సంశ్లేషణ",
        "intuitive-emotional-kinesthetic": "అంతర్జ్ఞాన-భావోద్వేగ-చలనాత్మక",
        "action-experiential-competitive": "కార్య-అనుభవాత్మక-పోటీ",
        "systematic-methodical-disciplined": "క్రమబద్ధ-పద్ధతిగల-క్రమశిక్షణ",
        "aesthetic-creative-associative": "సౌందర్యపరమైన-సృజనాత్మక-సహచర",
        "unconventional-innovative-research-oriented": "అసాంప్రదాయిక-నూతన-పరిశోధనాధారిత",
        "mixed-adaptive-balanced": "మిశ్రమ-అనుకూల-సమతుల్య",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "నాయకత్వం/పరిపాలన/రాజకీయ-శాస్త్రం/వైద్యం/ప్రభుత్వ-అధ్యయనం",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "మనోవిజ్ఞానం/నర్సింగ్/ఆతిథ్యం/ఆహార-శాస్త్రం/ప్రజా-సంబంధాలు",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "ఇంజనీరింగ్/సైనిక-అధ్యయనం/శస్త్రచికిత్స/క్రీడలు/రియల్-ఎస్టేట్/యంత్రశాస్త్రం",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "వాణిజ్యం/IT/సంభాషణ/అకౌంటింగ్/రచన/భాషాశాస్త్రం/డేటా-విశ్లేషణ",
        "law/philosophy/education/finance/religion/advisory-studies": "న్యాయం/తత్వశాస్త్రం/విద్య/ఆర్థికం/మతం/సలహా-అధ్యయనం",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "కళ/డిజైన్/సంగీతం/విలాస-బ్రాండ్/ఫ్యాషన్/వినోదం/అందం",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "పరిశోధన/ఇంజనీరింగ్/మౌలిక-సదుపాయాలు/గనులు/సేవా-పరిశ్రమ/శ్రమ-అధ్యయనం",
        # Wealth types
        "earned": "సంపాదించిన", "inherited": "వారసత్వ",
        "speculative": "ఊహాజనిత", "mixed": "మిశ్రమ",
        "professional": "వృత్తిపరమైన", "business": "వ్యాపారం",
        "passive": "నిష్క్రియ",
        # Investment styles
        "accumulator": "సేకరణకర్త", "trader": "వ్యాపారి",
        "speculator": "ఊహాగానవర్తకుడు", "passive-holder": "నిష్క్రియ-ధారకుడు",
        "balanced-investor": "సమతుల్య-పెట్టుబడిదారుడు",
        # Wealth acquisition styles
        "effort-based": "కృషి-ఆధారిత",
        "relationship-based": "సంబంధ-ఆధారిత",
        "balanced": "సమతుల్య",
        # Risk categories
        "high": "ఎక్కువ", "medium": "మధ్యస్థం", "low": "తక్కువ",
        # Love styles
        "romantic": "రొమాంటిక్", "cautious": "జాగ్రత్తగల",
        "slow-warmth": "నెమ్మదైన-వేడి", "magnetic": "ఆకర్షణీయ",
        "quick-falls": "తక్షణ-ప్రేమ", "passionate": "ఉద్వేగభరిత",
        "steady": "స్థిరమైన", "detached": "నిర్లిప్త",
        # Marriage archetypes
        "refined-partner": "పరిష్కృత-భాగస్వామి",
        "unconventional-partner": "అసాంప్రదాయిక-భాగస్వామి",
        "service-oriented-partner": "సేవాధారిత-భాగస్వామి",
        # Health types
        "acute": "తీవ్రమైన", "psychosomatic": "మనోదైహిక",
        "chronic": "దీర్ఘకాలిక", "structural": "నిర్మాణాత్మక",
        # Mental stress styles
        "open": "బహిరంగ", "measured": "సంయమిత",
        "suppressed": "అణచిపెట్టిన", "explosive": "విస్ఫోటనాత్మక",
        "withdrawn": "అంతర్ముఖ",
        # Property types
        "acquisitive": "స్వాధీనపరచుకునే", "protective": "రక్షణాత్మక",
        "volatile": "అస్థిర", "minimal": "కనిష్ఠ",
        "luxury-car": "విలాస-వాహనం", "practical-sedan": "ఆచరణాత్మక-సెడాన్",
        "utility-vehicle": "ఉపయోగ-వాహనం",
        # Legal types
        "litigation-prone": "వ్యాజ్యం-సులభమైన", "defensive-prone": "రక్షణ-సులభమైన",
        "protracted-cases": "దీర్ఘకాల-కేసులు", "settlement-prone": "సంధి-సులభమైన",
        "quick-resolution": "శీఘ్ర-పరిష్కారం",
        # Life path karma types
        "dharmic-continuation": "ధార్మిక-కొనసాగింపు",
        "mastery-completion": "నైపుణ్య-పూర్తి",
        "karmic-resolution": "కర్మ-పరిష్కారం",
        "wisdom-teaching": "జ్ఞాన-బోధన",
        "purification-focused": "శుద్ధీకరణ-కేంద్రిత",
        "service-karma": "సేవా-కర్మ",
        "new-beginning": "కొత్త-ప్రారంభం",
        # Past life
        "peaceful-natural": "శాంతియుత-సహజ",
        # Debt
        "secured": "భద్రమైన", "unsecured": "అభద్రమైన",
    },
    "kn": {
        # Career categories
        "leadership-executive": "ನಾಯಕತ್ವ-ಕಾರ್ಯನಿರ್ವಾಹಕ",
        "government-administration": "ಸರ್ಕಾರಿ-ಆಡಳಿತ",
        "military-defense": "ಸೈನಿಕ-ರಕ್ಷಣೆ",
        "technical-engineering": "ತಾಂತ್ರಿಕ-ಎಂಜಿನಿಯರಿಂಗ್",
        "skilled-trade": "ಕೌಶಲ-ವ್ಯಾಪಾರ",
        "education-teaching": "ಶಿಕ್ಷಣ-ಬೋಧನೆ",
        "business-commerce": "ವ್ಯಾಪಾರ-ವಾಣಿಜ್ಯ",
        "technology-software": "ತಂತ್ರಜ್ಞಾನ-ಸಾಫ್ಟ್‌ವೇರ್",
        "spiritual-religious": "ಆಧ್ಯಾತ್ಮಿಕ-ಧಾರ್ಮಿಕ",
        "finance-banking": "ಹಣಕಾಸು-ಬ್ಯಾಂಕಿಂಗ್",
        "media-communication": "ಮಾಧ್ಯಮ-ಸಂವಹನ",
        "entertainment-performance": "ಮನರಂಜನೆ-ಪ್ರದರ್ಶನ",
        "creative-arts": "ಸೃಜನಾತ್ಮಕ-ಕಲೆ",
        "service-hospitality": "ಸೇವೆ-ಆತಿಥ್ಯ",
        "research-scientific": "ಸಂಶೋಧನೆ-ವೈಜ್ಞಾನಿಕ",
        "medical-healing": "ವೈದ್ಯಕೀಯ-ಚಿಕಿತ್ಸೆ",
        # Grades
        "Very High": "ತುಂಬಾ ಹೆಚ್ಚು", "High": "ಹೆಚ್ಚು", "Moderate": "ಮಧ್ಯಮ",
        "Low": "ಕಡಿಮೆ", "Very Low": "ತುಂಬಾ ಕಡಿಮೆ",
        "Excellent": "ಅತ್ಯುತ್ತಮ",
        "Good": "ಒಳ್ಳೆಯ",
        "Average": "ಸರಾಸರಿ",
        "Below Average": "ಸರಾಸರಿಗಿಂತ ಕಡಿಮೆ",
        "Poor": "ಕಳಪೆ",
        "Strong": "ಬಲಿಷ್ಠ",
        "Weak": "ದುರ್ಬಲ",
        "Challenged": "ಸವಾಲಿನ",
        # Planets
        "Sun": "ಸೂರ್ಯ", "Moon": "ಚಂದ್ರ", "Mars": "ಕುಜ",
        "Mercury": "ಬುಧ", "Jupiter": "ಗುರು", "Venus": "ಶುಕ್ರ",
        "Saturn": "ಶನಿ", "Rahu": "ರಾಹು", "Ketu": "ಕೇತು",
        # Dignities
        "Exalted": "ಉಚ್ಚ", "Debilitated": "ನೀಚ",
        "Own": "ಸ್ವಗೃಹ", "Friend": "ಮಿತ್ರ", "Enemy": "ಶತ್ರು",
        "Neutral": "ತಟಸ್ಥ",
        # Signs
        "Aries": "ಮೇಷ", "Taurus": "ವೃಷಭ", "Gemini": "ಮಿಥುನ",
        "Cancer": "ಕರ್ಕಾಟಕ", "Leo": "ಸಿಂಹ", "Virgo": "ಕನ್ಯಾ",
        "Libra": "ತುಲಾ", "Scorpio": "ವೃಶ್ಚಿಕ", "Sagittarius": "ಧನು",
        "Capricorn": "ಮಕರ", "Aquarius": "ಕುಂಭ", "Pisces": "ಮೀನ",
        # Founder archetypes
        "Visionary-Leader-Founder": "ದೂರದರ್ಶಿ-ನಾಯಕ-ಸಂಸ್ಥಾಪಕ",
        "Wealth-Compounder-Founder": "ಸಂಪತ್ತು-ವೃದ್ಧಿ-ಸಂಸ್ಥಾಪಕ",
        "Action-Driven-Founder": "ಕ್ರಿಯಾಶೀಲ-ಸಂಸ್ಥಾಪಕ",
        "Tech-Innovator-Founder": "ತಂತ್ರಜ್ಞಾನ-ಆವಿಷ್ಕಾರಕ-ಸಂಸ್ಥಾಪಕ",
        "Advisory-Dharmic-Founder": "ಸಲಹೆಗಾರ-ಧಾರ್ಮಿಕ-ಸಂಸ್ಥಾಪಕ",
        "Brand-Aesthetic-Founder": "ಬ್ರ್ಯಾಂಡ್-ಸೌಂದರ್ಯ-ಸಂಸ್ಥಾಪಕ",
        "Disciplined-Operator-Founder": "ಶಿಸ್ತುಬದ್ಧ-ನಿರ್ವಾಹಕ-ಸಂಸ್ಥಾಪಕ",
        "People-Facing-Founder": "ಜನಸಂಪರ್ಕ-ಸಂಸ್ಥಾಪಕ",
        "Research-Niche-Founder": "ಸಂಶೋಧನೆ-ವಿಶೇಷ-ಸಂಸ್ಥಾಪಕ",
        "Generalist-Adaptive-Founder": "ಬಹುಮುಖ-ಹೊಂದಾಣಿಕೆ-ಸಂಸ್ಥಾಪಕ",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "ಅಧಿಕಾರ-ನಾಯಕತ್ವ ಉದ್ಯಮಗಳು (ಸರ್ಕಾರಿ-ಸಂಪರ್ಕ, ವೈದ್ಯಕೀಯ-ಅಭ್ಯಾಸ, ಆಡಳಿತ-ಸಲಹೆ)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "ಜನಸೇವಾ ಉದ್ಯಮಗಳು (ಆತಿಥ್ಯ, ಚಿಲ್ಲರೆ, ಆಹಾರ-ಸೇವೆ, ಮಾಧ್ಯಮ, ಪೋಷಣೆ-ಸೇವೆ)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "ಕ್ರಿಯಾಧಾರಿತ ಉದ್ಯಮಗಳು (ಎಂಜಿನಿಯರಿಂಗ್, ರಿಯಲ್-ಎಸ್ಟೇಟ್, ಕ್ರೀಡೆ, ತಯಾರಿಕೆ, ಭದ್ರತೆ)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "ವಾಣಿಜ್ಯ-ಸಂವಹನ ಉದ್ಯಮಗಳು (IT, ಸಲಹೆ, ವ್ಯಾಪಾರ, ಮಾಧ್ಯಮ, ವಿಶ್ಲೇಷಣೆ, ಬರವಣಿಗೆ)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "ಸಲಹೆ-ಶೈಕ್ಷಣಿಕ ಉದ್ಯಮಗಳು (ಬೋಧನೆ, ಸಮಾಲೋಚನೆ, ಹಣಕಾಸು-ಸಲಹೆ, ಪ್ರಕಾಶನ, ಕಾನೂನು)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "ಸೌಂದರ್ಯ-ಐಷಾರಾಮ ಉದ್ಯಮಗಳು (ವಿನ್ಯಾಸ, ಫ್ಯಾಶನ್, ಮನರಂಜನೆ, ಐಷಾರಾಮ-ಆತಿಥ್ಯ, ಸೌಂದರ್ಯ)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "ಮೂಲಸೌಕರ್ಯ-ಸೇವಾ ಉದ್ಯಮಗಳು (ತಯಾರಿಕೆ, ಸರಕು-ಸಾಗಾಟ, ಸಂಸ್ಥಾಗತ-ಸೇವೆ, ಸಂಶೋಧನೆ)",
        "balanced ventures": "ಸಮತೋಲಿತ ಉದ್ಯಮಗಳು",
        # Leadership styles
        "Authoritative Leader": "ಅಧಿಕಾರಯುತ ನಾಯಕ",
        "Innovative Disruptor": "ನವೀನ ಬದಲಾವಣೆಗಾರ",
        "Strategic Planner": "ವ್ಯೂಹಾತ್ಮಕ ಯೋಜಕ",
        "Collaborative Builder": "ಸಹಯೋಗಿ ನಿರ್ಮಾಣಕಾರ",
        "Visionary Pioneer": "ದೂರದರ್ಶಿ ಮುಂಚೂಣಿಗಾರ",
        "Steady Operator": "ಸ್ಥಿರ ನಿರ್ವಾಹಕ",
        # Swakshetra dignity
        "Swakshetra 🏠": "ಸ್ವಗೃಹ 🏠",
        "Normal": "ಸಾಮಾನ್ಯ",
        # Education archetypes
        "classical-scholar": "ಶಾಸ್ತ್ರೀಯ-ವಿದ್ವಾಂಸ",
        "intellect-with-authority": "ಬುದ್ಧಿ-ಅಧಿಕಾರ",
        "researcher-investigator": "ಸಂಶೋಧಕ-ತನಿಖೆಗಾರ",
        "modern-technologist": "ಆಧುನಿಕ-ತಂತ್ರಜ್ಞ",
        "wisdom-teacher": "ಜ್ಞಾನ-ಗುರು",
        "creative-artist": "ಸೃಜನಾತ್ಮಕ-ಕಲಾವಿದ",
        "patient-builder": "ತಾಳ್ಮೆಯ-ನಿರ್ಮಾಣಕಾರ",
        "generalist-learner": "ಬಹುಮುಖ-ವಿದ್ಯಾರ್ಥಿ",
        # Education learning styles
        "quick-analytical-visual": "ತ್ವರಿತ-ವಿಶ್ಲೇಷಣಾತ್ಮಕ-ದೃಶ್ಯ",
        "deep-philosophical-synthesizing": "ಆಳವಾದ-ತಾತ್ವಿಕ-ಸಂಶ್ಲೇಷಣೆ",
        "intuitive-emotional-kinesthetic": "ಅಂತಃಪ್ರಜ್ಞೆ-ಭಾವನಾತ್ಮಕ-ಚಲನಾತ್ಮಕ",
        "action-experiential-competitive": "ಕ್ರಿಯಾಶೀಲ-ಅನುಭವಾತ್ಮಕ-ಸ್ಪರ್ಧಾತ್ಮಕ",
        "systematic-methodical-disciplined": "ಕ್ರಮಬದ್ಧ-ಪದ್ಧತಿಯ-ಶಿಸ್ತುಬದ್ಧ",
        "aesthetic-creative-associative": "ಸೌಂದರ್ಯಾತ್ಮಕ-ಸೃಜನಾತ್ಮಕ-ಸಾಹಚರ್ಯ",
        "unconventional-innovative-research-oriented": "ಅಸಾಂಪ್ರದಾಯಿಕ-ನವೀನ-ಸಂಶೋಧನಾಧಾರಿತ",
        "mixed-adaptive-balanced": "ಮಿಶ್ರ-ಹೊಂದಾಣಿಕೆ-ಸಮತೋಲಿತ",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "ನಾಯಕತ್ವ/ಆಡಳಿತ/ರಾಜಕೀಯ-ಶಾಸ್ತ್ರ/ವೈದ್ಯಕೀಯ/ಸರ್ಕಾರಿ-ಅಧ್ಯಯನ",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "ಮನಶ್ಶಾಸ್ತ್ರ/ನರ್ಸಿಂಗ್/ಆತಿಥ್ಯ/ಆಹಾರ-ವಿಜ್ಞಾನ/ಸಾರ್ವಜನಿಕ-ಸಂಬಂಧ",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "ಎಂಜಿನಿಯರಿಂಗ್/ಸೈನಿಕ-ಅಧ್ಯಯನ/ಶಸ್ತ್ರಚಿಕಿತ್ಸೆ/ಕ್ರೀಡೆ/ರಿಯಲ್-ಎಸ್ಟೇಟ್/ಯಂತ್ರಶಾಸ್ತ್ರ",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "ವಾಣಿಜ್ಯ/IT/ಸಂವಹನ/ಲೆಕ್ಕಪತ್ರ/ಬರವಣಿಗೆ/ಭಾಷಾಶಾಸ್ತ್ರ/ಡೇಟಾ-ವಿಶ್ಲೇಷಣೆ",
        "law/philosophy/education/finance/religion/advisory-studies": "ಕಾನೂನು/ತತ್ವಶಾಸ್ತ್ರ/ಶಿಕ್ಷಣ/ಹಣಕಾಸು/ಧರ್ಮ/ಸಲಹಾ-ಅಧ್ಯಯನ",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "ಕಲೆ/ವಿನ್ಯಾಸ/ಸಂಗೀತ/ಐಷಾರಾಮ-ಬ್ರ್ಯಾಂಡ್/ಫ್ಯಾಶನ್/ಮನರಂಜನೆ/ಸೌಂದರ್ಯ",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "ಸಂಶೋಧನೆ/ಎಂಜಿನಿಯರಿಂಗ್/ಮೂಲಸೌಕರ್ಯ/ಗಣಿಗಾರಿಕೆ/ಸೇವಾ-ಉದ್ಯಮ/ಕಾರ್ಮಿಕ-ಅಧ್ಯಯನ",
        # Wealth types
        "earned": "ಗಳಿಸಿದ", "inherited": "ಪಾರಂಪರಿಕ",
        "speculative": "ಊಹಾತ್ಮಕ", "mixed": "ಮಿಶ್ರ",
        "professional": "ವೃತ್ತಿಪರ", "business": "ವ್ಯಾಪಾರ",
        "passive": "ನಿಷ್ಕ್ರಿಯ",
        # Investment styles
        "accumulator": "ಸಂಚಯಕಾರ", "trader": "ವ್ಯಾಪಾರಿ",
        "speculator": "ಊಹಾವ್ಯಾಪಾರಿ", "passive-holder": "ನಿಷ್ಕ್ರಿಯ-ಧಾರಕ",
        "balanced-investor": "ಸಮತೋಲಿತ-ಹೂಡಿಕೆದಾರ",
        # Wealth acquisition styles
        "effort-based": "ಪ್ರಯತ್ನ-ಆಧಾರಿತ",
        "relationship-based": "ಸಂಬಂಧ-ಆಧಾರಿತ",
        "balanced": "ಸಮತೋಲಿತ",
        # Risk categories
        "high": "ಹೆಚ್ಚು", "medium": "ಮಧ್ಯಮ", "low": "ಕಡಿಮೆ",
        # Love styles
        "romantic": "ರೊಮ್ಯಾಂಟಿಕ್", "cautious": "ಎಚ್ಚರಿಕೆಯ",
        "slow-warmth": "ನಿಧಾನ-ಬೆಚ್ಚಗೆ", "magnetic": "ಆಕರ್ಷಕ",
        "quick-falls": "ತ್ವರಿತ-ಪ್ರೇಮ", "passionate": "ಉತ್ಕಟ",
        "steady": "ಸ್ಥಿರ", "detached": "ನಿರ್ಲಿಪ್ತ",
        # Marriage archetypes
        "refined-partner": "ಪರಿಷ್ಕೃತ-ಸಂಗಾತಿ",
        "unconventional-partner": "ಅಸಾಂಪ್ರದಾಯಿಕ-ಸಂಗಾತಿ",
        "service-oriented-partner": "ಸೇವಾಧಾರಿತ-ಸಂಗಾತಿ",
        # Health types
        "acute": "ತೀವ್ರ", "psychosomatic": "ಮನೋದೈಹಿಕ",
        "chronic": "ದೀರ್ಘಕಾಲಿಕ", "structural": "ರಚನಾತ್ಮಕ",
        # Mental stress styles
        "open": "ಮುಕ್ತ", "measured": "ಸಂಯಮಿತ",
        "suppressed": "ಅಡಗಿಸಿದ", "explosive": "ಸ್ಫೋಟಕ",
        "withdrawn": "ಅಂತರ್ಮುಖ",
        # Property types
        "acquisitive": "ಸ್ವಾಧೀನಕಾರಿ", "protective": "ರಕ್ಷಣಾತ್ಮಕ",
        "volatile": "ಅಸ್ಥಿರ", "minimal": "ಕನಿಷ್ಠ",
        "luxury-car": "ಐಷಾರಾಮ-ವಾಹನ", "practical-sedan": "ಪ್ರಾಯೋಗಿಕ-ಸೆಡಾನ್",
        "utility-vehicle": "ಉಪಯೋಗ-ವಾಹನ",
        # Legal types
        "litigation-prone": "ವ್ಯಾಜ್ಯ-ಪ್ರವಣ", "defensive-prone": "ರಕ್ಷಣಾ-ಪ್ರವಣ",
        "protracted-cases": "ದೀರ್ಘ-ಪ್ರಕರಣಗಳು", "settlement-prone": "ಒಪ್ಪಂದ-ಪ್ರವಣ",
        "quick-resolution": "ತ್ವರಿತ-ಪರಿಹಾರ",
        # Life path karma types
        "dharmic-continuation": "ಧಾರ್ಮಿಕ-ಮುಂದುವರಿಕೆ",
        "mastery-completion": "ಪ್ರಾವೀಣ್ಯ-ಪೂರ್ಣತೆ",
        "karmic-resolution": "ಕರ್ಮ-ಪರಿಹಾರ",
        "wisdom-teaching": "ಜ್ಞಾನ-ಬೋಧನೆ",
        "purification-focused": "ಶುದ್ಧೀಕರಣ-ಕೇಂದ್ರಿತ",
        "service-karma": "ಸೇವಾ-ಕರ್ಮ",
        "new-beginning": "ಹೊಸ-ಆರಂಭ",
        # Past life
        "peaceful-natural": "ಶಾಂತ-ನೈಸರ್ಗಿಕ",
        # Debt
        "secured": "ಸುರಕ್ಷಿತ", "unsecured": "ಅಸುರಕ್ಷಿತ",
    },
    "bn": {
        # Career categories
        "leadership-executive": "নেতৃত্ব-কার্যনির্বাহী",
        "government-administration": "সরকারি-প্রশাসন",
        "military-defense": "সামরিক-প্রতিরক্ষা",
        "technical-engineering": "কারিগরি-প্রকৌশল",
        "skilled-trade": "দক্ষ-ব্যবসা",
        "education-teaching": "শিক্ষা-শিক্ষকতা",
        "business-commerce": "ব্যবসা-বাণিজ্য",
        "technology-software": "প্রযুক্তি-সফটওয়্যার",
        "spiritual-religious": "আধ্যাত্মিক-ধর্মীয়",
        "finance-banking": "অর্থ-ব্যাংকিং",
        "media-communication": "মিডিয়া-যোগাযোগ",
        "entertainment-performance": "বিনোদন-পরিবেশনা",
        "creative-arts": "সৃজনশীল-কলা",
        "service-hospitality": "সেবা-আতিথেয়তা",
        "research-scientific": "গবেষণা-বৈজ্ঞানিক",
        "medical-healing": "চিকিৎসা-আরোগ্য",
        # Grades
        "Very High": "অত্যন্ত উচ্চ", "High": "উচ্চ", "Moderate": "মাঝারি",
        "Low": "নিম্ন", "Very Low": "অত্যন্ত নিম্ন",
        "Excellent": "চমৎকার",
        "Good": "ভালো",
        "Average": "গড়",
        "Below Average": "গড়ের নিচে",
        "Poor": "দুর্বল",
        "Strong": "শক্তিশালী",
        "Weak": "দুর্বল",
        "Challenged": "চ্যালেঞ্জপূর্ণ",
        # Planets
        "Sun": "সূর্য", "Moon": "চন্দ্র", "Mars": "মঙ্গল",
        "Mercury": "বুধ", "Jupiter": "বৃহস্পতি", "Venus": "শুক্র",
        "Saturn": "শনি", "Rahu": "রাহু", "Ketu": "কেতু",
        # Dignities
        "Exalted": "উচ্চ", "Debilitated": "নীচ",
        "Own": "স্বগৃহী", "Friend": "মিত্র", "Enemy": "শত্রু",
        "Neutral": "নিরপেক্ষ",
        # Signs
        "Aries": "মেষ", "Taurus": "বৃষ", "Gemini": "মিথুন",
        "Cancer": "কর্কট", "Leo": "সিংহ", "Virgo": "কন্যা",
        "Libra": "তুলা", "Scorpio": "বৃশ্চিক", "Sagittarius": "ধনু",
        "Capricorn": "মকর", "Aquarius": "কুম্ভ", "Pisces": "মীন",
        # Founder archetypes
        "Visionary-Leader-Founder": "দূরদর্শী-নেতা-প্রতিষ্ঠাতা",
        "Wealth-Compounder-Founder": "সম্পদ-বৃদ্ধিকারী-প্রতিষ্ঠাতা",
        "Action-Driven-Founder": "কর্মশীল-প্রতিষ্ঠাতা",
        "Tech-Innovator-Founder": "প্রযুক্তি-উদ্ভাবক-প্রতিষ্ঠাতা",
        "Advisory-Dharmic-Founder": "পরামর্শদাতা-ধর্মীয়-প্রতিষ্ঠাতা",
        "Brand-Aesthetic-Founder": "ব্র্যান্ড-সৌন্দর্য-প্রতিষ্ঠাতা",
        "Disciplined-Operator-Founder": "শৃঙ্খলাবদ্ধ-পরিচালক-প্রতিষ্ঠাতা",
        "People-Facing-Founder": "জনসংযোগ-প্রতিষ্ঠাতা",
        "Research-Niche-Founder": "গবেষণা-বিশেষায়িত-প্রতিষ্ঠাতা",
        "Generalist-Adaptive-Founder": "বহুমুখী-অভিযোজনীয়-প্রতিষ্ঠাতা",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "কর্তৃত্ব-নেতৃত্ব উদ্যোগ (সরকারি-সংযোগ, চিকিৎসা-অনুশীলন, প্রশাসনিক-পরামর্শ)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "জনসেবা উদ্যোগ (আতিথেয়তা, খুচরা, খাদ্য-সেবা, মিডিয়া, পরিচর্যা-সেবা)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "কর্মমুখী উদ্যোগ (প্রকৌশল, রিয়েল-এস্টেট, খেলাধুলা, উৎপাদন, নিরাপত্তা)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "বাণিজ্য-যোগাযোগ উদ্যোগ (IT, পরামর্শ, বাণিজ্য, মিডিয়া, বিশ্লেষণ, লেখা)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "পরামর্শ-শিক্ষামূলক উদ্যোগ (শিক্ষকতা, কাউন্সেলিং, আর্থিক-পরামর্শ, প্রকাশনা, আইন)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "সৌন্দর্য-বিলাস উদ্যোগ (নকশা, ফ্যাশন, বিনোদন, বিলাস-আতিথেয়তা, সৌন্দর্য)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "অবকাঠামো-সেবা উদ্যোগ (উৎপাদন, রসদ, প্রাতিষ্ঠানিক-সেবা, গবেষণা)",
        "balanced ventures": "সুষম উদ্যোগ",
        # Leadership styles
        "Authoritative Leader": "কর্তৃত্বপূর্ণ নেতা",
        "Innovative Disruptor": "উদ্ভাবনী বিপ্লবকারী",
        "Strategic Planner": "কৌশলগত পরিকল্পনাকারী",
        "Collaborative Builder": "সহযোগী নির্মাতা",
        "Visionary Pioneer": "দূরদর্শী অগ্রদূত",
        "Steady Operator": "স্থিতিশীল পরিচালক",
        # Swakshetra dignity
        "Swakshetra 🏠": "স্বগৃহী 🏠",
        "Normal": "সাধারণ",
        # Education archetypes
        "classical-scholar": "শাস্ত্রীয়-পণ্ডিত",
        "intellect-with-authority": "মেধা-কর্তৃত্ব",
        "researcher-investigator": "গবেষক-তদন্তকারী",
        "modern-technologist": "আধুনিক-প্রযুক্তিবিদ",
        "wisdom-teacher": "জ্ঞান-গুরু",
        "creative-artist": "সৃজনশীল-শিল্পী",
        "patient-builder": "ধৈর্যশীল-নির্মাতা",
        "generalist-learner": "বহুমুখী-শিক্ষার্থী",
        # Education learning styles
        "quick-analytical-visual": "দ্রুত-বিশ্লেষণাত্মক-দৃশ্য",
        "deep-philosophical-synthesizing": "গভীর-দার্শনিক-সংশ্লেষণ",
        "intuitive-emotional-kinesthetic": "অন্তর্জ্ঞানী-আবেগপূর্ণ-গতিজ",
        "action-experiential-competitive": "কর্মশীল-অভিজ্ঞতামূলক-প্রতিযোগিতামূলক",
        "systematic-methodical-disciplined": "পদ্ধতিগত-সুশৃঙ্খল-শৃঙ্খলাবদ্ধ",
        "aesthetic-creative-associative": "সৌন্দর্যপরক-সৃজনশীল-সাহচর্য",
        "unconventional-innovative-research-oriented": "অপ্রচলিত-উদ্ভাবনী-গবেষণামুখী",
        "mixed-adaptive-balanced": "মিশ্র-অভিযোজনীয়-সুষম",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "নেতৃত্ব/প্রশাসন/রাষ্ট্রবিজ্ঞান/চিকিৎসা/সরকারি-অধ্যয়ন",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "মনোবিজ্ঞান/নার্সিং/আতিথেয়তা/খাদ্যবিজ্ঞান/জনসংযোগ",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "প্রকৌশল/সামরিক-অধ্যয়ন/শল্যচিকিৎসা/খেলাধুলা/রিয়েল-এস্টেট/যন্ত্রবিদ্যা",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "বাণিজ্য/IT/যোগাযোগ/হিসাবরক্ষণ/লেখা/ভাষাবিজ্ঞান/ডেটা-বিশ্লেষণ",
        "law/philosophy/education/finance/religion/advisory-studies": "আইন/দর্শন/শিক্ষা/অর্থ/ধর্ম/পরামর্শ-অধ্যয়ন",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "কলা/নকশা/সঙ্গীত/বিলাস-ব্র্যান্ড/ফ্যাশন/বিনোদন/সৌন্দর্য",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "গবেষণা/প্রকৌশল/অবকাঠামো/খনন/সেবা-শিল্প/শ্রম-অধ্যয়ন",
        # Wealth types
        "earned": "উপার্জিত", "inherited": "উত্তরাধিকারসূত্রে",
        "speculative": "অনুমানভিত্তিক", "mixed": "মিশ্র",
        "professional": "পেশাদার", "business": "ব্যবসা",
        "passive": "নিষ্ক্রিয়",
        # Investment styles
        "accumulator": "সঞ্চয়কারী", "trader": "ব্যবসায়ী",
        "speculator": "ফটকাবাজ", "passive-holder": "নিষ্ক্রিয়-ধারক",
        "balanced-investor": "সুষম-বিনিয়োগকারী",
        # Wealth acquisition styles
        "effort-based": "প্রচেষ্টা-ভিত্তিক",
        "relationship-based": "সম্পর্ক-ভিত্তিক",
        "balanced": "সুষম",
        # Risk categories
        "high": "উচ্চ", "medium": "মাঝারি", "low": "নিম্ন",
        # Love styles
        "romantic": "রোমান্টিক", "cautious": "সতর্ক",
        "slow-warmth": "ধীর-উষ্ণতা", "magnetic": "চুম্বকীয়",
        "quick-falls": "দ্রুত-প্রেম", "passionate": "আবেগপ্রবণ",
        "steady": "স্থিতিশীল", "detached": "নির্লিপ্ত",
        # Marriage archetypes
        "refined-partner": "পরিশীলিত-সঙ্গী",
        "unconventional-partner": "অপ্রচলিত-সঙ্গী",
        "service-oriented-partner": "সেবামুখী-সঙ্গী",
        # Health types
        "acute": "তীব্র", "psychosomatic": "মনোদৈহিক",
        "chronic": "দীর্ঘস্থায়ী", "structural": "কাঠামোগত",
        # Mental stress styles
        "open": "উন্মুক্ত", "measured": "সংযত",
        "suppressed": "চাপা", "explosive": "বিস্ফোরক",
        "withdrawn": "অন্তর্মুখী",
        # Property types
        "acquisitive": "অধিগ্রহণকারী", "protective": "সুরক্ষামূলক",
        "volatile": "অস্থির", "minimal": "ন্যূনতম",
        "luxury-car": "বিলাস-যান", "practical-sedan": "ব্যবহারিক-সেডান",
        "utility-vehicle": "উপযোগী-যান",
        # Legal types
        "litigation-prone": "মামলা-প্রবণ", "defensive-prone": "রক্ষণাত্মক-প্রবণ",
        "protracted-cases": "দীর্ঘ-মামলা", "settlement-prone": "মীমাংসা-প্রবণ",
        "quick-resolution": "দ্রুত-সমাধান",
        # Life path karma types
        "dharmic-continuation": "ধর্মীয়-ধারাবাহিকতা",
        "mastery-completion": "দক্ষতা-সম্পূর্ণতা",
        "karmic-resolution": "কর্ম-সমাধান",
        "wisdom-teaching": "জ্ঞান-শিক্ষা",
        "purification-focused": "শুদ্ধিকরণ-কেন্দ্রিক",
        "service-karma": "সেবা-কর্ম",
        "new-beginning": "নতুন-শুরু",
        # Past life
        "peaceful-natural": "শান্ত-প্রাকৃতিক",
        # Debt
        "secured": "সুরক্ষিত", "unsecured": "অসুরক্ষিত",
    },
    "pa": {
        # Career categories
        "leadership-executive": "ਅਗਵਾਈ-ਕਾਰਜਕਾਰੀ",
        "government-administration": "ਸਰਕਾਰੀ-ਪ੍ਰਸ਼ਾਸਨ",
        "military-defense": "ਫੌਜੀ-ਰੱਖਿਆ",
        "technical-engineering": "ਤਕਨੀਕੀ-ਇੰਜੀਨੀਅਰਿੰਗ",
        "skilled-trade": "ਹੁਨਰਮੰਦ-ਵਪਾਰ",
        "education-teaching": "ਸਿੱਖਿਆ-ਅਧਿਆਪਨ",
        "business-commerce": "ਵਪਾਰ-ਵਣਜ",
        "technology-software": "ਤਕਨਾਲੋਜੀ-ਸਾਫਟਵੇਅਰ",
        "spiritual-religious": "ਅਧਿਆਤਮਿਕ-ਧਾਰਮਿਕ",
        "finance-banking": "ਵਿੱਤ-ਬੈਂਕਿੰਗ",
        "media-communication": "ਮੀਡੀਆ-ਸੰਚਾਰ",
        "entertainment-performance": "ਮਨੋਰੰਜਨ-ਪ੍ਰਦਰਸ਼ਨ",
        "creative-arts": "ਸਿਰਜਣਾਤਮਕ-ਕਲਾ",
        "service-hospitality": "ਸੇਵਾ-ਮਹਿਮਾਨਨਵਾਜ਼ੀ",
        "research-scientific": "ਖੋਜ-ਵਿਗਿਆਨਕ",
        "medical-healing": "ਡਾਕਟਰੀ-ਇਲਾਜ",
        # Grades
        "Very High": "ਬਹੁਤ ਉੱਚਾ", "High": "ਉੱਚਾ", "Moderate": "ਮੱਧਮ",
        "Low": "ਘੱਟ", "Very Low": "ਬਹੁਤ ਘੱਟ",
        "Excellent": "ਸ਼ਾਨਦਾਰ",
        "Good": "ਚੰਗਾ",
        "Average": "ਔਸਤ",
        "Below Average": "ਔਸਤ ਤੋਂ ਘੱਟ",
        "Poor": "ਕਮਜ਼ੋਰ",
        "Strong": "ਮਜ਼ਬੂਤ",
        "Weak": "ਕਮਜ਼ੋਰ",
        "Challenged": "ਚੁਣੌਤੀਪੂਰਨ",
        # Planets
        "Sun": "ਸੂਰਜ", "Moon": "ਚੰਦਰ", "Mars": "ਮੰਗਲ",
        "Mercury": "ਬੁਧ", "Jupiter": "ਗੁਰੂ", "Venus": "ਸ਼ੁੱਕਰ",
        "Saturn": "ਸ਼ਨੀ", "Rahu": "ਰਾਹੂ", "Ketu": "ਕੇਤੂ",
        # Dignities
        "Exalted": "ਉੱਚ", "Debilitated": "ਨੀਚ",
        "Own": "ਸਵਗ੍ਰਹੀ", "Friend": "ਮਿੱਤਰ", "Enemy": "ਸ਼ਤਰੂ",
        "Neutral": "ਨਿਰਪੱਖ",
        # Signs
        "Aries": "ਮੇਖ", "Taurus": "ਬ੍ਰਿਖ", "Gemini": "ਮਿਥੁਨ",
        "Cancer": "ਕਰਕ", "Leo": "ਸਿੰਘ", "Virgo": "ਕੰਨਿਆ",
        "Libra": "ਤੁਲਾ", "Scorpio": "ਬ੍ਰਿਸ਼ਚਕ", "Sagittarius": "ਧਨੁ",
        "Capricorn": "ਮਕਰ", "Aquarius": "ਕੁੰਭ", "Pisces": "ਮੀਨ",
        # Founder archetypes
        "Visionary-Leader-Founder": "ਦੂਰਦਰਸ਼ੀ-ਆਗੂ-ਸੰਸਥਾਪਕ",
        "Wealth-Compounder-Founder": "ਧਨ-ਵਧਾਊ-ਸੰਸਥਾਪਕ",
        "Action-Driven-Founder": "ਕਰਮਸ਼ੀਲ-ਸੰਸਥਾਪਕ",
        "Tech-Innovator-Founder": "ਤਕਨੀਕੀ-ਨਵੀਨਤਾਕਾਰ-ਸੰਸਥਾਪਕ",
        "Advisory-Dharmic-Founder": "ਸਲਾਹਕਾਰ-ਧਾਰਮਿਕ-ਸੰਸਥਾਪਕ",
        "Brand-Aesthetic-Founder": "ਬ੍ਰਾਂਡ-ਸੁੰਦਰਤਾ-ਸੰਸਥਾਪਕ",
        "Disciplined-Operator-Founder": "ਅਨੁਸ਼ਾਸਿਤ-ਸੰਚਾਲਕ-ਸੰਸਥਾਪਕ",
        "People-Facing-Founder": "ਜਨ-ਸੰਪਰਕ-ਸੰਸਥਾਪਕ",
        "Research-Niche-Founder": "ਖੋਜ-ਵਿਸ਼ੇਸ਼-ਸੰਸਥਾਪਕ",
        "Generalist-Adaptive-Founder": "ਬਹੁਮੁਖੀ-ਅਨੁਕੂਲ-ਸੰਸਥਾਪਕ",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "ਅਧਿਕਾਰ-ਅਗਵਾਈ ਉੱਦਮ (ਸਰਕਾਰੀ-ਸੰਪਰਕ, ਡਾਕਟਰੀ-ਅਭਿਆਸ, ਪ੍ਰਸ਼ਾਸਨਿਕ-ਸਲਾਹ)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "ਜਨ-ਸੇਵਾ ਉੱਦਮ (ਮਹਿਮਾਨਨਵਾਜ਼ੀ, ਪ੍ਰਚੂਨ, ਖਾਣਾ-ਸੇਵਾ, ਮੀਡੀਆ, ਪਾਲਣ-ਸੇਵਾ)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "ਕਰਮ-ਅਧਾਰਿਤ ਉੱਦਮ (ਇੰਜੀਨੀਅਰਿੰਗ, ਰੀਅਲ-ਅਸਟੇਟ, ਖੇਡ, ਨਿਰਮਾਣ, ਸੁਰੱਖਿਆ)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "ਵਣਜ-ਸੰਚਾਰ ਉੱਦਮ (IT, ਸਲਾਹ, ਵਪਾਰ, ਮੀਡੀਆ, ਵਿਸ਼ਲੇਸ਼ਣ, ਲਿਖਤ)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "ਸਲਾਹ-ਵਿੱਦਿਅਕ ਉੱਦਮ (ਅਧਿਆਪਨ, ਸਲਾਹ, ਵਿੱਤ-ਸਲਾਹ, ਪ੍ਰਕਾਸ਼ਨ, ਕਾਨੂੰਨੀ)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "ਸੁੰਦਰਤਾ-ਐਸ਼ੋ-ਆਰਾਮ ਉੱਦਮ (ਡਿਜ਼ਾਈਨ, ਫੈਸ਼ਨ, ਮਨੋਰੰਜਨ, ਐਸ਼ੋ-ਆਰਾਮ-ਮਹਿਮਾਨਨਵਾਜ਼ੀ, ਸੁੰਦਰਤਾ)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "ਬੁਨਿਆਦੀ-ਸੇਵਾ ਉੱਦਮ (ਨਿਰਮਾਣ, ਰਸਦ, ਸੰਸਥਾਗਤ-ਸੇਵਾ, ਖੋਜ)",
        "balanced ventures": "ਸੰਤੁਲਿਤ ਉੱਦਮ",
        # Leadership styles
        "Authoritative Leader": "ਅਧਿਕਾਰੀ ਆਗੂ",
        "Innovative Disruptor": "ਨਵੀਨ ਬਦਲਾਵਕਾਰੀ",
        "Strategic Planner": "ਰਣਨੀਤਕ ਯੋਜਨਾਕਾਰ",
        "Collaborative Builder": "ਸਹਿਯੋਗੀ ਨਿਰਮਾਤਾ",
        "Visionary Pioneer": "ਦੂਰਦਰਸ਼ੀ ਮੋਢੀ",
        "Steady Operator": "ਸਥਿਰ ਸੰਚਾਲਕ",
        # Swakshetra dignity
        "Swakshetra 🏠": "ਸਵਗ੍ਰਹੀ 🏠",
        "Normal": "ਸਾਧਾਰਨ",
        # Education archetypes
        "classical-scholar": "ਸ਼ਾਸਤਰੀ-ਵਿਦਵਾਨ",
        "intellect-with-authority": "ਬੁੱਧੀ-ਅਧਿਕਾਰ",
        "researcher-investigator": "ਖੋਜਕਰਤਾ-ਜਾਂਚਕਰਤਾ",
        "modern-technologist": "ਆਧੁਨਿਕ-ਤਕਨੀਕਵਿਦ",
        "wisdom-teacher": "ਗਿਆਨ-ਗੁਰੂ",
        "creative-artist": "ਸਿਰਜਣਾਤਮਕ-ਕਲਾਕਾਰ",
        "patient-builder": "ਧੀਰਜਵਾਨ-ਨਿਰਮਾਤਾ",
        "generalist-learner": "ਬਹੁਮੁਖੀ-ਵਿਦਿਆਰਥੀ",
        # Education learning styles
        "quick-analytical-visual": "ਤੇਜ਼-ਵਿਸ਼ਲੇਸ਼ਣਾਤਮਕ-ਦ੍ਰਿਸ਼ਟੀ",
        "deep-philosophical-synthesizing": "ਡੂੰਘੀ-ਦਾਰਸ਼ਨਿਕ-ਸੰਸ਼ਲੇਸ਼ਣ",
        "intuitive-emotional-kinesthetic": "ਅੰਤਰ-ਗਿਆਨੀ-ਭਾਵਨਾਤਮਕ-ਗਤੀਜ",
        "action-experiential-competitive": "ਕਿਰਿਆਸ਼ੀਲ-ਅਨੁਭਵੀ-ਮੁਕਾਬਲੇਬਾਜ਼",
        "systematic-methodical-disciplined": "ਵਿਵਸਥਿਤ-ਢੰਗਬੱਧ-ਅਨੁਸ਼ਾਸਿਤ",
        "aesthetic-creative-associative": "ਸੁੰਦਰਤਾ-ਸਿਰਜਣਾਤਮਕ-ਸਾਹਚਰਜ",
        "unconventional-innovative-research-oriented": "ਗੈਰ-ਰਵਾਇਤੀ-ਨਵੀਨ-ਖੋਜ-ਅਧਾਰਿਤ",
        "mixed-adaptive-balanced": "ਮਿਸ਼ਰਤ-ਅਨੁਕੂਲ-ਸੰਤੁਲਿਤ",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "ਅਗਵਾਈ/ਪ੍ਰਸ਼ਾਸਨ/ਰਾਜਨੀਤੀ-ਵਿਗਿਆਨ/ਡਾਕਟਰੀ/ਸਰਕਾਰੀ-ਅਧਿਐਨ",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "ਮਨੋਵਿਗਿਆਨ/ਨਰਸਿੰਗ/ਮਹਿਮਾਨਨਵਾਜ਼ੀ/ਖਾਣਾ-ਵਿਗਿਆਨ/ਜਨ-ਸੰਪਰਕ",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "ਇੰਜੀਨੀਅਰਿੰਗ/ਫੌਜੀ-ਅਧਿਐਨ/ਸਰਜਰੀ/ਖੇਡ/ਰੀਅਲ-ਅਸਟੇਟ/ਮਕੈਨਿਕਸ",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "ਵਣਜ/IT/ਸੰਚਾਰ/ਲੇਖਾ/ਲਿਖਤ/ਭਾਸ਼ਾ-ਵਿਗਿਆਨ/ਡੇਟਾ-ਵਿਸ਼ਲੇਸ਼ਣ",
        "law/philosophy/education/finance/religion/advisory-studies": "ਕਾਨੂੰਨ/ਦਰਸ਼ਨ/ਸਿੱਖਿਆ/ਵਿੱਤ/ਧਰਮ/ਸਲਾਹ-ਅਧਿਐਨ",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "ਕਲਾ/ਡਿਜ਼ਾਈਨ/ਸੰਗੀਤ/ਐਸ਼ੋ-ਆਰਾਮ-ਬ੍ਰਾਂਡ/ਫੈਸ਼ਨ/ਮਨੋਰੰਜਨ/ਸੁੰਦਰਤਾ",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "ਖੋਜ/ਇੰਜੀਨੀਅਰਿੰਗ/ਬੁਨਿਆਦੀ-ਢਾਂਚਾ/ਖਣਨ/ਸੇਵਾ-ਉਦਯੋਗ/ਕਿਰਤ-ਅਧਿਐਨ",
        # Wealth types
        "earned": "ਕਮਾਇਆ", "inherited": "ਵਿਰਾਸਤੀ",
        "speculative": "ਸੱਟੇਬਾਜ਼ੀ", "mixed": "ਮਿਸ਼ਰਤ",
        "professional": "ਪੇਸ਼ੇਵਰ", "business": "ਵਪਾਰ",
        "passive": "ਨਿਸ਼ਕਿਰਿਆ",
        # Investment styles
        "accumulator": "ਸੰਚਯਕਰਤਾ", "trader": "ਵਪਾਰੀ",
        "speculator": "ਸੱਟੇਬਾਜ਼", "passive-holder": "ਨਿਸ਼ਕਿਰਿਆ-ਧਾਰਕ",
        "balanced-investor": "ਸੰਤੁਲਿਤ-ਨਿਵੇਸ਼ਕ",
        # Wealth acquisition styles
        "effort-based": "ਮਿਹਨਤ-ਅਧਾਰਿਤ",
        "relationship-based": "ਰਿਸ਼ਤਾ-ਅਧਾਰਿਤ",
        "balanced": "ਸੰਤੁਲਿਤ",
        # Risk categories
        "high": "ਉੱਚਾ", "medium": "ਮੱਧਮ", "low": "ਘੱਟ",
        # Love styles
        "romantic": "ਰੋਮਾਂਟਿਕ", "cautious": "ਸਾਵਧਾਨ",
        "slow-warmth": "ਹੌਲੀ-ਨਿੱਘ", "magnetic": "ਚੁੰਬਕੀ",
        "quick-falls": "ਤੇਜ਼-ਪਿਆਰ", "passionate": "ਜੋਸ਼ੀਲਾ",
        "steady": "ਸਥਿਰ", "detached": "ਨਿਰਲੇਪ",
        # Marriage archetypes
        "refined-partner": "ਸੁਧਰੇ-ਸਾਥੀ",
        "unconventional-partner": "ਗੈਰ-ਰਵਾਇਤੀ-ਸਾਥੀ",
        "service-oriented-partner": "ਸੇਵਾ-ਮੁਖੀ-ਸਾਥੀ",
        # Health types
        "acute": "ਤੀਬਰ", "psychosomatic": "ਮਨੋ-ਸਰੀਰਕ",
        "chronic": "ਲੰਮੇ-ਸਮੇਂ-ਦੀ", "structural": "ਢਾਂਚਾਗਤ",
        # Mental stress styles
        "open": "ਖੁੱਲ੍ਹਾ", "measured": "ਸੰਜਮੀ",
        "suppressed": "ਦੱਬਿਆ", "explosive": "ਵਿਸਫੋਟਕ",
        "withdrawn": "ਅੰਤਰਮੁਖੀ",
        # Property types
        "acquisitive": "ਅਧਿਗ੍ਰਹਿਣਕਾਰੀ", "protective": "ਰੱਖਿਆਤਮਕ",
        "volatile": "ਅਸਥਿਰ", "minimal": "ਘੱਟੋ-ਘੱਟ",
        "luxury-car": "ਐਸ਼ੋ-ਆਰਾਮ-ਵਾਹਨ", "practical-sedan": "ਵਿਹਾਰਕ-ਸੇਡਾਨ",
        "utility-vehicle": "ਉਪਯੋਗੀ-ਵਾਹਨ",
        # Legal types
        "litigation-prone": "ਮੁਕੱਦਮਾ-ਪ੍ਰਵਣ", "defensive-prone": "ਰੱਖਿਆਤਮਕ-ਪ੍ਰਵਣ",
        "protracted-cases": "ਲੰਮੇ-ਮੁਕੱਦਮੇ", "settlement-prone": "ਸਮਝੌਤਾ-ਪ੍ਰਵਣ",
        "quick-resolution": "ਤੁਰੰਤ-ਹੱਲ",
        # Life path karma types
        "dharmic-continuation": "ਧਾਰਮਿਕ-ਨਿਰੰਤਰਤਾ",
        "mastery-completion": "ਮੁਹਾਰਤ-ਪੂਰਤੀ",
        "karmic-resolution": "ਕਰਮ-ਹੱਲ",
        "wisdom-teaching": "ਗਿਆਨ-ਸਿੱਖਿਆ",
        "purification-focused": "ਸ਼ੁੱਧੀਕਰਨ-ਕੇਂਦ੍ਰਿਤ",
        "service-karma": "ਸੇਵਾ-ਕਰਮ",
        "new-beginning": "ਨਵੀਂ-ਸ਼ੁਰੂਆਤ",
        # Past life
        "peaceful-natural": "ਸ਼ਾਂਤ-ਕੁਦਰਤੀ",
        # Debt
        "secured": "ਸੁਰੱਖਿਅਤ", "unsecured": "ਅਸੁਰੱਖਿਅਤ",
    },
    "ml": {
        # Career categories
        "leadership-executive": "നേതൃത്വ-കാര്യനിർവ്വാഹക",
        "government-administration": "സർക്കാർ-ഭരണനിർവ്വഹണം",
        "military-defense": "സൈനിക-പ്രതിരോധം",
        "technical-engineering": "സാങ്കേതിക-എഞ്ചിനീയറിംഗ്",
        "skilled-trade": "വൈദഗ്ധ്യ-വ്യാപാരം",
        "education-teaching": "വിദ്യാഭ്യാസം-അധ്യാപനം",
        "business-commerce": "വ്യാപാരം-വാണിജ്യം",
        "technology-software": "സാങ്കേതികവിദ്യ-സോഫ്റ്റ്‌വെയർ",
        "spiritual-religious": "ആത്മീയ-മതപരം",
        "finance-banking": "ധനകാര്യം-ബാങ്കിംഗ്",
        "media-communication": "മാധ്യമം-ആശയവിനിമയം",
        "entertainment-performance": "വിനോദം-പ്രകടനം",
        "creative-arts": "സർഗ്ഗാത്മക-കല",
        "service-hospitality": "സേവനം-ആതിഥ്യം",
        "research-scientific": "ഗവേഷണ-ശാസ്ത്രീയ",
        "medical-healing": "വൈദ്യ-ചികിത്സ",
        # Grades
        "Very High": "വളരെ ഉയർന്നത്", "High": "ഉയർന്നത്", "Moderate": "മിതമായ",
        "Low": "കുറവ്", "Very Low": "വളരെ കുറവ്",
        "Excellent": "മികച്ചത്",
        "Good": "നല്ലത്",
        "Average": "ശരാശരി",
        "Below Average": "ശരാശരിയിൽ താഴെ",
        "Poor": "ദുർബലം",
        "Strong": "ശക്തം",
        "Weak": "ദുർബലം",
        "Challenged": "വെല്ലുവിളി നിറഞ്ഞ",
        # Planets
        "Sun": "സൂര്യൻ", "Moon": "ചന്ദ്രൻ", "Mars": "ചൊവ്വ",
        "Mercury": "ബുധൻ", "Jupiter": "വ്യാഴം", "Venus": "ശുക്രൻ",
        "Saturn": "ശനി", "Rahu": "രാഹു", "Ketu": "കേതു",
        # Dignities
        "Exalted": "ഉച്ചം", "Debilitated": "നീചം",
        "Own": "സ്വഗൃഹം", "Friend": "മിത്രം", "Enemy": "ശത്രു",
        "Neutral": "നിഷ്പക്ഷം",
        # Signs
        "Aries": "മേടം", "Taurus": "ഇടവം", "Gemini": "മിഥുനം",
        "Cancer": "കർക്കടകം", "Leo": "ചിങ്ങം", "Virgo": "കന്നി",
        "Libra": "തുലാം", "Scorpio": "വൃശ്ചികം", "Sagittarius": "ധനു",
        "Capricorn": "മകരം", "Aquarius": "കുംഭം", "Pisces": "മീനം",
        # Founder archetypes
        "Visionary-Leader-Founder": "ദീർഘദർശി-നേതാവ്-സ്ഥാപകൻ",
        "Wealth-Compounder-Founder": "ധന-വർദ്ധക-സ്ഥാപകൻ",
        "Action-Driven-Founder": "കർമ്മോന്മുഖ-സ്ഥാപകൻ",
        "Tech-Innovator-Founder": "സാങ്കേതിക-നവീകരണ-സ്ഥാപകൻ",
        "Advisory-Dharmic-Founder": "ഉപദേശക-ധാർമ്മിക-സ്ഥാപകൻ",
        "Brand-Aesthetic-Founder": "ബ്രാൻഡ്-സൗന്ദര്യ-സ്ഥാപകൻ",
        "Disciplined-Operator-Founder": "അച്ചടക്ക-പ്രവർത്തക-സ്ഥാപകൻ",
        "People-Facing-Founder": "ജനസമ്പർക്ക-സ്ഥാപകൻ",
        "Research-Niche-Founder": "ഗവേഷണ-വിശേഷ-സ്ഥാപകൻ",
        "Generalist-Adaptive-Founder": "ബഹുമുഖ-പൊരുത്തപ്പെടുന്ന-സ്ഥാപകൻ",
        # Business directions
        "authority-leader ventures (government-liaison, medical-practice, administrative-consulting)": "അധികാര-നേതൃത്വ സംരംഭങ്ങൾ (സർക്കാർ-ബന്ധം, വൈദ്യ-പ്രയോഗം, ഭരണ-ഉപദേശം)",
        "public-facing ventures (hospitality, retail, food-service, media, nurturing-services)": "ജനസേവന സംരംഭങ്ങൾ (ആതിഥ്യം, ചില്ലറ, ഭക്ഷണ-സേവനം, മാധ്യമം, പരിപാലന-സേവനം)",
        "action-oriented ventures (engineering, real-estate, sports, manufacturing, security)": "കർമ്മോന്മുഖ സംരംഭങ്ങൾ (എഞ്ചിനീയറിംഗ്, റിയൽ-എസ്റ്റേറ്റ്, കായികം, നിർമ്മാണം, സുരക്ഷ)",
        "commerce-communication ventures (IT, consulting, trading, media, analytics, writing)": "വാണിജ്യ-ആശയവിനിമയ സംരംഭങ്ങൾ (IT, ഉപദേശം, വ്യാപാരം, മാധ്യമം, വിശകലനം, എഴുത്ത്)",
        "advisory-educational ventures (teaching, counseling, finance-advisory, publishing, legal)": "ഉപദേശ-വിദ്യാഭ്യാസ സംരംഭങ്ങൾ (അധ്യാപനം, കൗൺസലിംഗ്, ധനകാര്യ-ഉപദേശം, പ്രസാധനം, നിയമ)",
        "aesthetic-luxury ventures (design, fashion, entertainment, hospitality-luxury, beauty)": "സൗന്ദര്യ-ആഡംബര സംരംഭങ്ങൾ (ഡിസൈൻ, ഫാഷൻ, വിനോദം, ആഡംബര-ആതിഥ്യം, സൗന്ദര്യം)",
        "infrastructure-service ventures (manufacturing, logistics, institutional-services, research)": "അടിസ്ഥാന-സേവന സംരംഭങ്ങൾ (നിർമ്മാണം, ലോജിസ്റ്റിക്സ്, സ്ഥാപന-സേവനം, ഗവേഷണം)",
        "balanced ventures": "സന്തുലിത സംരംഭങ്ങൾ",
        # Leadership styles
        "Authoritative Leader": "അധികാരിയായ നേതാവ്",
        "Innovative Disruptor": "നവീന മാറ്റക്കാരൻ",
        "Strategic Planner": "തന്ത്രപരമായ ആസൂത്രകൻ",
        "Collaborative Builder": "സഹകരണ നിർമ്മാതാവ്",
        "Visionary Pioneer": "ദീർഘദർശി മുൻഗാമി",
        "Steady Operator": "സ്ഥിരമായ പ്രവർത്തകൻ",
        # Swakshetra dignity
        "Swakshetra 🏠": "സ്വഗൃഹം 🏠",
        "Normal": "സാധാരണ",
        # Education archetypes
        "classical-scholar": "ശാസ്ത്രീയ-പണ്ഡിതൻ",
        "intellect-with-authority": "ബുദ്ധി-അധികാരം",
        "researcher-investigator": "ഗവേഷകൻ-അന്വേഷകൻ",
        "modern-technologist": "ആധുനിക-സാങ്കേതികവിദഗ്ധൻ",
        "wisdom-teacher": "ജ്ഞാന-ഗുരു",
        "creative-artist": "സർഗ്ഗാത്മക-കലാകാരൻ",
        "patient-builder": "ക്ഷമാശീല-നിർമ്മാതാവ്",
        "generalist-learner": "ബഹുമുഖ-പഠിതാവ്",
        # Education learning styles
        "quick-analytical-visual": "ദ്രുത-വിശകലന-ദൃശ്യ",
        "deep-philosophical-synthesizing": "ആഴമേറിയ-ദാർശനിക-സംശ്ലേഷണ",
        "intuitive-emotional-kinesthetic": "അവബോധ-വൈകാരിക-ചലനാത്മക",
        "action-experiential-competitive": "കർമ്മ-അനുഭവ-മത്സരാത്മക",
        "systematic-methodical-disciplined": "ക്രമാനുസൃത-രീതിബദ്ധ-അച്ചടക്ക",
        "aesthetic-creative-associative": "സൗന്ദര്യാത്മക-സർഗ്ഗാത്മക-സഹവർത്തന",
        "unconventional-innovative-research-oriented": "അസാമ്പ്രദായിക-നവീന-ഗവേഷണോന്മുഖ",
        "mixed-adaptive-balanced": "മിശ്ര-അനുരൂപ-സന്തുലിത",
        # Education subject directions
        "leadership/administration/political-science/medicine/government-studies": "നേതൃത്വം/ഭരണം/രാഷ്ട്രമീമാംസ/വൈദ്യം/സർക്കാർ-പഠനം",
        "psychology/nursing/hospitality/liquids/food-science/public-relations": "മനഃശാസ്ത്രം/നഴ്‌സിംഗ്/ആതിഥ്യം/ഭക്ഷ്യ-ശാസ്ത്രം/ജനസമ്പർക്കം",
        "engineering/military-studies/surgery/sports/real-estate/mechanics": "എഞ്ചിനീയറിംഗ്/സൈനിക-പഠനം/ശസ്ത്രക്രിയ/കായികം/റിയൽ-എസ്റ്റേറ്റ്/യന്ത്രശാസ്ത്രം",
        "commerce/IT/communication/accounting/writing/linguistics/data-analytics": "വാണിജ്യം/IT/ആശയവിനിമയം/അക്കൗണ്ടിംഗ്/എഴുത്ത്/ഭാഷാശാസ്ത്രം/ഡാറ്റാ-വിശകലനം",
        "law/philosophy/education/finance/religion/advisory-studies": "നിയമം/തത്ത്വചിന്ത/വിദ്യാഭ്യാസം/ധനകാര്യം/മതം/ഉപദേശ-പഠനം",
        "arts/design/music/luxury-brands/fashion/entertainment/beauty": "കല/ഡിസൈൻ/സംഗീതം/ആഡംബര-ബ്രാൻഡ്/ഫാഷൻ/വിനോദം/സൗന്ദര്യം",
        "research/engineering/infrastructure/mining/service-industry/labor-studies": "ഗവേഷണം/എഞ്ചിനീയറിംഗ്/അടിസ്ഥാനസൗകര്യം/ഖനനം/സേവന-വ്യവസായം/തൊഴിൽ-പഠനം",
        # Wealth types
        "earned": "സമ്പാദിച്ചത്", "inherited": "പാരമ്പര്യം",
        "speculative": "ഊഹക്കച്ചവട", "mixed": "മിശ്രം",
        "professional": "പ്രൊഫഷണൽ", "business": "വ്യാപാരം",
        "passive": "നിഷ്ക്രിയ",
        # Investment styles
        "accumulator": "സഞ്ചയകർത്താവ്", "trader": "വ്യാപാരി",
        "speculator": "ഊഹക്കച്ചവടക്കാരൻ", "passive-holder": "നിഷ്ക്രിയ-ഉടമ",
        "balanced-investor": "സന്തുലിത-നിക്ഷേപകൻ",
        # Wealth acquisition styles
        "effort-based": "പ്രയത്ന-അടിസ്ഥാന",
        "relationship-based": "ബന്ധ-അടിസ്ഥാന",
        "balanced": "സന്തുലിതം",
        # Risk categories
        "high": "ഉയർന്ന", "medium": "മിതമായ", "low": "കുറഞ്ഞ",
        # Love styles
        "romantic": "റൊമാന്റിക്", "cautious": "ജാഗ്രതയുള്ള",
        "slow-warmth": "മന്ദ-ഊഷ്മളത", "magnetic": "ആകർഷണീയ",
        "quick-falls": "ദ്രുത-പ്രേമം", "passionate": "വികാരതീവ്ര",
        "steady": "സ്ഥിരമായ", "detached": "നിർമ്മമ",
        # Marriage archetypes
        "refined-partner": "പരിഷ്കൃത-ഇണ",
        "unconventional-partner": "അസാമ്പ്രദായിക-ഇണ",
        "service-oriented-partner": "സേവനോന്മുഖ-ഇണ",
        # Health types
        "acute": "തീവ്രമായ", "psychosomatic": "മനോദൈഹിക",
        "chronic": "ദീർഘകാല", "structural": "ഘടനാപരം",
        # Mental stress styles
        "open": "തുറന്ന", "measured": "സംയമിത",
        "suppressed": "അടിച്ചമർത്തിയ", "explosive": "സ്ഫോടനാത്മക",
        "withdrawn": "ഉൾവലിഞ്ഞ",
        # Property types
        "acquisitive": "ഏറ്റെടുക്കുന്ന", "protective": "സംരക്ഷണാത്മക",
        "volatile": "അസ്ഥിരം", "minimal": "കുറഞ്ഞ",
        "luxury-car": "ആഡംബര-വാഹനം", "practical-sedan": "പ്രായോഗിക-സെഡാൻ",
        "utility-vehicle": "ഉപയോഗ-വാഹനം",
        # Legal types
        "litigation-prone": "വ്യവഹാര-സാധ്യത", "defensive-prone": "പ്രതിരോധ-സാധ്യത",
        "protracted-cases": "ദീർഘ-കേസുകൾ", "settlement-prone": "ഒത്തുതീർപ്പ്-സാധ്യത",
        "quick-resolution": "ദ്രുത-പരിഹാരം",
        # Life path karma types
        "dharmic-continuation": "ധാർമ്മിക-തുടർച്ച",
        "mastery-completion": "നൈപുണ്യ-പൂർത്തീകരണം",
        "karmic-resolution": "കർമ്മ-പരിഹാരം",
        "wisdom-teaching": "ജ്ഞാന-അധ്യാപനം",
        "purification-focused": "ശുദ്ധീകരണ-കേന്ദ്രിത",
        "service-karma": "സേവന-കർമ്മം",
        "new-beginning": "പുതിയ-തുടക്കം",
        # Past life
        "peaceful-natural": "ശാന്ത-പ്രകൃതിദത്ത",
        # Debt
        "secured": "സുരക്ഷിതം", "unsecured": "അസുരക്ഷിതം",
    },
}

# Keys whose values should be translated (exact match lookup)
_TRANSLATE_VALUE_KEYS = {
    "primary_career_category", "probability_grade", "compatibility_grade",
    "day_grade", "grade", "career_grade", "strength_rating",
    "dignity", "lord_dignity", "d7_jupiter_dignity", "d9_dignity",
    "progeny_favorability", "love_favorability",
    "founder_archetype", "ideal_cofounder_archetype",
    "leadership_style", "amatyakaraka_dignity",
    # Karaka roles and descriptions
    "atmakaraka_role", "amatyakaraka_role", "darakaraka_role",
    "atmakaraka_soul_description", "amatyakaraka_career_direction",
    "atmakaraka_soul_contract",
    "amatyakaraka_d10_dignity", "d10_tenth_lord_dignity",
    "d10_amatyakaraka_dignity", "d9_amatyakaraka_dignity",
    "d11_eleventh_lord_dignity", "d60_tenth_lord_dignity",
    "tenth_lord_dignity", "eleventh_lord_dignity",
    "amatyakaraka_business_direction", "primary_business_direction_recommendation",
    "current_business_phase_signature",
    # Education
    "intellectual_archetype", "learning_style_signature",
    "amatyakaraka_subject_direction", "primary_subject_direction",
    "primary_education_direction_recommendation", "action_direction",
    # Wealth
    "wealth_type", "investment_style", "expense_risk_category",
    "wealth_acquisition_style",
    # Love
    "love_style", "current_relationship_phase",
    # Marriage
    "marriage_type_signature", "spouse_primary_archetype",
    "domestic_comforts_level", "spouse_education_level_signature",
    # Health
    "d6_disease_karma_type", "constitutional_type",
    # Mental
    "current_stress_level", "active_emotional_phase",
    "communication_style", "conflict_engagement_style",
    # Property
    "d4_property_karma_type", "vehicle_type",
    # Legal
    "d6_litigation_karma_type", "legal_karma_type",
    "soul_level_legal_karma",
    # Life path
    "past_life_karma_type",
    # Character
    "atmakaraka_soul_character_archetype",
    # Past life
    "cultural_archetype", "past_life_partner_archetype",
    "past_life_spiritual_level", "primary_karmic_debt_type",
    # Debt
    "active_debt_phase", "primary_debt_category",
    "best_loan_type_if_needed", "dti_category", "remedy_direction",
}

# Keys whose values are planet names
_PLANET_VALUE_KEYS = {
    "lord", "fifth_lord", "d7_fifth_lord", "planet", "atmakaraka",
    "amatyakaraka", "md", "ad", "pd", "tenth_lord",
    "atmakaraka_planet", "amatyakaraka_planet", "darakaraka_planet",
    "eleventh_lord", "d10_tenth_lord", "d11_eleventh_lord",
}

# Keys whose values are sign names
_SIGN_VALUE_KEYS = {
    "sign", "sign_english", "moon_sign", "lagna", "d7_lagna",
    "d7_fifth_sign", "d7_jupiter_sign", "his_moon", "her_moon",
    "venus_sign",
}


# ── language code normalization ─────────────────────────────────────
#
# This module's TRANSLATIONS dict is keyed by short codes (en, hi, mr, gu,
# ta, te, kn, bn, pa, ml). Callers (routers, the developer-API gateway)
# may pass those short codes directly, a common full-name alias
# ("hindi", "Tamil", ...), or an Accept-Language-style value
# ("hi-IN", "hi_IN;q=0.9", ...). normalize_lang() is the ONE place that
# reconciles all of those into a TRANSLATIONS key so every call site
# behaves identically. Unknown/empty/English -> "en" (passthrough).
_LANG_ALIASES = {
    "en": "en", "eng": "en", "english": "en",
    "hi": "hi", "hin": "hi", "hindi": "hi",
    "mr": "mr", "mar": "mr", "marathi": "mr",
    "gu": "gu", "guj": "gu", "gujarati": "gu",
    "ta": "ta", "tam": "ta", "tamil": "ta",
    "te": "te", "tel": "te", "telugu": "te",
    "kn": "kn", "kan": "kn", "kannada": "kn",
    "bn": "bn", "ben": "bn", "bengali": "bn",
    "pa": "pa", "pan": "pa", "punjabi": "pa",
    "ml": "ml", "mal": "ml", "malayalam": "ml",
}


def normalize_lang(raw) -> str:
    """Normalize any incoming language code/alias/Accept-Language value to
    one of the short codes this module's TRANSLATIONS dict understands
    (en, hi, mr, gu, ta, te, kn, bn, pa, ml). Falls back to "en"
    (passthrough / no translation) for anything empty, unknown, or already
    English. Never raises."""
    if not raw:
        return "en"
    try:
        key = str(raw).strip().lower()
    except Exception:
        return "en"
    if not key:
        return "en"
    # Accept-Language-style value, e.g. "hi-IN,en;q=0.9" -> take the first tag
    key = key.split(",")[0].split(";")[0].strip()
    key = key.replace("-", "_")
    if key in _LANG_ALIASES:
        return _LANG_ALIASES[key]
    primary = key.split("_")[0]
    return _LANG_ALIASES.get(primary, "en")


def translate_report(data: dict, lang: str) -> dict:
    """Translate a specialist report dict into the target language.

    `lang` may be a short code (hi, mr, ...), a full-name alias (hindi,
    marathi, ...), or an Accept-Language-style value — normalize_lang()
    resolves it. English (or anything unrecognized) is a passthrough."""
    lang = normalize_lang(lang)
    if lang == "en" or lang not in TRANSLATIONS:
        return data
    return _translate_value(data, TRANSLATIONS[lang])


def translate_report_safe(data: dict, lang: str) -> dict:
    """Same as translate_report but never raises. On any failure it logs a
    warning and returns the original, untranslated data — used by the
    developer-API gateway where a bad/unknown lang code or an unexpected
    payload shape must never break a response."""
    try:
        return translate_report(data, lang)
    except Exception:
        import logging
        logging.getLogger("report_translator").warning(
            "translate_report failed for lang=%r; returning untranslated data", lang, exc_info=True,
        )
        return data


def _translate_value(obj, trans: dict):
    if isinstance(obj, dict):
        return {k: _translate_field(k, v, trans) for k, v in obj.items()}
    if isinstance(obj, list):
        return [_translate_value(item, trans) for item in obj]
    return obj


def _translate_field(key: str, value, trans: dict):
    if isinstance(value, dict):
        return _translate_value(value, trans)
    if isinstance(value, list):
        return [_translate_value(item, trans) for item in value]
    if isinstance(value, str):
        if key in _TRANSLATE_VALUE_KEYS or key in _PLANET_VALUE_KEYS or key in _SIGN_VALUE_KEYS:
            return trans.get(value, value)
        if key.endswith("_grade") or key.endswith("_rating") or key.endswith("_dignity") or key.endswith("_role") or key.endswith("_direction") or key.endswith("_contract"):
            return trans.get(value, value)
    return value
