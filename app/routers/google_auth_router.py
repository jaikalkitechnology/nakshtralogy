"""
Google OAuth Callback Router
=============================
Uses credentials stored in platform_settings (google_auth_user / google_auth_astro).

Flow:
  1. Frontend calls GET /google/login-url?role=user
     → backend builds Google OAuth URL with stored client_id + redirect_uri
     → returns { url }
  2. Frontend redirects browser to that URL
  3. User authorizes → Google redirects to callback_url?code=...&state=...
  4. Backend handles GET /google/callback:
     - exchanges code for access_token + id_token
     - gets user profile
     - creates or finds user in DB
     - issues app JWT + refresh token
     - redirects to frontend with ?token=<jwt>&refresh=<refresh>
"""

import base64
import json
import secrets as pysecrets
from datetime import datetime
from urllib.parse import urlencode
from typing import Optional

import httpx
from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import RedirectResponse
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import create_access_token, create_refresh_token
from app.core.i18n import get_lang, t
from app.models.model import User, Wallet, RefreshToken, PlatformSetting

router = APIRouter()

GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth"
GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo"
GOOGLE_TOKENINFO_URL = "https://oauth2.googleapis.com/tokeninfo"

# Default per-role frontend callbacks (overridable by ?return_to= or the
# platform_settings key `frontend_return_url`).
_DEFAULT_FRONTEND = {
    "user": "https://app.nakshatralogy.com/auth/callback",
    "astrologer": "https://astro.nakshatralogy.com/auth/callback",
}


def _encode_return_to(return_to: Optional[str]) -> str:
    """URL-safe base64 of a return_to URL for embedding in the OAuth state
    (state has no place for arbitrary query params otherwise)."""
    if not return_to:
        return ""
    return base64.urlsafe_b64encode(return_to.encode("utf-8")).decode("ascii")


def _decode_return_to(encoded: Optional[str]) -> Optional[str]:
    if not encoded:
        return None
    try:
        return base64.urlsafe_b64decode(encoded.encode("ascii")).decode("utf-8")
    except Exception:
        return None


def _resolve_frontend_url(role: str, return_to: Optional[str], cfg: dict) -> str:
    """return_to (client-supplied) → platform_settings.frontend_return_url →
    per-role default."""
    return return_to or cfg.get("frontend_return_url") or _DEFAULT_FRONTEND.get(role, _DEFAULT_FRONTEND["user"])


def _redirect_with_tokens(base_url: str, params: dict) -> RedirectResponse:
    """Append token params to base_url, respecting any existing query string."""
    sep = "&" if "?" in base_url else "?"
    return RedirectResponse(url=f"{base_url}{sep}{urlencode(params)}", status_code=302)


def _get_google_settings(db: Session, role: str, lang: str = "english") -> dict:
    """Load Google OAuth credentials for a role from platform_settings."""
    if role not in ("user", "astrologer"):
        raise HTTPException(status_code=400, detail=t("err.invalid_role", lang))
    category = f"google_auth_{'astro' if role == 'astrologer' else 'user'}"
    rows = db.query(PlatformSetting).filter(PlatformSetting.category == category).all()
    config = {r.key: r.value for r in rows}
    if not config.get("client_id") or not config.get("client_secret"):
        raise HTTPException(
            status_code=500,
            detail=t("err.google_oauth_not_configured", lang, role=role, category=category),
        )
    return config


@router.get("/login-url")
def get_google_login_url(
    role: str = Query("user", description="user | astrologer"),
    return_to: Optional[str] = Query(
        None, description="Frontend URL to redirect back to after callback (overrides defaults)."
    ),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Build the Google OAuth consent URL for the given role.

    An optional ``return_to`` is carried through the OAuth ``state`` so the
    callback knows where to hand the tokens back to (web/mobile can specify
    their own callback route).
    """
    cfg = _get_google_settings(db, role, lang)
    redirect_uri = cfg.get("redirect_uri") or "https://api.nakshatralogy.com/api/v1/google/callback"
    # state = "role:random[:b64(return_to)]"
    state = f"{role}:{pysecrets.token_urlsafe(16)}"
    encoded_return = _encode_return_to(return_to)
    if encoded_return:
        state = f"{state}:{encoded_return}"

    params = {
        "client_id": cfg["client_id"],
        "redirect_uri": redirect_uri,
        "response_type": "code",
        "scope": "openid email profile",
        "access_type": "offline",
        "prompt": "consent",
        "state": state,
    }
    return {"url": f"{GOOGLE_AUTH_URL}?{urlencode(params)}", "state": state}


def _issue_app_tokens(user: User, db: Session):
    access = create_access_token(user.id, user.role)
    raw_refresh, token_hash, expires_at = create_refresh_token(user.id)
    db.add(RefreshToken(user_id=user.id, token_hash=token_hash, expires_at=expires_at))
    user.last_login_at = datetime.utcnow()
    db.commit()
    return access, raw_refresh


@router.get("/callback")
async def google_callback(
    code: Optional[str] = None,
    state: Optional[str] = None,
    error: Optional[str] = None,
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """
    Handle the OAuth redirect from Google, exchange code for tokens,
    find/create user, issue app JWT, and redirect to frontend.
    """
    if error:
        return RedirectResponse(
            url=f"https://nakshatralogy.com/auth?google_error={error}",
            status_code=302,
        )
    if not code:
        raise HTTPException(status_code=400, detail=t("err.missing_auth_code", lang))

    # state format "role:random[:b64(return_to)]"
    role = "user"
    return_to = None
    if state and ":" in state:
        parts = state.split(":", 2)
        if parts[0] in ("user", "astrologer"):
            role = parts[0]
        if len(parts) == 3:
            return_to = _decode_return_to(parts[2])

    cfg = _get_google_settings(db, role, lang)
    redirect_uri = cfg.get("redirect_uri") or "https://api.nakshatralogy.com/api/v1/google/callback"

    # Exchange code for access_token
    async with httpx.AsyncClient(timeout=20) as client:
        token_resp = await client.post(
            GOOGLE_TOKEN_URL,
            data={
                "code": code,
                "client_id": cfg["client_id"],
                "client_secret": cfg["client_secret"],
                "redirect_uri": redirect_uri,
                "grant_type": "authorization_code",
            },
        )
        if token_resp.status_code != 200:
            raise HTTPException(
                status_code=400,
                detail=t("err.google_token_exchange_failed", lang, detail=token_resp.text),
            )
        token_data = token_resp.json()
        access_token = token_data.get("access_token")
        if not access_token:
            raise HTTPException(status_code=400, detail=t("err.no_google_access_token", lang))

        # Get user profile
        profile_resp = await client.get(
            GOOGLE_USERINFO_URL,
            headers={"Authorization": f"Bearer {access_token}"},
        )
        if profile_resp.status_code != 200:
            raise HTTPException(
                status_code=400,
                detail=t("err.google_userinfo_failed", lang, detail=profile_resp.text),
            )
        profile = profile_resp.json()

    google_id = profile.get("sub")
    email = profile.get("email")
    if not email or not google_id:
        raise HTTPException(status_code=400, detail=t("err.google_profile_incomplete", lang))

    # Find or create user
    is_new_user = False
    user = db.query(User).filter(User.google_id == google_id).first()
    if not user:
        user = db.query(User).filter(User.email == email).first()

    if user:
        if user.role != role and role != "user":
            return RedirectResponse(
                url=f"https://nakshatralogy.com/auth?google_error=role_mismatch",
                status_code=302,
            )
        if not user.google_id:
            user.google_id = google_id
        if not user.avatar_url and profile.get("picture"):
            user.avatar_url = profile.get("picture")
        if not user.name and profile.get("name"):
            user.name = profile.get("name")
        db.commit()
    else:
        is_new_user = True
        user = User(
            email=email,
            name=profile.get("name", ""),
            avatar_url=profile.get("picture"),
            google_id=google_id,
            is_verified=True,
            role=role,
        )
        db.add(user)
        db.flush()
        db.add(Wallet(user_id=user.id))
        db.commit()
        db.refresh(user)

    if not user.is_active:
        return RedirectResponse(
            url=f"https://nakshatralogy.com/auth?google_error=account_deactivated",
            status_code=302,
        )

    jwt_token, refresh_token = _issue_app_tokens(user, db)

    # Redirect to the role's frontend callback with tokens. The frontend reads
    # them from the URL, stores them, and strips them from the address bar.
    # Resolution order: return_to (from state) → platform_settings
    # frontend_return_url → per-role default.
    frontend_url = _resolve_frontend_url(user.role, return_to, cfg)
    return _redirect_with_tokens(frontend_url, {
        "token": jwt_token,
        "refresh": refresh_token,
        "role": user.role,
        "is_new_user": str(is_new_user).lower(),
        "user_id": user.id,
        "name": user.name or "",
        "email": user.email,
    })


# ── Native id_token verification (mobile google_sign_in) ───────────────

class GoogleVerifyRequest(BaseModel):
    id_token: str
    role: str = "user"


def _acceptable_audiences(cfg: dict) -> set:
    """Client IDs the native id_token audience may match. web/android/ios
    client ids for the native SDK, falling back to the web-flow client_id."""
    keys = ("web_client_id", "android_client_id", "ios_client_id", "client_id")
    return {cfg[k] for k in keys if cfg.get(k)}


@router.post("/verify")
async def google_verify(
    req: GoogleVerifyRequest,
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang),
):
    """Verify a Google ``id_token`` obtained by a native google_sign_in sheet,
    check its audience against the stored client id(s), find/create the user,
    and issue app JWT + refresh tokens. Same source of truth as /callback."""
    role = req.role if req.role in ("user", "astrologer") else "user"
    category = f"google_auth_{'astro' if role == 'astrologer' else 'user'}"
    rows = db.query(PlatformSetting).filter(PlatformSetting.category == category).all()
    cfg = {r.key: r.value for r in rows}

    audiences = _acceptable_audiences(cfg)
    if not audiences:
        raise HTTPException(
            status_code=500,
            detail=t("err.google_oauth_not_configured", lang, role=role, category=category),
        )

    # Verify token with Google and read its claims.
    async with httpx.AsyncClient(timeout=20) as client:
        resp = await client.get(GOOGLE_TOKENINFO_URL, params={"id_token": req.id_token})
    if resp.status_code != 200:
        raise HTTPException(status_code=401, detail=t("err.invalid_google_token", lang))
    info = resp.json()

    if info.get("aud") not in audiences:
        raise HTTPException(status_code=401, detail=t("err.google_audience_mismatch", lang))

    email = info.get("email")
    google_id = info.get("sub")
    if not email or not google_id:
        raise HTTPException(status_code=400, detail=t("err.google_profile_incomplete", lang))

    # Find or create user (mirrors /callback).
    is_new_user = False
    user = db.query(User).filter(User.google_id == google_id).first()
    if not user:
        user = db.query(User).filter(User.email == email).first()

    if user:
        if user.role != role and role != "user":
            raise HTTPException(status_code=403, detail=t("err.google_role_mismatch", lang))
        if not user.google_id:
            user.google_id = google_id
        if not user.avatar_url and info.get("picture"):
            user.avatar_url = info.get("picture")
        if not user.name and info.get("name"):
            user.name = info.get("name")
        db.commit()
    else:
        is_new_user = True
        user = User(
            email=email,
            name=info.get("name", ""),
            avatar_url=info.get("picture"),
            google_id=google_id,
            is_verified=True,
            role=role,
        )
        db.add(user)
        db.flush()
        db.add(Wallet(user_id=user.id))
        db.commit()
        db.refresh(user)

    if not user.is_active:
        raise HTTPException(status_code=403, detail=t("err.account_deactivated", lang))

    jwt_token, refresh_token = _issue_app_tokens(user, db)
    return {"token": jwt_token, "refresh": refresh_token, "is_new_user": is_new_user}
