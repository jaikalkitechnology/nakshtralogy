"""Nakshtralogy — FastAPI Entry Point."""

from contextlib import asynccontextmanager

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import create_tables, get_db
from app.core.dependencies import require_role
from app.routers import user_router, astrologer_router, service_router, communication_router, ws_chat, admin_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    create_tables()
    yield
    # Shutdown (cleanup if needed)


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(user_router.router, prefix="/api/v1/user", tags=["User"])
app.include_router(astrologer_router.router, prefix="/api/v1/astrologer", tags=["Astrologer"])
app.include_router(service_router.router, prefix="/api/v1/service", tags=["Service"])
app.include_router(communication_router.router, prefix="/api/v1/comm", tags=["Communication"])
app.include_router(ws_chat.router, tags=["WebSocket"])
app.include_router(admin_router.router, prefix="/api/v1/admin", tags=["Admin"])



@app.get("/health")
def health():
    return {"status": "ok", "engine": "nakshtralogy_v2", "db": "mysql"}


@app.post("/api/v1/admin/seed", tags=["Admin"])
def seed_database(
    current_user=Depends(require_role("admin")),
    db: Session = Depends(get_db),
):
    """Admin-only: seed all tables with demo data."""
    from app.seeds.seed_data import seed_all
    result = seed_all(db)
    return {"status": "ok", "seeded": result}


@app.post("/api/v1/admin/seed-open", tags=["Admin"])
def seed_database_open(db: Session = Depends(get_db)):
    """
    Open seed endpoint (no auth) — use ONLY for initial setup.
    Remove or disable after first seed.
    """
    from app.seeds.seed_data import seed_all
    result = seed_all(db)
    return {
        "status": "ok",
        "seeded": result,
        "credentials": {
            "admin": {"email": "admin@nakshatralogy.com", "password": "admin@123"},
            "user": {"email": "rahul@example.com", "password": "user@123"},
            "astrologer": {"email": "rajesh.sharma@example.com", "password": "astro@123"},
        },
    }
