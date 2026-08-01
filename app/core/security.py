"""JWT tokens, password hashing, Google ID token verification."""

import hashlib
import secrets
import uuid
from datetime import datetime, timedelta
from typing import Optional

from jose import JWTError, jwt
from passlib.context import CryptContext

from app.core.config import settings

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# ── Password ──────────────────────────────────────────────────────────

def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)


# ── JWT ───────────────────────────────────────────────────────────────

def create_access_token(user_id: str, role: str) -> str:
    expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    payload = {
        "sub": user_id,
        "role": role,
        "exp": expire,
        "type": "access",
    }
    return jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.JWT_ALGORITHM)


def create_refresh_token(user_id: str) -> tuple[str, str, datetime]:
    """Returns (raw_token, token_hash, expires_at)."""
    raw = secrets.token_urlsafe(64)
    token_hash = hashlib.sha256(raw.encode()).hexdigest()
    expires_at = datetime.utcnow() + timedelta(days=settings.REFRESH_TOKEN_EXPIRE_DAYS)
    return raw, token_hash, expires_at


def decode_access_token(token: str) -> Optional[dict]:
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])
        if payload.get("type") != "access":
            return None
        return payload
    except JWTError:
        return None


def hash_token(raw_token: str) -> str:
    return hashlib.sha256(raw_token.encode()).hexdigest()


# ── Developer API Platform — API keys (developerApiPlatform/) ────────
# Shared by app/routers/developer_router.py (create/rotate), the gateway
# auth dependency, and app/seeds/seed_data.py (deterministic test key).

def generate_api_key(mode: str = "live") -> tuple[str, str, str]:
    """Generate a new API key. Returns (raw_secret, key_prefix, secret_hash).

    Only `key_prefix` + `secret_hash` (sha256) are ever persisted — the raw
    secret is returned to the caller exactly once.
    """
    suffix = secrets.token_hex(24)
    raw = f"sk_{mode}_{suffix}"
    key_prefix = raw[:16]
    secret_hash = hash_api_key_secret(raw)
    return raw, key_prefix, secret_hash


def hash_api_key_secret(raw_secret: str) -> str:
    return hashlib.sha256(raw_secret.encode()).hexdigest()


# ── OTP ───────────────────────────────────────────────────────────────

def generate_otp() -> str:
    return f"{secrets.randbelow(1000000):06d}"


def generate_reset_token() -> str:
    return secrets.token_urlsafe(48)


# ── Google ────────────────────────────────────────────────────────────

def verify_google_token(id_token: str) -> Optional[dict]:
    """
    Verify a Google ID token. Returns user info dict or None.
    In production, use google-auth library:
        from google.oauth2 import id_token as google_id_token
        from google.auth.transport import requests
        info = google_id_token.verify_oauth2_token(id_token, requests.Request(), CLIENT_ID)
    For now, we decode the JWT payload without full verification (dev mode).
    """
    try:
        # Production: use google.oauth2.id_token.verify_oauth2_token
        payload = jwt.decode(id_token, options={"verify_signature": False})
        return {
            "google_id": payload.get("sub"),
            "email": payload.get("email"),
            "name": payload.get("name"),
            "avatar_url": payload.get("picture"),
            "email_verified": payload.get("email_verified", False),
        }
    except Exception:
        return None
