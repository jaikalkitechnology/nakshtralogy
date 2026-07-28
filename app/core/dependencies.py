"""FastAPI dependencies — auth, role checks."""

from typing import Optional

from fastapi import Depends, HTTPException, status, Query, Header
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.security import decode_access_token
from app.core.i18n import normalize_lang, DEFAULT_LANGUAGE
from app.models.model import User

bearer_scheme = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> User:
    payload = decode_access_token(credentials.credentials)
    if payload is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")
    user = db.query(User).filter(User.id == payload["sub"]).first()
    if not user or not user.is_active:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found or deactivated")
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
