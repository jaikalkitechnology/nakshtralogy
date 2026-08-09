"""
Server-side HTML → PDF renderer using headless Chromium (Playwright).

Chromium is used deliberately: it is the only engine with world-class text
shaping for every script this app ships in — Devanagari conjuncts, Tamil /
Telugu / Kannada / Malayalam, Arabic (RTL), Thai and CJK — plus full CSS for a
polished, branded layout. Production images need `chromium` (or the Playwright
browser) and the Noto font families (`fonts-noto`, `fonts-noto-cjk`); glyph
fallback then happens automatically.

This module is presentation-only: it turns already-computed, already-localized
report data (rendered to HTML by the Jinja templates) into a PDF. No astrology
calculation, scoring or translation happens here.
"""
from __future__ import annotations

import base64
import glob
import logging
import os
from functools import lru_cache
from pathlib import Path

logger = logging.getLogger(__name__)

_ASSETS = Path(__file__).parent / "assets"


@lru_cache(maxsize=8)
def asset_data_uri(name: str) -> str:
    """Return a `data:` URI for a bundled asset (logo), or '' if missing.

    Embedding as a data URI avoids any file-path resolution inside the headless
    browser and keeps each render self-contained.
    """
    p = _ASSETS / name
    if not p.exists():
        return ""
    mime = "image/png" if p.suffix.lower() == ".png" else "image/jpeg"
    b64 = base64.b64encode(p.read_bytes()).decode("ascii")
    return f"data:{mime};base64,{b64}"


def _find_chromium() -> str | None:
    """Best-effort locate a Chromium executable.

    Playwright normally manages its own browser (``launch()`` with no path). In
    environments where the browser lives under ``PLAYWRIGHT_BROWSERS_PATH`` but
    Playwright cannot auto-resolve it, fall back to a glob so rendering still
    works. Returning None lets Playwright use its default.
    """
    for env in ("CHROMIUM_EXECUTABLE_PATH", "PLAYWRIGHT_CHROMIUM_PATH"):
        v = os.environ.get(env)
        if v and Path(v).exists():
            return v
    roots = [os.environ.get("PLAYWRIGHT_BROWSERS_PATH", ""), "/opt/pw-browsers"]
    for root in roots:
        if not root:
            continue
        for pat in ("chromium-*/chrome-linux/chrome",
                    "chromium-*/chrome-linux/headless_shell",
                    "chromium_headless_shell-*/chrome-linux/headless_shell"):
            hits = sorted(glob.glob(str(Path(root) / pat)))
            if hits:
                return hits[-1]
    # System chromium as a last resort.
    for sys_path in ("/usr/bin/chromium", "/usr/bin/chromium-browser",
                     "/usr/bin/google-chrome"):
        if Path(sys_path).exists():
            return sys_path
    return None


async def html_to_pdf(html: str, *, header_html: str = "", footer_html: str = "") -> bytes:
    """Render an HTML string to PDF bytes with A4 pages and optional running
    header/footer (used for the brand mark + page numbers).

    Raises RuntimeError with a clear message if the browser is unavailable so
    the caller can surface a 503 rather than a raw stack trace.
    """
    try:
        from playwright.async_api import async_playwright
    except Exception as e:  # pragma: no cover - import guard
        raise RuntimeError(
            "PDF export requires the 'playwright' package and a Chromium "
            "browser. Install playwright and run `playwright install "
            "chromium`, and ensure Noto fonts are present."
        ) from e

    exe = _find_chromium()
    launch_kwargs: dict = {"args": ["--no-sandbox", "--disable-dev-shm-usage"]}
    if exe:
        launch_kwargs["executable_path"] = exe

    async with async_playwright() as p:
        try:
            browser = await p.chromium.launch(**launch_kwargs)
        except Exception as e:
            raise RuntimeError(
                "Could not launch Chromium for PDF rendering. Ensure the "
                "browser is installed on the server."
            ) from e
        try:
            page = await browser.new_page()
            await page.set_content(html, wait_until="networkidle")
            pdf_kwargs: dict = {
                "format": "A4",
                "print_background": True,
                "margin": {"top": "16mm", "bottom": "16mm", "left": "12mm", "right": "12mm"},
            }
            if header_html or footer_html:
                pdf_kwargs["display_header_footer"] = True
                pdf_kwargs["header_template"] = header_html or "<span></span>"
                pdf_kwargs["footer_template"] = footer_html or "<span></span>"
            return await page.pdf(**pdf_kwargs)
        finally:
            await browser.close()
