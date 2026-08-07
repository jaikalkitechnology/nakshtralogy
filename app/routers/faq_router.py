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


# Recommended default FAQ set (audience, category, question, answer).
_DEFAULT_FAQ = [
    # ── User app ──────────────────────────────────────────────────────
    ("user", "Getting Started", "How do I start a consultation with an astrologer?",
     "Open the Astrologers tab, pick an astrologer who is Online, and choose Chat, Call, or Video. Make sure your wallet has enough balance for at least a few minutes — the rate is shown on each astrologer's card before you start."),
    ("user", "Wallet & Payments", "How does wallet billing work?",
     "You add money to your wallet, and consultations are charged from it. For per-minute services an amount is briefly blocked at the start and the exact charge is settled when the session ends. Any unused blocked amount is released back automatically."),
    ("user", "Wallet & Payments", "Money was deducted but the session didn't start",
     "Blocked amounts are released automatically if a session never starts (e.g. the astrologer didn't answer). If the balance doesn't return within a few minutes, raise a support ticket with the date and time and we'll check it."),
    ("user", "Wallet & Payments", "How do I add money to my wallet?",
     "Go to the Wallet tab and tap Add Money, choose an amount, and complete the payment. Your balance updates instantly once the payment succeeds."),
    ("user", "Consultations", "My call is not connecting",
     "Check your internet connection and that the app has microphone and camera permission. On the web app, allow mic/camera when the browser asks. If the astrologer doesn't answer within 60 seconds the call auto-cancels and you are not charged."),
    ("user", "Consultations", "Can I get a refund for a bad consultation?",
     "If a session had a genuine technical problem (call didn't connect, astrologer didn't respond), raise a support ticket with the details and our team will review it. See our Refund Policy in Profile → About & Legal."),
    ("user", "Notifications", "I'm not receiving notifications",
     "Open Profile → Notifications and make sure they're enabled. On the web app, allow notifications in your browser (on iPhone, add the app to your Home Screen first). If you recently logged out and back in, toggling notifications once refreshes your device."),
    ("user", "Kundli & Reports", "How accurate are the Kundli and reports?",
     "Charts and reports are generated from precise Vedic astronomical calculations using your exact birth date, time, and place — so please enter your birth details as accurately as possible for the best results."),
    ("user", "Live", "How do gifts and super-chats work in live streams?",
     "During a live stream you can send gifts or a paid super-chat to the astrologer; the amount is deducted from your wallet. Super-chats are pinned so the astrologer sees them prominently."),
    ("user", "Account", "How do I change my birth details?",
     "Open your Kundli/profile, edit the birth date, time, and place, and save — your charts and reports will recalculate automatically."),

    # ── Astrologer app ────────────────────────────────────────────────
    ("astrologer", "Onboarding", "How long does approval take?",
     "After you complete your personal details, professional details, and KYC, our team reviews your application. You'll get a notification and email once you're approved or if anything needs correction."),
    ("astrologer", "Onboarding", "My application was rejected — what do I do?",
     "Open the app: the dashboard shows exactly which section needs correction (KYC, personal, or professional details). Fix the flagged section and resubmit — editing your profile automatically sends it back for review."),
    ("astrologer", "KYC", "Which documents do I need for KYC?",
     "Upload a clear, valid government ID (and any professional certificate if requested). Make sure the photo isn't blurry, the details match your profile, and the document isn't expired."),
    ("astrologer", "Requests", "I'm not receiving call/chat requests",
     "Make sure you're set to Online using the dashboard toggle and that notifications are enabled in Profile. Keep the app open, or install the web app to your Home Screen, for reliable delivery. New requests also appear under the bell icon."),
    ("astrologer", "Earnings", "How and when do I get paid?",
     "Your earnings from each consultation are credited to your wallet after the platform commission. You can withdraw to your bank from the Wallet screen; settlement to your bank follows your payment provider's timelines."),
    ("astrologer", "Earnings", "My withdrawal succeeded but I don't see the amount in my bank",
     "Bank settlement can take some time depending on your provider. Your wallet ledger shows the debit immediately; if the ledger doesn't reflect it, raise a support ticket with the reference and time."),
    ("astrologer", "Live", "How do I start a live stream?",
     "From the dashboard tap Go Live. On the web app you'll tap Start Camera first (your browser will ask for camera access), then Go Live. You can reply to viewers, pin a question you're answering, and set a gifting goal."),
    ("astrologer", "Ratings", "How is my rating calculated?",
     "Your rating is the average of the star ratings users leave after chat, call, and video sessions. Consistently helpful, on-time consultations improve your rating and visibility."),

    # ── Both apps ─────────────────────────────────────────────────────
    ("both", "Account", "How do I update my profile photo?",
     "Go to Profile and tap your avatar to upload a new photo. If you signed in with Google, your Google photo is used automatically until you upload your own."),
    ("both", "Support", "How do I contact support?",
     "Open Profile → Customer Support. Check the FAQ first, and if it doesn't help, tap Raise Ticket to send us the details (you can attach up to 2 screenshots). You can track the status and replies under My Tickets."),
    ("both", "Account", "How do I change the app language?",
     "Open Profile → Language and pick your preferred language. The app updates immediately."),
    ("both", "Privacy", "Where can I read the privacy, terms, and refund policies?",
     "They're in Profile → About & Legal, which links to the Privacy Policy, Terms & Conditions, and Refund Policy on nakshatralogy.com."),
]


@router.post("/admin/seed")
def admin_seed_faq(
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Add the recommended default FAQ set. Additive: only inserts entries that
    aren't already present (matched on audience + question), so it's safe to run
    again to pull in new defaults without creating duplicates."""
    existing = {
        (f.audience, (f.question or "").strip().lower())
        for f in db.query(FaqItem).all()
    }
    base = db.query(FaqItem).count()
    added = 0
    for i, (aud, cat, q, a) in enumerate(_DEFAULT_FAQ):
        if (aud, q.strip().lower()) in existing:
            continue
        db.add(FaqItem(audience=aud, category=cat, question=q, answer=a, sort_order=base + i))
        added += 1
    if added:
        db.commit()
    return {"status": "ok", "seeded": added, "skipped": len(_DEFAULT_FAQ) - added}
