"""Shared test helpers — seed principals and mint tokens directly."""
from __future__ import annotations

from decimal import Decimal

from app.core.database import AsyncSessionLocal
from app.core.security import create_access_token
from app.models.astrologer import Astrologer, KYCStatus


def user_headers(user_id) -> dict:
    return {"Authorization": f"Bearer {create_access_token(str(user_id), role='user')}"}


def astro_headers(astro_id) -> dict:
    return {"Authorization": f"Bearer {create_access_token(str(astro_id), role='astrologer')}"}


async def seed_astrologer(
    *,
    display_name="Pandit Test",
    rate_call=Decimal("20.00"),
    rate_video=Decimal("25.00"),
    rate_chat=Decimal("7.00"),
    kyc=KYCStatus.approved,
    is_online=True,
):
    async with AsyncSessionLocal() as db:
        astro = Astrologer(
            display_name=display_name,
            kyc_status=kyc,
            is_online=is_online,
            languages=["hi", "en"],
            skills=["vedic"],
            rate_call_per_min=rate_call,
            rate_video_per_min=rate_video,
            rate_chat_per_msg=rate_chat,
        )
        db.add(astro)
        await db.commit()
        await db.refresh(astro)
        return astro.id


async def set_wallet(user_id, amount: Decimal):
    from app.models.user import User

    async with AsyncSessionLocal() as db:
        user = await db.get(User, user_id)
        user.wallet_balance = amount
        await db.commit()


async def register_user(client, mobile="+919800000001") -> str:
    """OTP-login a user and return their id (and set headers via token)."""
    r = await client.post("/v1/auth/otp/request", json={"mobile": mobile})
    otp = r.json()["dev_otp"]
    r = await client.post("/v1/auth/otp/verify", json={"mobile": mobile, "otp": otp})
    return r.json()["user"]["id"]


async def register_astrologer(client, mobile="+919700000001") -> tuple[str, dict]:
    """OTP-login an astrologer; return (id, auth headers)."""
    r = await client.post("/v1/auth/astrologer/otp/request", json={"mobile": mobile})
    otp = r.json()["dev_otp"]
    r = await client.post(
        "/v1/auth/astrologer/otp/verify", json={"mobile": mobile, "otp": otp}
    )
    aid = r.json()["astrologer"]["id"]
    return aid, astro_headers(aid)


async def seed_admin(email="admin@hj.example.com", password="secret123") -> dict:
    """Create an admin directly and return login headers."""
    from app.core.security import create_access_token, hash_secret
    from app.models.admin import Admin

    async with AsyncSessionLocal() as db:
        admin = Admin(email=email, name="Admin", password_hash=hash_secret(password))
        db.add(admin)
        await db.commit()
        await db.refresh(admin)
        return {"Authorization": f"Bearer {create_access_token(str(admin.id), role='admin')}"}


# A fully valid KYC submission under the mandatory rules of
# blue_print/signup_login.md §§4–5: PAN + Aadhaar numbers, all three document
# photos (PAN, Aadhaar front AND back), and a complete bank payout block
# (method, bank name, holder, account, IFSC, typed proof document).
KYC_PAYLOAD = {
    "full_name": "Pandit Ramesh Sharma",
    "dob": "1980-03-15",
    "address": "Varanasi, UP",
    "id_type": "aadhaar",
    "skills": ["vedic", "palmistry"],
    "languages": ["hi", "en"],
    "years_experience": 12,
    "rate_chat_per_msg": "7.00",
    "rate_call_per_min": "20.00",
    "rate_video_per_min": "25.00",
    "bio": "Vedic astrologer with 12 years of experience.",
    "pan_number": "ABCDE1234F",
    "aadhaar_number": "123456789012",
    "pan_doc_key": "kyc/shared/pan.png",
    "aadhaar_doc_key": "kyc/shared/aadhaar-front.png",
    "aadhaar_back_doc_key": "kyc/shared/aadhaar-back.png",
    "payout_method": "bank",
    "bank_name": "HDFC Bank",
    "bank_account_holder": "Ramesh Sharma",
    "bank_account_number": "00112233445566",
    "bank_ifsc": "hdfc0001234",
    "bank_proof_key": "kyc/shared/bank-proof.png",
    "bank_proof_type": "passbook",
}
