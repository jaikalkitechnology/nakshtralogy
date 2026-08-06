"""FCM token ownership helper.

A device (phone / browser) has ONE FCM token. When someone logs out and a
different account logs in on the same device, that token must move to the new
account — and must NOT stay attached to the previous one, or the previous
account's notifications would be delivered to whoever is now using the device.

`claim_token` enforces "one token → exactly one account" by clearing the token
from any other user before assigning it to the current one. This is the reliable
fix even if the previous session never logged out cleanly (browser closed,
session expired): the new login re-claims the token.
"""

from sqlalchemy.orm import Session

from app.models.model import User


def claim_token(db: Session, user: User, token: str, is_web: bool) -> None:
    """Assign `token` to `user` (web or native), removing it from every other
    account that still holds it. Does not commit."""
    token = (token or "").strip()
    if not token:
        return
    col = User.fcm_token_web if is_web else User.fcm_token
    # Detach the token from any OTHER user first.
    db.query(User).filter(col == token, User.id != user.id).update(
        {col: None}, synchronize_session=False
    )
    if is_web:
        user.fcm_token_web = token
    else:
        user.fcm_token = token


def clear_stale_token(db: Session, user: User, token: str) -> bool:
    """Remove a token that FCM reported as unregistered/invalid from whichever
    column holds it. Called after a failed send so a stale token (e.g. an iOS
    web token that rotated) is dropped and the app re-registers a fresh one on
    its next open. Returns True if something was cleared."""
    token = (token or "").strip()
    if not token:
        return False
    cleared = False
    if user.fcm_token == token:
        user.fcm_token = None
        cleared = True
    if user.fcm_token_web == token:
        user.fcm_token_web = None
        cleared = True
    if cleared:
        db.commit()
    return cleared


def release_token(db: Session, user: User, token: str) -> None:
    """On logout: clear this token from the user (both native + web columns) so a
    logged-out account stops receiving pushes on this device."""
    token = (token or "").strip()
    if user.fcm_token and (not token or user.fcm_token == token):
        user.fcm_token = None
    if user.fcm_token_web and (not token or user.fcm_token_web == token):
        user.fcm_token_web = None
