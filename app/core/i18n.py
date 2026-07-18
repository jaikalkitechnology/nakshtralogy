"""
Backend i18n — language resolution + static message catalog
============================================================

Central localization layer for API responses. Lets any router return
user-facing strings (errors, success messages, labels) in the caller's
language without changing response *keys* or machine enums.

Usage in a router:

    from app.core.i18n import get_lang, t

    @router.post("/login")
    def login(..., lang: str = Depends(get_lang)):
        if bad:
            raise HTTPException(401, detail=t("err.invalid_credentials", lang))
        return {"message": t("msg.wallet_added", lang, amount=100)}

Language resolution order (get_lang): ?lang= query param → Accept-Language
header → "english". (An authenticated variant can additionally use the
user's stored preferred_language — see get_lang docstring.)

Canonical language codes (full words) match app/seeds/seed_ai_config.py
and app.ai_config.ai_cache. This module is the ONE place that normalizes
the legacy short codes (hi, mr, …) used by app/services/report_translator.py.
"""

from typing import Optional

try:  # keep pure-python helpers importable even without FastAPI installed
    from fastapi import Query, Header
    _HAS_FASTAPI = True
except Exception:  # pragma: no cover
    _HAS_FASTAPI = False


# ── Canonical languages ────────────────────────────────────────────────

SUPPORTED_LANGUAGES = [
    "english", "hindi", "hinglish", "bengali", "tamil", "telugu",
    "kannada", "malayalam", "gujarati", "marathi", "punjabi", "odia",
]
DEFAULT_LANGUAGE = "english"

# Short / locale-style codes → canonical full word. This resolves the
# hi/hindi mismatch between report_translator.py and ai_cache/llm_service.
_ALIASES = {
    "en": "english", "eng": "english", "en_us": "english", "en_gb": "english",
    "hi": "hindi", "hin": "hindi", "hi_in": "hindi",
    "hi_latn": "hinglish", "hinglish": "hinglish", "hien": "hinglish",
    "bn": "bengali", "ben": "bengali", "bn_in": "bengali",
    "ta": "tamil", "tam": "tamil",
    "te": "telugu", "tel": "telugu",
    "kn": "kannada", "kan": "kannada",
    "ml": "malayalam", "mal": "malayalam",
    "gu": "gujarati", "guj": "gujarati",
    "mr": "marathi", "mar": "marathi",
    "pa": "punjabi", "pan": "punjabi", "pa_in": "punjabi",
    "or": "odia", "ori": "odia", "ory": "odia",
}


def normalize_lang(raw: Optional[str]) -> str:
    """Map any incoming code/label to a canonical full-word language code."""
    if not raw:
        return DEFAULT_LANGUAGE
    key = str(raw).strip().lower().replace("-", "_")
    if key in SUPPORTED_LANGUAGES:
        return key
    if key in _ALIASES:
        return _ALIASES[key]
    # locale like "ta_IN" → try the primary subtag
    primary = key.split("_")[0]
    if primary in SUPPORTED_LANGUAGES:
        return primary
    if primary in _ALIASES:
        return _ALIASES[primary]
    return DEFAULT_LANGUAGE


# ── Request language dependency ────────────────────────────────────────

if _HAS_FASTAPI:

    def get_lang(
        lang: Optional[str] = Query(
            None, description="Language code (e.g. hindi, english, tamil, hinglish)."
        ),
        accept_language: Optional[str] = Header(None),
    ) -> str:
        """FastAPI dependency: resolve the response language for this request.

        Order: explicit ?lang= → Accept-Language header → english.

        For authenticated endpoints that should honour a saved preference,
        wrap this with a variant that falls back to
        current_user.preferred_language before english. Kept auth-free here so
        it works on public endpoints (signup/login) too.
        """
        if lang:
            return normalize_lang(lang)
        if accept_language:
            primary = accept_language.split(",")[0].split(";")[0].strip()
            return normalize_lang(primary)
        return DEFAULT_LANGUAGE

else:  # pragma: no cover - fallback when FastAPI isn't importable

    def get_lang(lang: Optional[str] = None, accept_language: Optional[str] = None) -> str:
        return normalize_lang(lang) if lang else DEFAULT_LANGUAGE


# ── Static message catalog ─────────────────────────────────────────────
#
# CATALOG[key] = {lang_code: text}. A key need not list every language;
# t() falls back to english when a language is missing, so translator
# backfill can land incrementally (tracked in docs/localization/).
#
# ── Translation status ──
#   english, hindi, hinglish : populated (primary launch languages)
#   bengali, tamil, telugu, kannada, malayalam, gujarati, marathi,
#   punjabi, odia            : TODO(i18n) — fall back to english until
#                              a translator backfills them.

CATALOG = {
    # ── Auth / account errors ──
    "err.email_registered": {
        "english": "Email already registered",
        "hindi": "यह ईमेल पहले से पंजीकृत है",
        "hinglish": "Yeh email pehle se registered hai",
    },
    "err.phone_registered": {
        "english": "Phone already registered",
        "hindi": "यह फ़ोन नंबर पहले से पंजीकृत है",
        "hinglish": "Yeh phone number pehle se registered hai",
    },
    "err.invalid_credentials": {
        "english": "Invalid email or password",
        "hindi": "ईमेल या पासवर्ड ग़लत है",
        "hinglish": "Email ya password galat hai",
    },
    "err.account_deactivated": {
        "english": "Account is deactivated",
        "hindi": "यह खाता निष्क्रिय कर दिया गया है",
        "hinglish": "Yeh account deactivate kar diya gaya hai",
    },
    "err.invalid_google_token": {
        "english": "Invalid Google token",
        "hindi": "अमान्य Google टोकन",
        "hinglish": "Google token invalid hai",
    },
    "err.invalid_reset_token": {
        "english": "Invalid or expired reset token",
        "hindi": "रीसेट टोकन अमान्य या समाप्त हो चुका है",
        "hinglish": "Reset token invalid ya expire ho chuka hai",
    },
    "err.invalid_refresh_token": {
        "english": "Invalid or expired refresh token",
        "hindi": "रिफ़्रेश टोकन अमान्य या समाप्त हो चुका है",
        "hinglish": "Refresh token invalid ya expire ho chuka hai",
    },
    "err.user_not_found": {
        "english": "User not found",
        "hindi": "उपयोगकर्ता नहीं मिला",
        "hinglish": "User nahi mila",
    },
    "err.incorrect_password": {
        "english": "Incorrect current password",
        "hindi": "वर्तमान पासवर्ड ग़लत है",
        "hinglish": "Current password galat hai",
    },
    "err.astrologer_not_found": {
        "english": "Astrologer not found",
        "hindi": "ज्योतिषी नहीं मिला",
        "hinglish": "Astrologer nahi mila",
    },
    "err.not_in_saved": {
        "english": "Not in saved list",
        "hindi": "सहेजी गई सूची में नहीं है",
        "hinglish": "Saved list mein nahi hai",
    },

    # ── Success messages ──
    "msg.reset_link_sent": {
        "english": "If this email is registered, a reset link has been sent",
        "hindi": "यदि यह ईमेल पंजीकृत है, तो रीसेट लिंक भेज दिया गया है",
        "hinglish": "Agar yeh email registered hai, to reset link bhej diya gaya hai",
    },
    "msg.password_reset": {
        "english": "Password reset successfully",
        "hindi": "पासवर्ड सफलतापूर्वक रीसेट हो गया",
        "hinglish": "Password successfully reset ho gaya",
    },
    "msg.password_changed": {
        "english": "Password changed successfully",
        "hindi": "पासवर्ड सफलतापूर्वक बदल दिया गया",
        "hinglish": "Password successfully change ho gaya",
    },
    "msg.account_deactivated": {
        "english": "Account deactivated",
        "hindi": "खाता निष्क्रिय कर दिया गया",
        "hinglish": "Account deactivate kar diya gaya",
    },
    "msg.wallet_added": {
        "english": "₹{amount} added to wallet",
        "hindi": "₹{amount} वॉलेट में जोड़े गए",
        "hinglish": "₹{amount} wallet mein add ho gaye",
    },
    "msg.already_saved": {
        "english": "Already saved",
        "hindi": "पहले से सहेजा गया है",
        "hinglish": "Pehle se saved hai",
    },
    "msg.astrologer_saved": {
        "english": "Astrologer saved",
        "hindi": "ज्योतिषी सहेजा गया",
        "hinglish": "Astrologer save ho gaya",
    },
    "msg.removed_saved": {
        "english": "Removed from saved list",
        "hindi": "सहेजी गई सूची से हटा दिया गया",
        "hinglish": "Saved list se hata diya gaya",
    },

    # ── Wallet transaction labels ──
    "label.wallet.recharge": {
        "english": "Wallet Recharge", "hindi": "वॉलेट रिचार्ज", "hinglish": "Wallet Recharge",
    },
    "label.wallet.bonus": {
        "english": "Bonus Credit", "hindi": "बोनस क्रेडिट", "hinglish": "Bonus Credit",
    },
    "label.wallet.consultation_debit": {
        "english": "Service / Consultation", "hindi": "सेवा / परामर्श", "hinglish": "Service / Consultation",
    },
    "label.wallet.consultation_credit": {
        "english": "Refund / Credit", "hindi": "रिफ़ंड / क्रेडिट", "hinglish": "Refund / Credit",
    },
    "label.wallet.refund": {
        "english": "Refund", "hindi": "रिफ़ंड", "hinglish": "Refund",
    },
    "label.wallet.withdrawal": {
        "english": "Withdrawal", "hindi": "निकासी", "hinglish": "Withdrawal",
    },
    "label.wallet.ai_debit": {
        "english": "AI Service", "hindi": "AI सेवा", "hinglish": "AI Service",
    },
}


def t(key: str, lang: str = DEFAULT_LANGUAGE, **fmt) -> str:
    """Translate a catalog key into `lang`, formatting any {placeholders}.

    Falls back to english, then to the raw key, so a missing translation
    never raises and never blocks a response.
    """
    lang = normalize_lang(lang)
    entry = CATALOG.get(key)
    if not entry:
        return key
    text = entry.get(lang) or entry.get(DEFAULT_LANGUAGE) or key
    if fmt:
        try:
            text = text.format(**fmt)
        except (KeyError, IndexError, ValueError):
            pass
    return text


def wallet_label(txn_type: str, lang: str = DEFAULT_LANGUAGE) -> str:
    """Localized label for a wallet transaction type (fallback: prettified type)."""
    key = f"label.wallet.{txn_type}"
    if key in CATALOG:
        return t(key, lang)
    return txn_type.replace("_", " ").title()
