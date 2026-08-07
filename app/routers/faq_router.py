"""FAQ — admin-managed help content shown in the apps' Customer Support screen.

Public:
  GET  /faq?audience=user|astrologer        — active FAQ for that audience
Admin (require_role admin):
  GET    /faq/admin                          — all FAQ (any audience/status)
  POST   /faq/admin                          — create
  PUT    /faq/admin/{id}                      — update
  DELETE /faq/admin/{id}                      — delete
"""

from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import require_role
from app.models.model import FaqItem

router = APIRouter()


class FaqCreate(BaseModel):
    audience: str = Field("user", pattern=r'^(user|astrologer|both)$')
    category: Optional[str] = None
    question: str = Field(..., min_length=1)
    answer: str = Field(..., min_length=1)
    sort_order: int = 0
    is_active: bool = True


class FaqUpdate(BaseModel):
    audience: Optional[str] = Field(None, pattern=r'^(user|astrologer|both)$')
    category: Optional[str] = None
    question: Optional[str] = None
    answer: Optional[str] = None
    sort_order: Optional[int] = None
    is_active: Optional[bool] = None


def _serialize(f: FaqItem) -> dict:
    return {
        "id": f.id, "audience": f.audience, "category": f.category,
        "question": f.question, "answer": f.answer,
        "sort_order": f.sort_order, "is_active": f.is_active,
        "created_at": str(f.created_at) if f.created_at else None,
        "updated_at": str(f.updated_at) if f.updated_at else None,
    }


@router.get("")
def list_faq(
    audience: str = Query("user", pattern=r'^(user|astrologer)$'),
    db: Session = Depends(get_db),
):
    """Public: active FAQ for an audience (audience match OR 'both')."""
    rows = db.query(FaqItem).filter(
        FaqItem.is_active == True,
        FaqItem.audience.in_((audience, "both")),
    ).order_by(FaqItem.sort_order.asc(), FaqItem.created_at.asc()).all()
    return {"items": [_serialize(f) for f in rows]}


@router.get("/admin")
def admin_list_faq(
    audience: Optional[str] = None,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(FaqItem)
    if audience:
        q = q.filter(FaqItem.audience == audience)
    rows = q.order_by(FaqItem.audience.asc(), FaqItem.sort_order.asc()).all()
    return {"items": [_serialize(f) for f in rows]}


@router.post("/admin")
def admin_create_faq(
    req: FaqCreate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    f = FaqItem(
        audience=req.audience, category=req.category,
        question=req.question, answer=req.answer,
        sort_order=req.sort_order, is_active=req.is_active,
    )
    db.add(f)
    db.commit()
    db.refresh(f)
    return _serialize(f)


@router.put("/admin/{faq_id}")
def admin_update_faq(
    faq_id: str,
    req: FaqUpdate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    f = db.query(FaqItem).filter(FaqItem.id == faq_id).first()
    if not f:
        raise HTTPException(status_code=404, detail="FAQ not found")
    for k, v in req.dict(exclude_unset=True).items():
        setattr(f, k, v)
    db.commit()
    db.refresh(f)
    return _serialize(f)


@router.delete("/admin/{faq_id}")
def admin_delete_faq(
    faq_id: str,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    f = db.query(FaqItem).filter(FaqItem.id == faq_id).first()
    if not f:
        raise HTTPException(status_code=404, detail="FAQ not found")
    db.delete(f)
    db.commit()
    return {"status": "ok", "deleted": faq_id}


@router.post("/admin/seed")
def admin_seed_faq(
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Seed a starter set of FAQs (idempotent-ish: only seeds when empty)."""
    if db.query(FaqItem).count() > 0:
        return {"status": "skipped", "reason": "FAQ already has entries"}
    seed = [
        ("user", "Notifications", "I'm not receiving notifications",
         "Open Profile → Notifications and make sure they're enabled. On web, allow notifications in your browser. If you recently logged out and back in, re-enabling once refreshes your device token."),
        ("user", "Calls", "My call is not connecting",
         "Check your internet connection and that the app has microphone/camera permission. If the astrologer doesn't answer within 60 seconds the call auto-cancels and you are not charged."),
        ("user", "Payments", "Money was deducted but the session didn't start",
         "Blocked amounts are released automatically if a session doesn't start. If you still see an issue after a few minutes, raise a support ticket with the transaction time."),
        ("astrologer", "Notifications", "I'm not receiving call/chat requests",
         "Make sure you're Online (dashboard toggle) and notifications are enabled in Profile. Keep the app open or installed to your home screen for reliable delivery."),
        ("astrologer", "Withdrawal", "My withdrawal succeeded but I don't see the amount",
         "Withdrawals reflect in your bank per your provider's settlement time. Your wallet ledger shows the debit immediately; if the ledger doesn't show it, raise a ticket."),
        ("both", "Account", "How do I update my profile photo?",
         "Go to Profile and tap your avatar to upload a new photo. Google-login photos are used automatically until you upload your own."),
    ]
    for i, (aud, cat, q, a) in enumerate(seed):
        db.add(FaqItem(audience=aud, category=cat, question=q, answer=a, sort_order=i))
    db.commit()
    return {"status": "ok", "seeded": len(seed)}
