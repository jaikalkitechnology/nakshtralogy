"""Google ID-token verification.

Verifies the token signature against Google's public keys and checks the
audience against the configured client IDs. Returns the normalised profile.

Client-ID configuration is resolved at call time in this order (same
DB-first pattern as `agora_service`/`razorpay_service`):
  1. the `google_auth` row in the `app_settings` table (set from the admin
     console — Settings → Google Login),
  2. the GOOGLE_CLIENT_IDS environment setting.

The setting is per app (`user`/`astro`) AND per platform
(`android`/`web`), because the two platforms consume the ID differently and
often need DIFFERENT OAuth clients:

* **Android** passes it as `serverClientId`. It must be an OAuth client of
  type *Web application*; Android's own client is matched separately by
  package name + SHA-1 from `google-services.json` and never appears here.
* **Web** passes it as `clientId`, and the OAuth client behind it must list
  the site's URL under *Authorized JavaScript origins* (see
  blue_print/WEB_SETUP.md). That is usually a different Web client from the
  one Android uses, which is why they are configured separately.

Both are accepted as ID-token audiences here, so a token minted for either
platform verifies. Every value is also served to the apps via the public
`GET /v1/public/app-config`, so credentials can be rotated from the admin
console with no app rebuild.
"""
from __future__ import annotations

from dataclasses import dataclass

from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import settings


class GoogleAuthError(Exception):
    """Raised when a Google ID token fails verification."""


GOOGLE_AUTH_SETTING_KEY = "google_auth"

APPS = ("user", "astro")
PLATFORMS = ("android", "web")

# One field per (app, platform), plus a free list of extra allowed audiences
# (e.g. an iOS client, or a legacy client kept working during a rotation).
_CLIENT_ID_FIELDS = tuple(f"{app}_{platform}_client_id" for app in APPS for platform in PLATFORMS)

# The public URL each app's WEB build is served from. Not consumed by the
# apps — it exists so the console can show the admin the exact string to
# register under "Authorized JavaScript origins" in Google Cloud Console,
# which is what the browser sign-in flow validates against.
_ORIGIN_FIELDS = tuple(f"{app}_web_origin" for app in APPS)

GOOGLE_AUTH_DEFAULT: dict = {
    **{f: "" for f in _CLIENT_ID_FIELDS},
    **{f: "" for f in _ORIGIN_FIELDS},
    "extra_client_ids": [],
}


def normalise_origin(value: str) -> str:
    """Reduce a pasted URL to the scheme://host[:port] form Google requires.

    Google rejects an origin with a path or a trailing slash, and those are
    the two things people paste most often, so normalise rather than making
    the admin get it exactly right by hand.
    """
    raw = (value or "").strip()
    if not raw:
        return ""
    if "://" not in raw:
        raw = f"https://{raw}"
    from urllib.parse import urlsplit

    parts = urlsplit(raw)
    if not parts.hostname:
        return ""
    netloc = parts.hostname
    if parts.port:
        netloc = f"{netloc}:{parts.port}"
    return f"{parts.scheme}://{netloc}"


def client_id_for(cfg: dict, app: str, platform: str) -> str:
    """The client ID to hand `app` on `platform`.

    Falls back to that app's WEB client ID when the platform-specific one is
    blank: Android's `serverClientId` must be a *Web application* client
    anyway, so a deployment that has only ever configured one Web client
    keeps working unchanged (this is also what preserves behaviour for rows
    saved before the per-platform split existed).
    """
    return cfg.get(f"{app}_{platform}_client_id") or cfg.get(f"{app}_web_client_id") or ""


async def google_auth_setting(db: AsyncSession) -> dict:
    """The admin-configured Google-login setting, normalised to the
    [GOOGLE_AUTH_DEFAULT] shape (missing/malformed fields become their
    defaults, never a KeyError downstream)."""
    from app.models.admin_content import AppSetting

    row = await db.get(AppSetting, GOOGLE_AUTH_SETTING_KEY)
    return normalise(row.value if row else None)


def normalise(value: object) -> dict:
    """Normalise an arbitrary stored/PUT payload to the canonical shape.

    Accepts the pre-split shape (`user_web_client_id`/`astro_web_client_id`
    only) unchanged — those keys are part of the new shape too, and the
    android fields simply stay blank and fall back via [client_id_for].
    """
    src = value if isinstance(value, dict) else {}
    out: dict = {f: str(src.get(f) or "").strip() for f in _CLIENT_ID_FIELDS}
    for f in _ORIGIN_FIELDS:
        out[f] = normalise_origin(str(src.get(f) or ""))
    extra = src.get("extra_client_ids")
    out["extra_client_ids"] = (
        [str(x).strip() for x in extra if str(x).strip()] if isinstance(extra, list) else []
    )
    return out


async def resolve_google_audiences(db: AsyncSession) -> list[str]:
    """Allowed ID-token audiences: every admin-configured client ID (all
    apps, all platforms, plus extras), with the GOOGLE_CLIENT_IDS env
    setting as fallback when nothing is configured."""
    cfg = await google_auth_setting(db)
    ids = [cfg[f] for f in _CLIENT_ID_FIELDS if cfg[f]] + list(cfg["extra_client_ids"])
    deduped = list(dict.fromkeys(ids))
    return deduped or settings.google_client_id_list


@dataclass
class GoogleProfile:
    google_id: str
    email: str | None
    name: str | None
    picture: str | None


def verify_google_id_token(
    id_token_str: str, audiences: list[str] | None = None
) -> GoogleProfile:
    """Verify a Google ID token and return the profile.

    ``audiences`` is the allowed client-ID list — pass the result of
    [resolve_google_audiences] so admin-configured IDs are honoured; when
    omitted (legacy callers/tests) the env-configured list is used directly.

    Imports google-auth lazily so the rest of the app (and the test suite)
    does not require network access just to import this module.
    """
    from google.auth.transport import requests as google_requests
    from google.oauth2 import id_token as google_id_token

    if audiences is None:
        audiences = settings.google_client_id_list
    try:
        request = google_requests.Request()
        # When no client IDs are configured we still verify the signature/issuer
        # but skip the audience check (useful for early integration).
        claims = google_id_token.verify_oauth2_token(
            id_token_str,
            request,
            audience=audiences[0] if len(audiences) == 1 else None,
        )
    except Exception as exc:  # noqa: BLE001 — surface as a domain error
        raise GoogleAuthError(str(exc)) from exc

    if claims.get("iss") not in (
        "accounts.google.com",
        "https://accounts.google.com",
    ):
        raise GoogleAuthError("Invalid token issuer")

    if audiences and len(audiences) > 1 and claims.get("aud") not in audiences:
        raise GoogleAuthError("Token audience not allowed")

    sub = claims.get("sub")
    if not sub:
        raise GoogleAuthError("Token missing subject")

    # Normalize the same way as the email-OTP schemas (strip + lowercase) so
    # a user signing up via Google with `Foo@x.com` resolves to the same
    # account as one who later logs in via email OTP with `foo@x.com`.
    # Google's claim is almost always already lowercase, but this makes the
    # invariant explicit rather than relying on that.
    email = claims.get("email")
    if email:
        email = email.strip().lower()

    return GoogleProfile(
        google_id=sub,
        email=email,
        name=claims.get("name"),
        picture=claims.get("picture"),
    )
