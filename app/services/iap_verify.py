"""
Store IAP receipt verification
==============================

International paid digital goods are sold through App Store / Google Play IAP
tiers (store policy — NOT the card wallet). After the client completes a store
purchase it POSTs the receipt to /service/iap/verify, which calls this module to
validate the receipt before granting a ServiceOrder.

⚠️  SCAFFOLD — real Apple / Google validation is the FINAL phase (PAPG, Phase D).
Until then `verify_receipt` runs in scaffold mode: it performs structural checks
(non-empty ids, product matches the service) and ACCEPTS the purchase so the end
-to-end flow runs, but it does NOT talk to Apple/Google. The scaffold is
gated behind IAP_SCAFFOLD_MODE so flipping to real validation is a one-line
change plus the Phase-D implementations below.

Phase D will implement:
  * Apple: App Store Server API / verifyReceipt — check bundle id, product id,
    environment (prod/sandbox), and that the transaction is not refunded.
  * Google: Google Play Developer API purchases.products.get — check
    purchaseState / acknowledgementState / order id.
  * refund & void handling; server-to-server notifications.
"""

import logging
from typing import Optional, Tuple

logger = logging.getLogger("iap_verify")

# When True, receipts are structurally checked + accepted without contacting the
# stores (pre-PAPG). Phase D sets this False and provides real validators.
IAP_SCAFFOLD_MODE = True

VALID_PLATFORMS = ("ios", "android")


def _scaffold_verify(platform: str, product_id: str, transaction_id: str,
                     expected_product_id: Optional[str]) -> Tuple[bool, dict]:
    """Structural-only acceptance used before the PAPG phase."""
    if platform not in VALID_PLATFORMS:
        return False, {"reason": "unknown_platform", "platform": platform}
    if not product_id or not transaction_id:
        return False, {"reason": "missing_ids"}
    # If the service has a configured store product id, the receipt must match it.
    if expected_product_id and product_id != expected_product_id:
        return False, {"reason": "product_mismatch",
                       "expected": expected_product_id, "got": product_id}
    return True, {
        "mode": "scaffold",
        "validated": False,     # NOT store-validated yet — Phase D flips this
        "platform": platform,
        "product_id": product_id,
        "transaction_id": transaction_id,
    }


def _verify_apple(product_id: str, transaction_id: str,
                  receipt: Optional[str], expected_product_id: Optional[str]) -> Tuple[bool, dict]:
    """PHASE D: validate an App Store receipt. Not implemented pre-PAPG."""
    raise NotImplementedError("Apple receipt validation lands in Phase D (PAPG)")


def _verify_google(product_id: str, transaction_id: str,
                   purchase_token: Optional[str], expected_product_id: Optional[str]) -> Tuple[bool, dict]:
    """PHASE D: validate a Google Play purchase. Not implemented pre-PAPG."""
    raise NotImplementedError("Google Play validation lands in Phase D (PAPG)")


def verify_receipt(
    platform: str,
    product_id: str,
    transaction_id: str,
    receipt: Optional[str] = None,
    expected_product_id: Optional[str] = None,
) -> Tuple[bool, dict]:
    """Validate a store purchase receipt.

    Returns (ok, info). In scaffold mode (pre-PAPG) this accepts structurally
    valid receipts without contacting the stores. Never raises — a failed
    validation returns (False, {...reason}).
    """
    platform = (platform or "").strip().lower()
    try:
        if IAP_SCAFFOLD_MODE:
            return _scaffold_verify(platform, product_id, transaction_id, expected_product_id)
        if platform == "ios":
            return _verify_apple(product_id, transaction_id, receipt, expected_product_id)
        if platform == "android":
            return _verify_google(product_id, transaction_id, receipt, expected_product_id)
        return False, {"reason": "unknown_platform", "platform": platform}
    except NotImplementedError as e:
        logger.warning("IAP real validation not available: %s", e)
        return False, {"reason": "validation_unavailable", "detail": str(e)}
    except Exception as e:  # pragma: no cover
        logger.warning("IAP verify error: %s", e)
        return False, {"reason": "verify_error", "detail": str(e)}
