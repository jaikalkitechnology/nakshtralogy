"""Application settings, loaded from environment / .env file."""
from __future__ import annotations

from functools import lru_cache

from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", extra="ignore"
    )

    # App
    APP_NAME: str = "Hindustani Jyotish API"
    ENVIRONMENT: str = "local"
    DEBUG: bool = True
    API_V1_PREFIX: str = "/v1"

    CORS_ORIGINS: str = "*"

    # Database — async SQLAlchemy URL (MySQL via aiomysql in every real env).
    # Special characters in the password MUST be percent-encoded (@ -> %40,
    # # -> %23) or SQLAlchemy will misparse the URL. Prefer setting DATABASE_URL
    # via the environment / .env instead of committing real credentials here.
    DATABASE_URL: str = "mysql+aiomysql://sameerbangkokumeed:Sameer1313umeed@localhost/hindustani_jyotish"
    # JWT — override in every non-local environment (see _warn_on_insecure_config).




    JWT_SECRET: str = "change-me-in-production-please"
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 15
    REFRESH_TOKEN_EXPIRE_DAYS: int = 30

    # Google Sign-In — comma-separated accepted client IDs (audiences).
    # These are the public OAuth client IDs for the two apps (they also ship
    # inside the APKs), so they are safe to default here; override via env in
    # other environments.
    #
    # The first two are the WEB client ids (user app, astro app) — the ones
    # each app passes as `serverClientId`, which is what actually becomes the
    # idToken's audience. The last two are the ANDROID client ids, kept for
    # backward compatibility with any installed build from before the apps
    # were corrected to pass the web ids (an Android id as serverClientId
    # doesn't work on-device anyway, but keeping them accepted here is
    # harmless and costs nothing).
    GOOGLE_CLIENT_IDS: str = (
        "892936615659-edoq5gafttfj1qs5mruv2ajppget8vlm.apps.googleusercontent.com,"
        "892936615659-1ba3hqq7bmnj1hcukjreq2n805kaj3du.apps.googleusercontent.com,"
        "892936615659-cb85ph8d209u9g94og1usprqffigns22.apps.googleusercontent.com,"
        "892936615659-ov54962d8n0prsugt2vav7umfmpfuom5.apps.googleusercontent.com"
    )

    # OTP
    OTP_EXPIRE_MINUTES: int = 5
    OTP_LENGTH: int = 6
    # Per-identifier (mobile or email) minimum gap between OTP requests.
    # Replaces an earlier "N per hour, then blocked for an hour" design —
    # that made ordinary repeated login/logout during dev/testing painful
    # (one 1-hour lockout after a handful of requests) without actually
    # stopping a determined abuser (they'd just wait it out too). A short
    # cooldown between individual requests blocks rapid-fire spam/double-tap
    # just as effectively, with no long lockout for legitimate use. Enabled
    # by default — set OTP_RATE_LIMIT_ENABLED=false in a local .env to drop
    # it entirely for local dev. Production should always leave it enabled.
    OTP_RATE_LIMIT_ENABLED: bool = True
    OTP_RESEND_COOLDOWN_SECONDS: int = 3
    OTP_RATE_PER_DAY_PER_IP: int = 30
    OTP_DEV_MODE: bool = True
    MSG91_AUTH_KEY: str = ""
    MSG91_TEMPLATE_ID: str = ""

    # Redis (optional in Phase 1)
    REDIS_URL: str = "redis://localhost:6379/0"

    # ── Phase 2 · Consultations ───────────────────────────────────────
    # Agora real-time A/V — tokens minted server-side (HMAC). No creds in
    # local/dev → a clearly-marked dev placeholder token is returned instead.
    AGORA_APP_ID: str = ""
    AGORA_APP_CERTIFICATE: str = ""
    # Agora RTC token lifetime. Default to Agora's max (24h) so a token minted
    # at accept/start can't expire mid-consultation. Used when an
    # agora_settings row leaves token_expire_seconds unset/0.
    AGORA_TOKEN_EXPIRE_SECONDS: int = 86400

    # Platform commission taken from each consultation charge (0.0–1.0).
    COMMISSION_RATE: float = 0.25
    # Pre-call wallet check: balance must cover at least this many minutes.
    MIN_PRECALL_MINUTES: int = 5
    # Caps for a chat session.
    CHAT_MESSAGE_CAP: int = 50

    # ── Phase 3 · Kundli & Cosmic Insights ────────────────────────────
    # Nakshatralogy — external Vedic-astrology computation provider
    # (https://api.nakshatralogy.com). The Bearer key is NEVER committed:
    # set it via env / .env only (see .env.example). Empty key → the
    # internal stub engine is used for every insight (dev/CI-safe).
    NAKSHATRALOGY_API_KEY: str = ""
    NAKSHATRALOGY_BASE_URL: str = "https://api.nakshatralogy.com"
    NAKSHATRALOGY_TIMEOUT_SECONDS: float = 45.0
    DEFAULT_AYANAMSA: str = "lahiri"          # lahiri | raman | kp
    DEFAULT_TZ_OFFSET_MINUTES: int = 330      # IST (+05:30)
    DEFAULT_LATITUDE: float = 28.6139         # New Delhi, fallback birth place
    DEFAULT_LONGITUDE: float = 77.2090
    # Local object storage for generated PDFs (S3/R2 in production).
    MEDIA_ROOT: str = "static"
    MEDIA_BASE_URL: str = "https://fastapi.hindustanijyotish.com/static"

    # ── Phase 4 · Astrologer portal & Admin ───────────────────────────
    # Auto-offline an astrologer if no heartbeat within this window.
    ASTROLOGER_OFFLINE_AFTER_SECONDS: int = 90
    # Seed admin (created by `python -m app.core.dev_init` when both are set).
    ADMIN_EMAIL: str = ""
    ADMIN_PASSWORD: str = ""
    # One-time token required to create additional admins via POST /admin/create-admin
    # once the first (bootstrap) admin exists. Empty → additional admins are refused.
    ADMIN_SETUP_TOKEN: str = ""

    # ── Observability (optional) ──────────────────────────────────────
    # Sentry DSN — when empty, Sentry init is a no-op (dev/CI unaffected).
    SENTRY_DSN: str = ""

    # ── Push notifications (Firebase Cloud Messaging) ─────────────────
    # Path to the Firebase Admin SDK service-account JSON (kept out of git).
    # When missing / unreadable, push sends are no-ops (dev-safe).
    FIREBASE_CREDENTIALS_PATH: str = "firebase-service-account.json"
    # Force-disable push (e.g. tests) even if a credentials file exists.
    PUSH_ENABLED: bool = True

    # ── Phase 6 · Wallet, Payments & Payouts (Razorpay) ───────────────
    # Live publishable Key ID, hardcoded as the default so the apps + admin
    # panel are wired to this Razorpay account out of the box. The Key ID is a
    # PUBLIC identifier (it ships in the client checkout), NOT a secret. The Key
    # Secret is required to create real orders + verify payments and is added
    # separately in the admin console (Settings → Razorpay); until it is,
    # recharges return a clear "add the Key Secret" error rather than a charge.
    RAZORPAY_KEY_ID: str = "rzp_live_OgYPmBDL7Q7dZS"
    RAZORPAY_KEY_SECRET: str = ""
    RAZORPAY_WEBHOOK_SECRET: str = ""
    # When true (no keys), recharge orders/signatures are simulated for local dev.
    PAYMENTS_DEV_MODE: bool = True

    RECHARGE_MIN: int = 10
    RECHARGE_MAX: int = 50000
    # Recharges at/above this amount require a fresh biometric attestation.
    BIOMETRIC_RECHARGE_THRESHOLD: int = 1000

    # Astrologer withdrawals
    MIN_WITHDRAWAL: int = 500
    # In dev, payouts are auto-marked paid; in prod a Celery worker settles them.
    PAYOUT_AUTO_PROCESS: bool = True

    # ── Admin schema auto-sync ("auto mode") ──────────────────────────
    # Default for the additive schema-sync auto-apply-on-startup toggle. The
    # live value is read from the `app_settings` row (admin-controlled); this
    # env flag is only the fallback when no row has been written yet. Additive
    # only — never drops or alters existing columns.
    AUTO_SCHEMA_SYNC: bool = True

    @property
    def cors_origin_list(self) -> list[str]:
        if self.CORS_ORIGINS.strip() == "*":
            return ["*"]
        return [o.strip() for o in self.CORS_ORIGINS.split(",") if o.strip()]

    @property
    def google_client_id_list(self) -> list[str]:
        return [c.strip() for c in self.GOOGLE_CLIENT_IDS.split(",") if c.strip()]

    @field_validator("ENVIRONMENT")
    @classmethod
    def _normalise_env(cls, v: str) -> str:
        return v.lower()


_DEFAULT_JWT_SECRET = "change-me-in-production-please"


def warn_on_insecure_config(s: "Settings") -> list[str]:
    """Emit loud warnings for insecure/unset secrets outside local dev.

    Returns the list of warning messages (also logged) so callers/tests can
    assert on them. In `local` the checks are informational only.
    """
    import logging

    logger = logging.getLogger("app.config")
    warnings: list[str] = []

    if s.JWT_SECRET == _DEFAULT_JWT_SECRET:
        warnings.append(
            "JWT_SECRET is still the built-in default — set a strong secret via env."
        )
    if s.ENVIRONMENT != "local":
        if not s.JWT_SECRET or s.JWT_SECRET == _DEFAULT_JWT_SECRET:
            warnings.append(
                f"ENVIRONMENT={s.ENVIRONMENT} but JWT_SECRET looks unset/default."
            )
        if "hj_user:hj_password@localhost" in s.DATABASE_URL:
            warnings.append(
                f"ENVIRONMENT={s.ENVIRONMENT} but DATABASE_URL is the local placeholder."
            )

    for msg in warnings:
        logger.warning("INSECURE CONFIG: %s", msg)
    return warnings


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
