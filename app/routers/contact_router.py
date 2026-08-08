"""Contact Us — public website enquiry form → admin query management.

Public:
  GET  /contact/captcha   — issue a stateless HMAC-signed math challenge
  POST /contact           — submit an enquiry (captcha + honeypot verified)
Admin (require_role admin):
  GET   /contact/admin              — list / filter / search enquiries
  GET   /contact/admin/{id}         — one enquiry + its reply thread
  PATCH /contact/admin/{id}         — update status / add an internal note
  POST  /contact/admin/{id}/reply   — reply to the submitter (emails them)

Spam / injection guard: a server-verified arithmetic captcha (the answer is
signed into the token, never trusted from the client) plus a hidden honeypot
field and strict length caps. Operational plumbing only — no astrology logic.
"""

import hashlib
import hmac
import random
import re
from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, Request
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import get_db
from app.core.dependencies import require_role
from app.models.model import ContactMessage, ContactReply

router = APIRouter()

SUPPORT_EMAIL = "support@jaikalki.com"
_CAPTCHA_TTL = 15 * 60  # seconds
_MAX_MSG = 4000


# ── Math captcha (stateless, HMAC-signed) ─────────────────────────────

def _sign(payload: str) -> str:
    return hmac.new(settings.SECRET_KEY.encode(), payload.encode(), hashlib.sha256).hexdigest()[:24]


def _make_captcha() -> dict:
    a, b = random.randint(2, 9), random.randint(2, 9)
    op = random.choice(["+", "×"])
    answer = a * b if op == "×" else a + b
    exp = int(datetime.utcnow().timestamp()) + _CAPTCHA_TTL
    body = f"{answer}.{exp}"
    return {"question": f"{a} {op} {b}", "token": f"{body}.{_sign(body)}", "expires_in": _CAPTCHA_TTL}


def _verify_captcha(token: str, answer: str) -> bool:
    try:
        expected, exp, sig = token.split(".")
        if _sign(f"{expected}.{exp}") != sig:
            return False
        if int(exp) < int(datetime.utcnow().timestamp()):
            return False
        return str(answer).strip() == str(expected).strip()
    except Exception:
        return False


@router.get("/captcha")
def get_captcha():
    """Issue a fresh math challenge. The correct answer is signed into the token
    (never sent in the clear), so the client cannot forge a valid submission."""
    return {"status": "ok", "data": _make_captcha()}


# ── Public submit ─────────────────────────────────────────────────────

_CTRL = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f]")


def _clean(s: Optional[str], limit: int) -> str:
    if not s:
        return ""
    return _CTRL.sub("", str(s)).strip()[:limit]


class ContactSubmit(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    email: EmailStr
    phone: Optional[str] = Field(None, max_length=40)
    subject: Optional[str] = Field(None, max_length=120)
    message: str = Field(..., min_length=5, max_length=_MAX_MSG)
    lang: Optional[str] = Field(None, max_length=20)
    captcha_token: str = Field(..., max_length=120)
    captcha_answer: str = Field(..., max_length=12)
    # Honeypot — must stay empty; bots tend to fill every field.
    company: Optional[str] = Field(None, max_length=200)


@router.post("", status_code=201)
def submit_contact(req: ContactSubmit, request: Request, db: Session = Depends(get_db)):
    # Honeypot: a real user never sees or fills this. Pretend success for bots.
    if (req.company or "").strip():
        return {"status": "ok", "message": "Thanks — we'll get back to you soon."}

    if not _verify_captcha(req.captcha_token, req.captcha_answer):
        raise HTTPException(status_code=400, detail="Incorrect answer to the verification question. Please try again.")

    headers = {k.lower(): v for k, v in request.headers.items()}
    from app.core import region as region_util
    ip = region_util.client_ip_from_headers(headers, request.client.host if request.client else None)

    msg = ContactMessage(
        name=_clean(req.name, 150),
        email=str(req.email).strip()[:200],
        phone=_clean(req.phone, 40) or None,
        subject=_clean(req.subject, 120) or None,
        message=_clean(req.message, _MAX_MSG),
        source="website",
        status="new",
        lang=_clean(req.lang, 20) or None,
        ip=(ip or "")[:64] or None,
        user_agent=_clean(headers.get("user-agent"), 400) or None,
    )
    db.add(msg)
    db.commit()

    # Best-effort notify support (never blocks the submission).
    try:
        from app.services.email_service import send_email
        html = (f"<p><b>New website enquiry</b></p>"
                f"<p><b>Name:</b> {msg.name}<br>"
                f"<b>Email:</b> {msg.email}<br>"
                f"<b>Phone:</b> {msg.phone or '-'}<br>"
                f"<b>Subject:</b> {msg.subject or '-'}</p>"
                f"<p>{(msg.message or '').replace(chr(10), '<br>')}</p>"
                f"<hr><p style='color:#888'>Sent from nakshatralogy.com — manage in the admin panel.</p>")
        send_email(db, to=SUPPORT_EMAIL, subject=f"[Website] {msg.subject or 'General enquiry'}", html=html)
    except Exception:
        pass

    return {"status": "ok", "message": "Thanks — we'll get back to you soon."}


# ── Admin ─────────────────────────────────────────────────────────────

def _serialize(m: ContactMessage, replies=None) -> dict:
    d = {
        "id": m.id, "name": m.name, "email": m.email, "phone": m.phone,
        "subject": m.subject, "message": m.message, "source": m.source,
        "status": m.status, "lang": m.lang, "ip": m.ip, "admin_note": m.admin_note,
        "last_reply_at": m.last_reply_at.isoformat() if m.last_reply_at else None,
        "created_at": m.created_at.isoformat() if m.created_at else None,
        "resolved_at": m.resolved_at.isoformat() if m.resolved_at else None,
    }
    if replies is not None:
        d["replies"] = [
            {"id": r.id, "body": r.body, "emailed": r.emailed,
             "created_at": r.created_at.isoformat() if r.created_at else None}
            for r in replies
        ]
    return d


@router.get("/admin")
def admin_list_contact(
    status: Optional[str] = Query(None),
    q: Optional[str] = Query(None, description="search name/email/message"),
    skip: int = 0,
    limit: int = Query(50, ge=1, le=200),
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    qry = db.query(ContactMessage)
    if status and status != "all":
        qry = qry.filter(ContactMessage.status == status)
    if q:
        like = f"%{q.strip()}%"
        qry = qry.filter(
            (ContactMessage.name.ilike(like))
            | (ContactMessage.email.ilike(like))
            | (ContactMessage.message.ilike(like))
        )
    total = qry.count()
    new_count = db.query(ContactMessage).filter(ContactMessage.status == "new").count()
    rows = qry.order_by(ContactMessage.created_at.desc()).offset(skip).limit(limit).all()
    return {"total": total, "new": new_count, "items": [_serialize(m) for m in rows]}


@router.get("/admin/{msg_id}")
def admin_get_contact(
    msg_id: str,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    m = db.query(ContactMessage).filter(ContactMessage.id == msg_id).first()
    if not m:
        raise HTTPException(status_code=404, detail="Not found")
    if m.status == "new":       # opening a new query marks it read
        m.status = "read"
        db.commit()
    replies = db.query(ContactReply).filter(ContactReply.message_id == m.id).order_by(ContactReply.created_at.asc()).all()
    return _serialize(m, replies)


class ContactUpdate(BaseModel):
    status: Optional[str] = Field(None, pattern=r"^(new|read|replied|resolved|spam)$")
    admin_note: Optional[str] = Field(None, max_length=2000)


@router.patch("/admin/{msg_id}")
def admin_update_contact(
    msg_id: str,
    req: ContactUpdate,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    m = db.query(ContactMessage).filter(ContactMessage.id == msg_id).first()
    if not m:
        raise HTTPException(status_code=404, detail="Not found")
    if req.status is not None:
        m.status = req.status
        m.resolved_at = datetime.utcnow() if req.status == "resolved" else None
    if req.admin_note is not None:
        m.admin_note = req.admin_note
    m.handled_by = getattr(current_user, "id", None)
    db.commit()
    return _serialize(m)


class ContactReplyRequest(BaseModel):
    body: str = Field(..., min_length=1, max_length=6000)
    resolve: bool = False   # also mark the query resolved after replying


@router.post("/admin/{msg_id}/reply")
def admin_reply_contact(
    msg_id: str,
    req: ContactReplyRequest,
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Reply to the submitter — records the reply and emails it to them."""
    m = db.query(ContactMessage).filter(ContactMessage.id == msg_id).first()
    if not m:
        raise HTTPException(status_code=404, detail="Not found")

    emailed = False
    try:
        from app.services.email_service import send_email
        safe = req.body.replace("\n", "<br>")
        html = (f"<p>Hi {m.name or 'there'},</p>"
                f"<p>{safe}</p>"
                f"<hr><p style='color:#888;font-size:12px'>In reply to your message to Nakshatralogy"
                f"{(': ' + m.subject) if m.subject else ''}. You can simply reply to this email.</p>")
        emailed = bool(send_email(
            db, to=m.email,
            subject=f"Re: {m.subject or 'Your enquiry'} — Nakshatralogy",
            html=html, text=req.body,
        ))
    except Exception:
        emailed = False

    reply = ContactReply(
        message_id=m.id, admin_id=getattr(current_user, "id", None),
        body=req.body.strip(), emailed=emailed,
    )
    db.add(reply)
    m.last_reply_at = datetime.utcnow()
    m.status = "resolved" if req.resolve else "replied"
    if req.resolve:
        m.resolved_at = datetime.utcnow()
    m.handled_by = getattr(current_user, "id", None)
    db.commit()
    db.refresh(reply)

    if not emailed:
        # The reply is saved, but SMTP failed/not configured — tell the admin.
        return {"status": "ok", "emailed": False,
                "detail": "Reply saved, but the email could not be sent (check SMTP settings).",
                "reply_id": reply.id}
    return {"status": "ok", "emailed": True, "reply_id": reply.id}
