"""
USD pricing for international (INTL) users
=========================================

International paid digital goods are sold through **store IAP tiers** (Apple App
Store / Google Play Billing), so every USD price must land on a real store tier
(e.g. $0.99 / $1.99 / $2.99 / $4.99 / $8.99 / $17.99 …). This module owns:

  * the tier ladder + rounding,
  * the global default rule  ``usd = round_to_tier(inr × MULTIPLIER ÷ FX_RATE)``
    (MULTIPLIER default 5, FX_RATE admin-set, both stored in PlatformSetting),
  * a per-service store product id,
  * a bulk "regenerate USD" that respects admin overrides.

This NEVER touches astrology logic — only currency presentation/plumbing. The
INR ledger and the India wallet flow are unchanged; USD is a display + IAP
concern for INTL sessions.
"""

import logging
from decimal import Decimal
from typing import Optional

logger = logging.getLogger("pricing")

# ── Store IAP tier ladder (USD). Ascending. Mirrors the common Apple/Google
#    price points. Admin can still override an individual price_usd. ──────────
IAP_TIERS = [
    0.99, 1.99, 2.99, 3.99, 4.99, 5.99, 6.99, 7.99, 8.99, 9.99,
    10.99, 11.99, 12.99, 14.99, 17.99, 19.99, 24.99, 29.99, 34.99,
    39.99, 44.99, 49.99, 59.99, 69.99, 79.99, 89.99, 99.99,
]

# PlatformSetting storage
SETTINGS_CATEGORY = "pricing"
FX_KEY = "fx_rate_usd"          # INR per 1 USD (e.g. 83.0)
MULT_KEY = "usd_multiplier"     # global multiplier (default 5)

DEFAULT_FX_RATE = 83.0
DEFAULT_MULTIPLIER = 5.0

# store product id namespace
IAP_PRODUCT_PREFIX = "com.nakshtralogy.iap"


def nearest_tier(amount: float) -> float:
    """Snap an arbitrary USD amount to the nearest IAP tier.

    Ties resolve upward. Anything at/below the floor returns the smallest tier;
    a non-positive amount also returns the smallest tier (there is no free IAP —
    free services never reach USD pricing).
    """
    if amount is None or amount <= 0:
        return IAP_TIERS[0]
    if amount >= IAP_TIERS[-1]:
        return IAP_TIERS[-1]
    best = IAP_TIERS[0]
    best_d = abs(amount - best)
    for t in IAP_TIERS[1:]:
        d = abs(amount - t)
        # `<=` so on a tie the higher tier wins
        if d <= best_d:
            best, best_d = t, d
    return best


def compute_usd(inr: float, fx_rate: float, multiplier: float) -> float:
    """Global default rule → nearest IAP tier.

    ``usd = round_to_tier(inr × multiplier ÷ fx_rate)``. Guards against a zero
    FX rate. Returns a tier value; caller decides whether a free service gets a
    USD price at all (it should not).
    """
    if not fx_rate or fx_rate <= 0:
        fx_rate = DEFAULT_FX_RATE
    raw = (float(inr or 0) * float(multiplier or DEFAULT_MULTIPLIER)) / float(fx_rate)
    return nearest_tier(raw)


def iap_product_id_for(service_key: str, tier_usd: float) -> str:
    """Store product id for a service at a tier, e.g.
    ``com.nakshtralogy.iap.career_report.t499`` ($4.99 → t499). Stable so the
    same service+tier always maps to the same store SKU."""
    cents = int(round(float(tier_usd) * 100))
    return f"{IAP_PRODUCT_PREFIX}.{service_key}.t{cents}"


# ── PlatformSetting-backed FX rate + multiplier (admin editable) ─────────────

def _get_setting(db, key: str) -> Optional[str]:
    from app.models.model import PlatformSetting
    row = (
        db.query(PlatformSetting)
        .filter(PlatformSetting.category == SETTINGS_CATEGORY, PlatformSetting.key == key)
        .first()
    )
    return row.value if row else None


def _set_setting(db, key: str, value: str, updated_by: Optional[str] = None):
    from app.models.model import PlatformSetting
    row = (
        db.query(PlatformSetting)
        .filter(PlatformSetting.category == SETTINGS_CATEGORY, PlatformSetting.key == key)
        .first()
    )
    if row:
        row.value = value
        if updated_by:
            row.updated_by = updated_by
    else:
        row = PlatformSetting(category=SETTINGS_CATEGORY, key=key, value=value,
                              updated_by=updated_by, description=f"USD pricing {key}")
        db.add(row)
    return row


def get_fx_rate(db) -> float:
    try:
        v = _get_setting(db, FX_KEY)
        return float(v) if v else DEFAULT_FX_RATE
    except Exception:
        return DEFAULT_FX_RATE


def get_multiplier(db) -> float:
    try:
        v = _get_setting(db, MULT_KEY)
        return float(v) if v else DEFAULT_MULTIPLIER
    except Exception:
        return DEFAULT_MULTIPLIER


def get_pricing_settings(db) -> dict:
    return {
        "fx_rate_usd": get_fx_rate(db),
        "usd_multiplier": get_multiplier(db),
        "iap_tiers": IAP_TIERS,
    }


def set_pricing_settings(db, fx_rate: Optional[float] = None,
                         multiplier: Optional[float] = None,
                         updated_by: Optional[str] = None) -> dict:
    if fx_rate is not None:
        _set_setting(db, FX_KEY, str(float(fx_rate)), updated_by)
    if multiplier is not None:
        _set_setting(db, MULT_KEY, str(float(multiplier)), updated_by)
    db.commit()
    return get_pricing_settings(db)


def usd_for_pricing(sp, fx_rate: float, multiplier: float) -> Optional[float]:
    """The USD amount to charge for a ServicePricing row (INTL session).

    Free services (is_free or price 0) have no USD price. A manual override
    (price_usd_manual) is returned verbatim. Otherwise apply the global rule.
    """
    price = float(getattr(sp, "price", 0) or 0)
    if getattr(sp, "is_free", False) or price == 0:
        return None
    if getattr(sp, "price_usd_manual", False) and sp.price_usd is not None:
        return float(sp.price_usd)
    return compute_usd(price, fx_rate, multiplier)


def consult_rate_usd(inr_rate: float, fx_rate: float, multiplier: float) -> float:
    """USD display rate for a per-minute consultation rate (international).

    Applies the same ``× MULTIPLIER ÷ FX`` premium rule as products, but WITHOUT
    tier snapping — per-minute rates aren't store-IAP tiers. The astrologer sets
    the ₹ base rate; international sessions see this USD rate. Currency
    presentation only; the ₹ ledger/wallet is unchanged. Live international
    consultation charging is gated on the payments (PAPG) phase."""
    if not inr_rate:
        return 0.0
    if not fx_rate or fx_rate <= 0:
        fx_rate = DEFAULT_FX_RATE
    return round(float(inr_rate) * float(multiplier or DEFAULT_MULTIPLIER) / float(fx_rate), 2)


def iap_product_id_for_agent(domain_key: str, tier_usd: float) -> str:
    """Store product id for a paid AI agent at a tier, e.g.
    ``com.nakshtralogy.iap.agent.career.t499``. Namespaced under ``agent`` so it
    never collides with a service SKU sharing the same key."""
    cents = int(round(float(tier_usd) * 100))
    return f"{IAP_PRODUCT_PREFIX}.agent.{domain_key}.t{cents}"


def usd_for_agent(setting, fx_rate: float, multiplier: float) -> Optional[float]:
    """The USD amount to charge to unlock a paid AI agent (INTL session).

    A free / unpriced agent (not is_paid, or price 0) has no USD price. A manual
    override (price_usd_manual) is returned verbatim. Otherwise apply the global
    rule. Mirrors ``usd_for_pricing`` for ServicePricing."""
    if setting is None:
        return None
    price = float(getattr(setting, "price", 0) or 0)
    if not getattr(setting, "is_paid", False) or price == 0:
        return None
    if getattr(setting, "price_usd_manual", False) and setting.price_usd is not None:
        return float(setting.price_usd)
    return compute_usd(price, fx_rate, multiplier)


def regenerate_usd_prices(db, force: bool = False) -> dict:
    """Recompute price_usd + iap_product_id for every priced service using the
    current rule. Skips rows an admin has manually overridden unless force=True.
    Returns a summary. Commits."""
    from app.models.model import ServicePricing
    fx = get_fx_rate(db)
    mult = get_multiplier(db)
    rows = db.query(ServicePricing).all()
    updated = 0
    skipped = 0
    for sp in rows:
        price = float(sp.price or 0)
        if sp.is_free or price == 0:
            # free service — clear any stray USD price, no IAP product
            if sp.price_usd is not None or sp.iap_product_id is not None:
                sp.price_usd = None
                sp.iap_product_id = None
                updated += 1
            continue
        if sp.price_usd_manual and not force:
            skipped += 1
            continue
        tier = compute_usd(price, fx, mult)
        sp.price_usd = Decimal(str(tier))
        sp.iap_product_id = iap_product_id_for(sp.service_key, tier)
        if force:
            sp.price_usd_manual = False
        updated += 1
    db.commit()
    return {"updated": updated, "skipped_manual": skipped,
            "fx_rate_usd": fx, "usd_multiplier": mult, "total": len(rows)}
