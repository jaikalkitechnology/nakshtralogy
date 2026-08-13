"""Reusable FastAPI dependencies — current user / current astrologer."""
from __future__ import annotations

import uuid
from typing import Annotated

import jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_db
from app.core.security import ACCESS, decode_token
from app.models.admin import Admin
from app.models.astrologer import Astrologer
from app.models.user import User

bearer = HTTPBearer(auto_error=True)

_CRED_EXC = HTTPException(
    status_code=status.HTTP_401_UNAUTHORIZED,
    detail="Could not validate credentials",
    headers={"WWW-Authenticate": "Bearer"},
)


def _decode_access(token: str) -> dict:
    try:
        payload = decode_token(token)
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token expired",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except jwt.PyJWTError:
        raise _CRED_EXC
    if payload.get("type") != ACCESS:
        raise _CRED_EXC
    return payload


async def get_current_user(
    creds: Annotated[HTTPAuthorizationCredentials, Depends(bearer)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> User:
    payload = _decode_access(creds.credentials)
    if payload.get("role") != "user":
        raise _CRED_EXC
    try:
        user_id = uuid.UUID(payload["sub"])
    except (KeyError, ValueError):
        raise _CRED_EXC

    user = await db.get(User, user_id)
    if user is None or not user.is_active:
        raise _CRED_EXC
    return user


async def get_current_astrologer(
    creds: Annotated[HTTPAuthorizationCredentials, Depends(bearer)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> Astrologer:
    payload = _decode_access(creds.credentials)
    if payload.get("role") != "astrologer":
        raise _CRED_EXC
    try:
        astro_id = uuid.UUID(payload["sub"])
    except (KeyError, ValueError):
        raise _CRED_EXC

    astro = await db.get(Astrologer, astro_id)
    if astro is None:
        raise _CRED_EXC
    return astro


CurrentUser = Annotated[User, Depends(get_current_user)]
class Principal:
    """Either party in a consultation — used by endpoints both sides call."""

    def __init__(self, role: str, id: uuid.UUID, user=None, astrologer=None):
        self.role = role
        self.id = id
        self.user: User | None = user
        self.astrologer: Astrologer | None = astrologer


async def get_current_principal(
    creds: Annotated[HTTPAuthorizationCredentials, Depends(bearer)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> Principal:
    """Resolve the caller as a user or astrologer from the access token."""
    payload = _decode_access(creds.credentials)
    role = payload.get("role")
    try:
        principal_id = uuid.UUID(payload["sub"])
    except (KeyError, ValueError):
        raise _CRED_EXC

    if role == "astrologer":
        astro = await db.get(Astrologer, principal_id)
        if astro is None:
            raise _CRED_EXC
        return Principal("astrologer", principal_id, astrologer=astro)

    user = await db.get(User, principal_id)
    if user is None or not user.is_active:
        raise _CRED_EXC
    return Principal("user", principal_id, user=user)


async def get_current_admin(
    creds: Annotated[HTTPAuthorizationCredentials, Depends(bearer)],
    db: Annotated[AsyncSession, Depends(get_db)],
) -> Admin:
    payload = _decode_access(creds.credentials)
    if payload.get("role") != "admin":
        raise _CRED_EXC
    try:
        admin_id = uuid.UUID(payload["sub"])
    except (KeyError, ValueError):
        raise _CRED_EXC
    admin = await db.get(Admin, admin_id)
    if admin is None or not admin.is_active:
        raise _CRED_EXC
    return admin


CurrentAstrologer = Annotated[Astrologer, Depends(get_current_astrologer)]
CurrentPrincipal = Annotated[Principal, Depends(get_current_principal)]
CurrentAdmin = Annotated[Admin, Depends(get_current_admin)]
DBSession = Annotated[AsyncSession, Depends(get_db)]
