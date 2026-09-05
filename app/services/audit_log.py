"""Admin action audit trail — writes to AuditLog for the admin panel's
Audit Logs page. Best-effort: a logging failure must never break the
action it's recording, so every call swallows its own errors."""

from sqlalchemy.orm import Session

from app.models.model import AuditLog, User, new_uuid


def log_action(
    db: Session,
    admin: User,
    action: str,
    target_type: str = None,
    target_id: str = None,
    target_label: str = None,
    detail: str = None,
) -> None:
    try:
        db.add(AuditLog(
            id=new_uuid(),
            admin_id=admin.id if admin else None,
            admin_email=admin.email if admin else None,
            action=action,
            target_type=target_type,
            target_id=target_id,
            target_label=target_label,
            detail=detail,
        ))
        db.commit()
    except Exception:
        db.rollback()
