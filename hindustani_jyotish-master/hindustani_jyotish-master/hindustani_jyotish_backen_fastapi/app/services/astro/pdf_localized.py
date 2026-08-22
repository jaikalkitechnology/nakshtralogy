"""Localized Kundli PDF — renders the (already-localized) API response bundle
in the user's selected language, so the downloaded PDF matches what the app
shows (Gujarati response → Gujarati PDF).

Unlike ``pdf.build_kundli_pdf`` (English interpretive prose built from the
``Chart`` object with the Helvetica font, which cannot draw Indic glyphs), this
module PRINTS THE API RESPONSE: the structured, deterministically-localized
content (birth details, chart, planetary positions, numerology) using a Noto
Sans face for the language's script so Gujarati/Devanagari/Tamil/… render
correctly.

Fonts come from the ``fonts-noto-core`` Debian package (see Dockerfile). If a
font file isn't found the text still lays out (falls back to Helvetica) — Latin
digits/degrees remain correct, only Indic glyphs would be missing, so the
build never fails on a missing font.
"""
from __future__ import annotations

import io
import logging
import os
from datetime import date, time
from typing import Any
from xml.sax.saxutils import escape as _xml_escape

from app.services.devapi_localize.catalog import normalize_lang
from app.services.devapi_localize.catalog import t as _cat

logger = logging.getLogger(__name__)

_INDIGO = "#1E1B4B"
_SAFFRON = "#F4811F"
_COPPER = "#C77B4A"
_CREAM = "#FBF6EE"

# language (full word) → Noto Sans family basename for its script.
_SCRIPT_FONT = {
    "hindi": "NotoSansDevanagari",
    "marathi": "NotoSansDevanagari",
    "gujarati": "NotoSansGujarati",
    "bengali": "NotoSansBengali",
    "tamil": "NotoSansTamil",
    "telugu": "NotoSansTelugu",
    "kannada": "NotoSansKannada",
    "malayalam": "NotoSansMalayalam",
    "punjabi": "NotoSansGurmukhi",
    "odia": "NotoSansOriya",
}

# Bundled faces (committed with the repo) take priority so the reportlab
# fallback embeds a real Unicode font even when no system font package is
# installed; the system dirs remain as extra fallbacks.
import os as _os  # noqa: E402
_BUNDLED_FONTS = _os.path.join(_os.path.dirname(__file__), "fonts")
_FONT_DIRS = [
    _BUNDLED_FONTS,
    "/usr/share/fonts/truetype/noto",
    "/usr/share/fonts/noto",
    "/usr/share/fonts/opentype/noto",
    "/usr/share/fonts/truetype",
]

_registered: set[str] = set()

# Fixed PDF labels per language. English + the ten Indian scripts; a missing
# language falls back to English. Terms (sign/nakshatra/planet names) are NOT
# here — they're localized from the response/catalog.
_L: dict[str, dict[str, str]] = {
    "english": {
        "subtitle": "Detailed Kundli Report", "birth_details": "Birth Details",
        "name": "Name", "dob": "Date of Birth", "tob": "Time of Birth",
        "place": "Place of Birth", "summary": "Chart Summary",
        "lagna": "Ascendant (Lagna)", "moon": "Moon Sign", "sun": "Sun Sign",
        "nakshatra": "Birth Nakshatra", "nak_lord": "Nakshatra Lord",
        "chart": "Birth Chart (North-Indian style)", "positions": "Planetary Positions",
        "planet": "Planet", "sign": "Sign", "degree": "Degree", "house": "House",
        "pada": "Pada", "motion": "Motion", "retro": "Retrograde", "direct": "Direct",
        "numerology": "Numerology", "life_path": "Life Path Number",
        "birth_day": "Birth Day Number", "meaning": "Meaning",
    },
    "hindi": {
        "subtitle": "विस्तृत कुंडली रिपोर्ट", "birth_details": "जन्म विवरण",
        "name": "नाम", "dob": "जन्म तिथि", "tob": "जन्म समय", "place": "जन्म स्थान",
        "summary": "कुंडली सारांश", "lagna": "लग्न", "moon": "चंद्र राशि",
        "sun": "सूर्य राशि", "nakshatra": "जन्म नक्षत्र", "nak_lord": "नक्षत्र स्वामी",
        "chart": "जन्म कुंडली (उत्तर भारतीय)", "positions": "ग्रह स्थिति",
        "planet": "ग्रह", "sign": "राशि", "degree": "अंश", "house": "भाव",
        "pada": "पद", "motion": "गति", "retro": "वक्री", "direct": "मार्गी",
        "numerology": "अंक ज्योतिष", "life_path": "मूलांक (जीवन पथ)",
        "birth_day": "जन्म दिनांक अंक", "meaning": "अर्थ",
    },
    "gujarati": {
        "subtitle": "વિગતવાર કુંડળી રિપોર્ટ", "birth_details": "જન્મ વિગતો",
        "name": "નામ", "dob": "જન્મ તારીખ", "tob": "જન્મ સમય", "place": "જન્મ સ્થળ",
        "summary": "કુંડળી સારાંશ", "lagna": "લગ્ન", "moon": "ચંદ્ર રાશિ",
        "sun": "સૂર્ય રાશિ", "nakshatra": "જન્મ નક્ષત્ર", "nak_lord": "નક્ષત્ર સ્વામી",
        "chart": "જન્મ કુંડળી (ઉત્તર ભારતીય)", "positions": "ગ્રહ સ્થિતિ",
        "planet": "ગ્રહ", "sign": "રાશિ", "degree": "અંશ", "house": "ભાવ",
        "pada": "પદ", "motion": "ગતિ", "retro": "વક્રી", "direct": "માર્ગી",
        "numerology": "અંક જ્યોતિષ", "life_path": "મૂળાંક (જીવન પથ)",
        "birth_day": "જન્મ દિવસ અંક", "meaning": "અર્થ",
    },
    "marathi": {
        "subtitle": "सविस्तर कुंडली अहवाल", "birth_details": "जन्म तपशील",
        "name": "नाव", "dob": "जन्म तारीख", "tob": "जन्म वेळ", "place": "जन्म स्थळ",
        "summary": "कुंडली सारांश", "lagna": "लग्न", "moon": "चंद्र राशी",
        "sun": "सूर्य राशी", "nakshatra": "जन्म नक्षत्र", "nak_lord": "नक्षत्र स्वामी",
        "chart": "जन्म कुंडली (उत्तर भारतीय)", "positions": "ग्रह स्थिती",
        "planet": "ग्रह", "sign": "राशी", "degree": "अंश", "house": "भाव",
        "pada": "पाद", "motion": "गती", "retro": "वक्री", "direct": "मार्गी",
        "numerology": "अंकशास्त्र", "life_path": "मूलांक (जीवन पथ)",
        "birth_day": "जन्म दिनांक अंक", "meaning": "अर्थ",
    },
    "bengali": {
        "subtitle": "বিস্তারিত কুণ্ডলী রিপোর্ট", "birth_details": "জন্ম বিবরণ",
        "name": "নাম", "dob": "জন্ম তারিখ", "tob": "জন্ম সময়", "place": "জন্মস্থান",
        "summary": "কুণ্ডলী সারাংশ", "lagna": "লগ্ন", "moon": "চন্দ্র রাশি",
        "sun": "সূর্য রাশি", "nakshatra": "জন্ম নক্ষত্র", "nak_lord": "নক্ষত্র অধিপতি",
        "chart": "জন্ম কুণ্ডলী (উত্তর ভারতীয়)", "positions": "গ্রহ অবস্থান",
        "planet": "গ্রহ", "sign": "রাশি", "degree": "ডিগ্রি", "house": "ভাব",
        "pada": "পদ", "motion": "গতি", "retro": "বক্রী", "direct": "মার্গী",
        "numerology": "অঙ্ক জ্যোতিষ", "life_path": "জীবন পথ সংখ্যা",
        "birth_day": "জন্ম দিন সংখ্যা", "meaning": "অর্থ",
    },
    "tamil": {
        "subtitle": "விரிவான ஜாதக அறிக்கை", "birth_details": "பிறப்பு விவரங்கள்",
        "name": "பெயர்", "dob": "பிறந்த தேதி", "tob": "பிறந்த நேரம்", "place": "பிறந்த இடம்",
        "summary": "ஜாதக சுருக்கம்", "lagna": "லக்னம்", "moon": "சந்திர ராசி",
        "sun": "சூரிய ராசி", "nakshatra": "பிறப்பு நட்சத்திரம்", "nak_lord": "நட்சத்திர அதிபதி",
        "chart": "பிறப்பு ஜாதகம் (வட இந்திய)", "positions": "கிரக நிலைகள்",
        "planet": "கிரகம்", "sign": "ராசி", "degree": "பாகை", "house": "வீடு",
        "pada": "பாதம்", "motion": "கதி", "retro": "வக்ரம்", "direct": "நேர்",
        "numerology": "எண் கணிதம்", "life_path": "வாழ்க்கை பாதை எண்",
        "birth_day": "பிறந்த நாள் எண்", "meaning": "பொருள்",
    },
    "telugu": {
        "subtitle": "వివరణాత్మక జాతక నివేదిక", "birth_details": "జనన వివరాలు",
        "name": "పేరు", "dob": "పుట్టిన తేదీ", "tob": "పుట్టిన సమయం", "place": "జన్మ స్థలం",
        "summary": "జాతక సారాంశం", "lagna": "లగ్నం", "moon": "చంద్ర రాశి",
        "sun": "సూర్య రాశి", "nakshatra": "జన్మ నక్షత్రం", "nak_lord": "నక్షత్ర అధిపతి",
        "chart": "జన్మ జాతకం (ఉత్తర భారత)", "positions": "గ్రహ స్థితులు",
        "planet": "గ్రహం", "sign": "రాశి", "degree": "డిగ్రీ", "house": "భావం",
        "pada": "పాదం", "motion": "గతి", "retro": "వక్రం", "direct": "మార్గి",
        "numerology": "సంఖ్యా శాస్త్రం", "life_path": "జీవన మార్గ సంఖ్య",
        "birth_day": "జన్మ దిన సంఖ్య", "meaning": "అర్థం",
    },
    "kannada": {
        "subtitle": "ವಿವರವಾದ ಜಾತಕ ವರದಿ", "birth_details": "ಜನ್ಮ ವಿವರಗಳು",
        "name": "ಹೆಸರು", "dob": "ಜನ್ಮ ದಿನಾಂಕ", "tob": "ಜನ್ಮ ಸಮಯ", "place": "ಜನ್ಮ ಸ್ಥಳ",
        "summary": "ಜಾತಕ ಸಾರಾಂಶ", "lagna": "ಲಗ್ನ", "moon": "ಚಂದ್ರ ರಾಶಿ",
        "sun": "ಸೂರ್ಯ ರಾಶಿ", "nakshatra": "ಜನ್ಮ ನಕ್ಷತ್ರ", "nak_lord": "ನಕ್ಷತ್ರ ಅಧಿಪತಿ",
        "chart": "ಜನ್ಮ ಜಾತಕ (ಉತ್ತರ ಭಾರತ)", "positions": "ಗ್ರಹ ಸ್ಥಿತಿಗಳು",
        "planet": "ಗ್ರಹ", "sign": "ರಾಶಿ", "degree": "ಡಿಗ್ರಿ", "house": "ಭಾವ",
        "pada": "ಪಾದ", "motion": "ಗತಿ", "retro": "ವಕ್ರ", "direct": "ಮಾರ್ಗಿ",
        "numerology": "ಸಂಖ್ಯಾ ಶಾಸ್ತ್ರ", "life_path": "ಜೀವನ ಪಥ ಸಂಖ್ಯೆ",
        "birth_day": "ಜನ್ಮ ದಿನ ಸಂಖ್ಯೆ", "meaning": "ಅರ್ಥ",
    },
    "malayalam": {
        "subtitle": "വിശദമായ ജാതക റിപ്പോർട്ട്", "birth_details": "ജനന വിവരങ്ങൾ",
        "name": "പേര്", "dob": "ജനന തീയതി", "tob": "ജനന സമയം", "place": "ജനന സ്ഥലം",
        "summary": "ജാതക സംഗ്രഹം", "lagna": "ലഗ്നം", "moon": "ചന്ദ്ര രാശി",
        "sun": "സൂര്യ രാശി", "nakshatra": "ജന്മ നക്ഷത്രം", "nak_lord": "നക്ഷത്ര അധിപതി",
        "chart": "ജന്മ ജാതകം (ഉത്തരേന്ത്യൻ)", "positions": "ഗ്രഹ സ്ഥിതികൾ",
        "planet": "ഗ്രഹം", "sign": "രാശി", "degree": "ഡിഗ്രി", "house": "ഭാവം",
        "pada": "പാദം", "motion": "ഗതി", "retro": "വക്രം", "direct": "മാർഗി",
        "numerology": "സംഖ്യാ ശാസ്ത്രം", "life_path": "ജീവിത പാത സംഖ്യ",
        "birth_day": "ജനന ദിന സംഖ്യ", "meaning": "അർത്ഥം",
    },
    "punjabi": {
        "subtitle": "ਵਿਸਥਾਰਤ ਕੁੰਡਲੀ ਰਿਪੋਰਟ", "birth_details": "ਜਨਮ ਵੇਰਵੇ",
        "name": "ਨਾਮ", "dob": "ਜਨਮ ਮਿਤੀ", "tob": "ਜਨਮ ਸਮਾਂ", "place": "ਜਨਮ ਸਥਾਨ",
        "summary": "ਕੁੰਡਲੀ ਸਾਰ", "lagna": "ਲਗਨ", "moon": "ਚੰਦਰ ਰਾਸ਼ੀ",
        "sun": "ਸੂਰਜ ਰਾਸ਼ੀ", "nakshatra": "ਜਨਮ ਨਛੱਤਰ", "nak_lord": "ਨਛੱਤਰ ਸੁਆਮੀ",
        "chart": "ਜਨਮ ਕੁੰਡਲੀ (ਉੱਤਰ ਭਾਰਤੀ)", "positions": "ਗ੍ਰਹਿ ਸਥਿਤੀ",
        "planet": "ਗ੍ਰਹਿ", "sign": "ਰਾਸ਼ੀ", "degree": "ਅੰਸ਼", "house": "ਭਾਵ",
        "pada": "ਪਦ", "motion": "ਗਤੀ", "retro": "ਵਕਰੀ", "direct": "ਮਾਰਗੀ",
        "numerology": "ਅੰਕ ਜੋਤਿਸ਼", "life_path": "ਜੀਵਨ ਪੱਥ ਅੰਕ",
        "birth_day": "ਜਨਮ ਦਿਨ ਅੰਕ", "meaning": "ਅਰਥ",
    },
    "odia": {
        "subtitle": "ବିସ୍ତୃତ କୁଣ୍ଡଳୀ ରିପୋର୍ଟ", "birth_details": "ଜନ୍ମ ବିବରଣୀ",
        "name": "ନାମ", "dob": "ଜନ୍ମ ତାରିଖ", "tob": "ଜନ୍ମ ସମୟ", "place": "ଜନ୍ମ ସ୍ଥାନ",
        "summary": "କୁଣ୍ଡଳୀ ସାରାଂଶ", "lagna": "ଲଗ୍ନ", "moon": "ଚନ୍ଦ୍ର ରାଶି",
        "sun": "ସୂର୍ଯ୍ୟ ରାଶି", "nakshatra": "ଜନ୍ମ ନକ୍ଷତ୍ର", "nak_lord": "ନକ୍ଷତ୍ର ଅଧିପତି",
        "chart": "ଜନ୍ମ କୁଣ୍ଡଳୀ (ଉତ୍ତର ଭାରତୀୟ)", "positions": "ଗ୍ରହ ସ୍ଥିତି",
        "planet": "ଗ୍ରହ", "sign": "ରାଶି", "degree": "ଡିଗ୍ରୀ", "house": "ଭାବ",
        "pada": "ପାଦ", "motion": "ଗତି", "retro": "ବକ୍ରୀ", "direct": "ମାର୍ଗୀ",
        "numerology": "ସଂଖ୍ୟା ଜ୍ୟୋତିଷ", "life_path": "ଜୀବନ ପଥ ସଂଖ୍ୟା",
        "birth_day": "ଜନ୍ମ ଦିନ ସଂଖ୍ୟା", "meaning": "ଅର୍ଥ",
    },
}

_PLANET_ORDER = ["Sun", "Moon", "Mars", "Mercury", "Jupiter",
                 "Venus", "Saturn", "Rahu", "Ketu"]
_PLANET_ABBR = {
    "Sun": "Su", "Moon": "Mo", "Mars": "Ma", "Mercury": "Me", "Jupiter": "Ju",
    "Venus": "Ve", "Saturn": "Sa", "Rahu": "Ra", "Ketu": "Ke",
}


def _find_font(basename: str, bold: bool) -> str | None:
    """Locate a Noto face file (Regular/Bold) across the known font dirs."""
    suffixes = (["-Bold.ttf", "-SemiBold.ttf", "-Regular.ttf"] if bold
                else ["-Regular.ttf", "-Medium.ttf"])
    for d in _FONT_DIRS:
        for suf in suffixes:
            path = os.path.join(d, basename + suf)
            if os.path.exists(path):
                return path
    return None


def _fonts_for(full_lang: str) -> tuple[str, str]:
    """Register (once) and return the (regular, bold) font names for a
    language. Falls back to Helvetica when the script needs no special font
    (English) or the Noto file isn't installed."""
    base = _SCRIPT_FONT.get(full_lang)
    if not base:
        return "Helvetica", "Helvetica-Bold"
    reg_name, bold_name = f"{base}", f"{base}-Bold"
    if base in _registered:
        return reg_name, bold_name
    try:
        from reportlab.pdfbase import pdfmetrics
        from reportlab.pdfbase.ttfonts import TTFont

        reg_path = _find_font(base, bold=False)
        bold_path = _find_font(base, bold=True) or reg_path
        if not reg_path:
            logger.warning("PDF: Noto font %s not found; falling back to Helvetica", base)
            return "Helvetica", "Helvetica-Bold"
        pdfmetrics.registerFont(TTFont(reg_name, reg_path))
        pdfmetrics.registerFont(TTFont(bold_name, bold_path))
        _registered.add(base)
        return reg_name, bold_name
    except Exception:  # pragma: no cover - defensive; never fail the build
        logger.exception("PDF: font registration failed for %s", base)
        return "Helvetica", "Helvetica-Bold"


def _s(v: Any) -> str:
    return _xml_escape("" if v is None else str(v))


def _north_indian(chart: dict, base_font: str):
    """North-Indian diamond drawing from the localized chart dict (uses the
    numeric ascendant_sign_idx + each planet's sign_idx — never the localized
    NAME, so localization can't break placement)."""
    from reportlab.graphics.shapes import Drawing, Line, Rect, String
    from reportlab.lib import colors

    size = 320
    d = Drawing(size, size)
    d.add(Rect(0, 0, size, size, strokeColor=colors.HexColor(_INDIGO),
               fillColor=colors.HexColor(_CREAM), strokeWidth=2))
    d.add(Line(0, 0, size, size, strokeColor=colors.HexColor(_INDIGO)))
    d.add(Line(0, size, size, 0, strokeColor=colors.HexColor(_INDIGO)))
    half = size / 2
    for x1, y1, x2, y2 in [(0, half, half, size), (half, size, size, half),
                           (size, half, half, 0), (half, 0, 0, half)]:
        d.add(Line(x1, y1, x2, y2, strokeColor=colors.HexColor(_INDIGO)))

    q = size / 4
    anchors = {
        1: (half, size - q), 2: (q, size - q / 1.6), 3: (q / 1.6, size - q),
        4: (q, half), 5: (q / 1.6, q), 6: (q, q / 1.6), 7: (half, q),
        8: (size - q, q / 1.6), 9: (size - q / 1.6, q), 10: (size - q, half),
        11: (size - q / 1.6, size - q), 12: (size - q, size - q / 1.6),
    }

    lagna_idx = chart.get("ascendant_sign_idx")
    if not isinstance(lagna_idx, int):
        lagna_idx = 0
    planets = chart.get("planets") or {}
    by_house: dict[int, list[str]] = {}
    for name, p in planets.items() if isinstance(planets, dict) else []:
        if not isinstance(p, dict):
            continue
        si = p.get("sign_idx")
        if not isinstance(si, int):
            continue
        house = (si - lagna_idx) % 12 + 1
        abbr = _PLANET_ABBR.get(name, name[:2])
        by_house.setdefault(house, []).append(abbr + ("*" if p.get("vakri") else ""))

    for house, (x, y) in anchors.items():
        sign_no = (lagna_idx + house - 1) % 12 + 1
        d.add(String(x, y + 12, str(sign_no), textAnchor="middle",
                     fontSize=9, fillColor=colors.HexColor(_COPPER), fontName=base_font))
        occ = " ".join(by_house.get(house, []))
        if occ:
            d.add(String(x, y - 3, occ, textAnchor="middle",
                         fontSize=10, fillColor=colors.HexColor(_INDIGO), fontName=base_font))
    return d


def build_localized_kundli_pdf(
    data: dict,
    *,
    name: str | None,
    dob: date,
    birth_time: time | None,
    birth_place: str | None,
    lang: str | None,
) -> bytes:
    """Render the localized detailed-kundli response (``data`` = the API's
    ``{chart, numerology, ...}`` bundle, already localized) into a PDF in the
    caller's language, using a Noto face so Indic scripts render. Prints the API
    response content — no separate English interpretation."""
    from reportlab.lib import colors
    from reportlab.lib.enums import TA_CENTER
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.styles import ParagraphStyle
    from reportlab.lib.units import mm
    from reportlab.platypus import (
        PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle,
    )

    full = normalize_lang(lang) if lang else "english"
    L = _L.get(full, _L["english"])
    reg, bold = _fonts_for(full)

    chart = data.get("chart") if isinstance(data.get("chart"), dict) else data
    chart = chart or {}
    numerology = data.get("numerology") if isinstance(data.get("numerology"), dict) else {}

    def sty(size: float, color: str, *, b: bool = False, center: bool = False, leading=None):
        return ParagraphStyle(
            f"s{size}{color}{b}{center}", fontName=bold if b else reg,
            fontSize=size, leading=leading or size * 1.4,
            textColor=colors.HexColor(color),
            alignment=TA_CENTER if center else 0,
        )

    cover_title = sty(28, _INDIGO, b=True, center=True, leading=34)
    cover_sub = sty(15, _SAFFRON, b=True, center=True)
    centered = sty(10.5, "#333333", center=True)
    h2 = sty(15, _SAFFRON, b=True)
    body = sty(10.5, "#222222")

    def kv_table(rows):
        t = Table(rows, colWidths=[55 * mm, 105 * mm])
        t.setStyle(TableStyle([
            ("TEXTCOLOR", (0, 0), (0, -1), colors.HexColor(_COPPER)),
            ("FONTNAME", (0, 0), (0, -1), bold),
            ("FONTNAME", (1, 0), (1, -1), reg),
            ("FONTSIZE", (0, 0), (-1, -1), 10),
            ("BOTTOMPADDING", (0, 0), (-1, -1), 4),
            ("LINEBELOW", (0, 0), (-1, -1), 0.25, colors.HexColor("#E0E0E0")),
        ]))
        return t

    def grid(rows, widths=None):
        t = Table(rows, repeatRows=1, colWidths=widths)
        t.setStyle(TableStyle([
            ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor(_INDIGO)),
            ("TEXTCOLOR", (0, 0), (-1, 0), colors.white),
            ("FONTNAME", (0, 0), (-1, 0), bold),
            ("FONTNAME", (0, 1), (-1, -1), reg),
            ("FONTSIZE", (0, 0), (-1, -1), 9),
            ("GRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#D6D6D6")),
            ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.white, colors.HexColor(_CREAM)]),
            ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
        ]))
        return t

    buf = io.BytesIO()
    doc = SimpleDocTemplate(buf, pagesize=A4, title="Hindustani Jyotish — Kundli",
                            topMargin=18 * mm, bottomMargin=18 * mm)
    e: list = []

    # Cover
    e += [
        Spacer(1, 40 * mm),
        Paragraph("Hindustani Jyotish", cover_title),
        Spacer(1, 6 * mm),
        Paragraph(_s(L["subtitle"]), cover_sub),
        Spacer(1, 20 * mm),
        Paragraph(f"<b>{_s(name) if name else ''}</b>", cover_sub),
        Spacer(1, 4 * mm),
        Paragraph(
            f"{dob.strftime('%d %B %Y')}"
            + (f" · {birth_time.strftime('%H:%M')}" if birth_time else "")
            + (f"<br/>{_s(birth_place)}" if birth_place else ""),
            centered),
        PageBreak(),
    ]

    # Birth details + chart summary
    lagna = chart.get("ascendant_sign") or chart.get("lagna")
    asc = chart.get("ascendant")
    lagna_val = _s(lagna) + (f" ({asc:.2f}°)" if isinstance(asc, (int, float)) else "")
    e += [
        Paragraph(_s(L["birth_details"]), h2),
        Spacer(1, 3 * mm),
        kv_table([
            [_s(L["name"]), _s(name) or "—"],
            [_s(L["dob"]), dob.strftime("%d %B %Y")],
            [_s(L["tob"]), birth_time.strftime("%H:%M") if birth_time else "—"],
            [_s(L["place"]), _s(birth_place) or "—"],
        ]),
        Spacer(1, 6 * mm),
        Paragraph(_s(L["summary"]), h2),
        Spacer(1, 3 * mm),
        kv_table([
            [_s(L["lagna"]), lagna_val or "—"],
            [_s(L["moon"]), _s(chart.get("moon_sign")) or "—"],
            [_s(L["sun"]), _s(chart.get("sun_sign")) or "—"],
            [_s(L["nakshatra"]), _s(chart.get("nakshatra")) or "—"],
        ]),
        PageBreak(),
    ]

    # North-Indian chart
    if isinstance(chart.get("ascendant_sign_idx"), int) and chart.get("planets"):
        e += [
            Paragraph(_s(L["chart"]), h2),
            Spacer(1, 6 * mm),
            _north_indian(chart, reg),
            PageBreak(),
        ]

    # Planetary positions
    planets = chart.get("planets") or {}
    if isinstance(planets, dict) and planets:
        header = [_s(L["planet"]), _s(L["sign"]), _s(L["degree"]),
                  _s(L["nakshatra"]), _s(L["pada"]), _s(L["motion"])]
        rows = [header]
        ordered = [n for n in _PLANET_ORDER if n in planets] + \
                  [n for n in planets if n not in _PLANET_ORDER]
        for n in ordered:
            p = planets[n]
            if not isinstance(p, dict):
                continue
            deg = p.get("degree")
            deg_s = f"{deg:.2f}°" if isinstance(deg, (int, float)) else _s(deg)
            planet_name = _cat(f"planet.{n.lower()}", full)
            if planet_name.startswith("planet."):
                planet_name = n
            rows.append([
                _s(planet_name), _s(p.get("sign_full") or p.get("sign")), deg_s,
                _s(p.get("nakshatra")), _s(p.get("pada")),
                _s(L["retro"]) if p.get("vakri") else _s(L["direct"]),
            ])
        e += [
            Paragraph(_s(L["positions"]), h2),
            Spacer(1, 3 * mm),
            grid(rows, widths=[26 * mm, 30 * mm, 22 * mm, 40 * mm, 16 * mm, 26 * mm]),
        ]

    # ── Full analysis sections (dasha, doshas, yogas, shadbala, ashtakavarga,
    # bhava, life-areas, chakra, gochar, aspects) — so the fallback PDF is the
    # COMPLETE report, not just chart+positions, matching the WeasyPrint report.
    from app.services.astro import pdf_labels

    def _n(v, dp=0):
        if isinstance(v, bool) or v is None:
            return ""
        if isinstance(v, (int, float)):
            return f"{v:.{dp}f}" if dp else f"{int(round(v))}"
        return _s(v)

    def _pname(nm):
        loc = _cat(f"planet.{str(nm).lower()}", full)
        return _s(nm) if loc.startswith("planet.") else _s(loc)

    def _sec(key, fallback, headers, rows, widths=None):
        if not rows:
            return
        e.append(Spacer(1, 6 * mm))
        e.append(Paragraph(_s(pdf_labels.heading(key, full, fallback=fallback)), h2))
        e.append(Spacer(1, 3 * mm))
        e.append(grid([headers] + rows, widths=widths))

    _hd = lambda k, fb: _s(pdf_labels.heading(k, full, fallback=fb))  # noqa: E731

    # Vimshottari
    dashas = (data.get("vimshottari") or {}).get("dashas") or []
    _sec("dashas", "Vimshottari Dasha",
         [_hd("planet", "Planet"), _hd("years", "Years"), _hd("date", "Start"), "→"],
         [[_pname(d.get("planet")), _n(d.get("years"), 1), _s(d.get("start")), _s(d.get("end"))]
          for d in dashas if isinstance(d, dict)])

    # Doshas
    doshas = [d for d in ((data.get("dosh_analysis") or {}).get("top")
              or (data.get("dosh_analysis") or {}).get("doshas") or [])
              if isinstance(d, dict) and d.get("present")][:12]
    _sec("doshas", "Doshas", [_hd("title", "Name"), _hd("score", "Score"), _hd("status", "Severity")],
         [[_s(d.get("name")), _n(d.get("score")), _s(d.get("severity"))] for d in doshas])

    # Yogas
    yogas = [y for y in ((data.get("yoga_analysis") or {}).get("top")
             or (data.get("yoga_analysis") or {}).get("yogas") or [])
             if isinstance(y, dict) and y.get("present")][:12]
    _sec("yogas", "Yogas", [_hd("title", "Name"), _hd("score", "Score"), _hd("strength", "Strength")],
         [[_s(y.get("name")), _n(y.get("score")), _s(y.get("strength"))] for y in yogas])

    # Shadbala
    sb = (data.get("shadbala") or {}).get("planets") or {}
    _sec("shadbala", "Shadbala", [_hd("planet", "Planet"), _hd("score", "Score")],
         [[_pname(n), _n(v.get("score_100"))] for n, v in sb.items()
          if isinstance(v, dict) and n != "Lagna"])

    # Ashtakavarga (SAV)
    av = data.get("ashtakavarga") or {}
    sav = av.get("sav") or {}
    _sec("ashtakavarga", "Ashtakavarga", [_hd("sign", "Sign"), _hd("score", "Score")],
         [[_s(sign), _n(score)] for sign, score in sav.items()])

    # Bhava strength
    bhava = data.get("bhava_strength") or {}
    _sec("bhava", "House Strength", [_hd("house", "House"), _hd("sign", "Sign"), _hd("score", "Score")],
         [[_n(b.get("house")), _s(b.get("sign")), _n(b.get("score"))]
          for hk in sorted(bhava.keys()) for b in [bhava[hk]] if isinstance(b, dict)])

    # Life areas
    la = data.get("life_areas") or {}
    _sec("life_areas", "Life Areas", [_hd("life_areas", "Area"), _hd("score", "Score")],
         [[_s(k), _n(v.get("score"))] for k, v in la.items() if isinstance(v, dict)])

    # Chakra health
    chakras = (data.get("chakra_health") or {}).get("chakras") or []
    _sec("chakra", "Chakra Health", [_hd("chakra", "Chakra"), _hd("score", "Score"), _hd("status", "Status")],
         [[_s(c.get("name")), _n(c.get("chakra_score")), _s(c.get("chakra_status"))]
          for c in chakras if isinstance(c, dict)])

    # Gochar (transit)
    grashis = (data.get("gochar_today") or {}).get("rashis") or []
    _sec("gochar", "Transit (Gochar)", [_hd("sign", "Sign"), _hd("score", "Score"), _hd("grade", "Grade")],
         [[_s(r.get("rashi")), _n(r.get("score"), 1), _s(r.get("grade"))]
          for r in grashis if isinstance(r, dict)])

    # Aspects
    gd = (data.get("aspect_matrix") or {}).get("graha_drishti") or {}
    _sec("aspects", "Aspects", [_hd("planet", "Planet"), _hd("aspect_on", "Aspects On")],
         [[_pname(p), ", ".join(_cat(f"planet.{str(t).lower()}", full) if not
           _cat(f"planet.{str(t).lower()}", full).startswith("planet.") else str(t)
           for t in tg.keys())]
          for p, tg in gd.items() if isinstance(tg, dict) and tg])

    # Numerology
    if numerology:
        e += [
            Spacer(1, 8 * mm),
            Paragraph(_s(L["numerology"]), h2),
            Spacer(1, 3 * mm),
            kv_table([
                [_s(L["life_path"]), _s(numerology.get("life_path_number")) or "—"],
                [_s(L["birth_day"]), _s(numerology.get("birth_day_number")) or "—"],
                [_s(L["meaning"]), _s(numerology.get("meaning")) or "—"],
            ]),
        ]

    doc.build(e)
    return buf.getvalue()
