# PDF export — runtime requirements

The PDF endpoints (`/api/v1/pdf/...`) render branded, multi-language PDFs by
driving **headless Chromium** (via Playwright). If the browser or fonts are
missing on the server, the endpoints return **HTTP 503** and the apps show
"PDF service is temporarily unavailable". That is a deployment gap, not an app
bug — install the two things below.

## 1. Python deps
Already in `requirements.txt`:
```
pip install -r requirements.txt        # installs jinja2 + playwright
```

## 2. The Chromium browser + its OS libraries (REQUIRED)
`pip install playwright` installs the Python bindings only. You MUST also
download the browser **and** its shared libraries, or launch fails at runtime
with a 503 (RuntimeError: "Could not launch Chromium"):
```
python -m playwright install --with-deps chromium   # browser + OS libs in one step
```
`--with-deps` is important — installing the browser WITHOUT its system
libraries (libnss3, libatk, libgbm, …) is the usual cause of a 503 on an
otherwise-working server. If you cannot use `--with-deps`, run both:
```
python -m playwright install chromium
python -m playwright install-deps chromium
```
On a locked-down image you can instead point at an existing Chromium:
```
export CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium      # or chromium-browser
```
(The renderer also auto-detects `PLAYWRIGHT_BROWSERS_PATH`, `/opt/pw-browsers`,
and `/usr/bin/chromium*`.)

## 3. Fonts for every language (REQUIRED for Hindi/Tamil/Arabic/CJK/…)
Chromium shapes the scripts correctly but needs the glyphs installed:
```
# Debian/Ubuntu
apt-get install -y fonts-noto fonts-noto-cjk fonts-noto-core \
                   fonts-noto-extra fonts-noto-ui-core
# Alpine
apk add font-noto font-noto-cjk font-noto-extra
```
Without these, Latin still renders but Indic/Arabic/CJK show boxes.

## Dockerfile snippet
```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
      fonts-noto fonts-noto-cjk fonts-noto-extra \
 && pip install -r requirements.txt \
 && python -m playwright install --with-deps chromium \
 && rm -rf /var/lib/apt/lists/*
```

## Verify
```
python -c "import asyncio; from app.services.pdf.renderer import html_to_pdf; \
print(len(asyncio.run(html_to_pdf('<h1>ok नमस्ते</h1>'))), 'bytes')"
```
A non-zero byte count means PDF export is ready.
