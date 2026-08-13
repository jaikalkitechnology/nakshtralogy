"""Current-user profile endpoints (section 9.2)."""
from __future__ import annotations

import uuid
from datetime import datetime, timezone

from fastapi import APIRouter, File, HTTPException, UploadFile, status

from app.core.deps import CurrentUser, DBSession
from app.models.device_token import OWNER_USER
from app.schemas.auth import SimpleMessage
from app.schemas.device import DeviceRegister, DeviceRegistered
from app.schemas.user import UserOut, UserUpdate
from app.services import auth_service, push_service, storage

router = APIRouter(tags=["users"])


@router.get("/me", response_model=UserOut)
async def get_me(user: CurrentUser):
    return UserOut.model_validate(user)


@router.patch("/me", response_model=UserOut)
async def update_me(body: UserUpdate, user: CurrentUser, db: DBSession):
    data = body.model_dump(exclude_unset=True)
    if "mobile" in data or "country_code" in data:
        # Effective post-merge pair — a PATCH touching only one of the two
        # fields still needs to be checked against the OTHER field's
        # existing value, not just the delta.
        effective_mobile = data.get("mobile", user.mobile)
        effective_country_code = data.get("country_code", user.country_code)
        try:
            await auth_service.assert_mobile_available(
                db, effective_country_code, effective_mobile, exclude_user_id=user.id
            )
        except auth_service.MobileAlreadyRegisteredError as exc:
            raise HTTPException(status.HTTP_409_CONFLICT, str(exc))
    for field, value in data.items():
        setattr(user, field, value)
    await db.flush()
    await db.refresh(user)
    return UserOut.model_validate(user)


@router.post("/me/avatar", response_model=UserOut)
async def upload_avatar(
    user: CurrentUser, db: DBSession, file: UploadFile = File(...)
):
    """Upload a profile photo (multipart) → object storage; returns the user."""
    data = await file.read()
    if len(data) > storage.MAX_UPLOAD_BYTES:
        raise HTTPException(status.HTTP_413_REQUEST_ENTITY_TOO_LARGE, "File too large")
    ext = storage.safe_extension(file.filename)
    if ext == ".bin":
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "Unsupported file type")
    # Avatars are rendered small — recompress oversized camera shots
    # server-side (no-op for anything already small/undecodable).
    data, ext = storage.compress_image(data, ext, max_dim=1024)
    key = storage.save_bytes(f"avatars/{uuid.uuid4()}{ext}", data)
    user.avatar_url = storage.url_for(key)
    await db.flush()
    await db.refresh(user)
    return UserOut.model_validate(user)


@router.post("/me/device", response_model=DeviceRegistered)
async def register_device(body: DeviceRegister, user: CurrentUser, db: DBSession):
    """Register/refresh this install's FCM token for push notifications."""
    await push_service.register_token(
        db,
        owner_type=OWNER_USER,
        owner_id=user.id,
        token=body.token,
        platform=body.platform,
    )
    return DeviceRegistered()


@router.delete("/me/device", response_model=SimpleMessage)
async def unregister_device(body: DeviceRegister, user: CurrentUser, db: DBSession):
    """Drop this device's FCM token (e.g. on logout)."""
    await push_service.unregister_token(db, body.token)
    return SimpleMessage(detail="Device unregistered.")


@router.delete("/me", response_model=SimpleMessage)
async def delete_me(user: CurrentUser, db: DBSession):
    """Soft-delete (anonymise) the account per DPDP right-to-deletion."""
    user.is_active = False
    user.deleted_at = datetime.now(timezone.utc)
    user.name = None
    user.email = None
    user.avatar_url = None
    await db.flush()
    return SimpleMessage(detail="Account scheduled for deletion.")
