"""Seed a WebSocket test fixture and print ready-to-use credentials.

Run this ON THE SERVER (or anywhere with the app's DATABASE_URL + JWT_SECRET),
so the tokens are signed with the same secret the API verifies against and the
user/astrologer rows actually exist for the socket's membership check.

    cd hindustani_jyotish_backen_fastapi
    .venv/bin/python -m scripts.seed_ws_test
    # or:  .venv/bin/python scripts/seed_ws_test.py
    # quiet output:  DEBUG=false .venv/bin/python -m scripts.seed_ws_test

It creates a private test fixture just for the WebSocket tester:
  • a test customer (with wallet balance so chat messages can be billed),
  • a test astrologer that is DELIBERATELY NOT public — KYC=rejected + offline,
    so it never appears in the customer app's astrologer list nor in the admin
    pending-KYC queue (the socket only checks consultation membership, not KYC),
  • an in-progress CHAT consultation linking them,
and prints both access tokens, the consultation id, and the full wss:// URLs
for lib/ws_test.html.

Rows are tagged with a marker so they can be removed later:
    .venv/bin/python -m scripts.seed_ws_test --cleanup

Tokens are minted long-lived (24h by default, --hours to change) so the socket
doesn't drop mid-test. Re-run any time for a fresh set.
"""
from __future__ import annotations

import argparse
import asyncio
import os
import sys
import uuid
from datetime import datetime, timedelta, timezone
from decimal import Decimal

# Allow running as a plain script (python scripts/seed_ws_test.py).
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import jwt  # noqa: E402
from sqlalchemy import delete, select  # noqa: E402

from app.core.config import settings  # noqa: E402
from app.core.database import AsyncSessionLocal  # noqa: E402
from app.core.security import ACCESS  # noqa: E402
from app.models.astrologer import Astrologer, KYCStatus  # noqa: E402
from app.models.consultation import (  # noqa: E402
    Consultation,
    ConsultationStatus,
    ConsultationType,
)
from app.models.message import ConsultationMessage  # noqa: E402
from app.models.user import User  # noqa: E402

# Marker that tags every row this script creates, so --cleanup can find them
# and so they are easy to spot if they ever surface anywhere.
MARKER = "[WSTEST]"


def mint_token(subject: str, role: str, hours: int) -> str:
    now = datetime.now(timezone.utc)
    payload = {
        "sub": subject,
        "role": role,
        "type": ACCESS,
        "iat": int(now.timestamp()),
        "exp": int((now + timedelta(hours=hours)).timestamp()),
    }
    return jwt.encode(payload, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)


async def cleanup() -> None:
    """Delete every fixture this script has created (matched by MARKER)."""
    async with AsyncSessionLocal() as db:
        user_ids = list(await db.scalars(select(User.id).where(User.name.like(f"{MARKER}%"))))
        astro_ids = list(
            await db.scalars(select(Astrologer.id).where(Astrologer.display_name.like(f"{MARKER}%")))
        )
        consult_ids = []
        if user_ids or astro_ids:
            consult_ids = list(
                await db.scalars(
                    select(Consultation.id).where(
                        Consultation.user_id.in_(user_ids or [None])
                        | Consultation.astrologer_id.in_(astro_ids or [None])
                    )
                )
            )
        if consult_ids:
            await db.execute(
                delete(ConsultationMessage).where(
                    ConsultationMessage.consultation_id.in_(consult_ids)
                )
            )
            await db.execute(delete(Consultation).where(Consultation.id.in_(consult_ids)))
        if astro_ids:
            await db.execute(delete(Astrologer).where(Astrologer.id.in_(astro_ids)))
        if user_ids:
            await db.execute(delete(User).where(User.id.in_(user_ids)))
        await db.commit()
    print(
        f"Cleanup done — removed {len(user_ids)} test user(s), "
        f"{len(astro_ids)} test astrologer(s), {len(consult_ids)} consultation(s)."
    )


async def seed(hours: int, ws_host: str) -> None:
    suffix = uuid.uuid4().hex[:8]
    async with AsyncSessionLocal() as db:
        user = User(
            mobile=f"+9199{uuid.uuid4().int % 100000000:08d}",
            name=f"{MARKER} User {suffix}",
            language="en",
            wallet_balance=Decimal("1000.00"),
            is_active=True,
        )
        # NOT public: rejected KYC + offline → excluded from /v1/astrologers
        # (which lists approved only) and from the admin pending-KYC queue
        # (which counts pending only). The socket's membership check does not
        # depend on KYC/online, so the WS test still works.
        astro = Astrologer(
            display_name=f"{MARKER} Astrologer {suffix}",
            kyc_status=KYCStatus.rejected,
            is_online=False,
            is_live=False,
            skills=["vedic"],
            languages=["hi", "en"],
            years_experience=5,
            rate_chat_per_msg=Decimal("5.00"),
            rate_call_per_min=Decimal("20.00"),
            rate_video_per_min=Decimal("25.00"),
        )
        db.add_all([user, astro])
        await db.flush()

        consult = Consultation(
            user_id=user.id,
            astrologer_id=astro.id,
            type=ConsultationType.chat,
            status=ConsultationStatus.in_progress,  # so messages can be sent
            rate=Decimal("5.00"),
            agora_channel=f"consult_{uuid.uuid4().hex}",
            started_at=datetime.now(timezone.utc),
        )
        db.add(consult)
        await db.commit()

        user_id, astro_id, consult_id = str(user.id), str(astro.id), str(consult.id)

    user_token = mint_token(user_id, "user", hours)
    astro_token = mint_token(astro_id, "astrologer", hours)

    host = ws_host.rstrip("/")
    base = f"{host}/v1/consultations/{consult_id}/ws"

    bar = "=" * 72
    print(f"\n{bar}\n  WebSocket test fixture ready  (tokens valid ~{hours}h)\n{bar}")
    print("\nThis fixture is PRIVATE to the WS tester — the test astrologer is")
    print("KYC=rejected + offline, so it does NOT show in the customer app list.")
    print(f"\nconsultation_id : {consult_id}")
    print("status          : in_progress (chat)  — messages can be sent")
    print(f"\nuser_id         : {user_id}")
    print(f"USER access token:\n{user_token}")
    print(f"\nastrologer_id   : {astro_id}")
    print(f"ASTRO access token:\n{astro_token}")
    print(f"\n{bar}\n  Paste into hindustani_user/lib/ws_test.html, or connect directly:\n{bar}")
    print(f"\n# as the customer:\n{base}?token={user_token}")
    print(f"\n# as the astrologer (watch the same room / receive sends):\n{base}?token={astro_token}")
    print(
        "\nTip: connect both in two tabs — a {\"body\":\"hi\"} from one appears as a\n"
        "'message' frame in the other. Re-run for a fresh set; --cleanup to remove\n"
        "all WS test rows when you're done.\n"
    )


def main() -> None:
    ap = argparse.ArgumentParser(description="Seed a consultation + tokens for WS testing")
    ap.add_argument("--hours", type=int, default=24, help="token lifetime in hours (default 24)")
    ap.add_argument(
        "--host",
        default="wss://fastapi.hindustanijyotish.com",
        help="WebSocket host (scheme + host, no path)",
    )
    ap.add_argument(
        "--cleanup",
        action="store_true",
        help="delete all WS test rows this script created, then exit",
    )
    args = ap.parse_args()
    if args.cleanup:
        asyncio.run(cleanup())
    else:
        asyncio.run(seed(args.hours, args.host))


if __name__ == "__main__":
    main()
