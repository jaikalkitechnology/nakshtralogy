"""
Store IAP receipt verification (Apple App Store + Google Play)
=============================================================

International paid digital goods are sold through App Store / Google Play IAP
tiers (store policy — NOT the card wallet). After the client completes a store
purchase it POSTs the receipt to /service/iap/verify, which calls this module to
validate the receipt before granting a ServiceOrder.

Two modes, selected automatically per platform by whether real store credentials
are configured (PlatformSetting category "iap", loaded by the router into
`config`):

  * REAL (PAPG / Phase D) — talks to the store:
      - Apple: App Store Server API GET /inApps/v1/transactions/{id}, authorised
        with an ES256 JWT signed by an App Store Connect API key. Verifies the
        decoded transaction's bundleId + productId and rejects a refunded/revoked
        transaction (revocationDate present).
      - Google: Google Play Developer API
        purchases.products.get(packageName, productId, token), authorised with an
        OAuth2 access token minted from a service-account JWT. Requires
        purchaseState == 0 (purchased) and treats a refund/void as invalid.
  * SCAFFOLD (pre-PAPG) — no credentials configured, or IAP_SCAFFOLD_MODE forced:
      structural checks (non-empty ids, product matches the service) + accept, so
      the end-to-end flow runs. Clearly marks validated=False.

Refund/void handling: `handle_refund` flips a granted ServiceOrder to "refunded"
idempotently (used by store server-to-server notifications).

Never raises — a failed/unavailable validation returns (False, {...reason}).
Real network calls degrade gracefully if optional libs (PyJWT/cryptography) or
network are unavailable.
"""

import base64
import json
import logging
import time
from typing import Optional, Tuple

logger = logging.getLogger("iap_verify")

# Force scaffold even if credentials exist (e.g. staging). Normally leave False:
# the module auto-selects real validation only when credentials are present.
IAP_SCAFFOLD_MODE_FORCE = False

VALID_PLATFORMS = ("ios", "android")

# App Store Server API hosts
APPLE_HOST_PROD = "https://api.storekit.itunes.apple.com"
APPLE_HOST_SANDBOX = "https://api.storekit-sandbox.itunes.apple.com"
GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
GOOGLE_ANDROIDPUBLISHER = "https://androidpublisher.googleapis.com/androidpublisher/v3"


# ── mode selection ───────────────────────────────────────────────────────

def _has_apple_creds(cfg: dict) -> bool:
    return bool(cfg and cfg.get("apple_issuer_id") and cfg.get("apple_key_id")
                and cfg.get("apple_private_key") and cfg.get("apple_bundle_id"))


def _has_google_creds(cfg: dict) -> bool:
    return bool(cfg and cfg.get("google_service_account_json") and cfg.get("google_package_name"))


def platform_is_live(platform: str, cfg: Optional[dict]) -> bool:
    """True when real store validation should run for this platform."""
    if IAP_SCAFFOLD_MODE_FORCE or not cfg:
        return False
    if platform == "ios":
        return _has_apple_creds(cfg)
    if platform == "android":
        return _has_google_creds(cfg)
    return False


# ── scaffold ─────────────────────────────────────────────────────────────

def _scaffold_verify(platform: str, product_id: str, transaction_id: str,
                     expected_product_id: Optional[str]) -> Tuple[bool, dict]:
    """Structural-only acceptance used before store credentials are configured."""
    if platform not in VALID_PLATFORMS:
        return False, {"reason": "unknown_platform", "platform": platform}
    if not product_id or not transaction_id:
        return False, {"reason": "missing_ids"}
    if expected_product_id and product_id != expected_product_id:
        return False, {"reason": "product_mismatch",
                       "expected": expected_product_id, "got": product_id}
    return True, {
        "mode": "scaffold",
        "validated": False,   # NOT store-validated — configure credentials to go live
        "platform": platform,
        "product_id": product_id,
        "transaction_id": transaction_id,
    }


# ── Apple: App Store Server API ──────────────────────────────────────────

def _b64url_decode(seg: str) -> bytes:
    seg += "=" * (-len(seg) % 4)
    return base64.urlsafe_b64decode(seg)


def _decode_jws_payload(jws: str) -> Optional[dict]:
    """Decode a JWS (Apple signed transaction) payload without verifying the
    signature chain (Apple already signed it; the JWT auth to their API is what
    proves authenticity of the fetch). Returns the JSON payload dict."""
    try:
        parts = jws.split(".")
        if len(parts) != 3:
            return None
        return json.loads(_b64url_decode(parts[1]))
    except Exception as e:  # pragma: no cover
        logger.warning("apple jws decode failed: %s", e)
        return None


def _apple_client_jwt(cfg: dict) -> Optional[str]:
    """Sign the ES256 App Store Connect API JWT used to call the App Store
    Server API. Requires PyJWT + cryptography; returns None if unavailable."""
    try:
        # BaseException: a broken cryptography backend can pyo3-panic on import
        # (PanicException subclasses BaseException); degrade instead of crashing.
        import jwt  # PyJWT
    except BaseException as e:  # pragma: no cover
        logger.warning("PyJWT unavailable for Apple JWT: %s", e)
        return None
    now = int(time.time())
    headers = {"alg": "ES256", "kid": cfg["apple_key_id"], "typ": "JWT"}
    payload = {
        "iss": cfg["apple_issuer_id"],
        "iat": now,
        "exp": now + 60 * 20,
        "aud": "appstoreconnect-v1",
        "bid": cfg["apple_bundle_id"],
    }
    try:
        return jwt.encode(payload, cfg["apple_private_key"], algorithm="ES256", headers=headers)
    except Exception as e:  # pragma: no cover
        logger.warning("apple jwt sign failed: %s", e)
        return None


def _verify_apple(product_id: str, transaction_id: str,
                  receipt: Optional[str], expected_product_id: Optional[str],
                  cfg: dict) -> Tuple[bool, dict]:
    """Validate an App Store transaction via the App Store Server API."""
    try:
        import requests
    except Exception:  # pragma: no cover
        return False, {"reason": "validation_unavailable", "detail": "requests missing"}
    token = _apple_client_jwt(cfg)
    if not token:
        return False, {"reason": "validation_unavailable", "detail": "cannot sign Apple JWT (PyJWT/cryptography)"}

    env = (cfg.get("apple_environment") or "production").lower()
    hosts = [APPLE_HOST_PROD, APPLE_HOST_SANDBOX] if env == "production" else [APPLE_HOST_SANDBOX, APPLE_HOST_PROD]
    headers = {"Authorization": f"Bearer {token}"}
    txn = None
    for host in hosts:
        try:
            r = requests.get(f"{host}/inApps/v1/transactions/{transaction_id}",
                             headers=headers, timeout=10)
            if r.status_code == 200:
                signed = r.json().get("signedTransactionInfo")
                txn = _decode_jws_payload(signed) if signed else None
                if txn:
                    break
            elif r.status_code in (401, 403):
                return False, {"reason": "auth_failed", "status": r.status_code}
        except Exception as e:  # pragma: no cover
            logger.warning("apple api call failed on %s: %s", host, e)
    if not txn:
        return False, {"reason": "transaction_not_found", "transaction_id": transaction_id}

    if txn.get("bundleId") and txn["bundleId"] != cfg["apple_bundle_id"]:
        return False, {"reason": "bundle_mismatch", "got": txn.get("bundleId")}
    tx_product = txn.get("productId")
    if expected_product_id and tx_product and tx_product != expected_product_id:
        return False, {"reason": "product_mismatch", "expected": expected_product_id, "got": tx_product}
    if txn.get("revocationDate"):
        return False, {"reason": "revoked", "revocationDate": txn["revocationDate"]}

    return True, {
        "mode": "apple",
        "validated": True,
        "platform": "ios",
        "product_id": tx_product or product_id,
        "transaction_id": txn.get("transactionId") or transaction_id,
        "original_transaction_id": txn.get("originalTransactionId"),
        "environment": txn.get("environment"),
    }


# ── Google: Play Developer API ───────────────────────────────────────────

def _google_access_token(cfg: dict) -> Optional[str]:
    """Mint an OAuth2 access token from the service-account JSON via a signed
    JWT grant. Requires PyJWT + cryptography + requests."""
    try:
        # BaseException: guards against a pyo3 crypto-backend panic on import.
        import jwt  # PyJWT
        import requests
    except BaseException as e:  # pragma: no cover
        logger.warning("PyJWT/requests unavailable for Google token: %s", e)
        return None
    try:
        sa = cfg["google_service_account_json"]
        if isinstance(sa, str):
            sa = json.loads(sa)
        now = int(time.time())
        claim = {
            "iss": sa["client_email"],
            "scope": "https://www.googleapis.com/auth/androidpublisher",
            "aud": GOOGLE_TOKEN_URL,
            "iat": now,
            "exp": now + 3600,
        }
        assertion = jwt.encode(claim, sa["private_key"], algorithm="RS256")
        r = requests.post(GOOGLE_TOKEN_URL, data={
            "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
            "assertion": assertion,
        }, timeout=10)
        if r.status_code == 200:
            return r.json().get("access_token")
        logger.warning("google token endpoint %s: %s", r.status_code, r.text[:200])
    except Exception as e:  # pragma: no cover
        logger.warning("google token mint failed: %s", e)
    return None


def _verify_google(product_id: str, transaction_id: str,
                   purchase_token: Optional[str], expected_product_id: Optional[str],
                   cfg: dict) -> Tuple[bool, dict]:
    """Validate a Google Play product purchase via the Play Developer API.

    `purchase_token` is the Google purchase token (client sends it as `receipt`).
    """
    try:
        import requests
    except Exception:  # pragma: no cover
        return False, {"reason": "validation_unavailable", "detail": "requests missing"}
    if not purchase_token:
        return False, {"reason": "missing_purchase_token"}
    if expected_product_id and product_id != expected_product_id:
        return False, {"reason": "product_mismatch", "expected": expected_product_id, "got": product_id}
    token = _google_access_token(cfg)
    if not token:
        return False, {"reason": "validation_unavailable", "detail": "cannot mint Google token"}

    pkg = cfg["google_package_name"]
    url = f"{GOOGLE_ANDROIDPUBLISHER}/applications/{pkg}/purchases/products/{product_id}/tokens/{purchase_token}"
    try:
        r = requests.get(url, headers={"Authorization": f"Bearer {token}"}, timeout=10)
    except Exception as e:  # pragma: no cover
        return False, {"reason": "api_error", "detail": str(e)}
    if r.status_code in (401, 403):
        return False, {"reason": "auth_failed", "status": r.status_code}
    if r.status_code != 200:
        return False, {"reason": "purchase_not_found", "status": r.status_code}
    data = r.json()
    # purchaseState: 0 = purchased, 1 = canceled, 2 = pending
    if data.get("purchaseState", 0) != 0:
        return False, {"reason": "not_purchased", "purchaseState": data.get("purchaseState")}
    return True, {
        "mode": "google",
        "validated": True,
        "platform": "android",
        "product_id": product_id,
        "transaction_id": data.get("orderId") or transaction_id,
        "order_id": data.get("orderId"),
        "acknowledgementState": data.get("acknowledgementState"),
    }


# ── public entrypoint ────────────────────────────────────────────────────

def verify_receipt(
    platform: str,
    product_id: str,
    transaction_id: str,
    receipt: Optional[str] = None,
    expected_product_id: Optional[str] = None,
    config: Optional[dict] = None,
) -> Tuple[bool, dict]:
    """Validate a store purchase receipt. Returns (ok, info). Never raises.

    Runs REAL store validation when credentials for the platform are present in
    `config` (PlatformSetting category "iap"); otherwise falls back to the
    structural SCAFFOLD so the flow still works pre-PAPG.
    """
    platform = (platform or "").strip().lower()
    try:
        if platform not in VALID_PLATFORMS:
            return False, {"reason": "unknown_platform", "platform": platform}
        if platform_is_live(platform, config):
            if platform == "ios":
                return _verify_apple(product_id, transaction_id, receipt, expected_product_id, config)
            return _verify_google(product_id, transaction_id, receipt, expected_product_id, config)
        return _scaffold_verify(platform, product_id, transaction_id, expected_product_id)
    except Exception as e:  # pragma: no cover
        logger.warning("IAP verify error: %s", e)
        return False, {"reason": "verify_error", "detail": str(e)}


# ── refund / void handling ───────────────────────────────────────────────

def handle_refund(db, transaction_id: str) -> dict:
    """Mark the ServiceOrder for a refunded/voided store transaction as
    "refunded" (idempotent). Called by store server-to-server refund
    notifications. Does not touch the wallet ledger (IAP never used it)."""
    from app.models.model import ServiceOrder
    order = db.query(ServiceOrder).filter(
        ServiceOrder.iap_transaction_id == transaction_id
    ).first()
    if not order:
        return {"found": False, "transaction_id": transaction_id}
    if order.status != "refunded":
        order.status = "refunded"
        db.commit()
    return {"found": True, "order_id": order.id, "status": order.status}
