"""Nakshtralogy — FastAPI Entry Point."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.core.database import create_tables
from app.routers import user_router, astrologer_router, service_router, communication_router, ws_chat

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    docs_url="/docs",
    redoc_url="/redoc",
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


@app.on_event("startup")
def on_startup():
    create_tables()


@app.get("/health")
def health():
    return {"status": "ok", "engine": "nakshtralogy_v2", "db": "mysql"}
