"""Home-screen banners (slider), admin-managed.

Public:
  GET  /banners?audience=user|astrologer   — active banners for that audience
Admin (require_role admin):
  GET    /banners/admin                     — all banners
  POST   /banners/admin                     — create
  PUT    /banners/admin/{id}                 — update
  DELETE /banners/admin/{id}                 — delete
  POST   /banners/admin/upload              — upload a banner image
  GET    /banners/file/{y}/{m}/{d}/{name}    — serve an uploaded banner image
"""

import os
import uuid
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import require_role
from app.models.model import Banner

router = APIRouter()

UPLOAD_DIR = os.path.join("uploads", "banners")
_ALLOWED_IMG = {".jpg", ".jpeg", ".png", ".webp", ".gif"}
_MAX_BYTES = 6 * 1024 * 1024


class BannerCreate(BaseModel):
    audience: str = Field("user", pattern=r'^(user|astrologer|both)$')
    title: Optional[str] = None
    image_url: str = Field(..., min_length=1)
    link_url: Optional[str] = None
    sort_order: int = 0
    is_active: bool = True


class BannerUpdate(BaseModel):
    audience: Optional[str] = Field(None, pattern=r'^(user|astrologer|both)$')
    title: Optional[str] = None
    image_url: Optional[str] = None
    link_url: Optional[str] = None
    sort_order: Optional[int] = None
    is_active: Optional[bool] = None


def _serialize(b: Banner) -> dict:
    return {
        "id": b.id, "audience": b.audience, "title": b.title,
        "image_url": b.image_url, "link_url": b.link_url,
        "sort_order": b.sort_order, "is_active": b.is_active,
        "created_at": str(b.created_at) if b.created_at else None,
    }


@router.get("")
def list_banners(
    audience: str = Query("user", pattern=r'^(user|astrologer)$'),
    db: Session = Depends(get_db),
):
    """Public: active banners for an audience (audience match OR 'both')."""
    rows = db.query(Banner).filter(
        Banner.is_active == True,
        Banner.audience.in_((audience, "both")),
    ).order_by(Banner.sort_order.asc(), Banner.created_at.desc()).all()
    return {"items": [_serialize(b) for b in rows]}


@router.get("/admin")
def admin_list_banners(
    audience: Optional[str] = None,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(Banner)
    if audience:
        q = q.filter(Banner.audience == audience)
    rows = q.order_by(Banner.audience.asc(), Banner.sort_order.asc()).all()
    return {"items": [_serialize(b) for b in rows]}


@router.post("/admin")
def admin_create_banner(
    req: BannerCreate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    b = Banner(
        audience=req.audience, title=req.title, image_url=req.image_url,
        link_url=req.link_url, sort_order=req.sort_order, is_active=req.is_active,
    )
    db.add(b)
    db.commit()
    db.refresh(b)
    return _serialize(b)


@router.put("/admin/{banner_id}")
def admin_update_banner(
    banner_id: str,
    req: BannerUpdate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    b = db.query(Banner).filter(Banner.id == banner_id).first()
    if not b:
        raise HTTPException(status_code=404, detail="Banner not found")
    for k, v in req.dict(exclude_unset=True).items():
        setattr(b, k, v)
    db.commit()
    db.refresh(b)
    return _serialize(b)


@router.delete("/admin/{banner_id}")
def admin_delete_banner(
    banner_id: str,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    b = db.query(Banner).filter(Banner.id == banner_id).first()
    if not b:
        raise HTTPException(status_code=404, detail="Banner not found")
    db.delete(b)
    db.commit()
    return {"status": "ok", "deleted": banner_id}


@router.post("/admin/upload")
async def admin_upload_banner(
    file: UploadFile = File(...),
    current_user=Depends(require_role("admin")),
):
    ext = os.path.splitext(file.filename or "")[1].lower()
    if ext not in _ALLOWED_IMG:
        raise HTTPException(status_code=400, detail="Only image files are allowed")
    contents = await file.read()
    if len(contents) > _MAX_BYTES:
        raise HTTPException(status_code=400, detail="Image too large (max 6 MB)")
    now = datetime.utcnow()
    date_folder = now.strftime("%Y/%m/%d")
    folder = os.path.join(UPLOAD_DIR, date_folder)
    os.makedirs(folder, exist_ok=True)
    unique = f"{uuid.uuid4().hex}{ext}"
    with open(os.path.join(folder, unique), "wb") as f:
        f.write(contents)
    return {"media_url": f"/api/v1/banners/file/{date_folder}/{unique}",
            "file_name": file.filename, "file_size": len(contents)}


@router.get("/file/{year}/{month}/{day}/{filename}")
def download_banner_file(year: str, month: str, day: str, filename: str):
    path = os.path.join(UPLOAD_DIR, year, month, day, filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(path, filename=filename)
