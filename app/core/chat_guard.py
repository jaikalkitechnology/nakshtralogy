"""Chat guard — detect off-platform payment/solicitation in chat messages.

Astrologers must never ask a user to pay them directly or move the conversation
off the Platform (see Terms C2/C4). This scanner flags messages that look like
off-platform solicitation — UPI IDs, phone numbers, payment-app names, personal
payment/contact requests — so they can be surfaced to moderation and the user
can be warned. It never changes astrology logic; it only inspects free text.

Detection is intentionally recall-biased (better to flag a borderline message
for human review than to miss a scam). It returns the matched signal categories,
not a hard block, so genuine messages are not silently dropped.
"""

import re

# UPI handle: name@bank  (e.g. john@okhdfcbank, 98765@ybl) — letters/digits/.-_
_UPI = re.compile(r"\b[\w.\-]{2,}@[a-zA-Z]{2,}\b")
# Indian mobile: optional +91/0, then 10 digits starting 6-9, allowing spaces/dashes
_PHONE = re.compile(r"(?<!\d)(?:\+?91[\-\s]?|0)?[6-9]\d{2}[\-\s]?\d{3}[\-\s]?\d{4}(?!\d)")
# Long digit runs (bank a/c, card) — 9+ consecutive digits
_LONGNUM = re.compile(r"(?<!\d)\d{9,18}(?!\d)")

# Payment apps / rails and social/off-platform channels.
_PAY_WORDS = re.compile(
    r"\b(?:g[\-\s]?pay|googlepay|google\s*pay|phonepe|phone\s*pe|paytm|bhim|"
    r"upi|imps|neft|rtgs|net\s*bank|bank\s*(?:a/?c|account|transfer)|ifsc|"
    r"scan(?:ner)?\s*(?:qr|code)|qr\s*code|gift\s*card|amazon\s*pay|"
    r"crypto|bitcoin|usdt|western\s*union)\b",
    re.I,
)
_CONTACT_WORDS = re.compile(
    r"\b(?:whats\s*app|whatsapp|telegram|signal|insta(?:gram)?|"
    r"my\s*(?:number|no\.?|mobile|contact|email|e[\-\s]?mail))\b",
    re.I,
)
# "pay me / send money / transfer to my ..." style solicitation.
_SOLICIT = re.compile(
    r"\b(?:pay\s*me|send\s*(?:me\s*)?(?:money|cash|amount|rs|inr|₹)|"
    r"transfer\s*(?:to|me)|deposit\s*(?:to|in)|"
    r"dakshina|donation|personal\s*(?:account|number|upi)|"
    r"outside\s*(?:the\s*)?app|off\s*(?:the\s*)?app|directly\s*to\s*me)\b",
    re.I,
)


def scan(text):
    """Return {flagged: bool, reasons: [str]} for a chat message body.

    `reasons` is a list of matched signal categories: 'upi', 'phone',
    'payment_app', 'contact_channel', 'solicitation', 'long_number'.
    Empty / non-text input is never flagged.
    """
    reasons = []
    if not text or not isinstance(text, str):
        return {"flagged": False, "reasons": reasons}
    s = text.strip()
    if not s:
        return {"flagged": False, "reasons": reasons}

    is_email = _looks_like_email(s)
    if _UPI.search(s) and not is_email:
        reasons.append("upi")
    elif is_email:
        reasons.append("contact_channel")   # sharing an e-mail = off-platform contact
    if _PHONE.search(s):
        reasons.append("phone")
    if _PAY_WORDS.search(s):
        reasons.append("payment_app")
    if _CONTACT_WORDS.search(s):
        reasons.append("contact_channel")
    if _SOLICIT.search(s):
        reasons.append("solicitation")
    if "phone" not in reasons and _LONGNUM.search(s):
        reasons.append("long_number")

    return {"flagged": bool(reasons), "reasons": reasons}


def _looks_like_email(s):
    """A plain e-mail address also matches the UPI pattern; only treat an @-handle
    as UPI when it is NOT a normal email (has a dot-TLD)."""
    return bool(re.search(r"\b[\w.\-]+@[\w\-]+\.[a-zA-Z]{2,}\b", s))
