"""
Email service — SMTP transport backed by admin-editable platform settings.

Configuration lives in `platform_settings` under the `smtp` category (editable
from the admin panel → Settings → Email / SMTP). Values fall back to the
environment-based `settings` (config.py) when a key is not set in the DB, so the
service works out of the box and can be overridden at runtime without a redeploy.

Keys (category = "smtp"):
    host, port, username, password, from_email, from_name, use_tls

Public API:
    get_smtp_config(db)                       -> resolved config dict
    send_email(db, to, subject, html, text)   -> bool (True if sent)
    send_otp_email(db, to, name, otp, ...)     -> bool
"""

from __future__ import annotations

import smtplib
import ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formataddr
from typing import Optional

from sqlalchemy.orm import Session

from app.core.config import settings

SMTP_CATEGORY = "smtp"


def _db_setting(db: Session, key: str) -> Optional[str]:
    """Read a single `smtp` platform setting, or None if unset/empty."""
    try:
        from app.models.model import PlatformSetting

        row = (
            db.query(PlatformSetting)
            .filter(PlatformSetting.category == SMTP_CATEGORY, PlatformSetting.key == key)
            .first()
        )
        val = row.value if row else None
        return val if val not in (None, "") else None
    except Exception:
        return None


def get_smtp_config(db: Session) -> dict:
    """Resolve SMTP config: DB platform_settings first, env config fallback."""
    host = _db_setting(db, "host") or settings.SMTP_HOST
    port_raw = _db_setting(db, "port")
    try:
        port = int(port_raw) if port_raw else settings.SMTP_PORT
    except (TypeError, ValueError):
        port = settings.SMTP_PORT
    username = _db_setting(db, "username") or settings.SMTP_USER
    password = _db_setting(db, "password") or settings.SMTP_PASSWORD
    from_email = _db_setting(db, "from_email") or settings.FROM_EMAIL
    from_name = _db_setting(db, "from_name") or "Nakshatralogy"
    use_tls_raw = _db_setting(db, "use_tls")
    # Default to TLS on unless explicitly disabled.
    use_tls = True if use_tls_raw is None else str(use_tls_raw).strip().lower() in ("1", "true", "yes", "on")
    return {
        "host": host,
        "port": port,
        "username": username,
        "password": password,
        "from_email": from_email,
        "from_name": from_name,
        "use_tls": use_tls,
    }


def send_email(
    db: Session,
    to: str,
    subject: str,
    html: str,
    text: Optional[str] = None,
) -> bool:
    """Send an email via the configured SMTP server.

    Returns True on success. Returns False (and logs) when SMTP is not
    configured or the send fails — callers decide whether that is fatal. The OTP
    flow treats a False here as a hard error so users are never left waiting for
    an email that will never arrive.
    """
    cfg = get_smtp_config(db)
    if not cfg["host"] or not cfg["from_email"]:
        print("[email_service] SMTP not configured (missing host/from_email) — email not sent")
        return False

    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"] = formataddr((cfg["from_name"], cfg["from_email"]))
    msg["To"] = to
    if text:
        msg.attach(MIMEText(text, "plain", "utf-8"))
    msg.attach(MIMEText(html, "html", "utf-8"))

    try:
        if cfg["port"] == 465:
            # Implicit TLS (SMTPS).
            context = ssl.create_default_context()
            with smtplib.SMTP_SSL(cfg["host"], cfg["port"], context=context, timeout=20) as server:
                if cfg["username"]:
                    server.login(cfg["username"], cfg["password"] or "")
                server.sendmail(cfg["from_email"], [to], msg.as_string())
        else:
            with smtplib.SMTP(cfg["host"], cfg["port"], timeout=20) as server:
                if cfg["use_tls"]:
                    server.starttls(context=ssl.create_default_context())
                if cfg["username"]:
                    server.login(cfg["username"], cfg["password"] or "")
                server.sendmail(cfg["from_email"], [to], msg.as_string())
        return True
    except Exception as exc:  # noqa: BLE001 — surface any SMTP failure as a soft False
        print(f"[email_service] send failed to {to}: {exc}")
        return False


def _otp_html(name: str, otp: str, minutes: int, purpose: str) -> str:
    """Branded OTP email body (inline styles for broad client support)."""
    greeting = f"Hi {name}," if name else "Hello,"
    return f"""\
<div style="margin:0;padding:0;background:#0B0B1F;font-family:Arial,Helvetica,sans-serif;">
  <div style="max-width:480px;margin:0 auto;padding:32px 24px;">
    <div style="text-align:center;margin-bottom:24px;">
      <span style="font-size:22px;font-weight:700;color:#D4AF37;letter-spacing:0.5px;">Nakshatralogy</span>
    </div>
    <div style="background:#15152e;border:1px solid #2a2a45;border-radius:16px;padding:28px 24px;color:#EDEDF2;">
      <p style="margin:0 0 12px;font-size:15px;">{greeting}</p>
      <p style="margin:0 0 20px;font-size:14px;color:#B8B8CC;">Use the verification code below to {purpose}. This code expires in {minutes} minutes.</p>
      <div style="text-align:center;margin:24px 0;">
        <span style="display:inline-block;font-size:34px;font-weight:700;letter-spacing:10px;color:#D4AF37;background:#0B0B1F;border:1px solid #D4AF37;border-radius:12px;padding:14px 22px;">{otp}</span>
      </div>
      <p style="margin:16px 0 0;font-size:12px;color:#8888a0;">If you didn't request this, you can safely ignore this email.</p>
    </div>
    <p style="text-align:center;margin:20px 0 0;font-size:11px;color:#6a6a80;">© Nakshatralogy · Jaikalki Technology Pvt Ltd</p>
  </div>
</div>"""


def send_otp_email(
    db: Session,
    to: str,
    name: str,
    otp: str,
    minutes: int = 10,
    purpose: str = "verify your email address",
) -> bool:
    """Send a one-time password to `to`. Returns True on success."""
    subject = f"{otp} is your Nakshatralogy verification code"
    text = (
        f"{('Hi ' + name) if name else 'Hello'},\n\n"
        f"Your Nakshatralogy verification code is: {otp}\n"
        f"It expires in {minutes} minutes.\n\n"
        f"If you didn't request this, ignore this email.\n"
    )
    return send_email(db, to=to, subject=subject, html=_otp_html(name, otp, minutes, purpose), text=text)
