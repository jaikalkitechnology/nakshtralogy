"""Render the Instagram Reels (1080x1920, 30 fps, MP4/H.264 + AAC) for
Nakshatralogy — a 60 s and a 30 s video each for the user app and the
astrologer app — into media/instagram/{user,astro}/.

Frames are drawn with Pillow from the apps' own screenshots (media/play_console,
media/instagram) and logos (flutter_user/assets/icon, flutter_astro/assets/logos), piped into ffmpeg, and muxed with a
synthesized ambient soundtrack (no third-party audio).

    pip install pillow numpy imageio-ffmpeg
    python3 scripts/marketing/make_instagram_reels.py            # all four
    python3 scripts/marketing/make_instagram_reels.py user_30    # one

Poppins / Playfair fonts are fetched from github.com/google/fonts (OFL) into
~/.cache/nakshatralogy-fonts on first run; Liberation Sans is the fallback.
"""
import math
import os
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
SR = 44100

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
    def __init__(self, kind, duration, theme, seed):
        self.kind, self.duration, self.theme = kind, duration, theme
        self.bg = Background(theme, seed)
        self.scenes = []
        self.icon_small = app_icon(theme["icon"], 84)
        self.icon_big = app_icon(theme["icon"], 300)
        self.mandala = mandala(theme["mandala"], 420)
        self.header = self._header()

    def _header(self):
        img = Image.new("RGBA", (W, 130), (0, 0, 0, 0))
        img.paste(self.icon_small, (60, 23), self.icon_small)
        ImageDraw.Draw(img).text((162, 65), "Nakshatralogy", font=font(BOLD, 44), fill=GOLD + (255,), anchor="lm")
        pill = chip(self.theme["pill"], 30, border=(150, 140, 200))
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
def hook_scene(lines_spec, punch, punch_at):
    """lines_spec: list of (runs, size, appear_time); punch: final gold line."""
    built = [(rich_text(r, s, max_w=960, align="center")[0], s, at) for r, s, at in lines_spec]
    punch_lines, plh = rich_text(punch, 84, max_w=960)

    def fn(img, t, dur):
        a = scene_alpha(t, dur, 0.2)
        total = sum(len(ls) * int(s * 1.12) for ls, s, _ in built) + 60 + len(punch_lines) * plh
        y = (H - total) // 2 - 80
        for ls, s, at in built:
            for ln in ls:
                p = ease_out(prog(t, at, at + 0.45))
                fade = 1 - 0.55 * prog(t, punch_at, punch_at + 0.4)
                put(img, ln, (W - ln.width) // 2, y + (1 - p) * 60, p * a * fade)
                y += int(s * 1.12)
        y += 60
        for i, ln in enumerate(punch_lines):
            p = back_out(prog(t, punch_at + i * 0.15, punch_at + 0.6 + i * 0.15))
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
    d.text((124, 48), "AI Astrologer", font=font(BOLD, 34), fill=WHITE + (255,), anchor="lm")
    d.text((124, 86), "Reads your own kundli", font=font(REG, 24), fill=MUTED + (255,), anchor="lm")
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
            bub_h = (len(lines) * 46 + 44) if n > 0 else 90
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
                    bd.text((26, 22 + i * 46), l[:left], font=af, fill=WHITE + (255,))
                    left -= len(l)
            put(img, bub, cx + 34, ay, a * ease_out(prog(t, typing_start, typing_start + 0.3)))
    return fn


def forecast_scene(reel, runs, sub, chips):
    head = headline_block(runs, sub=sub, chips=chips, y0=300)
    CW, CH = 900, 680
    card = rounded(CW, CH, 40, fill=(20, 16, 48, 235), outline=(105, 90, 160, 255), width=2)
    d = ImageDraw.Draw(card)
    d.text((44, 56), "TODAY'S FORECAST", font=font(SEMI, 26), fill=GOLD + (255,), anchor="lm")
    d.text((44, 100), "Your day, read from your chart", font=font(REG, 28), fill=MUTED + (255,), anchor="lm")
    bars = [("Career", 82, GOLD), ("Love", 68, (236, 120, 170)), ("Health", 74, GREEN), ("Money", 77, ORANGE)]

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
            dd.rounded_rectangle((bx + 130, yy - 9, bx + 470, yy + 9), 9, fill=(55, 48, 105, 255))
            if qq > 0:
                dd.rounded_rectangle((bx + 130, yy - 9, bx + 130 + int(340 * val / 100 * qq), yy + 9), 9,
                                     fill=col + (255,))
        tip = "Lucky colour: Yellow  ·  Good time: 10:30 – 12:00"
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
    d.text((54, 64), "THIS MONTH  ·  YOUR 70%", font=font(SEMI, 28), fill=(70, 40, 10, 255), anchor="lm")
    rows = [("Chat earning — 70% of ₹299", "+₹209.3"), ("Call earning — 70% of ₹450", "+₹315.0"),
            ("Live gift — 70% of ₹200", "+₹140.0")]

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
                bd.text((34, 110), "You keep 70%", font=font(BOLD, 36), fill=(40, 22, 6, int(255 * lq)), anchor="lm")
            bd.text((CW - 30, 110), "30%", font=font(SEMI, 30), fill=LAVENDER + (255,), anchor="rm")
            bd.text((0, 26), "Every call, chat, gift & super chat", font=font(MED, 30), fill=LAVENDER + (255,),
                    anchor="lm")
            put(img, bar, cx, cy + CH + 40, a * sq)
    return fn


def steps_scene(reel, runs, steps, chips=None):
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


def cta_scene(reel, runs, button, url, small, sub=None):
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
    url_img = rich_text([(url, GOLD, SEMI)], 46, max_w=1000, weight=SEMI, shadow=False)[0][0]
    small_img = chip(small, 30, border=(150, 140, 200), dot=GREEN)
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
        y += 170
        q = ease_out(prog(t, 1.3, 1.8))
        put(img, url_img, (W - url_img.width) // 2, y, a * q)
        y += 90
        q = ease_out(prog(t, 1.6, 2.1))
        put(img, small_img, (W - small_img.width) // 2, y, a * q)
    return fn


# ── soundtrack ───────────────────────────────────────────────────────────
def note_hz(n):
    return 440.0 * 2 ** ((n - 69) / 12)


def soundtrack(duration, cues, path, seed=7, key_shift=0):
    rng = np.random.default_rng(seed)
    n = int(duration * SR)
    t = np.arange(n) / SR
    L = np.zeros(n)
    R = np.zeros(n)
    chords = [[57, 60, 64, 69], [53, 57, 60, 65], [48, 52, 55, 60], [55, 59, 62, 67]]  # Am F C G
    bar = 4.0
    for ci in range(int(duration / bar) + 1):
        notes = chords[ci % 4]
        s0 = int(ci * bar * SR)
        seg = min(n, s0 + int((bar + 1.5) * SR)) - s0
        if seg <= 0:
            continue
        tt = np.arange(seg) / SR
        env = np.minimum(1, tt / 1.2) * np.clip((bar + 1.5 - tt) / 1.5, 0, 1)
        for k, m in enumerate(notes):
            f = note_hz(m + key_shift)
            for det, side in ((-0.6, L), (0.6, R)):
                tone = (np.sin(2 * np.pi * (f + det) * tt) + 0.25 * np.sin(2 * np.pi * 2 * (f + det) * tt)
                        + 0.08 * np.sin(2 * np.pi * 3 * (f + det) * tt))
                side[s0:s0 + seg] += 0.045 * env * tone
        bass = note_hz(notes[0] - 12 + key_shift)
        b = 0.09 * env * np.sin(2 * np.pi * bass * tt)
        L[s0:s0 + seg] += b
        R[s0:s0 + seg] += b
    # gentle pulse so it feels like it's moving
    pulse = 0.85 + 0.15 * np.sin(2 * np.pi * t * 1.5) ** 2
    L *= pulse
    R *= pulse
    # bell arpeggio sparkles on scene cues + a soft whoosh
    pent = [81, 84, 86, 88, 91, 93, 96]
    for ci, cue in enumerate(cues):
        for j in range(4):
            st = int((cue + j * 0.13) * SR)
            if st >= n:
                continue
            ln = min(n - st, int(2.2 * SR))
            tt = np.arange(ln) / SR
            f = note_hz(pent[(ci * 2 + j) % len(pent)] + key_shift)
            bell = np.sin(2 * np.pi * f * tt) * np.exp(-tt * 3.2) + 0.3 * np.sin(2 * np.pi * f * 2.76 * tt) * np.exp(-tt * 6)
            pan = 0.5 + 0.35 * math.sin(ci + j)
            L[st:st + ln] += 0.05 * bell * (1 - pan)
            R[st:st + ln] += 0.05 * bell * pan
        st = int(max(0, cue - 0.6) * SR)
        ln = min(n - st, int(0.9 * SR))
        if ln > 0:
            noise = rng.standard_normal(ln)
            noise = np.convolve(noise, np.ones(40) / 40, mode="same")
            env = np.sin(np.linspace(0, np.pi, ln)) ** 2
            L[st:st + ln] += 0.12 * noise * env
            R[st:st + ln] += 0.12 * np.roll(noise, 50) * env
    # simple feedback-delay reverb
    for d_s, g in ((0.153, 0.32), (0.227, 0.26), (0.341, 0.2)):
        d = int(d_s * SR)
        for ch in (L, R):
            ch[d:] += g * ch[:-d].copy()
    fade = np.minimum(1, t / 1.0) * np.clip((duration - t) / 2.0, 0, 1)
    L *= fade
    R *= fade
    peak = max(np.abs(L).max(), np.abs(R).max()) or 1
    st = np.stack([L, R], axis=1) / peak * 0.7
    pcm = (st * 32767).astype("<i2")
    with wave.open(str(path), "wb") as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())


# ── reels ────────────────────────────────────────────────────────────────
USER_THEME = dict(
    bg_top=(30, 22, 72), bg_bottom=(9, 8, 30), glow=(150, 90, 220), pill="Free Kundli",
    icon=ROOT / "flutter_user/assets/icon/app_icon.png",
    mandala=ROOT / "flutter_user/assets/icon/ic_launcher_foreground.png",
    nebulae=[(150, 250, 520, (95, 60, 180), 150), (1050, 1700, 560, (170, 60, 120), 130),
             (300, 1300, 380, (60, 40, 140), 90)])
ASTRO_THEME = dict(
    bg_top=(32, 20, 58), bg_bottom=(9, 8, 28), glow=(240, 150, 60), pill="For Astrologers",
    icon=MEDIA / "play_console/astrologer/00_app_icon_512.png",
    mandala=ROOT / "flutter_astro/assets/logos/nakshatralogy-astrologer-logos/nakshatralogy-astrologer-logos/"
                   "nakshatralogy-astrologer-mandala-transparent-1024.png",
    nebulae=[(80, 180, 560, (200, 105, 50), 165), (1040, 1800, 520, (170, 130, 50), 120),
             (900, 700, 420, (70, 50, 150), 80)])

PC_BOX = (560, 1640, 1600, 3670)
IG_BOX = (250, 525, 830, 1265)
USER_SITE = "nakshatralogy.com"
ASTRO_SITE = "astro.nakshatralogy.com"


def user_scenes(reel, long):
    th = reel.theme
    consult = phone_crop(MEDIA / "play_console/user/02_consult.png", PC_BOX, 720)
    reports = phone_crop(MEDIA / "play_console/user/03_kundli.png", PC_BOX, 720)
    hook = hook_scene(
        [([("Career stuck?", WHITE)], 96, 0.1), ([("Marriage delayed?", WHITE)], 96, 0.8),
         ([("Money not stable?", WHITE)], 96, 1.5)],
        [("Your ", WHITE), ("kundli", GOLD), ("has the answers.", WHITE)], 2.6 if long else 2.2)
    experts = phone_scene(reel, [("Talk to ", WHITE), ("expert astrologers", GOLD), ("24×7", WHITE)],
                          "Chat, call or video with verified Vedic, KP & Nadi astrologers.",
                          ["Chat", "Call", "Video"], consult)
    reps = phone_scene(reel, [("19 ", GOLD), ("deep life reports", WHITE)],
                       "Career, wealth, marriage, love, health & more — 2,000+ data points each.",
                       ["19 engines", "AI-powered", "Instant"], reports)
    chat = chat_scene(reel, [("Ask our ", WHITE), ("AI astrologer", GOLD)],
                      "Answers from your own chart — in English, Hindi, Hinglish & more.",
                      ["11 languages", "Your chart", "24×7"],
                      "When will I get a new job?",
                      "Rahul, Jupiter's period that begins next year activates your 10th house of career — "
                      "a strong window for a new role. Keep sharpening your skills till then.")
    cta = cta_scene(reel, [("Know your stars.", WHITE), ("\n", WHITE), ("Shape your future.", GOLD)],
                    "Download free", USER_SITE, "Get it on Google Play",
                    sub="Free Kundli · Expert astrologers · AI answers")
    if long:
        kundli = kundli_scene(reel, [("Your ", WHITE), ("free Kundli", GOLD), ("in seconds", WHITE)],
                              "Planets, nakshatras, dashas & all 20 divisional charts — to the degree.",
                              ["D1–D60", "Vimshottari", "Doshas & yogas"])
        fc = forecast_scene(reel, [("Start every day with your ", WHITE), ("daily forecast", GOLD)],
                            "Personal scores, lucky colour and good timings — from your own chart.",
                            ["Daily", "Personal", "Transits"])
        plan = [(0, 5.5, hook), (5.5, 10.5, logo_scene(reel, "Vedic astrology, made personal")),
                (10.5, 19, experts), (19, 27.5, kundli), (27.5, 36, reps), (36, 45, chat), (45, 52, fc),
                (52, 60, cta)]
    else:
        plan = [(0, 4.2, hook), (4.2, 7.5, logo_scene(reel, "Vedic astrology, made personal")),
                (7.5, 13.5, experts), (13.5, 19, reps), (19, 25, chat), (25, 30, cta)]
    return plan


def astro_scenes(reel, long):
    consult = phone_crop(MEDIA / "play_console/astrologer/02_consult.png", PC_BOX, 720)
    profile = phone_crop(MEDIA / "play_console/astrologer/04_earn70.png", PC_BOX, 720)
    golive = phone_crop(MEDIA / "instagram/01_join.png", IG_BOX, 720)
    hook = hook_scene(
        [([("Astrologer?", WHITE)], 110, 0.1), ([("Your wisdom deserves", WHITE)], 80, 0.9)],
        [("a bigger stage.", GOLD)], 1.8) if long else hook_scene(
        [([("Astrologer?", WHITE)], 110, 0.1)], [("Earn from your ", WHITE), ("wisdom.", GOLD)], 1.0)
    consult_s = phone_scene(reel, [("Chat, Call & Video", GOLD), ("consultations", WHITE)],
                            "Accept requests, run server-metered sessions and never miss a client.",
                            ["Chat", "Voice", "Video"], consult)
    earn = earnings_scene(reel, [("Keep ", WHITE), ("70%", GOLD), ("of every earning", WHITE)],
                          "Calls, chats, gifts & super chats — withdraw to your bank anytime.",
                          ["70% payout", "Only 10% TDS", "Instant statements"])
    steps = steps_scene(reel, [("Start earning in ", WHITE), ("3 steps", GOLD)],
                        ["Sign up free in minutes", "Verify KYC — PAN / GST + bank", "Go online & start earning"])
    cta = cta_scene(reel, [("Grow your practice ", WHITE), ("online.", GOLD)], "Sign up free →", ASTRO_SITE,
                    "Nakshatralogy Astro · Google Play", sub="Reach seekers across India — on your schedule.")
    logo = logo_scene(reel, "Grow your astrology practice", pill="For Astrologers")
    if long:
        live = phone_scene(reel, [("Go Live", GOLD), ("& receive gifts", WHITE)],
                           "Host live Q&A — earn per minute, gifts and super chats in real time.",
                           ["Per-minute", "Live gifts", "Super chat"], golive)
        prof = phone_scene(reel, [("Your ", WHITE), ("trusted", GOLD), ("astrologer profile", WHITE)],
                           "Show your experience, specialities and ratings — build client trust.",
                           ["Verified", "Ratings", "Specialities"], profile)
        plan = [(0, 5.5, hook), (5.5, 10.5, logo), (10.5, 19, consult_s), (19, 27, live), (27, 36, earn),
                (36, 44, prof), (44, 52, steps), (52, 60, cta)]
    else:
        plan = [(0, 4, hook), (4, 7, logo), (7, 12.5, consult_s), (12.5, 19, earn), (19, 25, steps),
                (25, 30, cta)]
    return plan


REELS = {
    "user_60": ("user", 60, USER_THEME, user_scenes, True, "nakshatralogy_user_60s.mp4"),
    "user_30": ("user", 30, USER_THEME, user_scenes, False, "nakshatralogy_user_30s.mp4"),
    "astro_60": ("astro", 60, ASTRO_THEME, astro_scenes, True, "nakshatralogy_astro_60s.mp4"),
    "astro_30": ("astro", 30, ASTRO_THEME, astro_scenes, False, "nakshatralogy_astro_30s.mp4"),
}


def ffmpeg_exe():
    try:
        import imageio_ffmpeg
        return imageio_ffmpeg.get_ffmpeg_exe()
    except Exception:
        return "ffmpeg"


def build(key, preview_at=None):
    folder, dur, theme, scenes_fn, long, fname = REELS[key]
    reel = Reel(folder, dur, theme, seed=hash(key) % 1000)
    plan = scenes_fn(reel, long)
    for a, b, fn in plan:
        reel.add(a, b, fn)
    if preview_at is not None:
        return reel.render_frame(preview_at)
    out_dir = OUT / folder
    out_dir.mkdir(parents=True, exist_ok=True)
    wav = out_dir / (fname + ".wav")
    soundtrack(dur, [a for a, _, _ in plan[1:]], wav, seed=len(key), key_shift=0 if folder == "user" else -2)
    out = out_dir / fname
    cmd = [ffmpeg_exe(), "-y", "-loglevel", "error",
           "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{W}x{H}", "-r", str(FPS), "-i", "-",
           "-i", str(wav),
           "-c:v", "libx264", "-preset", "medium", "-crf", "21", "-pix_fmt", "yuv420p", "-profile:v", "high",
           "-r", str(FPS), "-g", str(FPS * 2),
           "-c:a", "aac", "-b:a", "160k", "-ar", str(SR),
           "-movflags", "+faststart", "-shortest", str(out)]
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
