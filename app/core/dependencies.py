"""FastAPI dependencies — auth, role checks."""

import json
from typing import Optional

from fastapi import Depends, HTTPException, status, Query, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import decode_access_token
from app.core.i18n import normalize_lang, DEFAULT_LANGUAGE
from app.models.model import User

# auto_error=False so a MISSING Authorization header yields our explicit 401
# (FastAPI's default HTTPBearer raises 403 for a missing header, which reads as
# "forbidden" to clients that special-case 401 for re-auth).
bearer_scheme = HTTPBearer(auto_error=False)


def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(bearer_scheme),
    db: Session = Depends(get_db),
    x_app_client: Optional[str] = Header(None),
) -> User:
    if credentials is None or not credentials.credentials:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Not authenticated")
    payload = decode_access_token(credentials.credentials)
    if payload is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")
    user = db.query(User).filter(User.id == payload["sub"]).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found or deactivated")
    # Which app is calling ("user" | "astro"). Lets entitlements charge an
    # astrologer like a normal user when they use the USER app, while keeping
    # free client-service in the astrologer app. Request-scoped, not persisted.
    try:
        user._app_client = (x_app_client or "").strip().lower() or None
    except Exception:
        pass
    return user


def require_role(*roles: str):
    """Dependency factory: require user to have one of the specified roles."""
    def _check(current_user: User = Depends(get_current_user)):
        if current_user.role not in roles:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Insufficient permissions")
        return current_user
    return _check


get_current_user_role = get_current_user  # alias

require_user = require_role("user")
require_astrologer = require_role("astrologer")
require_admin = require_role("admin")


def admin_permissions(user: User) -> Optional[list]:
    """User.permissions is a JSON array of permission keys, or NULL/empty for
    an unrestricted ("Super Admin") account — every admin created before the
    Role Permissions feature existed. Returns None for unrestricted, else the
    list of keys that admin is scoped to."""
    if not getattr(user, "permissions", None):
        return None
    try:
        parsed = json.loads(user.permissions)
        return parsed if isinstance(parsed, list) else None
    except Exception:
        return None


def require_permission(perm: str):
    """Require role=admin AND (unrestricted, or explicitly granted `perm`)."""
    def _check(current_user: User = Depends(get_current_user)):
        if current_user.role != "admin":
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Insufficient permissions")
        perms = admin_permissions(current_user)
        if perms is not None and perm not in perms:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=f"Missing permission: {perm}")
        return current_user
    return _check


def require_super_admin(current_user: User = Depends(get_current_user)):
    """Unrestricted admin only — required to manage other admin accounts and
    their permissions, so a scoped sub-admin can never grant themselves more
    access."""
    if current_user.role != "admin" or admin_permissions(current_user) is not None:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Super Admin access required")
    return current_user


def get_lang_user(
    lang: Optional[str] = Query(None, description="Language code (e.g. hindi, english, tamil)."),
    accept_language: Optional[str] = Header(None),
    current_user: User = Depends(get_current_user),
) -> str:
    """Authenticated language resolver — honours the user's stored preference.

    Order: explicit ?lang= → the user's saved preferred_language →
    Accept-Language header → english. Use this on authenticated endpoints so a
    logged-in user gets responses in their chosen language without repeating
    ?lang= on every request.
    """
    if lang:
        return normalize_lang(lang)
    if current_user is not None and getattr(current_user, "preferred_language", None):
        return normalize_lang(current_user.preferred_language)
    if accept_language:
        primary = accept_language.split(",")[0].split(";")[0].strip()
        return normalize_lang(primary)
    return DEFAULT_LANGUAGE


def resolve_user_lang(user: Optional[User], fallback: str = DEFAULT_LANGUAGE) -> str:
    """Resolve a specific user's preferred language (for notifications sent TO
    that user). Falls back to `fallback` (usually the request language)."""
    if user is not None and getattr(user, "preferred_language", None):
        return normalize_lang(user.preferred_language)
    return normalize_lang(fallback)
