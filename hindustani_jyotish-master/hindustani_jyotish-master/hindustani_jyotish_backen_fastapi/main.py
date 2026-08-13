"""Convenience entrypoint: `python main.py` runs the dev server.

For production use a process manager:
    uvicorn app.main:app --host 0.0.0.0 --port 8000
"""
from app.main import app  # noqa: F401  (uvicorn import target: main:app)

if __name__ == "__main__":
    import uvicorn

    from app.core.config import settings

    uvicorn.run(
        "app.main:app",
        host="127.0.0.1",
        port=8000,
        reload=settings.ENVIRONMENT == "local",
    )
