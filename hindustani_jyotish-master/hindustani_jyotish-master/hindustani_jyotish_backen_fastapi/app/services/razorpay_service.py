"""Razorpay order creation + payment signature verification.

Signature checks are implemented directly (HMAC-SHA256) so no SDK or network
call is needed to verify a payment. Order creation hits the Razorpay API when
keys are configured; otherwise a simulated order is returned for local dev.

Credentials are resolved at call time in this order:
  1. the active `razorpay_settings` row (set from the admin console),
  2. the RAZORPAY_* environment settings.
Callers that have a DB session should pass a resolved ``RazorpayCreds`` (via
:func:`resolve_credentials`); callers without one fall back to env settings so
the behaviour is unchanged.
"""
from __future__ import annotations

import hashlib
import hmac
import uuid
from dataclasses import dataclass
from decimal import Decimal

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings


class RazorpayError(Exception):
    """Raised on order-creation / verification failures."""


@dataclass
class RazorpayOrder:
    order_id: str
    amount_paise: int
    currency: str
    key_id: str


@dataclass
class RazorpayCreds:
    key_id: str
    key_secret: str
    webhook_secret: str


def _env_creds() -> RazorpayCreds:
    return RazorpayCreds(
        key_id=settings.RAZORPAY_KEY_ID,
        key_secret=settings.RAZORPAY_KEY_SECRET,
        webhook_secret=settings.RAZORPAY_WEBHOOK_SECRET,
    )


async def resolve_credentials(db: AsyncSession) -> RazorpayCreds:
    """Resolve Razorpay creds: active `razorpay_settings` row → env settings.

    A configured row wins for key_id/key_secret; its ``webhook_secret`` is used
    when set, otherwise the env webhook secret is retained.
    """
    from sqlalchemy import select

    from app.models.admin_content import RazorpaySetting

    active = await db.scalar(
        select(RazorpaySetting).where(RazorpaySetting.is_active.is_(True))
    )
    if active and active.key_id and active.key_secret:
        return RazorpayCreds(
            key_id=active.key_id.strip(),
            key_secret=active.key_secret.strip(),
            webhook_secret=(active.webhook_secret or "").strip()
            or settings.RAZORPAY_WEBHOOK_SECRET,
        )
    return _env_creds()


def _to_paise(amount: Decimal) -> int:
    return int((Decimal(str(amount)) * 100).to_integral_value())


async def create_order(
    amount: Decimal,
    *,
    receipt: str,
    notes: dict | None = None,
    creds: RazorpayCreds | None = None,
) -> RazorpayOrder:
    creds = creds or _env_creds()
    paise = _to_paise(amount)

    configured = bool(creds.key_id and creds.key_secret)
    if not configured:
        if settings.PAYMENTS_DEV_MODE:
            return RazorpayOrder(
                order_id=f"order_dev_{uuid.uuid4().hex[:16]}",
                amount_paise=paise,
                currency="INR",
                key_id=creds.key_id or "rzp_test_dev",
            )
        # Outside dev mode an unconfigured gateway must be a CLEAR error the
        # apps can show verbatim — not a silently-minted fake dev order that
        # lets a "payment" appear to succeed with no money ever moving.
        raise RazorpayError(
            "Payments are not configured yet — add the Razorpay Key ID and "
            "Key Secret in the admin console (Settings → Razorpay) and mark "
            "them active."
        )

    # Configured credentials ALWAYS take the real Razorpay path. Activating a
    # credential row in the admin console is the explicit "go live" signal —
    # PAYMENTS_DEV_MODE (a developer-convenience default that's True unless
    # the env overrides it) must never silently keep faking payments once
    # real keys are configured, or "payments" succeed with no money moving.
    import httpx

    body: dict = {"amount": paise, "currency": "INR", "receipt": receipt}
    if notes:
        body["notes"] = notes
    auth = (creds.key_id, creds.key_secret)
    try:
        async with httpx.AsyncClient(timeout=15) as client:
            resp = await client.post(
                "https://api.razorpay.com/v1/orders",
                auth=auth,
                json=body,
            )
    except httpx.HTTPError as exc:
        raise RazorpayError(f"Could not reach Razorpay: {exc}")
    if resp.status_code >= 300:
        raise RazorpayError(f"Razorpay order failed: {resp.text}")
    data = resp.json()
    return RazorpayOrder(
        order_id=data["id"], amount_paise=paise, currency="INR",
        key_id=creds.key_id,
    )


async def diagnose_credentials(creds: RazorpayCreds) -> dict:
    """Attempt a tiny (INR 1, smallest order Razorpay accepts) test order to
    confirm a key id/secret pair is genuinely valid and Razorpay is reachable.

    Always makes a real API call (ignores `PAYMENTS_DEV_MODE`) — the whole
    point is to verify the credentials themselves work, not to exercise the
    dev-mode short-circuit used by real recharges. Creating an order never
    moves money; nothing is captured/charged. Never raises — every failure
    mode is reported back as a dict so the admin endpoint can render a plain
    diagnosis.
    """
    import httpx

    receipt = f"diag_{uuid.uuid4().hex[:16]}"
    body = {
        "amount": 100,  # INR 1.00, Razorpay's minimum order amount
        "currency": "INR",
        "receipt": receipt,
        "notes": {"purpose": "hindustani_jyotish credential diagnostic — not a real charge"},
    }
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.post(
                "https://api.razorpay.com/v1/orders",
                auth=(creds.key_id, creds.key_secret),
                json=body,
            )
    except httpx.HTTPError as exc:
        return {"ok": False, "reason": "network", "detail": str(exc)}

    if resp.status_code == 200:
        data = resp.json()
        return {"ok": True, "reason": "ok", "detail": "Test order created successfully.", "order_id": data.get("id")}
    if resp.status_code in (401, 403):
        return {"ok": False, "reason": "auth", "detail": resp.text[:300]}
    return {"ok": False, "reason": "api_error", "detail": f"HTTP {resp.status_code}: {resp.text[:300]}"}


def expected_signature(order_id: str, payment_id: str, secret: str) -> str:
    msg = f"{order_id}|{payment_id}".encode()
    return hmac.new(secret.encode(), msg, hashlib.sha256).hexdigest()


def dev_signature(order_id: str, payment_id: str) -> str:
    """Deterministic signature for local dev (no real key secret)."""
    return expected_signature(order_id, payment_id, "dev-secret")


def verify_payment_signature(
    order_id: str,
    payment_id: str,
    signature: str,
    creds: RazorpayCreds | None = None,
) -> bool:
    secret = creds.key_secret if creds else settings.RAZORPAY_KEY_SECRET
    # Mirrors create_order's precedence: a configured secret ALWAYS verifies
    # for real (orders were real, so signatures must be too); the dev-mode
    # signature is only accepted while no secret is configured at all.
    if secret:
        return hmac.compare_digest(
            signature, expected_signature(order_id, payment_id, secret)
        )
    if settings.PAYMENTS_DEV_MODE:
        return hmac.compare_digest(signature, dev_signature(order_id, payment_id))
    return False


def verify_webhook_signature(
    body: bytes, signature: str, creds: RazorpayCreds | None = None
) -> bool:
    secret = creds.webhook_secret if creds else settings.RAZORPAY_WEBHOOK_SECRET
    if not secret:
        return settings.PAYMENTS_DEV_MODE
    expected = hmac.new(secret.encode(), body, hashlib.sha256).hexdigest()
    return hmac.compare_digest(signature, expected)
