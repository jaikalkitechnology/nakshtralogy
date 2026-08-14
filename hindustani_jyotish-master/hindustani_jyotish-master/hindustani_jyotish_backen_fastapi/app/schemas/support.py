"""Schemas for FAQ (admin CRUD) + support tickets (Phase L)."""
from __future__ import annotations

from pydantic import BaseModel, Field

# ── FAQ ──────────────────────────────────────────────────────────────

class FAQIn(BaseModel):
    app: str = Field("both", pattern=r"^(user|astro|both)$")
    category: str | None = Field(default=None, max_length=80)
    question_en: str = Field(..., min_length=1)
    answer_en: str = Field(..., min_length=1)
    question_hi: str | None = None
    answer_hi: str | None = None
    sort_order: int = 0
    is_active: bool = True


class FAQUpdate(BaseModel):
    app: str | None = Field(default=None, pattern=r"^(user|astro|both)$")
    category: str | None = Field(default=None, max_length=80)
    question_en: str | None = Field(default=None, min_length=1)
    answer_en: str | None = Field(default=None, min_length=1)
    question_hi: str | None = None
    answer_hi: str | None = None
    sort_order: int | None = None
    is_active: bool | None = None


class FAQReorderItem(BaseModel):
    id: str
    sort_order: int


class FAQReorderIn(BaseModel):
    items: list[FAQReorderItem]


# ── Support tickets ──────────────────────────────────────────────────

class TicketCreate(BaseModel):
    subject: str = Field(..., min_length=2, max_length=200)
    body: str = Field(..., min_length=1, max_length=4000)


class TicketReply(BaseModel):
    body: str = Field(..., min_length=1, max_length=4000)
