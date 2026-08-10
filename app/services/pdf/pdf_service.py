"""
High-level PDF builders. Compose the localized report data + branding into an
HTML document (Jinja) and render it to a PDF (headless Chromium).

Presentation only — the report/kundli/milan/forecast data passed in is already
computed and localized upstream; nothing here touches astrology logic.
"""
from __future__ import annotations

from functools import lru_cache

from jinja2 import Environment, FileSystemLoader, select_autoescape

from .renderer import asset_data_uri, html_to_pdf
from .report_view import build_report_view

_TEMPLATES = __file__.rsplit("/", 1)[0] + "/templates"

# Scripts that read right-to-left.
_RTL_LANGS = {"ar", "fa", "ur", "he"}


@lru_cache(maxsize=1)
def _env() -> Environment:
    return Environment(
        loader=FileSystemLoader(_TEMPLATES),
        autoescape=select_autoescape(["html", "xml"]),
    )


def _dir_for(lang: str) -> str:
    return "rtl" if (lang or "en").split("-")[0].split("_")[0] in _RTL_LANGS else "ltr"


def _logo(is_astro: bool = False) -> str:
    return asset_data_uri("logo-astro.png") if is_astro else asset_data_uri("logo-full.png")


def _footer_html(brand: str) -> str:
    icon = asset_data_uri("logo-icon.png")
    img = (f'<img src="{icon}" style="height:11px;vertical-align:middle;'
           f'margin-right:5px;">' if icon else "")
    return (
        '<div style="font-size:8px;color:#8A8298;width:100%;padding:0 12mm;'
        'display:flex;justify-content:space-between;align-items:center;">'
        f'<span>{img}{brand}</span>'
        '<span class="pageNumber"></span> / <span class="totalPages"></span>'
        "</div>"
    )


async def _render(template: str, ctx: dict, brand: str) -> bytes:
    html = _env().get_template(template).render(**ctx)
    return await html_to_pdf(html, footer_html=_footer_html(brand))


def _base_ctx(*, title, subject, subject_meta, lang, generated_on,
              labels, is_astro) -> dict:
    return {
        "title": title,
        "subject": subject,
        "subject_meta": subject_meta,
        "lang": lang,
        "dir": _dir_for(lang),
        "logo": _logo(is_astro),
        "brand": labels.get("brand", "Nakshatralogy"),
        "generated_label": labels.get("generated", "Generated"),
        "generated_on": generated_on,
    }


async def render_report_pdf(*, engine_label, data, subject, subject_meta,
                            lang, generated_on, labels, is_astro=False) -> bytes:
    ctx = _base_ctx(title=engine_label, subject=subject, subject_meta=subject_meta,
                    lang=lang, generated_on=generated_on, labels=labels, is_astro=is_astro)
    ctx["view"] = build_report_view(data)
    return await _render("report.html", ctx, ctx["brand"])


async def render_generic_pdf(*, title, data, subject, subject_meta,
                             lang, generated_on, labels, is_astro=False) -> bytes:
    """Kundli / milan / forecast reuse the generic report view for their body
    (the report template renders any normalized view beautifully)."""
    ctx = _base_ctx(title=title, subject=subject, subject_meta=subject_meta,
                    lang=lang, generated_on=generated_on, labels=labels, is_astro=is_astro)
    ctx["view"] = build_report_view(data)
    return await _render("report.html", ctx, ctx["brand"])
