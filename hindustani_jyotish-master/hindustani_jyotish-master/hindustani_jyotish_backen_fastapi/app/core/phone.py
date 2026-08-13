"""Contact-number validation shared by the user and astrologer profile schemas.

Rules (blue_print/signup_login.md §1):
- ``country_code`` must look like ``+<1–4 digits>`` (e.g. ``+91``, ``+1``).
- ``mobile`` is the national number, digits only — the dialling prefix lives
  in ``country_code``, never inside ``mobile``.
- When the country code is ``+91`` the mobile must be EXACTLY 10 digits;
  any other code is length-permissive (4–15 digits, bounded by the 15-digit
  E.164 maximum and the ``String(15)`` columns).

Raises ``ValueError`` so it can be called from Pydantic validators (which
turn it into a 422) as well as plain code.
"""
from __future__ import annotations

import re

COUNTRY_CODE_RE = re.compile(r"^\+\d{1,4}$")
_DIGITS_RE = re.compile(r"^[0-9]+$")

DEFAULT_COUNTRY_CODE = "+91"


def validate_contact(country_code: str | None, mobile: str | None) -> None:
    """Validate a (country_code, mobile) pair; raise ValueError when invalid.

    Either side may be None (partial PATCH). A mobile sent without a
    country_code is validated against the default ``+91`` — matching the
    column default, so the stored pair stays consistent.
    """
    if country_code is not None and not COUNTRY_CODE_RE.fullmatch(country_code):
        raise ValueError("country_code must be '+' followed by 1-4 digits (e.g. +91)")
    if mobile is None:
        return
    if not _DIGITS_RE.fullmatch(mobile):
        raise ValueError(
            "mobile must contain digits only (put the dialling prefix in country_code)"
        )
    effective_code = country_code or DEFAULT_COUNTRY_CODE
    if effective_code == DEFAULT_COUNTRY_CODE:
        if len(mobile) != 10:
            raise ValueError("mobile must be exactly 10 digits for +91 numbers")
    elif not 4 <= len(mobile) <= 15:
        raise ValueError("mobile must be between 4 and 15 digits")


def split_e164(raw: str) -> tuple[str, str]:
    """Split a raw mobile string into the canonical ``(country_code, mobile)``
    pair used by ``User``/``Astrologer`` (dialling prefix in its own column,
    bare digits in ``mobile``).

    The mobile-OTP login flow (``app/schemas/auth.py::OtpRequest.mobile`` /
    ``OtpVerifyRequest.mobile``) historically stored the RAW value with the
    dialling prefix EMBEDDED (e.g. ``"+919876543210"``), while the
    Complete-Profile / ``PATCH /users/me`` /  ``PATCH /astrologer/me`` flows
    store the split form. Two different string representations of the same
    real number defeated the DB's uniqueness check, allowing duplicate
    accounts. This helper normalizes ANY raw mobile string into the split
    canonical form so every write/lookup agrees.

    - No leading ``'+'`` → the string is already bare digits; assume
      ``DEFAULT_COUNTRY_CODE`` ("+91"), matching this product's original
      India-only assumption (the same default ``validate_contact`` applies
      when ``country_code`` is omitted).
    - Leading ``'+'`` → treat the trailing 10 digits as the national number
      (the shape every historically-supported number — India, +91, 10
      digits — actually has, and the common convention for the large
      majority of real-world E.164 numbers) and whatever 1-4 digits precede
      it as the dialling code. If that split isn't plausible (too few
      digits, code outside the 1-4 digit bound this app accepts elsewhere),
      fall back to treating the whole string as one bare-digit number under
      the default country code rather than raising — OTP verification has
      already succeeded by the time this runs, so this must never itself
      error out.
    """
    if not raw:
        return DEFAULT_COUNTRY_CODE, raw
    if not raw.startswith("+"):
        return DEFAULT_COUNTRY_CODE, raw
    digits = raw[1:]
    if len(digits) > 10:
        code, mobile = digits[:-10], digits[-10:]
        if 1 <= len(code) <= 4:
            return f"+{code}", mobile
    return DEFAULT_COUNTRY_CODE, digits
