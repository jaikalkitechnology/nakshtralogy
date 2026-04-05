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

import json
import secrets as pysecrets
from datetime import datetime
from urllib.parse import urlencode
from typing import Optional

import httpx
from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import create_access_token, create_refresh_token
from app.models.model import User, Wallet, RefreshToken, PlatformSetting

router = APIRouter()

GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth"
GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token"
GOOGLE_USERINFO_URL = "https://www.googleapis.com/oauth2/v3/userinfo"


def _get_google_settings(db: Session, role: str) -> dict:
    """Load Google OAuth credentials for a role from platform_settings."""
    if role not in ("user", "astrologer"):
        raise HTTPException(status_code=400, detail="role must be 'user' or 'astrologer'")
    category = f"google_auth_{'astro' if role == 'astrologer' else 'user'}"
    rows = db.query(PlatformSetting).filter(PlatformSetting.category == category).all()
    config = {r.key: r.value for r in rows}
    if not config.get("client_id") or not config.get("client_secret"):
        raise HTTPException(
            status_code=500,
            detail=f"Google OAuth not configured for {role}. "
                   f"Set client_id and client_secret in admin settings → {category}.",
        )
    return config


@router.get("/login-url")
def get_google_login_url(
    role: str = Query("user", description="user | astrologer"),
    db: Session = Depends(get_db),
):
    """Build the Google OAuth consent URL for the given role."""
    cfg = _get_google_settings(db, role)
    redirect_uri = cfg.get("redirect_uri") or "https://api.nakshatralogy.com/api/v1/google/callback"
    state = f"{role}:{pysecrets.token_urlsafe(16)}"

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
        raise HTTPException(status_code=400, detail="Missing authorization code")

    # state format "role:random"
    role = "user"
    if state and ":" in state:
        role_part = state.split(":", 1)[0]
        if role_part in ("user", "astrologer"):
            role = role_part

    cfg = _get_google_settings(db, role)
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
                detail=f"Google token exchange failed: {token_resp.text}",
            )
        token_data = token_resp.json()
        access_token = token_data.get("access_token")
        if not access_token:
            raise HTTPException(status_code=400, detail="No access_token in Google response")

        # Get user profile
        profile_resp = await client.get(
            GOOGLE_USERINFO_URL,
            headers={"Authorization": f"Bearer {access_token}"},
        )
        if profile_resp.status_code != 200:
            raise HTTPException(
                status_code=400,
                detail=f"Failed to fetch Google user info: {profile_resp.text}",
            )
        profile = profile_resp.json()

    google_id = profile.get("sub")
    email = profile.get("email")
    if not email or not google_id:
        raise HTTPException(status_code=400, detail="Google profile missing email or sub")

    # Find or create user
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

    # Redirect to frontend with tokens (frontend reads them from URL,
    # stores in localStorage, and removes them from URL)
    frontend_url = "https://nakshatralogy.com/auth/google-success"
    params = urlencode({
        "access_token": jwt_token,
        "refresh_token": refresh_token,
        "role": user.role,
        "user_id": user.id,
        "name": user.name or "",
        "email": user.email,
    })
    return RedirectResponse(url=f"{frontend_url}?{params}", status_code=302)
