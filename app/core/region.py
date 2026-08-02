"""
Region detection — IN vs INTL
=============================

Decides whether a request/user is inside India (`IN`) or international
(`INTL`). This single flag drives two presentation concerns and NOTHING in the
astrology engine:

  * language mode  — INTL shows only international languages, IN keeps the 11
    Indian locales (see app/core/i18n_intl.py + the flutter language picker).
  * currency       — INTL prices in USD via store IAP tiers, IN keeps the
    wallet/₹ flow (see app/core/pricing.py).

Resolution order (resolve_region):
  1. explicit country code (device-locale hint header `X-Device-Country`
     or a stored user country) — cheap, no network.
  2. IP-geo lookup of the caller's public IP (best-effort, cached, never
     raises — falls back to India on failure so existing behaviour is kept).

A user may MANUALLY override the region in Settings; when `region_manual` is
set on the user we never auto-overwrite it.

Never raises. Geo failure or an unknown country is treated as India (`IN`) so
the default Indian experience is preserved when detection is unavailable.
"""

import ipaddress
import logging
import time
from typing import Optional, Tuple

logger = logging.getLogger("region")

IN = "IN"
INTL = "INTL"

# Country hint header sent by the mobile client from its device locale, e.g.
# "US", "FR", "TH". Used before any network geo lookup.
DEVICE_COUNTRY_HEADER = "x-device-country"

# tiny in-process cache: ip -> (country_code, expires_epoch)
_GEO_CACHE: dict = {}
_GEO_TTL = 60 * 60 * 6  # 6h


def region_for_country(country_code: Optional[str]) -> str:
    """Map an ISO-3166 alpha-2 country code to a region. India → IN, else INTL.

    An empty/None country code is treated as India so we never accidentally
    push existing Indian users into international mode when detection failed.
    """
    if not country_code:
        return IN
    return IN if str(country_code).strip().upper() == "IN" else INTL


def is_international_region(region: Optional[str]) -> bool:
    return str(region or IN).strip().upper() == INTL


def app_mode_for_region(region: Optional[str]) -> str:
    """The flutter AppMode name for a region: `international` | `india`."""
    return "international" if is_international_region(region) else "india"


def currency_for_region(region: Optional[str]) -> str:
    """Session display currency for a region: USD international, INR India."""
    return "USD" if is_international_region(region) else "INR"


def _is_public_ip(ip: str) -> bool:
    try:
        addr = ipaddress.ip_address(ip)
        return not (addr.is_private or addr.is_loopback or addr.is_reserved
                    or addr.is_link_local or addr.is_unspecified)
    except ValueError:
        return False


def client_ip_from_headers(headers: dict, fallback: Optional[str] = None) -> Optional[str]:
    """Extract the caller's public IP from proxy headers (X-Forwarded-For /
    X-Real-IP), falling back to the socket peer. Lower-cased header dict."""
    xff = headers.get("x-forwarded-for") or headers.get("X-Forwarded-For")
    if xff:
        for part in xff.split(","):
            ip = part.strip()
            if _is_public_ip(ip):
                return ip
    xri = headers.get("x-real-ip") or headers.get("X-Real-IP")
    if xri and _is_public_ip(xri.strip()):
        return xri.strip()
    if fallback and _is_public_ip(fallback):
        return fallback
    return None


def geo_country(ip: Optional[str]) -> Optional[str]:
    """Best-effort IP-geo → ISO alpha-2 country code. Cached, never raises.

    Uses the free ip-api.com endpoint (no key). Returns None on any failure so
    the caller can fall back to a device hint or the India default.
    """
    if not ip or not _is_public_ip(ip):
        return None
    now = time.time()
    hit = _GEO_CACHE.get(ip)
    if hit and hit[1] > now:
        return hit[0]
    try:
        import requests  # local import — keeps module importable without requests
        resp = requests.get(
            f"http://ip-api.com/json/{ip}",
            params={"fields": "status,countryCode"},
            timeout=3,
        )
        if resp.status_code == 200:
            data = resp.json()
            if data.get("status") == "success":
                cc = (data.get("countryCode") or "").strip().upper() or None
                _GEO_CACHE[ip] = (cc, now + _GEO_TTL)
                return cc
    except Exception as e:  # pragma: no cover — network/parse failure is fine
        logger.info("geo lookup failed for %s: %s", ip, e)
    # cache the miss briefly so a flaky endpoint doesn't get hammered
    _GEO_CACHE[ip] = (None, now + 300)
    return None


def session_region(
    explicit_region: Optional[str] = None,
    user_region: Optional[str] = None,
    device_country: Optional[str] = None,
) -> str:
    """Resolve the region to price/present a single request in, cheaply (no
    network). Priority: an explicit ?region= override → the authenticated
    user's stored region → the device-country hint → India default.

    Used by pricing/entitlements/paywall so a response carries the right
    currency for the caller without an IP lookup on every call.
    """
    if explicit_region:
        r = str(explicit_region).strip().upper()
        if r in (IN, INTL):
            return r
    if user_region:
        r = str(user_region).strip().upper()
        if r in (IN, INTL):
            return r
    if device_country:
        return region_for_country(device_country)
    return IN


def resolve_region(
    device_country: Optional[str] = None,
    client_ip: Optional[str] = None,
    stored_country: Optional[str] = None,
) -> Tuple[str, Optional[str]]:
    """Resolve (region, country_code) from the cheapest available signal.

    Priority: explicit device-locale country hint → previously stored country →
    IP-geo → India default. Never raises.
    """
    cc = (device_country or "").strip().upper() or None
    if not cc:
        cc = (stored_country or "").strip().upper() or None
    if not cc:
        cc = geo_country(client_ip)
    return region_for_country(cc), cc
