"""API-key authentication for the metered gateway (developerApiPlatform/).

Used by app/routers/gateway_router.py (`/api/v2/...`, Phase 4). Parses the
`Authorization: Bearer sk_live_...` / `sk_test_...` header, looks the key up
by its indexed `key_prefix`, verifies the sha256 hash, loads the developer +
their active subscription, and updates `last_used_at`.

Kept separate from app/core/dependencies.py (the consumer-app JWT auth)
since gateway callers authenticate with an API key, not a user session.
"""

import hmac
from datetime import datetime
from typing import Optional

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import hash_api_key_secret
from app.models.model import ApiKey, User, DeveloperProfile, DeveloperSubscription, SubscriptionPlan

bearer_scheme = HTTPBearer(
    scheme_name="ApiKeyAuth",
    description="Developer API key — `Authorization: Bearer sk_live_...` or `sk_test_...`",
)

# Phase 8 retax: `specialist` + `milan` both fold into the new `reports`
# category (Kundli Milan is now one of the 19 reports); `kundli`/`forecast`
# are unchanged. `rashi` is brand-new (no legacy alias).
_LEGACY_SCOPE_ALIASES = {"specialist": "reports", "milan": "reports"}
_LEGACY_FULL_SCOPES = {"kundli", "specialist", "milan", "forecast"}


class GatewayAuthContext:
    """Bundles everything a gateway endpoint needs after authentication."""

    def __init__(self, developer: User, api_key: ApiKey, subscription: DeveloperSubscription,
                 plan: Optional[SubscriptionPlan]):
        self.developer = developer
        self.api_key = api_key
        self.subscription = subscription
        self.plan = plan

    @property
    def tps_limit(self) -> int:
        return self.plan.tps_limit if self.plan else 1

    def has_scope(self, product: str) -> bool:
        """`product` is always one of the current 4 categories
        (`kundli`/`reports`/`rashi`/`forecast` — Phase 8 retax). Keys created
        before the retax hold the legacy 4-item scope list
        (`kundli`/`specialist`/`milan`/`forecast`); since there is only ever
        one All-Access plan covering every product that exists, a key that
        already had every legacy product is treated as having every current
        category too — including the brand-new `rashi` category — so old
        keys never need re-issuing."""
        scopes = self.api_key.scopes or []
        if _LEGACY_FULL_SCOPES.issubset(set(scopes)):
            return True
        normalized = {_LEGACY_SCOPE_ALIASES.get(s, s) for s in scopes}
        return product in normalized


def get_developer_from_api_key(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> GatewayAuthContext:
    raw = (credentials.credentials or "").strip()
    if not raw.startswith("sk_"):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid API key format")

    prefix = raw[:16]
    secret_hash = hash_api_key_secret(raw)

    candidates = db.query(ApiKey).filter(ApiKey.key_prefix == prefix, ApiKey.status == "active").all()
    key_row = None
    for c in candidates:
        if hmac.compare_digest(c.secret_hash, secret_hash):
            key_row = c
            break
    if key_row is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or revoked API key")

    developer = db.query(User).filter(User.id == key_row.developer_user_id, User.role == "developer").first()
    if not developer or not developer.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Developer account not found or inactive")

    profile = db.query(DeveloperProfile).filter(DeveloperProfile.user_id == developer.id).first()
    if profile and profile.status in ("suspended", "blocked"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=f"Developer account {profile.status}")

    subscription = (
        db.query(DeveloperSubscription)
        .filter(DeveloperSubscription.developer_user_id == developer.id, DeveloperSubscription.status == "active")
        .order_by(DeveloperSubscription.expires_at.desc())
        .first()
    )
    if subscription and subscription.expires_at < datetime.utcnow():
        subscription.status = "expired"
        db.commit()
        subscription = None

    if not subscription:
        raise HTTPException(
            status_code=status.HTTP_402_PAYMENT_REQUIRED,
            detail="No active All-Access subscription. Subscribe via POST /api/v1/developer/subscribe.",
        )

    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()

    key_row.last_used_at = datetime.utcnow()
    db.commit()

    return GatewayAuthContext(developer=developer, api_key=key_row, subscription=subscription, plan=plan)


def require_scope(ctx: GatewayAuthContext, product: str) -> None:
    """Raise 403 if the API key isn't scoped for `product`."""
    if not ctx.has_scope(product):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"API key is not scoped for product '{product}'",
        )
