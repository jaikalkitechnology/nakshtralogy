"""
Lightweight abuse / profanity guard for user-authored short text
================================================================

Used to keep astrologer-authored coupon **codes** and **titles** clean before
they go live on user-facing surfaces. Deliberately small and dependency-free:
a curated blocklist + leetspeak normalisation. NOT a full moderation system —
it blocks the obvious cases so an offer name/code can't carry slurs/expletives.

Never touches astrology logic. Pure text screening.
"""

from typing import Optional

# Strong terms — matched as a SUBSTRING of the normalised text (>= 4 chars so
# they don't accidentally hit ordinary words). English + common romanised Hindi.
_SUBSTRING_BLOCK = {
    # English
    "fuck", "shit", "bitch", "cunt", "bastard", "dick", "pussy", "slut",
    "whore", "nigger", "nigga", "faggot", "motherfuck", "asshole", "dickhead",
    "cock", "wank", "bollock", "retard", "rape", "rapist", "pedo", "molest",
    # Romanised Hindi / Indic abuse
    "madarchod", "behenchod", "bhenchod", "bhosdi", "bhosda", "chutiya",
    "chutiyapa", "chutia", "gaand", "gandu", "lund", "lauda", "randi",
    "harami", "haramkhor", "kamina", "kaminey", "bakchod", "chinal",
    "jhaant", "tatti", "madhrchod", "bsdk", "choot", "chodu", "chood",
}

# Ambiguous / short terms — require a standalone WORD (token) match to avoid
# false positives inside legitimate words (e.g. "class", "assist", "essex").
_WORD_BLOCK = {
    "ass", "sex", "xxx", "porn", "nude", "boob", "boobs", "damn", "hell",
    "gand", "chut", "chod", "gay",
}

# Leetspeak / lookalike normalisation so "f*ck", "sh1t", "@ss" are caught.
_LEET = str.maketrans({
    "0": "o", "1": "i", "3": "e", "4": "a", "5": "s", "7": "t",
    "$": "s", "@": "a", "!": "i", "|": "i",
})


def _normalise(text: str) -> str:
    """Lowercase + leet-fold; return (collapsed_alnum, spaced_tokens)."""
    return (text or "").lower().translate(_LEET)


def contains_profanity(text: Optional[str]) -> bool:
    """True when the text carries an obvious slur/expletive."""
    if not text:
        return False
    low = _normalise(text)
    collapsed = "".join(ch for ch in low if ch.isalnum())
    if not collapsed:
        return False
    for term in _SUBSTRING_BLOCK:
        if term in collapsed:
            return True
    # Word-boundary check for the ambiguous set: tokenise on non-alnum.
    tokens = set()
    cur = []
    for ch in low:
        if ch.isalnum():
            cur.append(ch)
        elif cur:
            tokens.add("".join(cur)); cur = []
    if cur:
        tokens.add("".join(cur))
    return bool(tokens & _WORD_BLOCK)


def first_clean_error(*texts: Optional[str]) -> Optional[str]:
    """Return the first offending text (for messaging), or None if all clean."""
    for t in texts:
        if contains_profanity(t):
            return t
    return None
