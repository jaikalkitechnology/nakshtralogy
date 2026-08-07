"""Support tickets / complaint management (helpdesk).

User + astrologer (get_current_user):
  POST   /support/upload                 — upload one ticket image (≤2 per ticket)
  POST   /support/tickets                — raise a ticket (subject, description, ≤2 images)
  GET    /support/tickets                — my tickets
  GET    /support/tickets/{id}           — ticket + public thread
  POST   /support/tickets/{id}/reply     — add a reply to my ticket
  GET    /support/tickets/file/{y}/{m}/{d}/{name}  — download an attachment

Admin (require_role admin):
  GET    /support/admin/tickets          — all tickets (status/role/search filters)
  GET    /support/admin/tickets/{id}     — full detail incl. internal notes
  POST   /support/admin/tickets/{id}/reply   — reply (public) or internal note; notifies raiser
  PATCH  /support/admin/tickets/{id}/status  — change status; notifies raiser
"""

import os
import uuid
from datetime import datetime
from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from pydantic import BaseModel, Field

from app.core.database import get_db
from app.core.dependencies import get_current_user, require_role
from app.models.model import User, SupportTicket, SupportTicketReply

router = APIRouter()

UPLOAD_DIR = os.path.join("uploads", "support")
_ALLOWED_IMG = {".jpg", ".jpeg", ".png", ".webp", ".gif"}
_MAX_IMG_BYTES = 5 * 1024 * 1024


# ─── Schemas ─────────────────────────────────────────────────────────

class TicketCreate(BaseModel):
    subject: str = Field(..., min_length=2, max_length=200)
    description: str = Field(..., min_length=2)
    category: Optional[str] = None
    priority: str = Field("normal", pattern=r'^(low|normal|high|urgent)$')
    images: List[str] = Field(default_factory=list, max_items=2)


class TicketReplyReq(BaseModel):
    message: str = Field(..., min_length=1, max_length=2000)


class AdminReplyReq(BaseModel):
    message: str = Field(..., min_length=1, max_length=2000)
    is_internal: bool = False


class StatusReq(BaseModel):
    status: str = Field(..., pattern=r'^(pending|in_progress|completed|closed)$')


# ─── Helpers ─────────────────────────────────────────────────────────

def _ticket_dict(t: SupportTicket, replies=None, include_internal=False) -> dict:
    d = {
        "id": t.id, "user_id": t.user_id, "role": t.role,
        "subject": t.subject, "description": t.description,
        "category": t.category, "priority": t.priority, "status": t.status,
        "images": t.images or [], "last_reply_by": t.last_reply_by,
        "created_at": str(t.created_at) if t.created_at else None,
        "updated_at": str(t.updated_at) if t.updated_at else None,
    }
    if replies is not None:
        d["replies"] = [
            {
                "id": r.id, "author": r.author, "message": r.message,
                "is_internal": r.is_internal,
                "created_at": str(r.created_at) if r.created_at else None,
            }
            for r in replies if include_internal or not r.is_internal
        ]
    return d


def _notify_owner(db: Session, ticket: SupportTicket, title: str, body: str, ntype: str):
    """Push + in-app + email the ticket's raiser. Best-effort."""
    owner = db.query(User).filter(User.id == ticket.user_id).first()
    if not owner:
        return
    data = {"type": ntype, "ticket_id": ticket.id}
    try:
        from app.services.fcm_service import notify_generic
        if owner.fcm_token or owner.fcm_token_web:
            role = owner.role if owner.role in ("user", "astrologer") else "user"
            notify_generic(fcm_token=owner.fcm_token, web_token=owner.fcm_token_web,
                           title=title, body=body, role=role, data=data)
    except Exception:
        pass
    try:
        from app.routers.notification_router import save_notification
        save_notification(db, owner.id, title, body, ntype, data)
    except Exception:
        db.rollback()
    try:
        from app.services.email_service import send_email
        if owner.email:
            html = f"""<div style="font-family:Arial,sans-serif;max-width:520px;margin:0 auto;padding:24px;color:#EDE4D0;background:#0B0B1F;">
              <div style="text-align:center;font-weight:800;color:#D4AF37;font-size:20px;">Nakshatralogy Support</div>
              <div style="margin-top:16px;background:#15132e;border:1px solid rgba(212,175,55,.2);border-radius:14px;padding:20px;">
                <h3 style="margin:0 0 8px;color:#D4AF37;">{title}</h3>
                <p style="margin:0;color:#C9C4D6;line-height:1.6;">{body}</p>
                <p style="margin:14px 0 0;color:#8A8298;font-size:12px;">Ticket: {ticket.subject}</p>
              </div></div>"""
            send_email(db, owner.email, title, html)
    except Exception:
        pass


# ─── User / astrologer endpoints ─────────────────────────────────────

@router.post("/upload")
async def upload_ticket_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
):
    """Upload a single ticket attachment (image). Returns a relative media URL."""
    ext = os.path.splitext(file.filename or "")[1].lower()
    if ext not in _ALLOWED_IMG:
        raise HTTPException(status_code=400, detail="Only image files are allowed")
    contents = await file.read()
    if len(contents) > _MAX_IMG_BYTES:
        raise HTTPException(status_code=400, detail="Image too large (max 5 MB)")
    now = datetime.utcnow()
    date_folder = now.strftime("%Y/%m/%d")
    folder = os.path.join(UPLOAD_DIR, date_folder)
    os.makedirs(folder, exist_ok=True)
    unique = f"{uuid.uuid4().hex}{ext}"
    with open(os.path.join(folder, unique), "wb") as f:
        f.write(contents)
    return {"media_url": f"/api/v1/support/file/{date_folder}/{unique}",
            "file_name": file.filename, "file_size": len(contents)}


@router.post("/tickets")
def create_ticket(
    req: TicketCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    role = current_user.role if current_user.role in ("user", "astrologer") else "user"
    ticket = SupportTicket(
        user_id=current_user.id, role=role,
        subject=req.subject.strip(), description=req.description.strip(),
        category=req.category, priority=req.priority,
        images=(req.images or [])[:2], status="pending", last_reply_by="user",
    )
    db.add(ticket)
    db.commit()
    db.refresh(ticket)
    # Auto-acknowledge the raiser.
    _notify_owner(db, ticket,
                  "Ticket received", f"We received your ticket \"{ticket.subject}\" and will get back to you soon.",
                  "ticket_created")
    return _ticket_dict(ticket, replies=[])


@router.get("/tickets")
def my_tickets(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    rows = db.query(SupportTicket).filter(
        SupportTicket.user_id == current_user.id
    ).order_by(SupportTicket.updated_at.desc()).all()
    return {"items": [_ticket_dict(t) for t in rows]}


@router.get("/tickets/{ticket_id}")
def ticket_detail(
    ticket_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    t = db.query(SupportTicket).filter(
        SupportTicket.id == ticket_id, SupportTicket.user_id == current_user.id
    ).first()
    if not t:
        raise HTTPException(status_code=404, detail="Ticket not found")
    replies = db.query(SupportTicketReply).filter(
        SupportTicketReply.ticket_id == t.id
    ).order_by(SupportTicketReply.created_at.asc()).all()
    return _ticket_dict(t, replies=replies, include_internal=False)


@router.post("/tickets/{ticket_id}/reply")
def add_reply(
    ticket_id: str,
    req: TicketReplyReq,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    t = db.query(SupportTicket).filter(
        SupportTicket.id == ticket_id, SupportTicket.user_id == current_user.id
    ).first()
    if not t:
        raise HTTPException(status_code=404, detail="Ticket not found")
    r = SupportTicketReply(ticket_id=t.id, author="user", author_id=current_user.id,
                           message=req.message.strip(), is_internal=False)
    db.add(r)
    t.last_reply_by = "user"
    if t.status == "completed":
        t.status = "in_progress"   # re-open on a new user reply
    db.commit()
    db.refresh(r)
    return {"id": r.id, "author": "user", "message": r.message,
            "created_at": str(r.created_at) if r.created_at else None}


@router.get("/file/{year}/{month}/{day}/{filename}")
def download_support_file(
    year: str, month: str, day: str, filename: str,
    current_user: User = Depends(get_current_user),
):
    path = os.path.join(UPLOAD_DIR, year, month, day, filename)
    if not os.path.exists(path):
        raise HTTPException(status_code=404, detail="File not found")
    return FileResponse(path, filename=filename)


# ─── Admin endpoints ─────────────────────────────────────────────────

@router.get("/admin/tickets")
def admin_list_tickets(
    status: Optional[str] = None,
    role: Optional[str] = None,
    search: Optional[str] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    q = db.query(SupportTicket, User).outerjoin(User, SupportTicket.user_id == User.id)
    if status:
        q = q.filter(SupportTicket.status == status)
    if role:
        q = q.filter(SupportTicket.role == role)
    if search:
        like = f"%{search}%"
        q = q.filter((SupportTicket.subject.like(like)) | (SupportTicket.description.like(like)) | (User.name.like(like)))
    total = q.count()
    # status summary for the tab counters
    from sqlalchemy import func as _f
    counts = dict(db.query(SupportTicket.status, _f.count(SupportTicket.id)).group_by(SupportTicket.status).all())
    rows = q.order_by(SupportTicket.updated_at.desc()).offset(skip).limit(limit).all()
    items = []
    for t, u in rows:
        d = _ticket_dict(t)
        d["user_name"] = u.name if u else None
        d["user_email"] = u.email if u else None
        items.append(d)
    return {"total": total, "counts": counts, "items": items}


@router.get("/admin/tickets/{ticket_id}")
def admin_ticket_detail(
    ticket_id: str,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    t = db.query(SupportTicket).filter(SupportTicket.id == ticket_id).first()
    if not t:
        raise HTTPException(status_code=404, detail="Ticket not found")
    u = db.query(User).filter(User.id == t.user_id).first()
    replies = db.query(SupportTicketReply).filter(
        SupportTicketReply.ticket_id == t.id
    ).order_by(SupportTicketReply.created_at.asc()).all()
    d = _ticket_dict(t, replies=replies, include_internal=True)
    d["user_name"] = u.name if u else None
    d["user_email"] = u.email if u else None
    d["user_phone"] = getattr(u, "phone", None) if u else None
    return d


@router.post("/admin/tickets/{ticket_id}/reply")
def admin_reply(
    ticket_id: str,
    req: AdminReplyReq,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    t = db.query(SupportTicket).filter(SupportTicket.id == ticket_id).first()
    if not t:
        raise HTTPException(status_code=404, detail="Ticket not found")
    r = SupportTicketReply(ticket_id=t.id, author="admin", author_id=current_user.id,
                           message=req.message.strip(), is_internal=req.is_internal)
    db.add(r)
    if not req.is_internal:
        t.last_reply_by = "admin"
        if t.status == "pending":
            t.status = "in_progress"
    db.commit()
    db.refresh(r)
    notify = {"push": False, "email": False, "in_app": False}
    if not req.is_internal:
        _notify_owner(db, t, "Support replied to your ticket",
                      req.message.strip()[:140], "ticket_reply")
        notify = {"notified": True}
    return {"id": r.id, "author": "admin", "message": r.message,
            "is_internal": r.is_internal, "notify": notify,
            "created_at": str(r.created_at) if r.created_at else None}


@router.patch("/admin/tickets/{ticket_id}/status")
def admin_update_status(
    ticket_id: str,
    req: StatusReq,
    current_user: User = Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    t = db.query(SupportTicket).filter(SupportTicket.id == ticket_id).first()
    if not t:
        raise HTTPException(status_code=404, detail="Ticket not found")
    t.status = req.status
    db.commit()
    label = {"pending": "Pending", "in_progress": "In progress",
             "completed": "Completed", "closed": "Closed"}.get(req.status, req.status)
    _notify_owner(db, t, "Ticket status updated",
                  f"Your ticket \"{t.subject}\" is now: {label}.", "ticket_status")
    return {"id": t.id, "status": t.status, "notified": True}
