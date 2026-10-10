"""Render the Instagram Reels (1080x1920, 30 fps, MP4/H.264 + AAC) for
Nakshatralogy — a 60 s and a 30 s video each for the user app and the
astrologer app, in English and Hindi — into media/instagram/{user,astro}/.

Frames are drawn with Pillow from the apps' own screenshots (media/play_console,
media/instagram) and logos (flutter_user/assets/icon, flutter_astro/assets/logos), piped into ffmpeg, and muxed with a voiceover
read by offline neural TTS voices: Piper en-us-ryan-high (English, male) and
Kokoro v1.0 hf_beta (Hindi, female) via sherpa-onnx.

    pip install pillow numpy imageio-ffmpeg piper-tts sherpa-onnx
    python3 scripts/marketing/make_instagram_reels.py            # all four
    python3 scripts/marketing/make_instagram_reels.py user_30    # one
    python3 scripts/marketing/make_instagram_reels.py user_60_hi astro_60_hi   # Hindi cuts

Poppins / Playfair fonts are fetched from github.com/google/fonts (OFL) into
~/.cache/nakshatralogy-fonts on first run; Liberation Sans is the fallback.
The Piper voices are fetched from GitHub releases (rhasspy/piper, k2-fsa/sherpa-onnx) into
~/.cache/nakshatralogy-voices. Edit VOICE_SCRIPT to change the narration.
"""
import math
import random
import subprocess
import sys
import urllib.request
import wave
from functools import lru_cache
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[2]
MEDIA = ROOT / "media"
OUT = MEDIA / "instagram"
W, H, FPS = 1080, 1920, 30

GOLD = (242, 193, 78)
ORANGE = (232, 131, 58)
WHITE = (247, 243, 255)
LAVENDER = (183, 169, 232)
MUTED = (140, 132, 180)
GREEN = (95, 200, 140)

# ── fonts ────────────────────────────────────────────────────────────────
FONT_DIR = Path.home() / ".cache" / "nakshatralogy-fonts"
_FONT_URLS = {
    "Poppins-ExtraBold.ttf": "ofl/poppins/Poppins-ExtraBold.ttf",
    "Poppins-Bold.ttf": "ofl/poppins/Poppins-Bold.ttf",
    "Poppins-SemiBold.ttf": "ofl/poppins/Poppins-SemiBold.ttf",
    "Poppins-Medium.ttf": "ofl/poppins/Poppins-Medium.ttf",
    "Poppins-Regular.ttf": "ofl/poppins/Poppins-Regular.ttf",
    "Playfair-Italic.ttf": "ofl/playfairdisplay/PlayfairDisplay-Italic%5Bwght%5D.ttf",
}
_FALLBACK = {
    "Playfair-Italic.ttf": "/usr/share/fonts/truetype/liberation/LiberationSerif-Italic.ttf",
    "Poppins-Regular.ttf": "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    "Poppins-Medium.ttf": "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
}


def _font_path(name):
    p = FONT_DIR / name
    if not p.exists():
        try:
            FONT_DIR.mkdir(parents=True, exist_ok=True)
            urllib.request.urlretrieve("https://raw.githubusercontent.com/google/fonts/main/" + _FONT_URLS[name], p)
        except Exception:
            return _FALLBACK.get(name, "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf")
    return str(p)


@lru_cache(maxsize=None)
def font(name, size):
    return ImageFont.truetype(_font_path(name), size)


XB = "Poppins-ExtraBold.ttf"
BOLD = "Poppins-Bold.ttf"
SEMI = "Poppins-SemiBold.ttf"
MED = "Poppins-Medium.ttf"
REG = "Poppins-Regular.ttf"
SERIF_I = "Playfair-Italic.ttf"


# ── easing / timing ──────────────────────────────────────────────────────
def clamp(x, a=0.0, b=1.0):
    return a if x < a else b if x > b else x


def prog(t, a, b):
    return clamp((t - a) / (b - a)) if b > a else float(t >= a)


def ease_out(x):
    return 1 - (1 - x) ** 3


def ease_in_out(x):
    return 4 * x ** 3 if x < 0.5 else 1 - (-2 * x + 2) ** 3 / 2


def back_out(x, s=1.6):
    x -= 1
    return 1 + (s + 1) * x ** 3 + s * x ** 2


# ── drawing primitives ───────────────────────────────────────────────────
_LUTS = {}


def put(base, layer, x, y, alpha=1.0):
    """Paste an RGBA layer onto the RGB frame at (x, y) with extra opacity."""
    if alpha <= 0.003 or layer is None:
        return
    mask = layer.getchannel("A")
    if alpha < 0.997:
        k = round(alpha * 100)
        lut = _LUTS.get(k)
        if lut is None:
            lut = _LUTS[k] = [int(v * k / 100) for v in range(256)]
        mask = mask.point(lut)
    base.paste(layer, (int(round(x)), int(round(y))), mask)


def gradient(w, h, c1, c2, horizontal=True):
    a = np.linspace(0, 1, w if horizontal else h)[None, :, None] if horizontal else \
        np.linspace(0, 1, h)[:, None, None]
    arr = np.array(c1)[None, None, :] * (1 - a) + np.array(c2)[None, None, :] * a
    arr = np.broadcast_to(arr, (h, w, 3)).astype(np.uint8)
    return Image.fromarray(arr, "RGB")


def rounded(w, h, r, fill=None, outline=None, width=2, grad=None):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    m = Image.new("L", (w, h), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, w - 1, h - 1), r, fill=255)
    if grad:
        g = gradient(w, h, *grad).convert("RGBA")
        img.paste(g, (0, 0), m)
    elif fill:
        layer = Image.new("RGBA", (w, h), fill)
        img.paste(layer, (0, 0), m)
    if outline:
        d = ImageDraw.Draw(img)
        d.rounded_rectangle((0, 0, w - 1, h - 1), r, outline=outline, width=width)
    return img


def glow(w, h, color, radius, alpha=160):
    img = Image.new("RGBA", (w + radius * 4, h + radius * 4), (0, 0, 0, 0))
    ImageDraw.Draw(img).rounded_rectangle((radius * 2, radius * 2, radius * 2 + w, radius * 2 + h),
                                          min(w, h) // 2, fill=color + (alpha,))
    return img.filter(ImageFilter.GaussianBlur(radius)), radius * 2


def rich_text(runs, size, max_w=940, weight=XB, line_gap=1.12, align="left", shadow=True):
    """runs: list of (text, color[, font_name]). Word-wrapped, multi-colour.
    Returns a list of RGBA line images (so lines can be animated one by one)."""
    if any("\u0900" <= ch <= "\u097f" for run in runs for ch in run[0]):
        line_gap = max(line_gap, 1.3)          # Devanagari matras need more room above / below
    words = []
    for run in runs:
        text, color = run[0], run[1]
        fn = run[2] if len(run) > 2 else weight
        parts = text.split(" ")
        for i, p in enumerate(parts):
            if p == "\n":
                words.append(("\n", color, fn))
                continue
            if p:
                words.append((p, color, fn))
    lines, cur, cur_w = [], [], 0
    space = font(weight, size).getlength(" ")
    for wd in words:
        if wd[0] == "\n":
            lines.append(cur)
            cur, cur_w = [], 0
            continue
        ww = font(wd[2], size).getlength(wd[0])
        if cur and cur_w + space + ww > max_w:
            lines.append(cur)
            cur, cur_w = [], 0
        cur.append((wd, ww))
        cur_w += (space if len(cur) > 1 else 0) + ww
    if cur:
        lines.append(cur)
    out = []
    lh = int(size * line_gap)
    for ln in lines:
        lw = int(sum(w for _, w in ln) + space * (len(ln) - 1)) + 20
        img = Image.new("RGBA", (max(lw, 1), lh + int(size * 0.35)), (0, 0, 0, 0))
        d = ImageDraw.Draw(img)
        x = 6
        for (t, c, fn), ww in ln:
            d.text((x, 0), t, font=font(fn, size), fill=c + (255,))
            x += ww + space
        if shadow:
            sh = Image.new("RGBA", img.size, (0, 0, 0, 0))
            sh.putalpha(img.getchannel("A").filter(ImageFilter.GaussianBlur(6)).point(lambda v: int(v * 0.55)))
            sh2 = Image.new("RGBA", img.size, (5, 3, 20, 0))
            sh2.putalpha(sh.getchannel("A"))
            sh2.alpha_composite(img)
            img = sh2
        out.append(img)
    return out, lh


def chip(text, size=34, color=WHITE, border=(120, 110, 170), fill=(30, 26, 70, 200), dot=None):
    f = font(SEMI, size)
    tw = int(f.getlength(text))
    pad = int(size * 0.75)
    dw = int(size * 0.6) if dot else 0
    w, h = tw + pad * 2 + dw, int(size * 1.9)
    img = rounded(w, h, h // 2, fill=fill, outline=border + (255,), width=2)
    d = ImageDraw.Draw(img)
    if dot:
        r = size // 5
        cy = h // 2
        d.ellipse((pad - 2, cy - r, pad - 2 + 2 * r, cy + r), fill=dot + (255,))
    d.text((pad + dw, h // 2), text, font=f, fill=color + (255,), anchor="lm")
    return img


def chips_row(labels, size=34, gap=18, dot=None):
    return [chip(t, size, dot=dot) for t in labels], gap


# ── UI labels inside the drawn mock-ups, per language ────────────────────
LABELS = {
    "en": dict(
        ai_name="AI Astrologer", ai_sub="Reads your own kundli",
        fc_title="TODAY'S FORECAST", fc_sub="Your day, read from your chart",
        fc_bars=["Career", "Love", "Health", "Money"], fc_tip="Lucky colour: Yellow  ·  Good time: 10:30 – 12:00",
        earn_title="THIS MONTH  ·  YOUR 70%",
        earn_rows=["Chat earning — 70% of ₹299", "Call earning — 70% of ₹450", "Live gift — 70% of ₹200"],
        keep="You keep 70%", keep_sub="Every call, chat, gift & super chat",
        play_small="DOWNLOAD IT FROM THE", play_big="Play Store"),
    "hi": dict(
        ai_name="AI ज्योतिषी", ai_sub="आपकी अपनी कुंडली पढ़ता है",
        fc_title="आज का राशिफल", fc_sub="आपका दिन, आपकी कुंडली से",
        fc_bars=["करियर", "प्रेम", "स्वास्थ्य", "धन"], fc_tip="शुभ रंग: पीला  ·  शुभ समय: 10:30 – 12:00",
        earn_title="इस महीने  ·  आपका 70%",
        earn_rows=["चैट कमाई — ₹299 का 70%", "कॉल कमाई — ₹450 का 70%", "लाइव गिफ़्ट — ₹200 का 70%"],
        keep="70% आपका", keep_sub="हर कॉल, चैट, गिफ़्ट और सुपर चैट पर",
        play_small="अभी डाउनलोड करें", play_big="Play Store से"),
}


def play_badge(lang):
    """'Download it from the Play Store' pill (generic play icon, not the store logo)."""
    lb = LABELS[lang]
    fs, fb = font(MED, 26), font(BOLD, 52)
    tw = int(max(fs.getlength(lb["play_small"]), fb.getlength(lb["play_big"])))
    w, h = tw + 190, 132
    img = rounded(w, h, 30, fill=(10, 8, 24, 245), outline=(205, 200, 230, 255), width=3)
    d = ImageDraw.Draw(img)
    d.ellipse((30, 26, 110, 106), fill=GOLD + (255,))
    d.polygon([(60, 46), (60, 86), (93, 66)], fill=(20, 12, 4, 255))
    d.text((138, 44), lb["play_small"], font=fs, fill=(215, 210, 235, 255), anchor="lm")
    d.text((136, 90), lb["play_big"], font=fb, fill=WHITE + (255,), anchor="lm")
    return img


# ── background ───────────────────────────────────────────────────────────
class Background:
    def __init__(self, theme, seed):
        rng = random.Random(seed)
        self.W2, self.H2 = W + 160, H + 200
        top, bottom = theme["bg_top"], theme["bg_bottom"]
        base = gradient(self.W2, self.H2, top, bottom, horizontal=False).convert("RGBA")
        neb = Image.new("RGBA", (self.W2, self.H2), (0, 0, 0, 0))
        d = ImageDraw.Draw(neb)
        for (cx, cy, r, col, a) in theme["nebulae"]:
            d.ellipse((cx - r, cy - r, cx + r, cy + r), fill=col + (a,))
        neb = neb.filter(ImageFilter.GaussianBlur(170))
        base.alpha_composite(neb)
        # faint orbit ring like the static posts
        ring = Image.new("RGBA", (self.W2, self.H2), (0, 0, 0, 0))
        ImageDraw.Draw(ring).ellipse((560, -380, 1660, 720), outline=(200, 170, 140, 55), width=2)
        base.alpha_composite(ring)
        self.base = base.convert("RGB")
        self.stars = []
        for _ in range(240):
            depth = rng.random()
            self.stars.append(dict(
                x=rng.uniform(0, W), y=rng.uniform(0, H), depth=depth,
                r=0.8 + depth * 2.2, ph=rng.uniform(0, 6.28), sp=rng.uniform(0.6, 2.2),
                col=GOLD if rng.random() < 0.18 else (235, 232, 255)))

    def frame(self, t):
        ox = 80 + 50 * math.sin(t * 0.11)
        oy = 100 + 70 * math.sin(t * 0.07 + 1)
        img = self.base.crop((int(ox), int(oy), int(ox) + W, int(oy) + H))
        d = ImageDraw.Draw(img)
        for s in self.stars:
            y = (s["y"] - t * (6 + 22 * s["depth"])) % H
            x = s["x"]
            b = 0.35 + 0.65 * (0.5 + 0.5 * math.sin(t * s["sp"] + s["ph"]))
            r = s["r"] * (0.8 + 0.3 * b)
            c = tuple(int(v * b + 14 * (1 - b)) for v in s["col"])
            d.ellipse((x - r, y - r, x + r, y + r), fill=c)
        return img


# ── assets ───────────────────────────────────────────────────────────────
def phone_crop(path, box, width):
    im = Image.open(path).convert("RGBA").crop(box)
    h = int(width * im.height / im.width)
    im = im.resize((width, h), Image.LANCZOS)
    # fade the bottom (where the poster's dark band cut the phone) into the scene
    a = np.array(im.getchannel("A"), dtype=np.float32)
    fade = np.ones(h, dtype=np.float32)
    n = int(h * 0.22)
    fade[h - n:] = np.linspace(1, 0, n) ** 1.4
    im.putalpha(Image.fromarray((a * fade[:, None]).astype(np.uint8)))
    return im


def mandala(path, size):
    """The app's transparent mandala logo, trimmed to its bounding box."""
    im = Image.open(path).convert("RGBA")
    im = im.crop(im.getchannel("A").point(lambda v: 255 if v > 8 else 0).getbbox())
    return im.resize((size, size), Image.LANCZOS)


def app_icon(path, size):
    im = Image.open(path).convert("RGBA").resize((size, size), Image.LANCZOS)
    m = Image.new("L", (size, size), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, size - 1, size - 1), int(size * 0.24), fill=255)
    im.putalpha(m)
    return im


# ── scene building blocks ────────────────────────────────────────────────
class Scene:
    def __init__(self, start, end, fn):
        self.start, self.end, self.fn = start, end, fn


def scene_alpha(t, dur, fade_in=0.35, fade_out=0.4):
    return clamp(t / fade_in) * clamp((dur - t) / fade_out)


class Reel:
    def __init__(self, kind, duration, theme, seed, lang="en"):
        self.kind, self.duration, self.theme, self.lang = kind, duration, theme, lang
        self.L = LABELS[lang]
        self.bg = Background(theme, seed)
        self.scenes = []
        self.icon_small = app_icon(theme["icon"], 84)
        self.icon_big = app_icon(theme["icon"], 300)
        self.mandala = mandala(theme["mandala"], 420)
        self.header = self._header()
        self.cues = {}            # scene index -> [(start, dur)] of each voiceover sentence, scene-relative

    def cue(self, scene, sentence, frac=0.0, default=0.0):
        """Scene-relative time of a point inside a voiceover sentence."""
        c = self.cues.get(scene)
        if not c or sentence >= len(c):
            return default
        st, du = c[sentence]
        return st + du * frac

    def _header(self):
        img = Image.new("RGBA", (W, 130), (0, 0, 0, 0))
        img.paste(self.icon_small, (60, 23), self.icon_small)
        ImageDraw.Draw(img).text((162, 65), "Nakshatralogy", font=font(BOLD, 44), fill=GOLD + (255,), anchor="lm")
        pill = chip(self.theme["pill"][self.lang], 30, border=(150, 140, 200))
        img.paste(pill, (W - 60 - pill.width, 65 - pill.height // 2), pill)
        return img

    def add(self, start, end, fn):
        self.scenes.append(Scene(start, end, fn))

    def render_frame(self, t):
        img = self.bg.frame(t)
        for s in self.scenes:
            if s.start <= t < s.end:
                s.fn(img, t - s.start, s.end - s.start)
        return img


def headline_block(runs, size=92, sub=None, sub_size=40, max_w=960, y0=330, chips=None):
    lines, lh = rich_text(runs, size, max_w=max_w)
    sub_lines = rich_text([(sub, LAVENDER, REG)], sub_size, max_w=max_w, weight=REG, line_gap=1.35,
                          shadow=False)[0] if sub else []
    chip_imgs = [chip(c, 32) for c in (chips or [])]

    def draw(img, t, dur, a_scene):
        y = y0
        for i, ln in enumerate(lines):
            p = ease_out(prog(t, 0.08 + i * 0.12, 0.6 + i * 0.12))
            put(img, ln, 54, y + (1 - p) * 50, p * a_scene)
            y += lh
        y += 18
        for i, ln in enumerate(sub_lines):
            p = ease_out(prog(t, 0.45 + i * 0.08, 0.95 + i * 0.08))
            put(img, ln, 54, y + (1 - p) * 30, p * a_scene)
            y += int(sub_size * 1.35)
        if chip_imgs:
            y += 26
            x = 60
            for i, c in enumerate(chip_imgs):
                if x + c.width > W - 60:
                    x = 60
                    y += c.height + 16
                p = back_out(prog(t, 0.8 + i * 0.12, 1.2 + i * 0.12))
                put(img, c, x, y + (1 - clamp(p)) * 24, clamp(p) * a_scene)
                x += c.width + 16
            y += chip_imgs[-1].height
        return y

    return draw


def header_draw(reel):
    def draw(img, t, dur, a):
        put(img, reel.header, 0, 150, a)
    return draw


def phone_scene(reel, runs, sub, chips, phone_img, *, size=92):
    head = headline_block(runs, size=size, sub=sub, chips=chips, y0=300)
    g, off = glow(phone_img.width - 80, phone_img.height // 2, reel.theme["glow"], 70, 90)

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        header_draw(reel)(img, t, dur, a)
        bottom = head(img, t, dur, a)
        p = ease_out(prog(t, 0.35, 1.25))
        top = max(bottom + 60, 800) + (1 - p) * 700 + math.sin(t * 1.6) * 8 - t * 10
        x = (W - phone_img.width) // 2
        put(img, g, x + 40 - off, top + 120 - off, p * a * 0.8)
        put(img, phone_img, x, top, p * a)
    return fn


# ── user-app scenes ──────────────────────────────────────────────────────
def hook_scene(reel, lines_spec, punch, punch_at, cues=None):
    """lines_spec: list of (runs, size, appear_time); punch: final gold line.
    cues: per line (+ punch last) the (sentence, fraction) of the voiceover it
    appears on — overrides the fixed times once the voiceover is built."""
    built = [(rich_text(r, s, max_w=960, align="center")[0], s, at) for r, s, at in lines_spec]
    punch_lines, plh = rich_text(punch, 84, max_w=960)

    def times():
        ats = [at for _, _, at in built] + [punch_at]
        if cues:
            ats = [reel.cue(0, si, fr, default=d) - 0.05 for (si, fr), d in zip(cues, ats)]
        return ats[:-1], ats[-1]

    def fn(img, t, dur):
        a = scene_alpha(t, dur, 0.2)
        ats, p_at = times()
        total = sum(len(ls) * int(s * 1.12) for ls, s, _ in built) + 60 + len(punch_lines) * plh
        y = (H - total) // 2 - 80
        for (ls, s, _), at in zip(built, ats):
            for ln in ls:
                p = ease_out(prog(t, at, at + 0.45))
                fade = 1 - 0.55 * prog(t, p_at, p_at + 0.4)
                put(img, ln, (W - ln.width) // 2, y + (1 - p) * 60, p * a * fade)
                y += int(s * 1.12)
        y += 60
        for i, ln in enumerate(punch_lines):
            p = back_out(prog(t, p_at + i * 0.15, p_at + 0.6 + i * 0.15))
            sc = 0.8 + 0.2 * clamp(p)
            if clamp(p) > 0:
                lnr = ln.resize((max(1, int(ln.width * sc)), max(1, int(ln.height * sc))), Image.BILINEAR)
                put(img, lnr, (W - lnr.width) // 2, y + (ln.height - lnr.height) // 2, clamp(p) * a)
            y += plh
    return fn


def logo_scene(reel, tagline, pill=None):
    name = rich_text([("Nakshatralogy", GOLD)], 104, max_w=1000)[0][0]
    tag = rich_text([(tagline, LAVENDER, MED)], 44, max_w=900, weight=MED, shadow=False)[0]
    pill_img = chip(pill, 36, border=(200, 170, 110), color=GOLD) if pill else None
    g, off = glow(300, 300, reel.theme["glow"], 90, 170)

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        p = back_out(prog(t, 0.0, 0.9), 1.3)
        # (mandala logo from the app's own launcher assets, slowly turning)
        sc = 0.55 + 0.45 * clamp(p, 0, 1.1)
        cy = 700
        pulse = 0.75 + 0.25 * math.sin(t * 3)
        put(img, g, W // 2 - 150 - off, cy - 150 - off, a * clamp(p) * pulse)
        md = reel.mandala.rotate(-t * 14, resample=Image.BICUBIC)
        md = md.resize((int(420 * sc), int(420 * sc)), Image.BILINEAR)
        put(img, md, (W - md.width) // 2, cy - md.height // 2, a * clamp(p * 1.5))
        # orbiting sparkle
        ang = t * 2.2
        sx, sy = W // 2 + math.cos(ang) * 230, cy + math.sin(ang) * 230 * 0.35
        d = ImageDraw.Draw(img)
        if a * clamp(p) > 0.3:
            for r, c in ((9, (120, 90, 40)), (5, GOLD)):
                d.ellipse((sx - r, sy - r, sx + r, sy + r), fill=c)
        q = ease_out(prog(t, 0.6, 1.2))
        put(img, name, (W - name.width) // 2, 930 + (1 - q) * 40, a * q)
        y = 1080
        for i, ln in enumerate(tag):
            q = ease_out(prog(t, 0.9 + i * 0.1, 1.5 + i * 0.1))
            put(img, ln, (W - ln.width) // 2, y + (1 - q) * 30, a * q)
            y += 60
        if pill_img:
            q = back_out(prog(t, 1.3, 1.8))
            put(img, pill_img, (W - pill_img.width) // 2, y + 30, a * clamp(q))
    return fn


def kundli_scene(reel, runs, sub, chips):
    head = headline_block(runs, sub=sub, chips=chips, y0=300)
    S = 760
    houses_signs = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    planets = {1: ["As", "Ma"], 4: ["Ju"], 7: ["Sa"], 10: ["Su", "Me"], 11: ["Ve"], 9: ["Ra"], 3: ["Ke"], 5: ["Mo"]}
    # North-Indian chart house label anchors (fractions of S)
    anchors = {1: (.5, .27), 2: (.25, .1), 3: (.1, .25), 4: (.27, .5), 5: (.1, .75), 6: (.25, .9),
               7: (.5, .73), 8: (.75, .9), 9: (.9, .75), 10: (.73, .5), 11: (.9, .25), 12: (.75, .1)}
    segs = [((0, 0), (S, 0)), ((S, 0), (S, S)), ((S, S), (0, S)), ((0, S), (0, 0)),
            ((0, 0), (S, S)), ((S, 0), (0, S)),
            ((S / 2, 0), (S, S / 2)), ((S, S / 2), (S / 2, S)), ((S / 2, S), (0, S / 2)), ((0, S / 2), (S / 2, 0))]
    card = rounded(S + 80, S + 80, 36, fill=(22, 18, 52, 230), outline=(110, 95, 160, 255), width=2)
    pf = font(BOLD, 36)
    nf = font(MED, 24)

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        header_draw(reel)(img, t, dur, a)
        bottom = head(img, t, dur, a)
        p = ease_out(prog(t, 0.4, 1.1))
        x0, y0 = (W - S) // 2, max(bottom + 70, 860) + (1 - p) * 300
        put(img, card, x0 - 40, y0 - 40, a * p)
        layer = Image.new("RGBA", (S + 20, S + 20), (0, 0, 0, 0))
        d = ImageDraw.Draw(layer)
        for i, ((ax, ay), (bx, by)) in enumerate(segs):
            q = ease_in_out(prog(t, 0.7 + i * 0.12, 1.2 + i * 0.12))
            if q > 0:
                d.line((ax + 10, ay + 10, ax + 10 + (bx - ax) * q, ay + 10 + (by - ay) * q), fill=GOLD + (230,), width=4)
        for h_, (fx, fy) in anchors.items():
            q = prog(t, 2.0 + h_ * 0.05, 2.4 + h_ * 0.05)
            if q > 0:
                d.text((fx * S + 10, fy * S + 10 - 44 if h_ in planets else fy * S + 10), str(houses_signs[h_ - 1]),
                       font=nf, fill=MUTED + (int(255 * q),), anchor="mm")
        for k, (h_, pl) in enumerate(planets.items()):
            q = back_out(prog(t, 2.6 + k * 0.18, 3.0 + k * 0.18))
            if q > 0:
                fx, fy = anchors[h_]
                col = ORANGE if "As" in pl else WHITE
                d.text((fx * S + 10, fy * S + 10 + (1 - clamp(q)) * 20), " ".join(pl), font=pf,
                       fill=col + (int(255 * clamp(q)),), anchor="mm")
        put(img, layer, x0 - 10, y0 - 10, a * p)
    return fn


def chat_scene(reel, runs, sub, chips, user_q, ai_a):
    head = headline_block(runs, sub=sub, chips=chips, y0=300)
    CW = 900
    card_h = 620
    card = rounded(CW, card_h, 40, fill=(18, 15, 44, 240), outline=(105, 90, 160, 255), width=2)
    d = ImageDraw.Draw(card)
    d.ellipse((34, 30, 104, 100), fill=(60, 45, 120, 255))
    d.text((69, 65), "AI", font=font(BOLD, 28), fill=GOLD + (255,), anchor="mm")
    d.text((124, 48), reel.L["ai_name"], font=font(BOLD, 34), fill=WHITE + (255,), anchor="lm")
    d.text((124, 88), reel.L["ai_sub"], font=font(REG, 24), fill=MUTED + (255,), anchor="lm")
    d.ellipse((CW - 70, 56, CW - 52, 74), fill=GREEN + (255,))
    d.line((30, 125, CW - 30, 125), fill=(70, 60, 120, 255), width=2)
    uq_lines, _ = rich_text([(user_q, (30, 20, 10), SEMI)], 34, max_w=560, weight=SEMI, shadow=False)
    uw = max(l.width for l in uq_lines) + 50
    uh = len(uq_lines) * 44 + 40
    ububble = rounded(uw, uh, 30, grad=(GOLD, ORANGE))
    for i, l in enumerate(uq_lines):
        ububble.alpha_composite(l, (22, 18 + i * 44))
    af = font(REG, 32)
    # pre-wrap the AI answer
    words, lines, cur = ai_a.split(), [], ""
    for wd in words:
        if af.getlength((cur + " " + wd).strip()) > 700:
            lines.append(cur)
            cur = wd
        else:
            cur = (cur + " " + wd).strip()
    lines.append(cur)
    total_chars = sum(len(l) for l in lines)

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        header_draw(reel)(img, t, dur, a)
        bottom = head(img, t, dur, a)
        p = ease_out(prog(t, 0.35, 1.0))
        cx, cy = (W - CW) // 2, max(bottom + 60, 860) + (1 - p) * 300
        put(img, card, cx, cy, a * p)
        q = back_out(prog(t, 1.0, 1.4))
        put(img, ububble, cx + CW - uw - 34, cy + 160 + (1 - clamp(q)) * 30, a * clamp(q))
        ay = cy + 160 + uh + 34
        typing_start, text_start = 1.6, 2.5
        if t >= typing_start:
            n = int(clamp((t - text_start) / 3.6) * total_chars)
            bub_h = (len(lines) * 52 + 44) if n > 0 else 90
            bub_w = 760 if n > 0 else 160
            bub = rounded(bub_w, bub_h, 30, fill=(48, 40, 100, 255), outline=(95, 80, 160, 255), width=2)
            bd = ImageDraw.Draw(bub)
            if n <= 0:
                for k in range(3):
                    yy = 45 - 8 * max(0, math.sin(t * 8 - k * 0.8))
                    bd.ellipse((40 + k * 32 - 8, yy - 8, 40 + k * 32 + 8, yy + 8), fill=LAVENDER + (255,))
            else:
                left = n
                for i, l in enumerate(lines):
                    if left <= 0:
                        break
                    part = l if left >= len(l) else l[:left].rsplit(" ", 1)[0]   # whole words only
                    bd.text((26, 22 + i * 52), part, font=af, fill=WHITE + (255,))
                    left -= len(l)
            put(img, bub, cx + 34, ay, a * ease_out(prog(t, typing_start, typing_start + 0.3)))
    return fn


def forecast_scene(reel, runs, sub, chips):
    head = headline_block(runs, sub=sub, chips=chips, y0=300)
    CW, CH = 900, 680
    card = rounded(CW, CH, 40, fill=(20, 16, 48, 235), outline=(105, 90, 160, 255), width=2)
    d = ImageDraw.Draw(card)
    d.text((44, 56), reel.L["fc_title"], font=font(SEMI, 28), fill=GOLD + (255,), anchor="lm")
    d.text((44, 102), reel.L["fc_sub"], font=font(REG, 28), fill=MUTED + (255,), anchor="lm")
    bars = list(zip(reel.L["fc_bars"], [82, 68, 74, 77], [GOLD, (236, 120, 170), GREEN, ORANGE]))

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        header_draw(reel)(img, t, dur, a)
        bottom = head(img, t, dur, a)
        p = ease_out(prog(t, 0.35, 1.0))
        cx, cy = (W - CW) // 2, max(bottom + 60, 860) + (1 - p) * 300
        c = card.copy()
        dd = ImageDraw.Draw(c)
        q = ease_out(prog(t, 1.0, 2.4))
        score = int(78 * q)
        R = 120
        ox, oy = 44 + R + 10, 180 + R + 10
        dd.arc((ox - R, oy - R, ox + R, oy + R), 0, 360, fill=(60, 52, 110, 255), width=22)
        if q > 0:
            dd.arc((ox - R, oy - R, ox + R, oy + R), -90, -90 + 360 * 0.78 * q, fill=GOLD + (255,), width=22)
        dd.text((ox, oy - 8), str(score), font=font(XB, 76), fill=WHITE + (255,), anchor="mm")
        dd.text((ox, oy + 48), "/ 100", font=font(MED, 24), fill=MUTED + (255,), anchor="mm")
        bx = 380
        for i, (lab, val, col) in enumerate(bars):
            yy = 200 + i * 66
            dd.text((bx, yy), lab, font=font(SEMI, 28), fill=WHITE + (255,), anchor="lm")
            qq = ease_out(prog(t, 1.2 + i * 0.2, 2.2 + i * 0.2))
            dd.rounded_rectangle((bx + 150, yy - 9, bx + 470, yy + 9), 9, fill=(55, 48, 105, 255))
            if qq > 0:
                dd.rounded_rectangle((bx + 150, yy - 9, bx + 150 + int(320 * val / 100 * qq), yy + 9), 9,
                                     fill=col + (255,))
        tip = reel.L["fc_tip"]
        qq = prog(t, 2.6, 3.2)
        dd.rounded_rectangle((44, 500, CW - 44, 600), 24, fill=(48, 40, 100, int(255 * qq)))
        dd.text((CW // 2, 550), tip, font=font(MED, 28), fill=WHITE + (int(255 * qq),), anchor="mm")
        put(img, c, cx, cy, a * p)
    return fn


# ── astrologer-app scenes ────────────────────────────────────────────────
def earnings_scene(reel, runs, sub, chips):
    head = headline_block(runs, sub=sub, chips=chips, y0=300)
    CW, CH = 900, 560
    card_base = rounded(CW, CH, 44, grad=((240, 180, 70), (226, 120, 60)))
    d = ImageDraw.Draw(card_base)
    d.text((54, 64), reel.L["earn_title"], font=font(SEMI, 28), fill=(70, 40, 10, 255), anchor="lm")
    rows = list(zip(reel.L["earn_rows"], ["+₹209.3", "+₹315.0", "+₹140.0"]))

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        header_draw(reel)(img, t, dur, a)
        bottom = head(img, t, dur, a)
        p = ease_out(prog(t, 0.35, 1.0))
        cx, cy = (W - CW) // 2, max(bottom + 60, 860) + (1 - p) * 300
        c = card_base.copy()
        dd = ImageDraw.Draw(c)
        q = ease_out(prog(t, 0.9, 3.2))
        val = 16542.52 * q
        dd.text((54, 150), f"₹{val:,.2f}", font=font(XB, 104), fill=(30, 16, 8, 255), anchor="lm")
        for i, (lab, amt) in enumerate(rows):
            qq = ease_out(prog(t, 1.6 + i * 0.35, 2.1 + i * 0.35))
            yy = 270 + i * 88
            if qq > 0:
                dx = int((1 - qq) * 60)
                dd.rounded_rectangle((40 + dx, yy, CW - 40 + dx, yy + 72), 20, fill=(252, 226, 178, 255))
                dd.text((70 + dx, yy + 36), lab, font=font(MED, 28), fill=(60, 34, 12, 255), anchor="lm")
                dd.text((CW - 70 + dx, yy + 36), amt, font=font(BOLD, 30), fill=(18, 120, 64, 255), anchor="rm")
        put(img, c, cx, cy, a * p)
        # 70 / 30 split bar under the wallet card
        sq = ease_out(prog(t, 2.4, 3.4))
        if sq > 0:
            bar = Image.new("RGBA", (CW, 190), (0, 0, 0, 0))
            bd = ImageDraw.Draw(bar)
            bd.rounded_rectangle((0, 70, CW - 1, 150), 40, fill=(45, 38, 95, 255))
            bd.rounded_rectangle((0, 70, int((CW - 1) * 0.7 * sq), 150), 40, fill=GOLD + (255,))
            lq = prog(t, 3.2, 3.6)          # label once the gold fill has passed it
            if lq > 0:
                bd.text((34, 110), reel.L["keep"], font=font(BOLD, 36), fill=(40, 22, 6, int(255 * lq)), anchor="lm")
            bd.text((CW - 30, 110), "30%", font=font(SEMI, 30), fill=LAVENDER + (255,), anchor="rm")
            bd.text((0, 26), reel.L["keep_sub"], font=font(MED, 30), fill=LAVENDER + (255,), anchor="lm")
            put(img, bar, cx, cy + CH + 40, a * sq)
    return fn


def steps_scene(reel, runs, steps, chips=None, scene=None, first_sentence=1):
    head = headline_block(runs, sub=None, chips=chips, y0=320)
    rows = []
    for i, s in enumerate(steps):
        r = rounded(940, 170, 34, fill=(26, 22, 62, 230), outline=(105, 90, 160, 255), width=2)
        d = ImageDraw.Draw(r)
        num = rounded(86, 86, 22, grad=(GOLD, ORANGE))
        ImageDraw.Draw(num).text((43, 45), str(i + 1), font=font(XB, 48), fill=(40, 20, 5, 255), anchor="mm")
        r.alpha_composite(num, (32, 42))
        d.text((150, 85), s, font=font(SEMI, 40), fill=WHITE + (255,), anchor="lm")
        rows.append(r)

    def fn(img, t, dur):
        a = scene_alpha(t, dur)
        header_draw(reel)(img, t, dur, a)
        bottom = head(img, t, dur, a)
        y = max(bottom + 100, 820)
        for i, r in enumerate(rows):
            at = 0.7 + i * 0.9
            if scene is not None:
                at = reel.cue(scene, first_sentence + i, default=at) - 0.1
            p = ease_out(prog(t, at, at + 0.5))
            put(img, r, 70 + (1 - p) * 200, y, a * p)
            q = ease_out(prog(t, at + 0.5, at + 0.8))
            if q > 0:
                cx_, cy_ = W - 112, y + 85
                col = tuple(int(v * a * q) for v in GREEN)
                ImageDraw.Draw(img).line((cx_ - 18, cy_, cx_ - 5, cy_ + 14, cx_ + 20, cy_ - 16), fill=col,
                                         width=8, joint="curve")
            y += 220
    return fn


def cta_scene(reel, runs, button, sub=None):
    lines, lh = rich_text(runs, 88, max_w=960)
    sub_l = rich_text([(sub, LAVENDER, REG)], 40, max_w=900, weight=REG, shadow=False)[0] if sub else []
    bf = font(BOLD, 52)
    arrow = button.endswith("→")
    button = button.rstrip(" →")
    tw = int(bf.getlength(button))
    bw = tw + 140 + (64 if arrow else 0)
    btn = rounded(bw, 128, 64, grad=(GOLD, ORANGE))
    bd = ImageDraw.Draw(btn)
    bd.text((70, 64), button, font=bf, fill=(35, 18, 6, 255), anchor="lm")
    if arrow:
        ax = 70 + tw + 24
        bd.line((ax, 66, ax + 40, 66), fill=(35, 18, 6, 255), width=7)
        bd.line((ax + 24, 50, ax + 41, 66, ax + 24, 82), fill=(35, 18, 6, 255), width=7, joint="curve")
    bg_, boff = glow(bw, 128, ORANGE, 40, 150)
    badge = play_badge(reel.lang)
    g, off = glow(220, 220, reel.theme["glow"], 70, 150)
    icon = app_icon(reel.theme["icon"], 220)

    def fn(img, t, dur):
        a = clamp(t / 0.35)
        p = back_out(prog(t, 0.0, 0.7), 1.2)
        put(img, g, W // 2 - 110 - off, 380 - off, a * clamp(p) * (0.8 + 0.2 * math.sin(t * 3)))
        sc = 0.6 + 0.4 * clamp(p, 0, 1.1)
        ic = icon.resize((int(220 * sc), int(220 * sc)), Image.BILINEAR)
        halo = reel.mandala.rotate(t * 10, resample=Image.BICUBIC).resize((380, 380), Image.BILINEAR)
        put(img, halo, (W - 380) // 2, 490 - 190, a * clamp(p) * 0.35)
        put(img, ic, (W - ic.width) // 2, 490 - ic.height // 2, a * clamp(p))
        y = 680
        for i, ln in enumerate(lines):
            q = ease_out(prog(t, 0.3 + i * 0.12, 0.8 + i * 0.12))
            put(img, ln, (W - ln.width) // 2, y + (1 - q) * 40, a * q)
            y += lh
        y += 26
        for i, ln in enumerate(sub_l):
            q = ease_out(prog(t, 0.6, 1.1))
            put(img, ln, (W - ln.width) // 2, y, a * q)
            y += 56
        y += 50
        q = back_out(prog(t, 0.9, 1.4))
        pulse = 1 + 0.035 * math.sin(max(0, t - 1.4) * 5)
        if q > 0:
            b = btn.resize((int(bw * pulse * clamp(q, 0.01, 1.2)), int(128 * pulse * clamp(q, 0.01, 1.2))),
                           Image.BILINEAR)
            put(img, bg_, (W - bw) // 2 - boff, y - boff, a * clamp(q) * 0.55)
            put(img, b, (W - b.width) // 2, y + (128 - b.height) // 2, a * clamp(q))
        y += 180
        q = back_out(prog(t, 1.3, 1.8))
        put(img, badge, (W - badge.width) // 2, y + (1 - clamp(q)) * 40, a * clamp(q))
    return fn


# ── voiceover ────────────────────────────────────────────────────────────
VOICE_DIR = Path.home() / ".cache" / "nakshatralogy-voices"
# Offline neural voices.
#   en       Piper en-us-ryan-high (MIT), male
#   hi       Kokoro v1.0 hf_beta (Apache-2.0), female Hindi  ← used for the Hindi reels
#   hi_male  Piper hi_IN-rohan-medium (IIT Madras IndicTTS data — check its licence), male Hindi
VOICES = {
    "en": dict(engine="piper", dir="en-us-ryan-high", model="en-us-ryan-high.onnx",
               url="https://github.com/rhasspy/piper/releases/download/v0.0.2/voice-en-us-ryan-high.tar.gz",
               into="en-us-ryan-high", pace=0.92),
    "hi": dict(engine="kokoro", dir="kokoro-multi-lang-v1_0", sid=32, lang="hi",
               url="https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/kokoro-multi-lang-v1_0.tar.bz2",
               into="", pace=0.97),
    "hi_male": dict(engine="piper", dir="vits-piper-hi_IN-rohan-medium", model="hi_IN-rohan-medium.onnx",
                    url="https://github.com/k2-fsa/sherpa-onnx/releases/download/tts-models/"
                        "vits-piper-hi_IN-rohan-medium.tar.bz2",
                    into="", pace=0.86),
}
HINDI_VOICE = "hi"                 # set to "hi_male" for the male Hindi read
NAME = "Nukshuttrology"            # spelt for the English TTS: nuk-shuh-TRAH-luh-jee
NAME_HI = "नक्षत्रालॉजी"
SENTENCE_GAP = 0.28


def _fetch_voice(v):
    import tarfile
    if not (VOICE_DIR / v["dir"]).exists():
        VOICE_DIR.mkdir(parents=True, exist_ok=True)
        arc = VOICE_DIR / v["url"].rsplit("/", 1)[1]
        urllib.request.urlretrieve(v["url"], arc)
        with tarfile.open(arc) as tf:
            tf.extractall(VOICE_DIR / v["into"])
        arc.unlink()
    return VOICE_DIR / v["dir"]


@lru_cache(maxsize=None)
def tts_engine(voice):
    v = VOICES[voice]
    d = _fetch_voice(v)
    if v["engine"] == "piper":
        from piper import PiperVoice
        return PiperVoice.load(str(d / v["model"]))
    import sherpa_onnx
    k = sherpa_onnx.OfflineTtsKokoroModelConfig(
        model=str(d / "model.onnx"), voices=str(d / "voices.bin"), tokens=str(d / "tokens.txt"),
        data_dir=str(d / "espeak-ng-data"), lexicon="", lang=v["lang"])
    return sherpa_onnx.OfflineTts(sherpa_onnx.OfflineTtsConfig(
        model=sherpa_onnx.OfflineTtsModelConfig(kokoro=k, num_threads=2, provider="cpu")))


def _trim(x, sr, thr=0.012):
    """Drop the silence padding around a synthesized sentence."""
    idx = np.flatnonzero(np.abs(x) > thr)
    if not len(idx):
        return x
    pad = int(0.03 * sr)
    return x[max(0, idx[0] - pad):idx[-1] + pad]


def speak(text, length_scale, voice):
    """-> (sample_rate, [float32 array per sentence]); length_scale < 1 reads faster."""
    v = VOICES[voice]
    if v["engine"] == "piper":
        from piper import SynthesisConfig
        cfg = SynthesisConfig(length_scale=length_scale, noise_scale=0.7, noise_w_scale=0.85)
        chunks = list(tts_engine(voice).synthesize(text, syn_config=cfg))
        return chunks[0].sample_rate, [c.audio_float_array.astype(np.float32) for c in chunks]
    import re
    out, sr = [], 24000
    for sent in [p for p in re.split(r"(?<=[।?!.])\s+", text.strip()) if p]:
        a = tts_engine(voice).generate(sent, sid=v["sid"], speed=1.0 / length_scale)
        sr = a.sample_rate
        out.append(_trim(np.asarray(a.samples, dtype=np.float32), sr))
    return sr, out


def voiceover(lines, plan, duration, path, voice="en"):
    """lines: [(scene index, text)]. Each line starts shortly after its scene
    begins (or after the previous line ends); a line that would run long into
    the next scene is read a little faster. Writes a mono WAV and returns the
    per-scene sentence cues {scene: [(start, dur)]} relative to the scene start."""
    placed, cues, prev_end, sr = [], {}, 0.0, 22050
    for li, (sc, text) in enumerate(lines):
        start_at = plan[sc][0]
        nxt = lines[li + 1][0] if li + 1 < len(lines) else None
        limit = (plan[nxt][0] + 0.5) if nxt is not None else duration - 0.6
        base = VOICES[voice]["pace"]
        for ls in (base, base - 0.04, base - 0.08, base - 0.12, base - 0.16):
            sr, sents = speak(text, ls, voice)
            total = sum(len(x) for x in sents) / sr + SENTENCE_GAP * (len(sents) - 1)
            t0 = max(start_at + 0.25, prev_end + 0.2)
            if t0 + total <= limit:
                break
        t = t0
        cues[sc] = []
        for x in sents:
            placed.append((t, x))
            cues[sc].append((t - start_at, len(x) / sr))
            t += len(x) / sr + SENTENCE_GAP
        prev_end = t - SENTENCE_GAP
        print(f"  voice  scene {sc}  {t0:5.2f}-{prev_end:5.2f}s  (x{1 / ls:.2f})  {text[:60]}", flush=True)
        if prev_end > duration - 0.3:
            raise SystemExit(f"voiceover overruns the video: {text!r}")
    track = np.zeros(int(duration * sr) + sr, dtype=np.float32)
    for t, x in placed:
        i = int(t * sr)
        track[i:i + len(x)] += x
    track = track[:int(duration * sr)]
    track /= (np.abs(track).max() or 1)
    with wave.open(str(path), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sr)
        w.writeframes((track * 0.89 * 32767).astype("<i2").tobytes())
    return cues


# Narration per reel: (scene index in the plan, line). Brand / Sanskrit words
# are spelt for the TTS voice; the on-screen text keeps the real spelling.
VOICE_SCRIPT = {
    "user_60": [
        (0, "Career stuck? Marriage delayed? Money not stable? Your kundli has the answers."),
        (1, f"Meet {NAME}. Vedic astrology, made personal."),
        (2, "Talk to verified expert astrologers, twenty-four seven. On chat, call, or video, whenever you need them."),
        (3, "Get your free kundli in seconds. Planets, nukshuttras, dushas, and all twenty divisional charts, "
            "calculated to the degree."),
        (4, "Unlock nineteen deep life reports. Career, wealth, marriage, love, and health, each built on over "
            "two thousand data points."),
        (5, "Got a question? Ask our A I astrologer. It reads your own chart, and answers in English, Hindi, "
            "Hinglish, and more."),
        (6, "And start every day with your personal forecast. Lucky colours and the best timings, made just for you."),
        (7, f"Know your stars. Shape your future. Download {NAME} free, from the Play Store, today."),
    ],
    "user_30": [
        (0, "Career stuck? Marriage delayed? Money not stable? Your kundli has the answers."),
        (1, f"Meet {NAME}."),
        (2, "Talk to expert astrologers, twenty-four seven, on chat, call, or video."),
        (3, "Unlock nineteen deep life reports, on career, wealth, love, and health."),
        (4, "Or ask our A I astrologer. Answers from your own chart, in your language."),
        (5, f"Know your stars. Download {NAME} free, from the Play Store."),
    ],
    "astro_60": [
        (0, "Are you an astrologer? Your wisdom deserves a bigger stage."),
        (1, f"{NAME} Astro. Grow your astrology practice, online."),
        (2, "Consult clients by chat, call, and video. Every session is metered automatically, so you never miss "
            "a client."),
        (3, "Go live. Host Q and A sessions, earn per minute, and receive gifts and super chats, in real time."),
        (4, "And the best part? You keep seventy percent of every earning, and withdraw to your bank, anytime."),
        (5, "Build a trusted profile with your experience, specialities, and ratings, and let clients find you."),
        (6, "Getting started takes just three steps. Sign up free. Verify your K Y C. And go online."),
        (7, f"Grow your practice online. Download {NAME} Astro from the Play Store, and sign up free."),
    ],
    "astro_30": [
        (0, "Astrologer? Earn from your wisdom."),
        (1, f"Meet {NAME} Astro."),
        (2, "Consult clients by chat, call, and video, from anywhere."),
        (3, "Keep seventy percent of every earning, and withdraw anytime."),
        (4, "Sign up free. Verify your K Y C. Start earning."),
        (5, f"Download {NAME} Astro from the Play Store today."),
    ],
    "user_60_hi": [
        (0, "करियर रुका है? शादी में देरी? पैसों की तंगी? जवाब आपकी कुंडली में है।"),
        (1, f"पेश है {NAME_HI}। वैदिक ज्योतिष, आपके लिए।"),
        (2, "अनुभवी ज्योतिषियों से बात कीजिए, चैट, कॉल या वीडियो पर, जब चाहें।"),
        (3, "सेकंडों में पाइए अपनी मुफ़्त कुंडली। ग्रह, नक्षत्र, दशाएँ, सब कुछ एकदम सटीक।"),
        (4, "उन्नीस गहरी जीवन रिपोर्ट। करियर, धन, विवाह, प्रेम और सेहत, सब पर विस्तार से।"),
        (5, "कोई सवाल है? हमारे ए आई ज्योतिषी से पूछिए। यह आपकी कुंडली पढ़कर, आपकी भाषा में जवाब देता है।"),
        (6, "और रोज़ पाइए अपना दैनिक राशिफल, शुभ रंग और शुभ समय के साथ।"),
        (7, f"सितारों को जानिए, भविष्य संवारिए। आज ही प्ले स्टोर से {NAME_HI} मुफ़्त डाउनलोड कीजिए।"),
    ],
    "user_30_hi": [
        (0, "करियर रुका है? शादी में देरी? पैसों की तंगी? जवाब आपकी कुंडली में है।"),
        (1, f"पेश है {NAME_HI}।"),
        (2, "अनुभवी ज्योतिषियों से बात कीजिए, चैट, कॉल या वीडियो पर।"),
        (3, "उन्नीस गहरी जीवन रिपोर्ट, करियर, धन, प्रेम और स्वास्थ्य पर।"),
        (4, "या पूछिए हमारे ए आई ज्योतिषी से, अपनी भाषा में।"),
        (5, f"आज ही प्ले स्टोर से {NAME_HI} डाउनलोड कीजिए।"),
    ],
    "astro_60_hi": [
        (0, "क्या आप ज्योतिषी हैं? आपके ज्ञान को चाहिए, एक बड़ा मंच।"),
        (1, f"{NAME_HI} एस्ट्रो। अपनी ज्योतिष प्रैक्टिस, ऑनलाइन बढ़ाइए।"),
        (2, "चैट, कॉल और वीडियो पर परामर्श दीजिए। हर सेशन अपने आप मीटर होता है, ताकि कोई क्लाइंट न छूटे।"),
        (3, "लाइव जाइए। सवाल-जवाब कीजिए, प्रति मिनट कमाइए, और रियल टाइम में गिफ़्ट और सुपर चैट पाइए।"),
        (4, "और सबसे अच्छी बात? हर कमाई का सत्तर प्रतिशत आपका, और जब चाहें बैंक में निकालिए।"),
        (5, "अपने अनुभव, विशेषज्ञता और रेटिंग के साथ भरोसेमंद प्रोफ़ाइल बनाइए, ताकि क्लाइंट्स आपको ढूँढें।"),
        (6, "शुरुआत सिर्फ़ तीन स्टेप में। मुफ़्त साइन अप कीजिए। के वाई सी पूरा कीजिए। और ऑनलाइन आइए।"),
        (7, f"अपनी प्रैक्टिस ऑनलाइन बढ़ाइए। आज ही प्ले स्टोर से {NAME_HI} एस्ट्रो डाउनलोड कीजिए।"),
    ],
    "astro_30_hi": [
        (0, "ज्योतिषी हैं? अपने ज्ञान से कमाइए।"),
        (1, f"पेश है {NAME_HI} एस्ट्रो।"),
        (2, "चैट, कॉल और वीडियो पर परामर्श दीजिए, कहीं से भी।"),
        (3, "हर कमाई का सत्तर प्रतिशत आपका, कभी भी निकालिए।"),
        (4, "मुफ़्त साइन अप। के वाई सी। और कमाई शुरू।"),
        (5, f"आज ही प्ले स्टोर से {NAME_HI} एस्ट्रो डाउनलोड कीजिए।"),
    ],
}


# ── reels ────────────────────────────────────────────────────────────────
USER_THEME = dict(
    bg_top=(30, 22, 72), bg_bottom=(9, 8, 30), glow=(150, 90, 220),
    pill={"en": "Free Kundli", "hi": "मुफ़्त कुंडली"},
    icon=ROOT / "flutter_user/assets/icon/app_icon.png",
    mandala=ROOT / "flutter_user/assets/icon/ic_launcher_foreground.png",
    nebulae=[(150, 250, 520, (95, 60, 180), 150), (1050, 1700, 560, (170, 60, 120), 130),
             (300, 1300, 380, (60, 40, 140), 90)])
ASTRO_THEME = dict(
    bg_top=(32, 20, 58), bg_bottom=(9, 8, 28), glow=(240, 150, 60),
    pill={"en": "For Astrologers", "hi": "ज्योतिषियों के लिए"},
    icon=MEDIA / "play_console/astrologer/00_app_icon_512.png",
    mandala=ROOT / "flutter_astro/assets/logos/nakshatralogy-astrologer-logos/nakshatralogy-astrologer-logos/"
                   "nakshatralogy-astrologer-mandala-transparent-1024.png",
    nebulae=[(80, 180, 560, (200, 105, 50), 165), (1040, 1800, 520, (170, 130, 50), 120),
             (900, 700, 420, (70, 50, 150), 80)])

PC_BOX = (560, 1640, 1600, 3670)
IG_BOX = (250, 525, 830, 1265)

# On-screen copy. Runs are (text, colour); GOLD marks the highlighted words.
USER_COPY = {
    "en": dict(
        hook=["Career stuck?", "Marriage delayed?", "Money not stable?"],
        punch=[("Your ", WHITE), ("kundli", GOLD), ("has the answers.", WHITE)],
        tagline="Vedic astrology, made personal",
        experts=([("Talk to ", WHITE), ("expert astrologers", GOLD), ("24×7", WHITE)],
                 "Chat, call or video with verified Vedic, KP & Nadi astrologers.", ["Chat", "Call", "Video"]),
        kundli=([("Your ", WHITE), ("free Kundli", GOLD), ("in seconds", WHITE)],
                "Planets, nakshatras, dashas & all 20 divisional charts — to the degree.",
                ["D1–D60", "Vimshottari", "Doshas & yogas"]),
        reports=([("19 ", GOLD), ("deep life reports", WHITE)],
                 "Career, wealth, marriage, love, health & more — 2,000+ data points each.",
                 ["19 engines", "AI-powered", "Instant"]),
        chat=([("Ask our ", WHITE), ("AI astrologer", GOLD)],
              "Answers from your own chart — in English, Hindi, Hinglish & more.",
              ["11 languages", "Your chart", "24×7"]),
        chat_q="When will I get a new job?",
        chat_a="Rahul, Jupiter's period that begins next year activates your 10th house of career — "
               "a strong window for a new role. Keep sharpening your skills till then.",
        forecast=([("Start every day with your ", WHITE), ("daily forecast", GOLD)],
                  "Personal scores, lucky colour and good timings — from your own chart.",
                  ["Daily", "Personal", "Transits"]),
        cta=[("Know your stars.", WHITE), ("\n", WHITE), ("Shape your future.", GOLD)],
        button="Download free", cta_sub="Free Kundli · Expert astrologers · AI answers"),
    "hi": dict(
        hook=["करियर रुका है?", "शादी में देरी?", "पैसों की तंगी?"],
        punch=[("जवाब आपकी ", WHITE), ("कुंडली", GOLD), ("में है।", WHITE)],
        tagline="वैदिक ज्योतिष, सिर्फ़ आपके लिए",
        experts=([("अनुभवी ज्योतिषियों", GOLD), ("से बात करें 24×7", WHITE)],
                 "सत्यापित वैदिक, KP और नाड़ी ज्योतिषियों से चैट, कॉल या वीडियो पर।", ["चैट", "कॉल", "वीडियो"]),
        kundli=([("आपकी ", WHITE), ("मुफ़्त कुंडली", GOLD), ("सेकंडों में", WHITE)],
                "ग्रह, नक्षत्र, दशाएँ और सभी 20 वर्ग कुंडलियाँ — डिग्री तक सटीक।",
                ["D1–D60", "विंशोत्तरी", "दोष और योग"]),
        reports=([("19 ", GOLD), ("गहरी जीवन रिपोर्ट", WHITE)],
                 "करियर, धन, विवाह, प्रेम, स्वास्थ्य और बहुत कुछ — हर रिपोर्ट में 2,000+ डेटा पॉइंट।",
                 ["19 इंजन", "AI-आधारित", "तुरंत"]),
        chat=([("हमारे ", WHITE), ("AI ज्योतिषी", GOLD), ("से पूछें", WHITE)],
              "आपकी अपनी कुंडली से जवाब — हिंदी, English, Hinglish और कई भाषाओं में।",
              ["11 भाषाएँ", "आपकी कुंडली", "24×7"]),
        chat_q="मेरी नई नौकरी कब लगेगी?",
        chat_a="राहुल, अगले साल से शुरू हो रही गुरु की दशा आपके दसवें भाव (करियर) को सक्रिय करती है — "
               "नई नौकरी के लिए मज़बूत समय। तब तक अपनी स्किल्स निखारते रहिए।",
        forecast=([("हर दिन की शुरुआत ", WHITE), ("दैनिक राशिफल", GOLD), ("के साथ", WHITE)],
                  "निजी स्कोर, शुभ रंग और शुभ समय — आपकी अपनी कुंडली से।", ["रोज़ाना", "निजी", "गोचर"]),
        cta=[("सितारों को जानिए।", WHITE), ("\n", WHITE), ("भविष्य संवारिए।", GOLD)],
        button="मुफ़्त डाउनलोड करें", cta_sub="मुफ़्त कुंडली · अनुभवी ज्योतिषी · AI जवाब"),
}

ASTRO_COPY = {
    "en": dict(
        hook60=["Astrologer?", "Your wisdom deserves"], punch60=[("a bigger stage.", GOLD)],
        hook30=["Astrologer?"], punch30=[("Earn from your ", WHITE), ("wisdom.", GOLD)],
        tagline="Grow your astrology practice", pill="For Astrologers",
        consult=([("Chat, Call & Video", GOLD), ("consultations", WHITE)],
                 "Accept requests, run server-metered sessions and never miss a client.", ["Chat", "Voice", "Video"]),
        live=([("Go Live", GOLD), ("& receive gifts", WHITE)],
              "Host live Q&A — earn per minute, gifts and super chats in real time.",
              ["Per-minute", "Live gifts", "Super chat"]),
        earn=([("Keep ", WHITE), ("70%", GOLD), ("of every earning", WHITE)],
              "Calls, chats, gifts & super chats — withdraw to your bank anytime.",
              ["70% payout", "Only 10% TDS", "Instant statements"]),
        profile=([("Your ", WHITE), ("trusted", GOLD), ("astrologer profile", WHITE)],
                 "Show your experience, specialities and ratings — build client trust.",
                 ["Verified", "Ratings", "Specialities"]),
        steps=([("Start earning in ", WHITE), ("3 steps", GOLD)],
               ["Sign up free in minutes", "Verify KYC — PAN / GST + bank", "Go online & start earning"]),
        cta=[("Grow your practice ", WHITE), ("online.", GOLD)], button="Sign up free →",
        cta_sub="Reach seekers across India — on your schedule."),
    "hi": dict(
        hook60=["ज्योतिषी हैं?", "आपके ज्ञान को चाहिए"], punch60=[("एक बड़ा मंच।", GOLD)],
        hook30=["ज्योतिषी हैं?"], punch30=[("अपने ", WHITE), ("ज्ञान", GOLD), ("से कमाइए।", WHITE)],
        tagline="अपनी ज्योतिष प्रैक्टिस बढ़ाइए", pill="ज्योतिषियों के लिए",
        consult=([("चैट, कॉल और वीडियो", GOLD), ("परामर्श", WHITE)],
                 "अनुरोध स्वीकारें, सर्वर-मीटर्ड सेशन चलाएँ और कोई क्लाइंट न छूटे।", ["चैट", "वॉइस", "वीडियो"]),
        live=([("लाइव", GOLD), ("जाएँ और गिफ़्ट पाएँ", WHITE)],
              "लाइव Q&A करें — प्रति मिनट कमाई, गिफ़्ट और सुपर चैट, रियल टाइम में।",
              ["प्रति मिनट", "लाइव गिफ़्ट", "सुपर चैट"]),
        earn=([("हर कमाई का ", WHITE), ("70%", GOLD), ("आपका", WHITE)],
              "कॉल, चैट, गिफ़्ट और सुपर चैट — कभी भी बैंक में निकालें।",
              ["70% भुगतान", "सिर्फ़ 10% TDS", "तुरंत स्टेटमेंट"]),
        profile=([("आपकी ", WHITE), ("भरोसेमंद", GOLD), ("ज्योतिषी प्रोफ़ाइल", WHITE)],
                 "अपना अनुभव, विशेषज्ञता और रेटिंग दिखाइए — क्लाइंट का भरोसा बनाइए।",
                 ["सत्यापित", "रेटिंग", "विशेषज्ञता"]),
        steps=([("कमाई शुरू करें ", WHITE), ("3 आसान स्टेप", GOLD), ("में", WHITE)],
               ["मिनटों में मुफ़्त साइन अप", "KYC सत्यापन — PAN / GST + बैंक", "ऑनलाइन आएँ और कमाएँ"]),
        cta=[("अपनी प्रैक्टिस ", WHITE), ("ऑनलाइन", GOLD), ("बढ़ाइए।", WHITE)], button="मुफ़्त साइन अप →",
        cta_sub="पूरे भारत के लोगों तक पहुँचिए — अपने समय पर।"),
}


def user_scenes(reel, long):
    c = USER_COPY[reel.lang]
    consult = phone_crop(MEDIA / "play_console/user/02_consult.png", PC_BOX, 720)
    reports = phone_crop(MEDIA / "play_console/user/03_kundli.png", PC_BOX, 720)
    hook = hook_scene(
        reel, [([(c["hook"][0], WHITE)], 96, 0.1), ([(c["hook"][1], WHITE)], 96, 0.8),
               ([(c["hook"][2], WHITE)], 96, 1.5)],
        c["punch"], 2.6, cues=[(0, 0), (1, 0), (2, 0), (3, 0)])
    experts = phone_scene(reel, *c["experts"], consult)
    reps = phone_scene(reel, *c["reports"], reports)
    chat = chat_scene(reel, *c["chat"], c["chat_q"], c["chat_a"])
    cta = cta_scene(reel, c["cta"], c["button"], sub=c["cta_sub"])
    logo = logo_scene(reel, c["tagline"])
    if long:
        kundli = kundli_scene(reel, *c["kundli"])
        fc = forecast_scene(reel, *c["forecast"])
        h, l_end = (7.2, 11.8) if reel.lang == "hi" else (5.5, 10.5)    # the Hindi read is longer
        plan = [(0, h, hook), (h, l_end, logo), (l_end, 19, experts),
                (19, 27.5, kundli), (27.5, 36, reps), (36, 45, chat), (45, 52, fc), (52, 60, cta)]
    else:
        h, l_end = (6.8, 8.8) if reel.lang == "hi" else (4.8, 7.5)
        plan = [(0, h, hook), (h, l_end, logo), (l_end, 13.5, experts), (13.5, 19, reps), (19, 25, chat),
                (25, 30, cta)]
    return plan


def astro_scenes(reel, long):
    c = ASTRO_COPY[reel.lang]
    consult = phone_crop(MEDIA / "play_console/astrologer/02_consult.png", PC_BOX, 720)
    profile = phone_crop(MEDIA / "play_console/astrologer/04_earn70.png", PC_BOX, 720)
    golive = phone_crop(MEDIA / "instagram/01_join.png", IG_BOX, 720)
    if long:
        hook = hook_scene(reel, [([(c["hook60"][0], WHITE)], 110, 0.1), ([(c["hook60"][1], WHITE)], 80, 0.9)],
                          c["punch60"], 1.8, cues=[(0, 0), (1, 0), (1, 0.55)])
    else:
        hook = hook_scene(reel, [([(c["hook30"][0], WHITE)], 110, 0.1)], c["punch30"], 1.0, cues=[(0, 0), (1, 0)])
    consult_s = phone_scene(reel, *c["consult"], consult)
    earn = earnings_scene(reel, *c["earn"])
    steps = steps_scene(reel, *c["steps"], scene=6 if long else 4, first_sentence=1 if long else 0)
    cta = cta_scene(reel, c["cta"], c["button"], sub=c["cta_sub"])
    logo = logo_scene(reel, c["tagline"], pill=c["pill"])
    if long:
        live = phone_scene(reel, *c["live"], golive)
        prof = phone_scene(reel, *c["profile"], profile)
        plan = [(0, 5.5, hook), (5.5, 10.5, logo), (10.5, 19, consult_s), (19, 27, live), (27, 36, earn),
                (36, 44, prof), (44, 52, steps), (52, 60, cta)]
    else:
        plan = [(0, 4, hook), (4, 7, logo), (7, 12.5, consult_s), (12.5, 19, earn), (19, 25, steps),
                (25, 30, cta)]
    return plan


# key: (folder, seconds, theme, scenes, long cut, language, file name)
REELS = {
    "user_60": ("user", 60, USER_THEME, user_scenes, True, "en", "nakshatralogy_user_60s.mp4"),
    "user_30": ("user", 30, USER_THEME, user_scenes, False, "en", "nakshatralogy_user_30s.mp4"),
    "astro_60": ("astro", 60, ASTRO_THEME, astro_scenes, True, "en", "nakshatralogy_astro_60s.mp4"),
    "astro_30": ("astro", 30, ASTRO_THEME, astro_scenes, False, "en", "nakshatralogy_astro_30s.mp4"),
    "user_60_hi": ("user", 60, USER_THEME, user_scenes, True, "hi", "nakshatralogy_user_60s_hindi.mp4"),
    "user_30_hi": ("user", 30, USER_THEME, user_scenes, False, "hi", "nakshatralogy_user_30s_hindi.mp4"),
    "astro_60_hi": ("astro", 60, ASTRO_THEME, astro_scenes, True, "hi", "nakshatralogy_astro_60s_hindi.mp4"),
    "astro_30_hi": ("astro", 30, ASTRO_THEME, astro_scenes, False, "hi", "nakshatralogy_astro_30s_hindi.mp4"),
}


def ffmpeg_exe():
    try:
        import imageio_ffmpeg
        return imageio_ffmpeg.get_ffmpeg_exe()
    except Exception:
        return "ffmpeg"


def build(key, preview_at=None):
    folder, dur, theme, scenes_fn, long, lang, fname = REELS[key]
    reel = Reel(folder, dur, theme, seed=sum(map(ord, key)) % 1000, lang=lang)
    plan = scenes_fn(reel, long)
    for a, b, fn in plan:
        reel.add(a, b, fn)
    out_dir = OUT / folder
    out_dir.mkdir(parents=True, exist_ok=True)
    wav = out_dir / (fname + ".voice.wav")
    reel.cues = voiceover(VOICE_SCRIPT[key], plan, dur, wav, HINDI_VOICE if lang == "hi" else lang)
    if preview_at is not None:
        wav.unlink(missing_ok=True)
        return reel.render_frame(preview_at)
    out = out_dir / fname
    # voice polish: trim rumble, a touch of presence, gentle compression, broadcast loudness
    voice_fx = ("highpass=f=85,equalizer=f=180:t=q:w=1:g=2,equalizer=f=3200:t=q:w=1.2:g=3,"
                "acompressor=threshold=-20dB:ratio=3:attack=5:release=160:makeup=2,"
                "loudnorm=I=-14:TP=-1.5:LRA=7,aresample=44100")
    cmd = [ffmpeg_exe(), "-y", "-loglevel", "error",
           "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{W}x{H}", "-r", str(FPS), "-i", "-",
           "-i", str(wav),
           "-c:v", "libx264", "-preset", "medium", "-crf", "21", "-pix_fmt", "yuv420p", "-profile:v", "high",
           "-r", str(FPS), "-g", str(FPS * 2),
           "-af", voice_fx, "-ac", "2", "-c:a", "aac", "-b:a", "160k",
           "-movflags", "+faststart", "-t", str(dur), str(out)]
    proc = subprocess.Popen(cmd, stdin=subprocess.PIPE)
    total = int(dur * FPS)
    for i in range(total):
        proc.stdin.write(reel.render_frame(i / FPS).tobytes())
        if i % (FPS * 10) == 0:
            print(f"{key}: {i // FPS}s / {dur}s", flush=True)
    proc.stdin.close()
    proc.wait()
    wav.unlink(missing_ok=True)
    print(f"{key}: wrote {out.relative_to(ROOT)}", flush=True)
    return out


if __name__ == "__main__":
    keys = sys.argv[1:] or list(REELS)
    for k in keys:
        build(k)
