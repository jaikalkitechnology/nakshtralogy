"""Home-screen slider banners for the user app (16:7, as BannerSlider shows them).

    python scripts/marketing/make_user_banners.py

Writes media/banners/user/*.png. Upload them in the admin panel under
Banners (audience: user). Reuses the Instagram reels' drawing helpers, fonts
and app screenshots so the banners match the marketing videos.
"""
import random
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

sys.path.insert(0, str(Path(__file__).resolve().parent))
from make_instagram_reels import (BOLD, GOLD, LAVENDER, MED, MUTED, ORANGE, REG, SEMI, WHITE, XB,  # noqa: E402
                                  chip, font, mandala, put, rich_text, rounded)

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "media" / "instagram" / "user" / "images" / "source"
OUT = ROOT / "media" / "banners" / "user"
W, H = 1920, 840                      # 16:7 — exactly the slider's aspect ratio
PAD = 96
PHONE_BOX = (560, 1640, 1600, 3670)   # phone area inside the app screenshots


def background(seed):
    """Night-sky gradient with soft purple / pink nebula glows and stars."""
    y = np.linspace(0, 1, H)[:, None]
    x = np.linspace(0, 1, W)[None, :]
    top, bottom = np.array([20, 15, 52]), np.array([10, 8, 30])
    arr = top * (1 - y[..., None]) + bottom * y[..., None]
    arr = np.broadcast_to(arr, (H, W, 3)).astype(np.float32).copy()
    for cx, cy, r, col, k in [(0.08, 0.0, 0.55, (90, 60, 170), 0.55), (0.92, 1.0, 0.5, (170, 70, 130), 0.45),
                              (0.7, 0.2, 0.45, (60, 45, 140), 0.35)]:
        dist = np.sqrt(((x - cx) * W / H) ** 2 + (y - cy) ** 2)
        g = np.clip(1 - dist / r, 0, 1) ** 2 * k
        arr += g[..., None] * (np.array(col) - arr) * 0.9
    img = Image.fromarray(np.clip(arr, 0, 255).astype(np.uint8), "RGB")
    d = ImageDraw.Draw(img)
    rnd = random.Random(seed)
    for _ in range(260):
        sx, sy = rnd.uniform(0, W), rnd.uniform(0, H)
        r = rnd.choice([0.8, 1.0, 1.2, 1.6, 2.2])
        b = rnd.uniform(0.35, 1.0)
        col = GOLD if rnd.random() < 0.12 else (235, 230, 255)
        c = tuple(int(v * b + 20 * (1 - b)) for v in col)
        d.ellipse((sx - r, sy - r, sx + r, sy + r), fill=c)
    # faint orbit ring, like the app's hero
    ring = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(ring).ellipse((W * 0.52, -H * 0.55, W * 1.2, H * 0.9), outline=(150, 130, 220, 40), width=2)
    img.paste(ring, (0, 0), ring)
    return img


def brand(img):  # kept for one-off variants; the app already shows the brand
    """Mandala + Nakshatralogy wordmark, top-left."""
    m = mandala(SRC / "logo_mandala.png", 64)
    put(img, m, PAD, 64)
    d = ImageDraw.Draw(img)
    f = font(BOLD, 38)
    d.text((PAD + 82, 96), "Nakshatra", font=f, fill=WHITE, anchor="lm")
    d.text((PAD + 82 + f.getlength("Nakshatra"), 96), "logy", font=font(BOLD, 38), fill=GOLD, anchor="lm")


def cta(img, x, y, text):
    """Gold gradient pill button with an arrow."""
    f = font(BOLD, 52)
    tw = int(f.getlength(text))
    w, h = tw + 180, 116
    g = Image.new("RGBA", (w + 60, h + 60), (0, 0, 0, 0))
    ImageDraw.Draw(g).rounded_rectangle((30, 38, 30 + w, 38 + h), h // 2, fill=ORANGE + (120,))
    put(img, g.filter(ImageFilter.GaussianBlur(16)), x - 30, y - 30)
    btn = rounded(w, h, h // 2, grad=(GOLD, ORANGE))
    d = ImageDraw.Draw(btn)
    d.text((54, h // 2), text, font=f, fill=(22, 14, 40, 255), anchor="lm")
    ax, ay = 54 + tw + 34, h // 2                 # arrow drawn (Poppins has no →)
    d.line((ax, ay, ax + 48, ay), fill=(22, 14, 40, 255), width=8)
    d.polygon([(ax + 56, ay), (ax + 34, ay - 18), (ax + 34, ay + 18)], fill=(22, 14, 40, 255))
    put(img, btn, x, y)


def text_block(img, tag, runs, sub, button, sub_w=1000):
    """Left column: tag chip, headline, subtitle, CTA. Sized to stay readable
    when the slider shows the banner ~330 px wide on a phone."""
    y = 78
    t = chip(tag, size=34, color=GOLD, border=(150, 120, 70), fill=(60, 40, 30, 200))
    put(img, t, PAD, y)
    y += t.height + 30
    lines, lh = rich_text(runs, 108, max_w=1060, line_gap=1.08)
    for ln in lines:
        put(img, ln, PAD - 6, y)
        y += lh
    y += 34
    sl, slh = rich_text([(sub, LAVENDER, SEMI)], 46, max_w=sub_w, weight=SEMI, line_gap=1.3, shadow=False)
    for ln in sl:
        put(img, ln, PAD - 6, y)
        y += slh
    cta(img, PAD, H - 116 - 64, button)


def phone(img, shot, x, y, width, tilt=0):
    """App screenshot's phone, top part only, rising from the banner's bottom."""
    im = Image.open(SRC / shot).convert("RGBA").crop(PHONE_BOX)
    im = im.resize((width, int(width * im.height / im.width)), Image.LANCZOS)
    if tilt:
        im = im.rotate(tilt, resample=Image.BICUBIC, expand=True)
    sh = Image.new("RGBA", (im.width + 120, im.height + 120), (0, 0, 0, 0))
    sh.paste((0, 0, 0, 170), (60, 80), im.getchannel("A"))
    put(img, sh.filter(ImageFilter.GaussianBlur(28)), x - 60, y - 60)
    put(img, im, x, y)


def kundli_card(img, x, y, S):
    """North-Indian chart in gold, like the app's Kundli screen."""
    card = rounded(S + 70, S + 70, 32, fill=(24, 19, 56, 235), outline=(120, 100, 170, 255), width=2)
    g = Image.new("RGBA", (S + 230, S + 230), (0, 0, 0, 0))
    ImageDraw.Draw(g).rounded_rectangle((80, 80, S + 150, S + 150), 40, fill=(242, 193, 78, 70))
    put(img, g.filter(ImageFilter.GaussianBlur(40)), x - 115, y - 115)
    put(img, card, x - 35, y - 35)
    layer = Image.new("RGBA", (S + 8, S + 8), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    o = 4
    segs = [((0, 0), (S, 0)), ((S, 0), (S, S)), ((S, S), (0, S)), ((0, S), (0, 0)),
            ((0, 0), (S, S)), ((S, 0), (0, S)),
            ((S / 2, 0), (S, S / 2)), ((S, S / 2), (S / 2, S)), ((S / 2, S), (0, S / 2)), ((0, S / 2), (S / 2, 0))]
    for (ax, ay), (bx, by) in segs:
        d.line((ax + o, ay + o, bx + o, by + o), fill=GOLD + (235,), width=3)
    anchors = {1: (.5, .27), 2: (.25, .1), 3: (.1, .25), 4: (.27, .5), 5: (.1, .75), 6: (.25, .9),
               7: (.5, .73), 8: (.75, .9), 9: (.9, .75), 10: (.73, .5), 11: (.9, .25), 12: (.75, .1)}
    planets = {1: "As Ma", 4: "Ju", 7: "Sa", 10: "Su Me", 11: "Ve", 9: "Ra", 3: "Ke", 5: "Mo"}
    nf, pf = font(MED, max(16, S // 30)), font(BOLD, max(20, S // 20))
    for h_, (fx, fy) in anchors.items():
        has = h_ in planets
        d.text((fx * S + o, fy * S + o - (S * 0.055 if has else 0)), str(h_), font=nf, fill=MUTED + (255,), anchor="mm")
        if has:
            d.text((fx * S + o, fy * S + o + S * 0.02), planets[h_], font=pf,
                   fill=(ORANGE if h_ == 1 else WHITE) + (255,), anchor="mm")
    put(img, layer, x - o, y - o)


def stat_pills(img, x, y, items):
    for i, (num, label) in enumerate(items):
        w, h = 230, 104
        p = rounded(w, h, 22, fill=(30, 24, 70, 225), outline=(110, 95, 165, 255), width=2)
        d = ImageDraw.Draw(p)
        d.text((w // 2, 40), num, font=font(XB, 40), fill=GOLD + (255,), anchor="mm")
        d.text((w // 2, 78), label, font=font(MED, 20), fill=LAVENDER + (255,), anchor="mm")
        put(img, p, x, y + i * (h + 18))


def chat_card(img, x, y, w):
    """AI chat mock-up: user question + AI answer bubbles."""
    h = 640
    card = rounded(w, h, 36, fill=(18, 15, 46, 240), outline=(110, 95, 165, 255), width=2)
    g = Image.new("RGBA", (w + 200, h + 200), (0, 0, 0, 0))
    ImageDraw.Draw(g).rounded_rectangle((70, 70, w + 130, h + 130), 40, fill=(130, 90, 230, 80))
    put(img, g.filter(ImageFilter.GaussianBlur(40)), x - 100, y - 100)
    d = ImageDraw.Draw(card)
    # header
    av = rounded(64, 64, 32, grad=(GOLD, ORANGE))
    ImageDraw.Draw(av).text((32, 33), "AI", font=font(XB, 26), fill=(22, 14, 40, 255), anchor="mm")
    card.paste(av, (34, 30), av)
    d.text((116, 48), "AI Astrologer", font=font(BOLD, 30), fill=WHITE + (255,), anchor="lm")
    d.ellipse((118, 76, 130, 88), fill=(95, 200, 140, 255))
    d.text((140, 82), "Online · reads your Kundli", font=font(REG, 21), fill=MUTED + (255,), anchor="lm")
    d.line((30, 120, w - 30, 120), fill=(70, 60, 120, 255), width=2)

    def bubble(text_lines, bx, by, mine):
        f = font(MED, 31)
        tw = max(int(f.getlength(t)) for t in text_lines)
        bw, bh = tw + 52, 32 + 44 * len(text_lines)
        fill = (242, 193, 78, 255) if mine else (40, 33, 88, 255)
        b = rounded(bw, bh, 24, fill=fill, outline=None if mine else (90, 80, 150, 255), width=2)
        bd = ImageDraw.Draw(b)
        for i, t in enumerate(text_lines):
            bd.text((26, 38 + i * 44), t, font=f, fill=((22, 14, 40) if mine else WHITE) + (255,), anchor="lm")
        card.paste(b, (w - bw - 30 if mine else bx, by), b)
        return bh

    yy = 150
    yy += bubble(["When will my career grow?"], 30, yy, True) + 22
    yy += bubble(["Your 10th lord Jupiter is strong.",
                  "Jupiter Mahadasha from Mar 2027",
                  "brings promotion and new roles."], 30, yy, False) + 22
    bubble(["Which colour is lucky for me?"], 30, yy, True)
    # input bar
    bar = rounded(w - 60, 64, 32, fill=(30, 25, 66, 255), outline=(80, 70, 140, 255), width=2)
    bd = ImageDraw.Draw(bar)
    bd.text((28, 32), "Ask about your Kundli…", font=font(REG, 23), fill=MUTED + (255,), anchor="lm")
    bd.ellipse((w - 60 - 56, 8, w - 60 - 8, 56), fill=GOLD + (255,))
    bd.polygon([(w - 60 - 42, 20), (w - 60 - 18, 32), (w - 60 - 42, 44)], fill=(22, 14, 40, 255))
    card.paste(bar, (30, h - 90), bar)
    put(img, card, x, y)


def banner_kundli():
    img = background(7)
    text_block(img, "100% FREE",
               [("Your ", WHITE), ("Free Kundli,", GOLD), ("\n", WHITE), ("decoded.", WHITE)],
               "Dasha, Yogas, Doshas and 20 divisional charts.",
               "Create Free Kundli", sub_w=860)
    S = 600
    kundli_card(img, W - PAD - S + 10, (H - S) // 2, S)
    return img


def banner_ai():
    img = background(21)
    text_block(img, "AI ASTROLOGER · 24×7",
               [("Ask AI about", WHITE), ("\n", WHITE), ("your ", WHITE), ("Kundli", GOLD)],
               "Instant answers from your own birth chart, in your language.",
               "Ask AI Now", sub_w=900)
    chat_card(img, W - PAD - 760 + 30, 100, 760)
    return img


def banner_astrologers():
    img = background(42)
    text_block(img, "VERIFIED EXPERTS",
               [("Talk to expert", WHITE), ("\n", WHITE), ("astrologers ", GOLD), ("24×7", WHITE)],
               "Chat, call or video with KYC-verified astrologers.",
               "Talk Now")
    phone(img, "app_screen_life_reports.png", 1580, 250, 300, tilt=-7)
    phone(img, "app_screen_astrologers.png", 1200, 90, 400, tilt=4)
    return img


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name, fn in [("01_free_kundli", banner_kundli), ("02_ai_astrologer", banner_ai),
                     ("03_talk_to_astrologers", banner_astrologers)]:
        path = OUT / f"{name}.png"
        fn().convert("RGB").save(path, optimize=True)
        print(path.relative_to(ROOT))


if __name__ == "__main__":
    main()
