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
        "Very High": "ખૂબ ઊંચું", "High": "ઊંચું", "Moderate": "મધ્યમ",
        "Low": "નીચું", "Very Low": "ખૂબ નીચું",
        "Sun": "સૂર્ય", "Moon": "ચંદ્ર", "Mars": "મંગળ",
        "Mercury": "બુધ", "Jupiter": "ગુરુ", "Venus": "શુક્ર",
        "Saturn": "શનિ", "Rahu": "રાહુ", "Ketu": "કેતુ",
        "Aries": "મેષ", "Taurus": "વૃષભ", "Gemini": "મિથુન",
        "Cancer": "કર્ક", "Leo": "સિંહ", "Virgo": "કન્યા",
        "Libra": "તુલા", "Scorpio": "વૃશ્ચિક", "Sagittarius": "ધનુ",
        "Capricorn": "મકર", "Aquarius": "કુંભ", "Pisces": "મીન",
    },
    "ta": {
        "Very High": "மிக உயர்ந்தது", "High": "உயர்ந்தது", "Moderate": "மிதமான",
        "Low": "குறைவு", "Very Low": "மிகக் குறைவு",
        "Sun": "சூரியன்", "Moon": "சந்திரன்", "Mars": "செவ்வாய்",
        "Mercury": "புதன்", "Jupiter": "குரு", "Venus": "சுக்கிரன்",
        "Saturn": "சனி", "Rahu": "ராகு", "Ketu": "கேது",
        "Aries": "மேஷம்", "Taurus": "ரிஷபம்", "Gemini": "மிதுனம்",
        "Cancer": "கடகம்", "Leo": "சிம்மம்", "Virgo": "கன்னி",
        "Libra": "துலாம்", "Scorpio": "விருச்சிகம்", "Sagittarius": "தனுசு",
        "Capricorn": "மகரம்", "Aquarius": "கும்பம்", "Pisces": "மீனம்",
    },
    "te": {
        "Very High": "చాలా ఎక్కువ", "High": "ఎక్కువ", "Moderate": "మధ్యస్థం",
        "Low": "తక్కువ", "Very Low": "చాలా తక్కువ",
        "Sun": "సూర్యుడు", "Moon": "చంద్రుడు", "Mars": "కుజుడు",
        "Mercury": "బుధుడు", "Jupiter": "గురుడు", "Venus": "శుక్రుడు",
        "Saturn": "శని", "Rahu": "రాహువు", "Ketu": "కేతువు",
    },
    "kn": {
        "Very High": "ತುಂಬಾ ಹೆಚ್ಚು", "High": "ಹೆಚ್ಚು", "Moderate": "ಮಧ್ಯಮ",
        "Low": "ಕಡಿಮೆ", "Very Low": "ತುಂಬಾ ಕಡಿಮೆ",
        "Sun": "ಸೂರ್ಯ", "Moon": "ಚಂದ್ರ", "Mars": "ಕುಜ",
        "Mercury": "ಬುಧ", "Jupiter": "ಗುರು", "Venus": "ಶುಕ್ರ",
        "Saturn": "ಶನಿ", "Rahu": "ರಾಹು", "Ketu": "ಕೇತು",
    },
    "bn": {
        "Very High": "অত্যন্ত উচ্চ", "High": "উচ্চ", "Moderate": "মাঝারি",
        "Low": "নিম্ন", "Very Low": "অত্যন্ত নিম্ন",
        "Sun": "সূর্য", "Moon": "চন্দ্র", "Mars": "মঙ্গল",
        "Mercury": "বুধ", "Jupiter": "বৃহস্পতি", "Venus": "শুক্র",
        "Saturn": "শনি", "Rahu": "রাহু", "Ketu": "কেতু",
    },
    "pa": {
        "Very High": "ਬਹੁਤ ਉੱਚਾ", "High": "ਉੱਚਾ", "Moderate": "ਮੱਧਮ",
        "Low": "ਘੱਟ", "Very Low": "ਬਹੁਤ ਘੱਟ",
        "Sun": "ਸੂਰਜ", "Moon": "ਚੰਦਰ", "Mars": "ਮੰਗਲ",
        "Mercury": "ਬੁਧ", "Jupiter": "ਗੁਰੂ", "Venus": "ਸ਼ੁੱਕਰ",
        "Saturn": "ਸ਼ਨੀ", "Rahu": "ਰਾਹੂ", "Ketu": "ਕੇਤੂ",
    },
    "ml": {
        "Very High": "വളരെ ഉയർന്നത്", "High": "ഉയർന്നത്", "Moderate": "മിതമായ",
        "Low": "കുറവ്", "Very Low": "വളരെ കുറവ്",
        "Sun": "സൂര്യൻ", "Moon": "ചന്ദ്രൻ", "Mars": "ചൊവ്വ",
        "Mercury": "ബുധൻ", "Jupiter": "വ്യാഴം", "Venus": "ശുക്രൻ",
        "Saturn": "ശനി", "Rahu": "രാഹു", "Ketu": "കേതു",
    },
}

# Keys whose values should be translated (exact match lookup)
_TRANSLATE_VALUE_KEYS = {
    "primary_career_category", "probability_grade", "compatibility_grade",
    "day_grade", "grade", "career_grade", "strength_rating",
    "dignity", "lord_dignity", "d7_jupiter_dignity",
    "progeny_favorability", "love_favorability",
    "founder_archetype", "ideal_cofounder_archetype",
    "leadership_style", "amatyakaraka_dignity",
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


def translate_report(data: dict, lang: str) -> dict:
    """Translate a specialist report dict into the target language."""
    if not lang or lang == "en" or lang not in TRANSLATIONS:
        return data
    return _translate_value(data, TRANSLATIONS[lang])


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
        if key.endswith("_grade") or key.endswith("_rating"):
            return trans.get(value, value)
    return value
