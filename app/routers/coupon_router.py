"""
Coupon & discount management API.
=================================
  Admin      (require_role admin)      /coupons/admin*        full control + reports
  Astrologer (require_role astrologer) /coupons/astro*        self-serve (pending_review)
  User       (get_current_user)        /coupons/for-astrologer/{id}, /validate, /mine

Discounts are APPLIED inside the money paths (service purchase, IAP verify,
consultation finalization) via app.services.coupon_service — these endpoints
only manage/validate coupons. Ledger/billing plumbing only; no astrology logic.
"""

import csv
import io
from datetime import datetime
from decimal import Decimal
from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException, Query
from fastapi.responses import PlainTextResponse
from pydantic import BaseModel, Field
from sqlalchemy import func
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role, get_lang_user
from app.core.i18n import normalize_lang, DEFAULT_LANGUAGE
from app.models.model import (
    User, Coupon, CouponRedemption, AstrologerProfile,
)
from app.services import coupon_service

router = APIRouter()

_KINDS = {"first_consult", "consultation", "product", "all_free", "flat"}
_DISCOUNT_TYPES = {"percent", "flat", "full"}


# ── helpers ───────────────────────────────────────────────────────────

def _localized(i18n: Optional[dict], lang: str, fallback: str = "") -> str:
    if not i18n:
        return fallback
    lang = normalize_lang(lang)
    return i18n.get(lang) or i18n.get(DEFAULT_LANGUAGE) or fallback


def _coupon_dict(c: Coupon, lang: str = DEFAULT_LANGUAGE) -> dict:
    return {
        "id": c.id, "code": c.code, "owner_type": c.owner_type, "owner_id": c.owner_id,
        "kind": c.kind, "discount_type": c.discount_type,
        "discount_value": float(c.discount_value or 0),
        "max_discount_amt": float(c.max_discount_amt) if c.max_discount_amt is not None else None,
        "min_order_amt": float(c.min_order_amt) if c.min_order_amt is not None else None,
        "applies_to": c.applies_to, "first_time_only": bool(c.first_time_only),
        "per_user_limit": c.per_user_limit, "max_redemptions": c.max_redemptions,
        "redeemed_count": c.redeemed_count or 0, "funded_by": c.funded_by,
        "starts_at": c.starts_at.isoformat() if c.starts_at else None,
        "expires_at": c.expires_at.isoformat() if c.expires_at else None,
        "status": c.status,
        "title": _localized(c.title_i18n, lang, ""),
        "description": _localized(c.description_i18n, lang, ""),
        "title_i18n": c.title_i18n, "description_i18n": c.description_i18n,
        "created_at": c.created_at.isoformat() if c.created_at else None,
    }


def _parse_dt(v: Optional[str]) -> Optional[datetime]:
    if not v:
        return None
    try:
        return datetime.fromisoformat(v.replace("Z", "+00:00")).replace(tzinfo=None)
    except Exception:
        return None


def _apply_fields(c: Coupon, req, *, allow_owner_fields: bool):
    if req.code is not None:
        c.code = (req.code.strip().upper() or None)
    if req.kind is not None:
        c.kind = req.kind
    if req.discount_type is not None:
        c.discount_type = req.discount_type
    if req.discount_value is not None:
        c.discount_value = Decimal(str(req.discount_value))
    if req.max_discount_amt is not None:
        c.max_discount_amt = Decimal(str(req.max_discount_amt))
    if req.min_order_amt is not None:
        c.min_order_amt = Decimal(str(req.min_order_amt))
    if req.applies_to is not None:
        c.applies_to = req.applies_to or None
    if req.first_time_only is not None:
        c.first_time_only = req.first_time_only
    if req.per_user_limit is not None:
        c.per_user_limit = req.per_user_limit
    if req.max_redemptions is not None:
        c.max_redemptions = req.max_redemptions
    if req.starts_at is not None:
        c.starts_at = _parse_dt(req.starts_at)
    if req.expires_at is not None:
        c.expires_at = _parse_dt(req.expires_at)
    if req.title is not None or req.title_i18n is not None:
        i18n = dict(c.title_i18n or {})
        if req.title is not None:
            i18n[DEFAULT_LANGUAGE] = req.title
        if req.title_i18n:
            i18n.update(req.title_i18n)
        c.title_i18n = i18n or None
    if req.description is not None or req.description_i18n is not None:
        i18n = dict(c.description_i18n or {})
        if req.description is not None:
            i18n[DEFAULT_LANGUAGE] = req.description
        if req.description_i18n:
            i18n.update(req.description_i18n)
        c.description_i18n = i18n or None
    if allow_owner_fields and req.funded_by is not None:
        c.funded_by = req.funded_by


# ── coupon platform settings (admin toggles) ──────────────────────────

_SETTINGS_CAT = "coupons"
_AUTO_APPROVE_KEY = "astro_auto_approve"


def _get_setting(db: Session, key: str) -> Optional[str]:
    from app.models.model import PlatformSetting
    row = db.query(PlatformSetting).filter(
        PlatformSetting.category == _SETTINGS_CAT, PlatformSetting.key == key
    ).first()
    return row.value if row else None


def _set_setting(db: Session, key: str, value: str, user_id: Optional[str] = None) -> None:
    from app.models.model import PlatformSetting
    row = db.query(PlatformSetting).filter(
        PlatformSetting.category == _SETTINGS_CAT, PlatformSetting.key == key
    ).first()
    if row:
        row.value = value
        row.updated_by = user_id
    else:
        db.add(PlatformSetting(category=_SETTINGS_CAT, key=key, value=value, updated_by=user_id))


def _astro_auto_approve(db: Session) -> bool:
    """When ON, astrologer offers go straight to ACTIVE (no manual review).
    Default OFF (offers still require admin approval)."""
    v = _get_setting(db, _AUTO_APPROVE_KEY)
    return str(v or "").strip().lower() in ("1", "true", "yes", "on")


def _guard_coupon_text(*texts: Optional[str]) -> None:
    """Reject a coupon whose code/title/description carries abusive language —
    these strings render on user-facing surfaces. Raises HTTP 400."""
    from app.core.profanity import first_clean_error
    bad = first_clean_error(*texts)
    if bad is not None:
        raise HTTPException(
            400, "Please remove inappropriate language from the coupon name/code.")


# ── request models ────────────────────────────────────────────────────

class CouponBody(BaseModel):
    code: Optional[str] = None
    kind: Optional[str] = None
    discount_type: Optional[str] = None
    discount_value: Optional[float] = Field(None, ge=0)
    max_discount_amt: Optional[float] = Field(None, ge=0)
    min_order_amt: Optional[float] = Field(None, ge=0)
    applies_to: Optional[List[str]] = None
    first_time_only: Optional[bool] = None
    per_user_limit: Optional[int] = Field(None, ge=0)
    max_redemptions: Optional[int] = Field(None, ge=0)
    funded_by: Optional[str] = None
    starts_at: Optional[str] = None
    expires_at: Optional[str] = None
    status: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    title_i18n: Optional[dict] = None
    description_i18n: Optional[dict] = None


class ValidateBody(BaseModel):
    code: str
    scope: str = "product"                 # product | chat | call | video
    service_key: Optional[str] = None
    astrologer_id: Optional[str] = None
    base_amount: Optional[float] = 0


# ══════════════════════════════════════════════════════════════════════
#  ADMIN
# ══════════════════════════════════════════════════════════════════════

class CouponConfigBody(BaseModel):
    astro_auto_approve: Optional[bool] = None


@router.get("/admin/config")
def admin_get_config(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Coupon platform toggles (admin)."""
    return {"astro_auto_approve": _astro_auto_approve(db)}


@router.put("/admin/config")
def admin_set_config(
    req: CouponConfigBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Update coupon toggles. When astro_auto_approve is ON, astrologer offers
    go live immediately (no manual review). Abuse-language screening on the
    code/name still applies regardless."""
    if req.astro_auto_approve is not None:
        _set_setting(db, _AUTO_APPROVE_KEY,
                     "true" if req.astro_auto_approve else "false", current_user.id)
    db.commit()
    return {"astro_auto_approve": _astro_auto_approve(db)}


@router.get("/admin")
def admin_list(
    owner_type: Optional[str] = None,
    status: Optional[str] = None,
    q: Optional[str] = None,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    query = db.query(Coupon)
    if owner_type:
        query = query.filter(Coupon.owner_type == owner_type)
    if status:
        query = query.filter(Coupon.status == status)
    if q:
        like = f"%{q.upper()}%"
        query = query.filter(Coupon.code.like(like))
    rows = query.order_by(Coupon.created_at.desc()).all()
    return {"items": [_coupon_dict(c, lang) for c in rows], "total": len(rows)}


@router.post("/admin", status_code=201)
def admin_create(
    req: CouponBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    kind = req.kind or "product"
    if kind not in _KINDS:
        raise HTTPException(400, "Invalid kind")
    dtype = req.discount_type or ("full" if kind == "all_free" else "percent")
    if dtype not in _DISCOUNT_TYPES:
        raise HTTPException(400, "Invalid discount_type")
    if req.code:
        exists = db.query(Coupon).filter(func.lower(Coupon.code) == req.code.strip().lower()).first()
        if exists:
            raise HTTPException(409, "Coupon code already exists")
    c = Coupon(
        owner_type="platform", owner_id=None, kind=kind, discount_type=dtype,
        funded_by=(req.funded_by or "platform"),
        status=(req.status or "active"), created_by=current_user.id,
    )
    _apply_fields(c, req, allow_owner_fields=True)
    c.discount_type = dtype
    c.kind = kind
    db.add(c)
    db.commit()
    db.refresh(c)
    return _coupon_dict(c)


@router.patch("/admin/{coupon_id}")
def admin_update(
    coupon_id: str,
    req: CouponBody,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    c = db.query(Coupon).filter(Coupon.id == coupon_id).first()
    if not c:
        raise HTTPException(404, "Coupon not found")
    if req.kind and req.kind not in _KINDS:
        raise HTTPException(400, "Invalid kind")
    if req.discount_type and req.discount_type not in _DISCOUNT_TYPES:
        raise HTTPException(400, "Invalid discount_type")
    if req.code:
        dup = db.query(Coupon).filter(
            func.lower(Coupon.code) == req.code.strip().lower(), Coupon.id != c.id).first()
        if dup:
            raise HTTPException(409, "Coupon code already exists")
    _apply_fields(c, req, allow_owner_fields=True)
    if req.status is not None:
        c.status = req.status
    db.commit()
    db.refresh(c)
    return _coupon_dict(c)


@router.post("/admin/{coupon_id}/moderate")
def admin_moderate(
    coupon_id: str,
    payload: dict,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Approve or reject an astrologer coupon. payload: {action: approve|reject}."""
    c = db.query(Coupon).filter(Coupon.id == coupon_id).first()
    if not c:
        raise HTTPException(404, "Coupon not found")
    action = (payload or {}).get("action")
    if action == "approve":
        c.status = "active"
    elif action == "reject":
        c.status = "rejected"
    else:
        raise HTTPException(400, "action must be approve|reject")
    db.commit()
    db.refresh(c)
    return _coupon_dict(c)


@router.delete("/admin/{coupon_id}")
def admin_delete(
    coupon_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    c = db.query(Coupon).filter(Coupon.id == coupon_id).first()
    if not c:
        raise HTTPException(404, "Coupon not found")
    db.delete(c)
    db.commit()
    return {"status": "deleted"}


@router.get("/admin/redemptions")
def admin_redemptions(
    coupon_id: Optional[str] = None,
    user_id: Optional[str] = None,
    skip: int = 0,
    limit: int = Query(50, le=200),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(CouponRedemption)
    if coupon_id:
        q = q.filter(CouponRedemption.coupon_id == coupon_id)
    if user_id:
        q = q.filter(CouponRedemption.user_id == user_id)
    total = q.count()
    rows = q.order_by(CouponRedemption.created_at.desc()).offset(skip).limit(limit).all()
    code_by_id = {c.id: c.code for c in db.query(Coupon.id, Coupon.code).all()}
    items = [{
        "id": r.id, "coupon_id": r.coupon_id, "coupon_code": code_by_id.get(r.coupon_id),
        "user_id": r.user_id, "astrologer_id": r.astrologer_id,
        "context_type": r.context_type, "context_id": r.context_id,
        "base_amount": float(r.base_amount or 0), "discount_amount": float(r.discount_amount or 0),
        "currency": r.currency, "funded_by": r.funded_by, "status": r.status,
        "created_at": r.created_at.isoformat() if r.created_at else None,
    } for r in rows]
    agg = db.query(func.coalesce(func.sum(CouponRedemption.discount_amount), 0)).filter(
        CouponRedemption.status == "applied").scalar() or 0
    return {"items": items, "total": total, "total_discount_applied": float(agg)}


@router.get("/admin/redemptions.csv", response_class=PlainTextResponse)
def admin_redemptions_csv(
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Full redemptions ledger as CSV (all rows)."""
    rows = db.query(CouponRedemption).order_by(CouponRedemption.created_at.desc()).all()
    code_by_id = {c.id: c.code for c in db.query(Coupon.id, Coupon.code).all()}
    buf = io.StringIO()
    w = csv.writer(buf)
    w.writerow(["created_at", "coupon_code", "user_id", "astrologer_id", "context_type",
                "context_id", "base_amount", "discount_amount", "currency", "funded_by", "status"])
    for r in rows:
        w.writerow([
            r.created_at.isoformat() if r.created_at else "",
            code_by_id.get(r.coupon_id) or r.coupon_id,
            r.user_id, r.astrologer_id or "", r.context_type, r.context_id or "",
            float(r.base_amount or 0), float(r.discount_amount or 0),
            r.currency, r.funded_by, r.status,
        ])
    return PlainTextResponse(buf.getvalue(), headers={
        "Content-Disposition": 'attachment; filename="coupon_redemptions.csv"'})


# ══════════════════════════════════════════════════════════════════════
#  ASTROLOGER (self-serve)
# ══════════════════════════════════════════════════════════════════════

def _my_profile(current_user: User) -> AstrologerProfile:
    p = current_user.astrologer_profile
    if not p:
        raise HTTPException(404, "Astrologer profile not found")
    return p


@router.get("/astro")
def astro_list(
    current_user: User = Depends(require_role("astrologer")),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    p = _my_profile(current_user)
    rows = db.query(Coupon).filter(
        Coupon.owner_type == "astrologer", Coupon.owner_id == p.id
    ).order_by(Coupon.created_at.desc()).all()
    return {"items": [_coupon_dict(c, lang) for c in rows]}


@router.post("/astro", status_code=201)
def astro_create(
    req: CouponBody,
    current_user: User = Depends(require_role("astrologer")),
    db: Session = Depends(get_db),
):
    """Astrologer creates a first-time / consultation discount. Starts
    pending_review; astrologer-funded; scoped to chat/call/video."""
    p = _my_profile(current_user)
    # Abuse guard: code/title/description show on user-facing surfaces.
    _guard_coupon_text(req.code, req.title, req.description)
    kind = req.kind if req.kind in ("first_consult", "consultation") else "first_consult"
    dtype = req.discount_type or "percent"
    if dtype not in ("percent", "flat"):
        raise HTTPException(400, "Astrologer coupons are percent or flat only")
    if req.code:
        exists = db.query(Coupon).filter(func.lower(Coupon.code) == req.code.strip().lower()).first()
        if exists:
            raise HTTPException(409, "Coupon code already exists")
    # Admin toggle: auto-approve astrologer offers (skip manual review).
    initial_status = "active" if _astro_auto_approve(db) else "pending_review"
    c = Coupon(
        owner_type="astrologer", owner_id=p.id, kind=kind, discount_type=dtype,
        funded_by="astrologer",           # astrologer bears their own promo
        first_time_only=(kind == "first_consult"),
        per_user_limit=1,
        status=initial_status,
        applies_to=(req.applies_to or ["chat", "call", "video"]),
        created_by=current_user.id,
    )
    _apply_fields(c, req, allow_owner_fields=False)
    c.kind = kind
    c.discount_type = dtype
    c.owner_type = "astrologer"
    c.owner_id = p.id
    c.funded_by = "astrologer"
    c.status = initial_status
    db.add(c)
    db.commit()
    db.refresh(c)
    return _coupon_dict(c)


@router.patch("/astro/{coupon_id}")
def astro_update(
    coupon_id: str,
    req: CouponBody,
    current_user: User = Depends(require_role("astrologer")),
    db: Session = Depends(get_db),
):
    p = _my_profile(current_user)
    c = db.query(Coupon).filter(
        Coupon.id == coupon_id, Coupon.owner_type == "astrologer", Coupon.owner_id == p.id
    ).first()
    if not c:
        raise HTTPException(404, "Coupon not found")
    _guard_coupon_text(req.code, req.title, req.description)
    auto = _astro_auto_approve(db)
    _apply_fields(c, req, allow_owner_fields=False)
    # astrologers may only pause/resume their own coupon; edits re-enter review
    if req.status in ("active", "paused"):
        if req.status == "active" and c.status in ("pending_review", "rejected") and not auto:
            pass  # cannot self-approve while manual review is on
        else:
            c.status = req.status
    if any(v is not None for v in (req.discount_value, req.discount_type, req.applies_to, req.min_order_amt)):
        # material change → re-moderate, unless auto-approve is on
        if c.status == "active" and not auto:
            c.status = "pending_review"
    db.commit()
    db.refresh(c)
    return _coupon_dict(c)


@router.delete("/astro/{coupon_id}")
def astro_delete(
    coupon_id: str,
    current_user: User = Depends(require_role("astrologer")),
    db: Session = Depends(get_db),
):
    p = _my_profile(current_user)
    c = db.query(Coupon).filter(
        Coupon.id == coupon_id, Coupon.owner_type == "astrologer", Coupon.owner_id == p.id
    ).first()
    if not c:
        raise HTTPException(404, "Coupon not found")
    db.delete(c)
    db.commit()
    return {"status": "deleted"}


@router.get("/astro/{coupon_id}/stats")
def astro_stats(
    coupon_id: str,
    current_user: User = Depends(require_role("astrologer")),
    db: Session = Depends(get_db),
):
    p = _my_profile(current_user)
    c = db.query(Coupon).filter(
        Coupon.id == coupon_id, Coupon.owner_type == "astrologer", Coupon.owner_id == p.id
    ).first()
    if not c:
        raise HTTPException(404, "Coupon not found")
    n, total = db.query(
        func.count(CouponRedemption.id),
        func.coalesce(func.sum(CouponRedemption.discount_amount), 0),
    ).filter(CouponRedemption.coupon_id == c.id, CouponRedemption.status == "applied").first()
    return {"redemptions": int(n or 0), "total_discount": float(total or 0),
            "redeemed_count": c.redeemed_count or 0}


# ══════════════════════════════════════════════════════════════════════
#  USER
# ══════════════════════════════════════════════════════════════════════

@router.get("/for-astrologer/{astrologer_id}")
def coupon_for_astrologer(
    astrologer_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """The active astrologer offer to show on the profile, plus whether this
    user has already used it."""
    c = db.query(Coupon).filter(
        Coupon.owner_type == "astrologer", Coupon.owner_id == astrologer_id,
        Coupon.status == "active",
    ).order_by(Coupon.discount_value.desc()).first()
    if not c:
        return {"coupon": None}
    used = coupon_service.already_used(db, c.id, current_user.id)
    # eligibility (first-time) preview — used=True also implies not eligible
    eligible = (not used) and coupon_service._first_time_ok(
        db, c, current_user.id, "chat", astrologer_id)
    return {"coupon": _coupon_dict(c, lang), "already_used": used, "eligible": eligible}


@router.post("/validate")
def validate(
    req: ValidateBody,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Preview a code before purchase. Returns discount or a reason code."""
    try:
        res = coupon_service.validate_code(
            db, current_user.id, req.code, req.scope, req.base_amount or 0,
            astrologer_id=req.astrologer_id, service_key=req.service_key,
        )
    except coupon_service.CouponError as e:
        return {"valid": False, "reason": e.reason}
    return {
        "valid": True,
        "coupon": _coupon_dict(res.coupon, lang),
        "discount_amount": res.discount_amount,
        "final_amount": res.final_amount,
    }


@router.get("/mine")
def my_coupons(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    """Coupons this user has redeemed (history)."""
    rows = db.query(CouponRedemption).filter(
        CouponRedemption.user_id == current_user.id
    ).order_by(CouponRedemption.created_at.desc()).limit(100).all()
    code_by_id = {c.id: c for c in db.query(Coupon).filter(
        Coupon.id.in_([r.coupon_id for r in rows] or [""])).all()}
    items = []
    for r in rows:
        c = code_by_id.get(r.coupon_id)
        items.append({
            "coupon_code": c.code if c else None,
            "title": _localized(c.title_i18n, lang) if c else "",
            "discount_amount": float(r.discount_amount or 0),
            "context_type": r.context_type, "status": r.status,
            "created_at": r.created_at.isoformat() if r.created_at else None,
        })
    return {"items": items}
