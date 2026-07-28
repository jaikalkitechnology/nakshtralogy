"""
Notification Router
====================
GET  /notifications          — list user's notifications (newest first)
GET  /notifications/unread   — unread count
POST /notifications/{id}/read — mark one as read
POST /notifications/read-all  — mark all as read
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.dependencies import get_current_user, get_lang_user
from app.core.i18n import get_lang, t
from app.models.model import Notification, User

router = APIRouter()


def save_notification(db, user_id: str, title: str, body: str, notif_type: str, data: dict = None):
    n = Notification(user_id=user_id, title=title, body=body, notif_type=notif_type, data_json=data)
    db.add(n)
    db.commit()


@router.get("")
def list_notifications(
    skip: int = 0, limit: int = 50,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    notifs = (
        db.query(Notification)
        .filter(Notification.user_id == current_user.id)
        .order_by(Notification.created_at.desc())
        .offset(skip).limit(limit)
        .all()
    )
    return {
        "items": [
            {
                "id": n.id,
                "title": n.title,
                "body": n.body,
                "type": n.notif_type,
                "data": n.data_json,
                "is_read": n.is_read,
                "created_at": str(n.created_at) if n.created_at else None,
            }
            for n in notifs
        ],
        "unread": db.query(Notification).filter(
            Notification.user_id == current_user.id,
            Notification.is_read == False,
        ).count(),
    }


@router.get("/unread")
def unread_count(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    count = db.query(Notification).filter(
        Notification.user_id == current_user.id,
        Notification.is_read == False,
    ).count()
    return {"unread": count}


@router.post("/{notif_id}/read")
def mark_read(
    notif_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
    lang: str = Depends(get_lang_user),
):
    n = db.query(Notification).filter(
        Notification.id == notif_id,
        Notification.user_id == current_user.id,
    ).first()
    if not n:
        raise HTTPException(404, t("err.notification_not_found", lang))
    n.is_read = True
    db.commit()
    return {"status": "ok"}


@router.post("/read-all")
def mark_all_read(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    db.query(Notification).filter(
        Notification.user_id == current_user.id,
        Notification.is_read == False,
    ).update({"is_read": True})
    db.commit()
    return {"status": "ok"}
