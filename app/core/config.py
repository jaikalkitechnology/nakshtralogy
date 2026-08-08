"""Application configuration via environment variables."""

import os
from typing import Optional

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass


class Settings:
    APP_NAME: str = "Nakshtralogy"
    APP_VERSION: str = "2.0.0"
    DEBUG: bool = os.getenv("DEBUG", "false").lower() == "true"

    # Auto-apply additive schema sync (missing tables/columns) on startup/redeploy.
    # Default ON so a deploy picks up new model columns without a manual step; a
    # DB toggle in the admin panel overrides this env default at runtime.
    AUTO_SCHEMA_SYNC: bool = os.getenv("AUTO_SCHEMA_SYNC", "true").lower() == "true"

    # MySQL
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", "3306"))
    DB_USER: str = os.getenv("DB_USER", "naksh")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "naksh")
    DB_NAME: str = os.getenv("DB_NAME", "nakshtralogy")

    @property
    def DATABASE_URL(self) -> str:
        return (
            f"mysql+pymysql://{self.DB_USER}:{self.DB_PASSWORD}"
            f"@{self.DB_HOST}:{self.DB_PORT}/{self.DB_NAME}"
            f"?charset=utf8mb4"
        )

    # JWT
    SECRET_KEY: str = os.getenv("SECRET_KEY", "change-me-in-production-nakshtralogy-2026")
    JWT_ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "525600"))
    REFRESH_TOKEN_EXPIRE_DAYS: int = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "365"))

    # Local LLM via Ollama (AI Agent)
    OLLAMA_URL: str = os.getenv("OLLAMA_URL", "http://127.0.0.1:11434")
    OLLAMA_MODEL: str = os.getenv("OLLAMA_MODEL", "qwen2.5:3b")

    # Cloud LLM API Keys
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "AIzaSyBMu7cPo2FKzimGViEhP3hl0JoHFN2DyTw")
    GROQ_API_KEY: str = os.getenv("GROQ_API_KEY", "sk-or-v1-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")
    OPENROUTER_API_KEY: str = os.getenv("OPENROUTER_API_KEY", "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")
    SARVAM_API_KEY: str = os.getenv("SARVAM_API_KEY", "sk_q55qrb36_OUYtekZUouTkH03QKQ5iE2OC")
    DEEPSEEK_API_KEY: str = os.getenv("DEEPSEEK_API_KEY", "sk-427b160ab48c4e00aeebe8abe24d8aa9")

    # Google OAuth
    GOOGLE_CLIENT_ID: str = os.getenv("GOOGLE_CLIENT_ID", "")
    GOOGLE_CLIENT_SECRET: str = os.getenv("GOOGLE_CLIENT_SECRET", "")

    # OTP / Email
    OTP_EXPIRE_MINUTES: int = 10
    SMTP_HOST: str = os.getenv("SMTP_HOST", "")
    SMTP_PORT: int = int(os.getenv("SMTP_PORT", "587"))
    SMTP_USER: str = os.getenv("SMTP_USER", "")
    SMTP_PASSWORD: str = os.getenv("SMTP_PASSWORD", "")
    FROM_EMAIL: str = os.getenv("FROM_EMAIL", "noreply@nakshtralogy.com")

    # Redis (for cache/sessions)
    REDIS_URL: str = os.getenv("REDIS_URL", "redis://localhost:6379")

    # Agora (loaded from DB AgoraConfig, these are fallback/dev defaults)
    AGORA_APP_ID: str = os.getenv("AGORA_APP_ID", "")
    AGORA_APP_CERTIFICATE: str = os.getenv("AGORA_APP_CERTIFICATE", "")

    # Communication
    CALL_RING_TIMEOUT_SEC: int = 60       # missed if no answer in 60s
    CHAT_ACCEPT_TIMEOUT_SEC: int = 60     # chat request expires in 60s
    PLATFORM_COMMISSION_PCT: float = 30.0 # default 30% cut

    # Firebase FCM (dual-project: user app + astro app)
    FIREBASE_USER_SA_PATH: str = os.getenv("FIREBASE_USER_SA_PATH", "credentials/firebase-user-sa.json")
    FIREBASE_ASTRO_SA_PATH: str = os.getenv("FIREBASE_ASTRO_SA_PATH", "credentials/firebase-astro-sa.json")

    # CORS
    CORS_ORIGINS: list = ["*"]


settings = Settings()
