"""KYC submission: document number, front image and back image are all
mandatory (astrologer app KYC screen + POST /me/kyc)."""
import uuid

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

import app.routers.astrologer_router as ar
from app.core.database import get_db
from app.core.dependencies import get_current_user
from app.models.model import Base, User, KycDocument


@pytest.fixture()
def client():
    engine = create_engine("sqlite://", connect_args={"check_same_thread": False}, poolclass=StaticPool)
    Base.metadata.create_all(engine, tables=[User.__table__, KycDocument.__table__])
    Session = sessionmaker(bind=engine, autocommit=False, autoflush=False, expire_on_commit=False)
    db = Session()
    user = User(id=str(uuid.uuid4()), email=f"{uuid.uuid4()}@example.com", role="astrologer")
    db.add(user)
    db.commit()

    app = FastAPI()
    app.include_router(ar.router)

    def _db():
        s = Session()
        try:
            yield s
        finally:
            s.close()
    app.dependency_overrides[get_db] = _db
    app.dependency_overrides[get_current_user] = lambda: user
    c = TestClient(app)
    c.Session = Session
    c.db = db                     # keep the user's session alive for the test
    return c


FULL = {"doc_type": "aadhaar", "doc_number": "1234 5678 9012",
        "front_url": "/uploads/kyc/front.jpg", "back_url": "/uploads/kyc/back.jpg"}


@pytest.mark.parametrize("missing", ["doc_number", "front_url", "back_url"])
def test_kyc_rejected_without_each_required_field(client, missing):
    body = {k: v for k, v in FULL.items() if k != missing}
    r = client.post("/me/kyc", json=body)
    assert r.status_code == 422
    assert "back image" in r.json()["detail"]
    s = client.Session()
    assert s.query(KycDocument).count() == 0


def test_kyc_blank_back_image_is_rejected(client):
    r = client.post("/me/kyc", json={**FULL, "back_url": "  "})
    assert r.status_code == 422


def test_kyc_accepted_with_front_and_back(client):
    r = client.post("/me/kyc", json=FULL)
    assert r.status_code == 200 and r.json()["status"] == "pending"
    s = client.Session()
    doc = s.query(KycDocument).one()
    assert doc.back_url == FULL["back_url"] and doc.front_url == FULL["front_url"]


def test_kyc_error_is_translated(client):
    r = client.post("/me/kyc?lang=hindi", json={k: v for k, v in FULL.items() if k != "back_url"})
    assert r.status_code == 422 and "पीछे" in r.json()["detail"]
