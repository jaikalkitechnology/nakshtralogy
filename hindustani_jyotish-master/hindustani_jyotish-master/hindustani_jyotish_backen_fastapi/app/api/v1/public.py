"""Unauthenticated, read-only endpoints for app cold-start / marketing
content.

These are polled before login (maintenance check) or rendered on a public
home screen (promo videos), so: no auth, no heavy joins, minimal response
shape. Admin-side management for both lives in `admin_console.py`
(`/admin/settings/maintenance/{app}`, `/admin/promo-videos`).
"""
from __future__ import annotations

from typing import Literal

from fastapi import APIRouter
from sqlalchemy import select

from app.core.config import settings
from app.core.deps import DBSession
from app.core.media import normalize_media_url
from app.models.admin_content import FAQ, AppSetting, AstrologerVideo, Banner, PromoVideo
from app.models.astrologer import Astrologer
from app.services.astro import pricing

router = APIRouter(tags=["public"])

_MAINTENANCE_DEFAULT = {"enabled": False, "message": ""}


@router.get("/public/maintenance/{app}")
async def public_maintenance(app: Literal["user", "astro"], db: DBSession):
    """Per-app maintenance-mode flag. Each Flutter app polls this at cold
    start (before/without auth) and shows a blocking screen when `enabled`.
    """
    row = await db.get(AppSetting, f"maintenance_{app}")
    value = row.value if row else _MAINTENANCE_DEFAULT
    return {
        "enabled": bool(value.get("enabled", False)),
        "message": value.get("message") or "",
    }


@router.get("/promo-videos")
async def public_promo_videos(db: DBSession):
    """Active promo/feature videos for the home-screen carousel. Public,
    read-only marketing content — no auth required."""
    rows = await db.scalars(
        select(PromoVideo)
        .where(PromoVideo.is_active.is_(True))
        .order_by(PromoVideo.created_at.desc())
    )
    return [
        {
            "id": str(v.id),
            "title": v.title,
            # Normalized at read time — rows uploaded while MEDIA_BASE_URL
            # was the old relative "/media" base carry URLs Flutter cannot
            # load (the exact bug that made admin-added promo videos
            # invisible in the user app); see app/core/media.py.
            "video_url": normalize_media_url(v.video_url),
            "thumbnail_url": normalize_media_url(v.thumbnail_url),
        }
        for v in rows
        if v is not None
    ]


@router.get("/astrologer-videos")
async def public_astrologer_videos(db: DBSession):
    """Active recorded astrologer videos for the public/home video feed.
    Public, read-only content — no auth required. The (optional) linked
    astrologer's name/photo/live-flag are joined in so the app can render a
    profile chip and a "LIVE" badge on each card."""
    rows = await db.execute(
        select(AstrologerVideo, Astrologer)
        .outerjoin(Astrologer, AstrologerVideo.astrologer_id == Astrologer.id)
        .where(AstrologerVideo.is_active.is_(True))
        .order_by(AstrologerVideo.created_at.desc())
    )
    return [
        {
            "id": str(v.id),
            "astrologer_id": str(v.astrologer_id) if v.astrologer_id else None,
            "astrologer_name": a.display_name if a else None,
            "astrologer_photo": normalize_media_url(a.photo_url) if a else None,
            "is_live": bool(a.is_live) if a else False,
            "title": v.title,
            # Same read-time normalization as /promo-videos: rows stored
            # under the legacy relative "/media" base must come back as
            # absolute URLs Flutter can load (see app/core/media.py).
            "video_url": normalize_media_url(v.video_url),
            "thumbnail_url": normalize_media_url(v.thumbnail_url),
        }
        for v, a in rows.all()
    ]


@router.get("/cosmic-services")
async def public_cosmic_services(db: DBSession):
    """Active Cosmic Insights services with their ADMIN-CONFIGURED prices —
    the same rows the charge path bills from, so the prices the app shows
    can never drift from what's actually charged. Public: rendered on the
    insights screen before any purchase."""
    return [
        {"key": c.key, "name": c.name, "price": str(c.price)}
        for c in await pricing.active_services(db)
    ]


_SOCIAL_DEFAULT = {"facebook": "", "instagram": "", "youtube": "", "whatsapp": ""}


@router.get("/banners")
async def public_banners(db: DBSession):
    """Active home-screen banners (admin console → Banners), display order.
    The user app renders these above the Live section."""
    rows = await db.scalars(
        select(Banner)
        .where(Banner.is_active.is_(True))
        .order_by(Banner.position.asc(), Banner.created_at.desc())
    )
    return [
        {
            "id": str(b.id),
            "title": b.title,
            "image_url": normalize_media_url(b.image_url),
            "link_url": b.link_url,
        }
        for b in rows
    ]


@router.get("/privacy-policy")
async def public_privacy_policy(db: DBSession):
    """The admin-configured Privacy Policy URL. `url` is empty when the
    admin has not configured one — the apps then show a friendly
    "not added yet" message instead of a broken link."""
    row = await db.get(AppSetting, "privacy_policy")
    value = row.value if row and isinstance(row.value, dict) else {}
    url = value.get("url")
    return {"url": url if isinstance(url, str) else ""}


@router.get("/support-info")
async def public_support_info(db: DBSession):
    """Admin-configured helpline contact (email + phone). Empty strings when
    not configured — the apps show a friendly message instead of blanks."""
    row = await db.get(AppSetting, "support_contact")
    value = row.value if row and isinstance(row.value, dict) else {}
    return {
        "email": value.get("email") if isinstance(value.get("email"), str) else "",
        "phone": value.get("phone") if isinstance(value.get("phone"), str) else "",
    }


@router.get("/public/faqs/{app}")
async def public_faqs(app: Literal["user", "astro"], db: DBSession, lang: str = "en"):
    """Active FAQ for an app, localized. Returns entries scoped to the given
    app OR ``both``, ordered by ``sort_order``. When ``lang`` is Hindi the
    Hindi text is served, falling back to English per-field when a translation
    is blank. Public, read-only — no auth (rendered in the Help & Support
    screen)."""
    hi = str(lang).lower().startswith("hi")
    rows = await db.scalars(
        select(FAQ)
        .where(FAQ.is_active.is_(True), FAQ.app.in_((app, "both")))
        .order_by(FAQ.sort_order.asc(), FAQ.created_at.asc())
    )
    items = []
    for f in rows:
        question = (f.question_hi or f.question_en) if hi else f.question_en
        answer = (f.answer_hi or f.answer_en) if hi else f.answer_en
        items.append(
            {
                "id": str(f.id),
                "category": f.category,
                "question": question,
                "answer": answer,
            }
        )
    return {"items": items, "lang": "hi" if hi else "en"}


@router.get("/social-links")
async def public_social_links(db: DBSession):
    """The platform's social links as configured in the admin console
    (Settings → Social links). Empty string = not configured; the app hides
    those. Public marketing content — no auth."""
    row = await db.get(AppSetting, "social_links")
    value = row.value if row and isinstance(row.value, dict) else {}
    return {**_SOCIAL_DEFAULT, **{k: v for k, v in value.items() if isinstance(v, str)}}


@router.get("/public/app-config")
async def public_app_config(db: DBSession):
    """Client bootstrap config — everything the two Flutter apps need
    BEFORE anyone is signed in, all fed live from the admin console (no
    app rebuild needed when a credential changes):

    - `google_user_web_client_id` / `google_astro_web_client_id`: each
      app's OAuth *Web* client ID, passed to Google Sign-In as
      `serverClientId`. Null when not configured — the app falls back to
      its compiled-in default and, if that also fails, shows a clear
      "Google login is not configured" message instead of a cryptic
      DEVELOPER_ERROR.
    - `razorpay_key_id`: the PUBLIC Razorpay key (never the secret) for
      the checkout sheet. Null when payments aren't configured.
    - `payments_configured` / `agora_configured` / `google_login_configured`:
      readiness flags so the apps can explain exactly which credential is
      missing instead of failing generically.

    - `firebase_web`: per-app (`user`/`astro`) Firebase WEB app config —
      Firebase's public browser config, admin-managed (console → Firebase)
      so the two Flutter WEB builds can `Firebase.initializeApp` at runtime
      without a rebuild. Each entry carries a `configured` flag (true once
      api_key + web app_id are both present).

    Secrets (Razorpay key secret, Agora certificate, Firebase service
    account) are deliberately never exposed here — the Firebase web config
    is public-by-design browser config, not a secret.
    """
    from app.services import agora_service, firebase_web, razorpay_service
    from app.services.google_auth import client_id_for, google_auth_setting

    fb_web = await firebase_web.firebase_web_setting(db)
    for app_key in ("user", "astro"):
        fb_web[app_key]["configured"] = firebase_web.is_configured(fb_web[app_key])

    google_cfg = await google_auth_setting(db)
    # Per-platform IDs: Android consumes its value as `serverClientId`, web as
    # `clientId`, and the two often belong to DIFFERENT OAuth clients (the web
    # one must carry Authorized JavaScript origins). client_id_for() falls back
    # to the app's web ID when a platform-specific one isn't set.
    google_ids = {
        f"google_{app}_{platform}_client_id": client_id_for(google_cfg, app, platform) or None
        for app in ("user", "astro")
        for platform in ("android", "web")
    }
    agora_creds = await agora_service.resolve_credentials(db)
    razorpay_creds = await razorpay_service.resolve_credentials(db)

    payments_configured = bool(razorpay_creds.key_id and razorpay_creds.key_secret)
    google_configured = bool(
        any(google_ids.values()) or settings.google_client_id_list
    )
    return {
        # Per-app, per-platform (google_user_android_client_id, …). The two
        # legacy `google_{app}_web_client_id` keys above are part of this same
        # set, so older app builds reading them keep working unchanged.
        **google_ids,
        "google_login_configured": google_configured,
        "razorpay_key_id": razorpay_creds.key_id or None,
        "payments_configured": payments_configured,
        "payments_dev_mode": settings.PAYMENTS_DEV_MODE,
        "agora_configured": bool(agora_creds.app_id),
        "firebase_web": fb_web,
    }
